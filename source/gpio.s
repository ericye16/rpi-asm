.globl GetGpioAddress
GetGpioAddress:
        ldr r0,=0x20200000
        mov pc,lr
.globl SetGpioFunction
SetGpioFunction:
        cmp r0,#53 @ pin number <= 53?
        cmpls r1,#7 @ gpio instruction > 7  ?
        movhi pc,lr @ return now if invalid
        push {lr}
        mov r2,r0 @ move r0 out of the way because GetGpioAddress needs it
        bl GetGpioAddress
functionLoop$:
        cmp r2,#9 @ while (r2 > 9) {
        subhi r2,#10 @ r2 -= 10
        addhi r0,#4 @ r0 += 4
        bhi functionLoop$ @ }
        add r2, r2,lsl #1
        lsl r1,r2
        str r1,[r0]
        pop {pc}

