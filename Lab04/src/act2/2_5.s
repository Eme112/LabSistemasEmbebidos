@   add, sub, mul, div 3 variables and print the result.
@	
@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	
	.data
	.balign 4	
string_1: .asciz "\nEnter the first operand:"
string_2: .asciz "\nEnter the second operand:"
string_3: .asciz "\nEnter the third operand:"
string2: .asciz "\nEnter the operation to be performed (+ 1, - 2, * 3, / 4):"
string4: .asciz "\nThe numbers are %d %d %d"
string5: .asciz "\nThe result for the operand %d is: %d\n"
formatInt: .asciz  "%d"
formatChar: .asciz  "%c"
op:    .word  0
op_1:    .word  1 @ *
op_2:    .word  2 @ +
op_3:    .word  3 @ -
op_4:    .word  4 @ /
a:	.word	0
b:	.word	0
c:      .word   0
d:      .word   0    @ will contain a +-*/ b +-*/
d_a:	.word	0
d_b:	.word	0
d_c:      .word   0
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
.text
.global main
.extern printf
.extern scanf

main:
        push 	{ip, lr}        @ push return address + dummy register for alignment
        
        @ NUM 1
        ldr     r0, =string_1    @ print msg
        bl      printf
        ldr     r0, =formatInt  @ call scanf, and pass address of format
        ldr     r1, =a          @ string and address of num in r0, and r1,
        bl      scanf           @ respectively.

        @ NUM 2
        ldr     r0, =string_2    @ print msg
        bl      printf
        ldr     r0, =formatInt  @ call scanf, and pass address of format
        ldr     r1, =b          @ string and address of num in r0, and r1,
        bl      scanf           @ respectively.

        @ NUM 3
        ldr     r0, =string_3    @ print msg
        bl      printf
        ldr     r0, =formatInt  @ call scanf, and pass address of format
        ldr     r1, =c          @ string and address of num in r0, and r1,
        bl      scanf           @ respectively.

askOp:
        ldr     r0, =string2    @ print msg
        bl      printf
        ldr     r0, =formatInt @ call scanf, and pass address of format
        ldr     r1, =op         @ string and address of num in r0, and r1,
        bl      scanf           @ respectively.
        
        ldr	r1, =op         @ r1 <- op
        ldr	r1, [r1]
        
        ldr	r0, =op_1       @ r0 <- op_1
        ldr	r0, [r0]
        cmp     r1, r0          @ check if operator is addition
        beq     add
        
        ldr	r0, =op_2       @ r0 <- op_2
        ldr	r0, [r0]
        cmp     r1, r0          @ check if operator is subtraction
        beq     subtract
        
        ldr	r0, =op_3       @ r0 <- op_2
        ldr	r0, [r0]
        cmp     r1, r0          @ check if operator is multiplication
        beq     mult
                
        ldr	r0, =op_4       @ r0 <- op_3
        ldr	r0, [r0]
        cmp     r1, r0          @ check if operator is division
        beq     div
        
        b       add
        b       askOp           @ op invalid, ask again

add:
        ldr	r0, =a       @ r0 <- a
        ldr	r0, [r0]

        ldr	r1, =b       @ r1 <- b
        ldr	r1, [r1]
        
        ldr	r2, =c       @ r2 <- c
        ldr	r2, [r2]

        add     r0, r0, r1       @ d <- a+b
        add     r0, r0, r2       @ d <- d+c

        ldr	r2, =d           @ get address of d into r2
        str	r0, [r2]         @ store r0 into d

        b       printf_r
        
subtract:
        ldr	r0, =a       @ r0 <- a
        ldr	r0, [r0]

        ldr	r1, =b       @ r1 <- b
        ldr	r1, [r1]

        ldr	r2, =c       @ r2 <- c
        ldr	r2, [r2]

        sub     r0, r0, r1       @ d <- a-b
        sub     r0, r0, r2       @ d <- d-c

        ldr	r2, =d           @ get address of d into r2
        str	r0, [r2]         @ store r0 into d
        b       printf_r
        
mult:
        ldr	r0, =a       @ r0 <- a
        ldr	r0, [r0]

        ldr	r1, =b       @ r1 <- b
        ldr	r1, [r1]

        ldr	r2, =c       @ r2 <- c
        ldr	r2, [r2]

        mul     r3, r0, r1       @ d <- a*b
        mul     r0, r3, r2       @ d <- d*c

        ldr	r2, =d           @ get address of d into r2
        str	r0, [r2]         @ store r0 into d

        b       printf_r

div:
        ldr	r0, =a       @ r0 <- a
        ldr	r0, [r0]
        ldr     r2,  =d_a     @ r2 <- d_a
        str     r0, [r2]       @ d_a = a

        ldr	r0, =b       @ r0 <- b
        ldr	r0, [r0]
        ldr     r2,  =d_b     @ r2 <- d_b
        str     r0, [r2]       @ d_b = b

        bl      div2

        ldr	r0, =d_c       @ r0 <- d_c
        ldr	r0, [r0]
        ldr     r2,  =d_a     @ r2 <- d_a
        str     r0, [r2]       @ d_a = d_C

        ldr	r0, =c       @ r0 <- c
        ldr	r0, [r0]
        ldr     r2,  =d_b     @ r2 <- d_b
        str     r0, [r2]       @ d_b = b

        bl      div2
        
        ldr	r0, =d_c       @ r0 <- d_c
        ldr	r0, [r0]

        ldr	r2, =d           @ get address of d into r2
        str	r0, [r2]         @ store r0 into d

        b       printf_r

div2:   push 	{ip, lr}	@ push return address + dummy register
        ldr	r0, =d_a       @ r0 <- a
        ldr	r0, [r0]

        ldr	r1, =d_b       @ r1 <- b
        ldr	r1, [r1]
        
        mov     r2, #0        @ initialize counter to 0
loop:
        cmp     r0, r1        @ compare dividend and divisor
        blt     done          @ if dividend < divisor, exit loop
        sub     r0, r0, r1    @ subtract divisor from dividend
        add     r2, r2, #1    @ increment counter
        b       loop          @ repeat loop
done:
        ldr     r3, =d_c        @ get address of c into r3
        str     r2, [r3]      @ store counter into c
        pop 	{ip, pc}	@ pop return address into pc

printf_r:
        ldr     r0, =string4     @ get address of string into r0
        ldr     r1, =a           @ r1 <- a
        ldr     r1, [r1]
        ldr     r2, =b         @ r2 <- b
        ldr     r2, [r2]
        ldr     r3, =c          @ r3 = c
        ldr     r3, [r3]
        bl      printf           @ print string and pass params into r1, r3, and r4
        
        ldr     r0, =string5     @ get address of string into r0
        ldr     r1, =op           @ r1 <- op
        ldr     r1, [r1]
        ldr     r2, =d           @ r1 <- d
        ldr     r2, [r2]
        bl      printf           @ print string and pass params into r1, r3, and r4
        
        b       end
        
end:
        pop     {ip, pc}         @ pop return address into pc
