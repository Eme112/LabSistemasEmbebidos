@ act2_1.s
@   D. Thiebaut
@   Assembly program that writes the values 0xAAAAAAAA, 0xBBBBBBBB and
@   0xCCCCCCCC to the memory location assigned to the variable y using three different
@   addressing modes (three different instructions).
@
@ ---------------------------------------
@   Data Section
@ ---------------------------------------

.data
.balign 4
string: .asciz "\nAddress of y = %Xhx, value of y = %Xhx\n"
A:      .word 0xAAAAAAAA       @ -1431655766
B:      .word 0xBBBBBBBB       @ -1145324613
C:      .word 0xCCCCCCCC       @ -858993460
y:      .word 0x00000000       @ will contain a, b or c

@ ---------------------------------------
@   Code Section
@ ---------------------------------------

.text
.global main
.extern printf

printByValue:
    push   {ip, lr}         @ push return address + dummy register for alignment
    ldr    r0, =string      @ load string into r0
    str    r2, [r1]         @ *r1 = r2
    bl     printf		    @ print string and r1 as parameters
    pop     {ip, pc}

printByReference:
    push   {ip, lr}         @ push return address + dummy register for alignment
    ldr    r0, =string      @ load string into r0
    ldr    r2, [r2]         @ *r2 = C
    str    r2, [r1]         @ *r1 = r2
    bl     printf		    @ print string and r1 as parameters
    pop     {ip, pc}

main:
    push   {ip, lr}         @ push return address + dummy register for alignment

    @ Method 1: direct
    ldr    r0, =string      @ load string into r0
    ldr    r1, =y		    @ r1 = &y
    ldr    r2, =A		    @ 
    ldr    r2, [r2]         @ *r2 = A
    str    r2, [r1]         @ *r1 = A
    bl     printf		    @ print string and r1 as parameters

    @ Method 2: by value
    ldr    r1, =y		    @ r1 = &y
    ldr    r2, =B		    @ 
    ldr    r2, [r2]         @ *r2 = B
    bl     printByValue

    @ Method 3: by reference
    ldr    r1, =y		    @ r1 = &y
    ldr    r2, =C		    @ r2 = &C
    bl     printByReference

    pop    {ip, pc}         @ pop return address into pc