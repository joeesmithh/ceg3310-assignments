; Write an LC3 assembly program originating at memory address x3000 that will load two numbers from memory into registers from addresses x5000 and x5001 into R0 and R1, respectively, using indirect loading.

; You may place any numbers you want into addresses x5000 and x5001 by manually typing them into memory in the simulator.

; After loading the numbers into registers R0 and R1, subtract R1 from R0 and put the result into R2 (e.g. R2 = R0 - R1).

; After performing the subtraction, multiply the result by 10 and put the result into R3, then halt your program.

; An example of your final registers before your program halts may look like this:


; (Assume that the number loaded into R0 will always be greater than R1, meaning, the subtraction result in R2 will never be a negative number or zero.)

; (You are not required to use a runtime stack or subroutines for this program.)

; (You should use the LC3 simulator to verify your code. You are NOT required to write comments. Once you have a complete solution, paste your code in the section below)

.ORIG x3000

LDI	R0,	ADR_1
LDI	R1,	ADR_2

NOT R1, R1
ADD R1, R1, #1

; R2 = R0 - R1
ADD R2, R0, R1

AND R4, R4, #0
ADD R4, R4, #10

AND R3, R3, #0

MULTIPLY
ADD R3, R3, R2
ADD R4, R4, #-1
BRp MULTIPLY

HALT
; Variables
ADR_1 .FILL x5000
ADR_2 .FILL x5001

.END