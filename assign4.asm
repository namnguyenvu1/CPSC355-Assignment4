// Name: Nam Nguyen Vu
// UCID: 30154892
// Tutorial 1
// TA: Akram
// CPSC 355 Assignment 4

printCuboid1:   .string "Cuboid %s origin = (%d, %d)\n"		// Format the printing for the first line of printCuboid
                .balign 4					// Set printing alignment
                .global main

printCuboid2:   .string "\tBase width = %d  Base length = %d\n"	// Format the printing for the second line of printCuboid
                .balign 4					// Set printing alignment
                .global main

printCuboid3:   .string "\tHeight = %d\n"			// Format the printing for the third line of printCuboid
                .balign 4					// Set printing alignment
                .global main

printCuboid4:   .string "\tVolume = %d\n\n"			// Format the printing for the fourth line of printCuboid
                .balign 4					// Set printing alignment
                .global main

main1:          .string "Initial cuboid values:\n"		// Format the printing for the line before printing initial cuboid values
                .balign 4					// Set printing alignment
                .global main

main2:          .string "\nChanged cuboid values:\n"		// Format the printing for the line before printing changed cuboid values
                .balign 4					// Set printing alignment
                .global main

first:          .string "first"					// Format to print the word "first"
                .balign 4					// Set printing alignment
                .global main

second:         .string "second"				// Format to print the word "second"
                .balign 4					// Set printing alignment
                .global main

False = 0							// Initialize false = 0
True = 1							// Initalize true = 1

point_x = 0							// Offset for int x in struct point
point_y = 4							// Offset for int y in struct point
point_size = 8							// Size of struct point
dimension_s = 8							// Struct dimension start 8 bytes after x29
dimension_width = 0						// Offset for width in struct dimension
dimension_length = 4						// Offset for length in struct dimension
dimension_size = 8						// Size of struct dimension
cuboid_s = 16							// Cuboid start 8 bytes after x29
cuboid_origin = 0						// Offset for struct point origin in struct cuboid
cuboid_base = 8							// Offset for struct dimension base in struct cuboid
cuboid_height = 16						// Offset for int height in struct cuboid
cuboid_volume = 20						// Offset for int volume in struct cuboid
cuboid_size = point_size + dimension_size + 8			// Size of struct cuboid

firstCuboid_s = cuboid_s + cuboid_size				// Calculate how many bytes firstCuboid start after x29
secondCuboid_s = firstCuboid_s + cuboid_size			// Calculate how many bytes secondCuboid start after x29
result_s = secondCuboid_s + cuboid_size				// Calculate how many bytes int result start after x29
firstCuboid_size = 24						// Size of firstCuboid in bytes
secondCuboid_size = 24						// Size of secondCuboid in bytes

int_size = 4							// Size of an int (To calculate allocation size of function)
char_size = 1							// Size of an char (To calculate allocation size of function)

	define(first_r, x20)					// Set name of x20 to first_r (m4 macros)
        define(second_r, x21)					// Set name of x21 to second_r (m4 macros)
        define(cuboid_base_r, x27)				// Set name of x27 to cuboid_base_r (m4 macros)
        define(result_r, w28)					// Set name of w27 to result_r (m4 macros)

main_alloc = -(16 + firstCuboid_size + secondCuboid_size) & -16	// Calculate the allocation size for main
main_dealloc = -main_alloc					// Calculate the deallocation size for main

main:   stp     x29, x30, [sp, main_alloc]!			// Allocate memory for main function
        mov     x29, sp

	add	x8, x29, firstCuboid_s				// Calculate the address of x8 (Where firstCuboid start)
        bl      newCuboid					// Call newCuboid function to create a new cuboid
gdb1:
	add     x8, x29, secondCuboid_s				// Calculate the address of x8 (Where secondCuboid start)
        bl      newCuboid					// Call newCuboid function to create a new cuboid
gdb2:
        ldr     x0, =main1					// Load string "Initial cuboid value:" to x0
        bl      printf						// Print the string

	ldr	w4, =first					// Load argument to print values of the initial first cuboid
	add     x8, x29, firstCuboid_s				
	bl	printCuboid					// Print the string

	ldr     w4, =second					// Load argument to print values of the initial second cuboid
        add     x8, x29, secondCuboid_s
        bl      printCuboid					// Print the string

	add	x0, x29, firstCuboid_s				// Load argument to call function equalSize
	add	x1, x29, secondCuboid_s
	bl	equalSize					// Call function equalSize

        ldr     result_r, [x29, result_s]			// Load the return value of function equalSize
        cmp     result_r, True					// Compare result and True
        b.eq    skip						// If equal, branch to skip

	add	x8, x29, firstCuboid_s				// Calculate the base address of the first cuboid
        mov     w1, 3						// Load 3 to int deltaX
        mov     w2, -6						// Load -6 to int deltaY
        bl      move						// Call function move
gdb3:
	add     x8, x29, secondCuboid_s				// Calculate the base address of the second cuboid
        mov     w1, 4						// Load 4 to int factor
        bl      scale						// Call function scale
gdb4:
skip:   ldr     x0, =main2					// Load string"Changed cuboid value:" to x0
        bl      printf						// Print the string

	ldr     w4, =first					// Load argument to print values of the changed first cuboid
        add     x8, x29, firstCuboid_s
        bl      printCuboid					// Print the string

	ldr     w4, =second					// Load argument to print values of the changed second cuboid
        add     x8, x29, secondCuboid_s
        bl      printCuboid					// Print the string

	ldr	x0, 0						// Deallocate memory and end main function
        ldp     x29, x30, [sp], main_dealloc
        ret

newCuboid_alloc = -(16 + cuboid_size) & -16			// Calculate the allocation size of function newCuboid
newCuboid_dealloc = -newCuboid_alloc				// Calculate the deallocation size of function newCuboid

newCuboid:
        stp     x29, x30, [sp, newCuboid_alloc]!		// Allocate memory for function newCuboid
        mov     x29, sp	

	mov 	cuboid_base_r, x8				// Move x8 to cuboid_base_r (Easier to read)
        mov     w19, 0						// w19 = 0
        str     w19, [cuboid_base_r, cuboid_origin + point_x]	// Store the value of w19 to point X

        mov     w19, 0						// w19 = 0
        str     w19, [cuboid_base_r, cuboid_origin + point_y]	// Store the value of w19 to point Y

        mov     w19, 2							// w19 = 2
        str     w19, [cuboid_base_r, cuboid_base + dimension_width]	// Store the value of w19 to width

        mov     w19, 2							// w19 = 2
        str     w19, [cuboid_base_r, cuboid_base + dimension_length]	// Store the value of w19 to length

        mov     w19, 3							// w19 = 3
        str     w19, [cuboid_base_r, cuboid_height]			// Store the value of w19 to height

        ldr     w19, [cuboid_base_r, cuboid_base + dimension_width]	// Load the width to w19
        ldr     w21, [cuboid_base_r, cuboid_base + dimension_length]	// Load the length to w21
        ldr     w22, [cuboid_base_r, cuboid_height]			// Load the height to w22
        mul     w19, w19, w21						// w19 = width * length
        mul     w19, w19, w22						// w19 = (width * length) * height
        str     w19, [cuboid_base_r, cuboid_volume]			// Store (width * length) * height to volume

        ldp     x29, x30, [sp], newCuboid_dealloc		// Deallocate memory for function newCuboid
        ret

printCuboid_alloc = -(16 + char_size + cuboid_size) & -16	// Calculate memory allocation size for function printCuboid
printCuboid_dealloc = -printCuboid_alloc			// Calculate memory deallocation size for function printCuboid

printCuboid:
        stp     x29, x30, [sp, printCuboid_alloc]!		// Allocate memory for function printCuboid
        mov     x29, sp

	mov	x25, x8						// Move x8 to x25

        ldr     x0, =printCuboid1				// Format the printing for the first line in printCuboid
	mov	w1, w4
        ldr     w2, [x25, cuboid_origin + point_x]
        ldr     w3, [x25, cuboid_origin + point_y]
        bl      printf						// Print the first line in printCuboid

        ldr     x0, =printCuboid2				// Format the printing for the second line in printCuboid
        ldr     w1, [x25, cuboid_base + dimension_width]
        ldr     w2, [x25, cuboid_base + dimension_length]
        bl      printf						// Print the second line in printCuboid

        ldr     x0, =printCuboid3				// Format the printing for the third line in printCuboid
        ldr     w1, [x25, cuboid_height]
        bl      printf						// Print the third line in printCuboid

        ldr     x0, =printCuboid4				// Format the printing for the last line in printCuboid
        ldr     w1, [x25, cuboid_volume]
        bl      printf						// Print the last line in printCuboid

        ldp     x29, x30, [sp], printCuboid_dealloc		// Deallocate memory for printCuboid function
        ret

equalSize_alloc = -(16 + cuboid_size + cuboid_size) & -16	// Calculate memory allocation size for function equalSize
equalSize_dealloc = -equalSize_alloc				// Calculate memory deallocation size for function equalSize

equalSize:
        stp     x29, x30, [sp, equalSize_alloc]!		// Allocate memory for function equalSize
        mov     x29, sp

        mov     result_r, False					// Initialize result_r to false
	mov	x24, x0						// Move x0 to x24 (x0 is the base address for firstCuboid)
	mov	x25, x1						// Move x1 to x25 (x1 is the base address for secondCuboid)

        ldr     w10, [x24, cuboid_base + dimension_width]	// Load the width of c1 to w10
        ldr     w11, [x25, cuboid_base + dimension_width]	// Load the width of c2 to w11
        cmp     w10, w11					// Compare c1.width to c2.width
        b.ne    return						// If not equal, return the result

        ldr     w10, [x24, cuboid_base + dimension_length]	// Load the length of c1 to w10
        ldr     w11, [x25, cuboid_base + dimension_length]	// Load the length of c2 to w11
        cmp     w10, w11					// Compare c1.length to c2.length
        b.ne    return						// If not equal, return the result

        ldr     w10, [x24, cuboid_height]			// Load the height of c1 to w10
        ldr     w11, [x25, cuboid_height]			// Load the height of c2 to w11
        cmp     w10, w11					// Compare c1.height to c2.height
        b.ne    return						// If not equal, return the result

return: str     result_r, [x29, result_s]			// Store the value of result_r

        ldp     x29, x30, [sp], equalSize_dealloc		// Deallocate memory for function equalSize
        ret

scale_alloc = -(16 + cuboid_size + int_size) & -16		// Calculate memory allocation size for function scale
scale_dealloc = -scale_alloc					// Calculate memory deallocation size for function scale

scale:  stp     x29, x30, [sp, scale_alloc]!			// Allocate memory for function scale
        mov     x29, sp

        ldr     w24, [x8, cuboid_base + dimension_width]	// Load the width of cuboid c to w24
        mul     w24, w24, w1					// c->base.width *= factor
        str     w24, [x8, cuboid_base + dimension_width]	// Store the width of cuboid c to w24

        ldr     w24, [x8, cuboid_base + dimension_length]	// Load the length of cuboid c to w24
        mul     w24, w24, w1					// c->base.length *= factor
        str     w24, [x8, cuboid_base + dimension_length]	// Store the length of cuboid c to w24

        ldr     w24, [x8, cuboid_height]			// Load the height of cuboid c to w24
        mul     w24, w24, w1					// c->base.height *= factor
        str     w24, [x8, cuboid_height]			// Store the height of cuboid c to w24

        ldr     w24, [x8, cuboid_base + dimension_width]	// Load the width of cuboid c to w24
        mov     w25, w24					// w25 = c->base.width
        ldr     w24, [x8, cuboid_base + dimension_length]	// Load the length of cuboid c to w24
        mul     w25, w25, w24					// w25 = c->base.width * c->base.length
        ldr     w24, [x8, cuboid_height]			// Load the height of cuboid c to w24
        mul     w25, w25, w24					// w25 = c->base.width * c->base.length * c->height

        str     w25, [x8, cuboid_volume]			// Store w25 to c->volume

        ldp     x29, x30, [sp], scale_dealloc			// Deallocate memory for function scale
        ret

move_alloc = -(16 + cuboid_size + int_size + int_size) & -16	// Calculate memory allocation size for function move
move_dealloc = -move_alloc					// Calculate memory deallocation size for function move

move:   stp     x29, x30, [sp, move_alloc]!			// Allocate memory for function move
        mov     x29, sp
	
        ldr     w23, [x8, cuboid_origin + point_x]		// Load the value of point_x to w23
        add     w23, w23, w1					// w23 = x + 3
        str     w23, [x8, cuboid_origin + point_x]		// Store new value of point_x 

        ldr     w23, [x8, cuboid_origin + point_y]		// Load the value of point_y to w23
        add     w23, w23, w2					// w23 = y - 6
        str     w23, [x8, cuboid_origin + point_y]		// Store new value of point_y

        ldp     x29, x30, [sp], move_dealloc			// Deallocate memory for function move
        ret
