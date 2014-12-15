.section .init
.globl _start
_start:
    b main

.section .text
main:
    @# stack starts at 0x8000 and goes down
    mov sp,#0x8000
    @# SetGpioFunction(16,1);
    pinNum .req r0
    pinFunc .req r1
    mov pinNum,#16
    mov pinFunc,#1
    bl SetGpioFunction
    .unreq pinNum
    .unreq pinFunc
    
loop$:
    @# SetGpio(16,0);
    pinNum .req r0
    pinVal .req r1
    mov pinNum,#16
    mov pinVal,#0
    bl SetGpio
    .unreq pinNum
    .unreq pinVal
    
    ldr r0,=500000
    bl waitUSec

    pinNum .req r0
    pinVal .req r1
    mov pinNum,#16
    mov pinVal,#1
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    ldr r0,=500000
    bl waitUSec
    
    b loop$
