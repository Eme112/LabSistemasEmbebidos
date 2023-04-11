@ Ismael Vidal López A00826076

        .data
        .balign 4
inp1: .asciz  "Ingresa el valor de X :  "
inp2: .asciz  "Ingresa el valor de Y :  "
Var1: .asciz  "El valor de X es : %d\n "
Var2: .asciz  "El valor de Y es :  %d\n"
Var3: .asciz  "El valor final es :  %d\n"
Var4: .asciz  "El valor en r3 es :  %d\n"
format: .asciz  "%d"
X:    .int    0
Y:    .int    0
Z:    .int    0
R:    .int    0
valor: .int   255
@ ---------------------------------------
@     Code Section
@ ---------------------------------------
.text
.global main
.extern printf
.extern scanf

sumFunc:
	push	{ip, lr}
	ldr	r1, [r1]
	ldr	r2, [r2]
	add	r0, r1, r2
	add	r3, r0, r1
	pop	{ip, pc}

@ ---------------------------------------

main:   push    {ip, lr}
        ldr     r0, =inp1
        bl      printf

        ldr     r0, =format
        ldr     r1, =X
        bl      scanf

	ldr     r0, =inp2
        bl      printf

        ldr     r0, =format
        ldr     r2, =Y
        bl      scanf

        Ldr     r1, =X
	ldr	r2, =Y
	bl 	sumFunc

	ldr	r3, =Z
	str 	r2, [r3]

	ldr	r0, =valor
	ldr 	r0, [r0]
	cmp	r3, r0

        pop     {ip, pc}

