.ORIG x3000

; main() return value
LD R6, STACK_BOTTOM         ; Load stack bottom into R6, R6 = x6000

; main() return address
ADD R6, R6, #-1             ; Used to push main() return address, R6 = x5FFF
STR R7, R6, #0              ; Store R7 in R6

; Previous frame pointer stored in R5
ADD R6, R6, #-1             ; R6 = x5FFE
STR R5, R6, #0

STACK_BOTTOM .FILL X6000    ; Initilize bottom of stack

.END