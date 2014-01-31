.section .init
.globl _start
_start:
        ldr r0,=0x20200000
        mov r1,#1
        lsl r1,#18
        str r1,[r0,#4] @ enable output
        mov r1,#1
        lsl r1,#16
loop$: @begin flashing loop
        str r1,[r0,#40] @ turn on OK LED
        mov r2,#0x3F0000 @start waiting
wait1$:
        sub r2, #1
        cmp r2, #0
        bne wait1$ @end waiting
        str r1,[r0,#28] @ turn off OK LED
        mov r2,#0x3F0000 @start waiting
wait2$:
        sub r2, #1
        cmp r2, #0
        bne wait2$ @end waiting
        b loop$ @end flashing loop

