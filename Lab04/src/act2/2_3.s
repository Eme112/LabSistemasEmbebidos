@   sum2.s
@   D. Thiebaut
@   add 2 variables together and print the result.
@	
@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	
	.data
	.balign 4	
string1: .asciz "\nEnter the first operand:"
string2: .asciz "\nEnter the second operand:"
string3: .asciz "\nThe result of %d + %d is: %d\n"
format: .asciz  "%d"
num:    .int    0
a:	.word	0
b:	.word	0
c:  .word 0    @ will contain a+b 
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
.text
.global main
.extern printf

main:
        push 	{ip, lr}         @ push return address + dummy register for alignment
        ldr     r0, =string1   @ print msg
        bl      printf
        ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =a         @ string and address of num in r0, and r1,
        bl      scanf            @ respectively.

        ldr     r0, =string2   @ print msg
        bl      printf
        ldr     r0, =format      @ call scanf, and pass address of format
        ldr     r1, =b         @ string and address of num in r0, and r1,
        bl      scanf            @ respectively.
        

        ldr	r1, =a           @ get address of a into r1
        ldr	r1, [r1]         @ get a into r1
        ldr	r2, =b           @ get address of b into r2
        ldr	r2, [r2]         @ get b into r2
        add	r1, r1, r2       @ add r1 to r2 and store into r1
        ldr	r2, =c           @ get address of c into r2
        str	r1, [r2]         @ store r1 into c
	
        ldr 	r0, =string3      @ get address of string into r0
        ldr	r1, =a           @ r1 <- a
        ldr	r1, [r1]
        ldr	r2, =b           @ r2 <- b
        ldr	r2, [r2]
        ldr	r3, =c           @ r3 <- c
        ldr	r3, [r3] 
        bl 	printf           @ print string and pass params into r1, r2, and r3

        pop 	{ip, pc}         @ pop return address into pc