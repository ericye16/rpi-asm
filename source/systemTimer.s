@# void waitUSec(int t){ // wait for t microseconds
@#     char *timerAddr = 0x20003000;
@#     int tCurrent = *(timerAddr + 4);
@#     t += tCurrent;
@#     while (tCurrent != t) {
@#         tCurrent = *(timerAddr + 4);
@#     }
@#     return;
@# }
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
