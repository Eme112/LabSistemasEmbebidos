.data
    prompt: .asciz  "Enter a number: "  @ user prompt
            .align  2
    sformat:.asciz  "%d"                @ Format string for reading an int with scanf
            .align  2
    pformat:.asciz  "The sum is: %d\n"  @ Format string for printf
            .align  2
    n:      .word   0                   @ int n = 0
    m:      .word   0                   @ int m = 0

            .text
            .global main
    main:   stmfd   sp!, {lr}       @ push lr onto stack

            @ printf("Enter a number: ")
            ldr     r0, =prompt
            bl      printf

            @ scanf("%d\0", &n)
            ldr     r0, =sformat    @ load address of format string
            ldr     r1, =n          @ load address of int n variable
            bl      scanf           @ call scanf("%d", &n)

            @ printf("Enter a number: ")
            ldr     r0, =prompt
            bl      printf

            @ scanf("%d\0" &m)
            ldr     r0, =sformat    @ load address of format string
            ldr     r1, =m          @ load address of int m variable
            bl      scanf           @ call scanf("%d", &m)

            @ printf("You entered %d\n", n)
            ldr     r0, =pformat    @ load address of format string
            ldr     r2, =m
            ldr     r2, [r2]
            ldr     r1, =n          @ load address of int variable
            ldr     r1, [r1]        @ load int variable
            add     r1, r2, r1
            bl      printf          @ call printf("You entered %d\n", n)

            ldmfd   sp!, {lr}       @ pop lr from stack
            mov     r0, #0          @ load return value
            mov     pc, lr          @ return from main
            .end
