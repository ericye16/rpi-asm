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

