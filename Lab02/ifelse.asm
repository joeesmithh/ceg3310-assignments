.ORIG x3000

LD R0, VAL1   ; Load R0_VAL into R0
LD R1, VAL2   ; Load R1_VAL into R1

; Negate R1
NOT R1, R1
ADD R1, R1, #1

ADD R1, R0, R1  ; Add negated R1 to R0, store in R1
BRnp #2         ; Branch PC 3 ahead if not zero
ADD R3, R3, #5  ; Add 5 to R3 if zero
BRnzp #2        ; Branch PC 3 ahead
ADD R3, R3, #-5 ; Subtract 5 from R3

STI R3, RES_ADDRESS ; Store result in x8002

HALT

; Variables
VAL1 .BLKW #1
VAL2 .BLKW #1
RES_ADDRESS .Fill x8002

.END