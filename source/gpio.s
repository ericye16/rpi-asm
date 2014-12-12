@# char* GetGpioAddress() { return 0x20200000; }
.globl GetGpioAddress
GetGpioAddress:
    ldr r0,=0x20200000
    mov pc,lr

@# void SetGpioFunction(int pinNo, int instr) {
@#     if (pinNo > 53 || instr > 7) return;
@#     char *gAddress = GetGpioAddress(); // memory addresses are char*
@#     while (pinNo > 9) {
@#         pinNo -= 10;
@#         gAddress += 4;
@#     }
@#     pinNo *= 3;
@#     instr <<= pinNo;
@#     *gAddress = instr;
@#     return;
#@ }
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

@# void SetGpio(int pinNum, int pinVal) {
@#     if (pinNum > 53) return;
@#     char *gpioAddr = GetGpioAddress();
@#     int pinBank = pinNum >> 5;
@#     pinBank <<= 2;
@#     gpioAddr &= pinBank;
@#     pinNum &= 31;
@#     int setBit = 1;
@#     setBit <<= pinNum;
@#     if (pinVal == 0) *(gpioAddr + 40) = setBit;
@#     else *(gpioAddr + 28) = setBit;
@#     return;
@# }
.globl SetGpio
SetGpio:
    pinNum .req r0
    pinVal .req r1
    cmp pinNum, #53
    movhi pc,lr
    push {lr}
    mov r2,pinNum
    .unreq pinNum
    pinNum .req r2
    bl GetGpioAddress
    gpioAddr .req r0
    pinBank .req r3
    lsr pinBank,pinNum,#5
    lsl pinBank,#2
    add gpioAddr,pinBank
    .unreq pinBank
    and pinNum,#31
    setBit .req r3
    mov setBit, #1
    lsl setBit,pinNum
    .unreq pinNum
    teq pinVal,#0
    .unreq pinVal
    streq setBit,[gpioAddr,#40]
    strne setBit,[gpioAddr,#28]
    .unreq setBit
    .unreq gpioAddr
    pop {pc}
