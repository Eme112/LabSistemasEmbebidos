@ define los registros
num1 .req r0
num2 .req r1
oper .req r2
resultado .req r3

.text
.global main

main:
    @ pedir al usuario el primer número
    mov r0, #1
    ldr r1, =num1
    bl scanf

    @ pedir al usuario el segundo número
    mov r0, #2
    ldr r1, =num2
    bl scanf

    @ pedir al usuario la operación a realizar
    mov r0, #3
    ldr r1, =oper
    bl scanf

    @ realizar la operación
    ldr r0, =oper
    ldrb r0, [r0]
    cmp r0, #'+'
    bne subtract
    @ suma
    add r3, r0, r1
    b end
subtract:
    cmp r0, #'-'
    bne multiply
    @ resta
    sub r3, r0, r1
    b end
multiply:
    cmp r0, #'*'
    bne divide
    @ multiplicación
    mul r3, r0, r1
    b end
divide:
    cmp r0, #'/'
    bne end
    @ división
    sdiv r3, r0, r1
end:
    @ imprimir el resultado
    mov r0, #4
    mov r1, #1
    ldr r2, =resultado
    bl printf

    @ salir
    mov r0, #0
    bx lr

.data
    @ variables de entrada
    .align
num1:   .word 0
num2:   .word 0
oper:   .byte 0

    @ resultado
    .align
resultado:  .word 0

