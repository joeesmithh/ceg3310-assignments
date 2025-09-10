.ORIG x3000

R0_VAL .FILL #0 ; Allow user to specify R0 value
R1_VAL .FILL #0 ; Allow user to specify R1 value
LD R0, R0_VAL   ; Load R0_VAL into R0
LD R1, R1_VAL   ; Load R1_VAL into R1

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
RES_ADDRESS .Fill x8002

.END