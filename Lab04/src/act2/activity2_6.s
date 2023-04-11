@ act2_1.s
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
equation:  .asciz "\nf(x) = 6x^2 + 9x + 2\nf(%d) = %d\n"
ask_for_X: .asciz "\nEnter the value of x: "
format:    .asciz "%d"
X:      .word 0x00000000
result: .word 0x00000000

@ ---------------------------------------
@   Code Section
@ ---------------------------------------

.text
.global main
.extern printf
.extern scanf

computeResult:
    push   {ip, lr}         @ push return address + dummy register for alignment
    ldr    r0, =X           @ move address of X into r0
    ldr    r1, [r0]         @ load value of X into r1
    ldr    r0, [r0]         @ also load value of X into r0
    mul    r6, r0, r1       @ multiply X by X and store in r6

    mov    r1, #6           @ move 6 into r1
    mul    r7, r1, r6       @ r7 = 6X^2

    mov    r1, #9           @ move 9 into r1
    mul    r8, r1, r0       @ r8 = 9X

    mov    r1, #2           @ move 2 into r1
    add    r9, r7, r8       @ r9 = 6X^2 + 9X
    add    r10, r9, r1      @ r10 = 6X^2 + 9X + 2

    ldr    r0, =result      @ move address of result into r0
    str    r10, [r0]        @ store r10 into result

    pop    {ip, pc}         @ pop return address into pc

askForX:
    push   {ip, lr}         @ push return address + dummy register for alignment

    ldr    r0, =ask_for_X   @ move address of ask_for_X into r0
    bl     printf           @ call printf() to print ask_for_X
    ldr    r0, =format      @ call scanf, and pass address of format
    ldr    r1, =X           @ string and address of num in r0, and r1,
    bl     scanf            @ respectively.

    pop    {ip, pc}         @ pop return address into pc

printEquation:
    ldr    r1, =X           @ move address of X into r1
    ldr    r1, [r1]         @ load value of X into r1
    ldr    r2, =result      @ move address of result into r2
    ldr    r2, [r2]         @ load value of result into r2
    ldr    r0, =equation
    bl     printf

main:
    push   {ip, lr}         @ push return address + dummy register for alignment
    
    bl     askForX          @ call askForX()
    bl     computeResult    @ call computeResult()
    bl     printEquation    @ call printEquation()    

    pop    {ip, pc}         @ pop return address into pc
