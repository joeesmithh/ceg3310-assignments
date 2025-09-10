.ORIG x3000

ITERATIONS .FILL #3 ; Allow user to specify iteration count, default 3
LD R1, ITERATIONS   ; Load interation count in R1

; Negate iteration count
;  for-loop termination condition
NOT R2, R1
ADD R2, R2, #1

; For loop
FOR_LOOP 
ADD R3, R3, #5  ; Increment R3 by 5
ADD R4, R4, #1  ; Increment R4 by 1
Add R5, R4, R2  ; Add R2 (negated iteration count) to R4
BRnp FOR_LOOP   ; Repeat loop if previous result not 0

STI R3, RES_ADDRESS ; Store result in x8001

HALT

; Variables
RES_ADDRESS .Fill x8001

.END