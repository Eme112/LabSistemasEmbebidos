@ act2_6.s
@   D. Thiebaut
@   Assembly program to compute the following equation $6x^2 + 9x + 2$. It reads the value of
@   $x$ using scanf() and prints the result using printf(). It uses the MUL instruction to
@   compute multiplications needed in this program
@
@ ---------------------------------------
@   Data Section
@ ---------------------------------------

.data
.balign 4
equation: .asciz "\nf(x) = 6x^2 + 9x + 2\nf(%d) = %d\n"
string4: .asciz "\nThe result is %d"
string1: .asciz "\nEnter the value of X: "
X:      .word 0
formatInt: .asciz  "%d"
Var1: 	.word	0

@ ---------------------------------------
@   Code Section
@ ---------------------------------------

.text
.global main
.extern printf
.extern scanf
computeResult:
    push   {ip, lr}         @ push return address + dummy register for alignment

    pop    {ip, pc}         @ pop return address into pc

main:
    push   {ip, lr}         @ push return address + dummy register for alignment
 
    ldr     r0, =string1    @ print msg
    bl      printf
    ldr     r0, =formatInt  @ call scanf, and pass address of format
    ldr     r1, =X          @ string and address of num in r0, and r1,
    bl      scanf           @ respectively.

    ldr	    r1,[r1]
    @mov     r0,#9
    mul     r3,r1,r1       @ x*9

    ldr     r2, =Var1           @ get address of c into r2
    str     r3, [r2]         @ store r0 into c

    b       printf_r
    
    printf_r:
        ldr     r0, =string4     @ get address of string into r0
        ldr     r1, =Var1        @ r1 <- Var1
        bl      printf           @ print string and pass params into r1, r3, and r4
        b       end
    pop    {ip, pc}         @ pop return address into pc
