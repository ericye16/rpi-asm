@# waitUSec(int t); // wait for t microseconds
.globl waitUSec
waitUSec:
    t .req r0
    timerAddr .req r1
    ldr timerAddr,=0x20003000
    tCurrent .req r2
    ldr tCurrent, [timerAddr,#4]
    add t, tCurrent
loop1$:
    ldr tCurrent, [timerAddr,#4]
    cmp t, tCurrent
    bne loop1$
    .unreq t
    .unreq timerAddr
    .unreq tCurrent
    mov pc,lr
