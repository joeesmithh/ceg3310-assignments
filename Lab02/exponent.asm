.ORIG x3000

LD R1, X_VAR
LD R2, Y_VAR

; Initialize iterators
AND R4, R4, #0
ADD R4, R1, #-1 ; Addition iterator

AND R5, R5, #0
ADD R5, R2, #-1 ; Mulitplication iterator

AND R3, R3, #0
ADD R3, R3, R1  ; Result builder

AND R6, R6, #0
AND R6, R1, #0  ; Adder

; Begin exponent evaluation algorithm
DO_ADD
ADD R3, R3, R6  ; Add R6 (adder) to R3 (builder)
ADD R4, R4, #-1 ; Decrement addition iterator
BRnp DO_ADD     

AND R6, R6, #0
ADD R6, R3, #0 ; Store R3 (builder) in R6 (adder)

AND R4, R4, #0
ADD R4, R1, #-1 ; Reset addition iterator

ADD R2, R2, #-1 ; Decrement multiplication iterator
BRnp DO_ADD

STI R3, RESULT_LOC ; Store result in memory location x8000

HALT

; Variables
X_VAR .FILL #5
Y_VAR .FILL #5
RESULT_LOC .FILL x8000

.END