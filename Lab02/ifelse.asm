.ORIG x3000

LD R0, VAL1   ; Load R0_VAL into R0
LD R1, VAL2   ; Load R1_VAL into R1

; Negate R1
NOT R1, R1
ADD R1, R1, #1

ADD R1, R0, R1  ; Add negated R1 to R0, store in R1
BRnp #2         ; R1 != R0 -> branch PC 3 ahead
ADD R3, R3, #5  ; R1 == R0 -> R3+=5
BRnzp #1        ; Branch PC 2 ahead
ADD R3, R3, #-5 ; R3-=5

STI R3, RES_ADDRESS ; Store result in x8002

HALT

; Variables
VAL1 .BLKW #1
VAL2 .BLKW #1
RES_ADDRESS .FILL x8002

.END