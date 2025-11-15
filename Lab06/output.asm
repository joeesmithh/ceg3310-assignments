.ORIG x5000

TRAP_OUTPUT

; Save registers
ST R1, OUTPUT_SAVE_R1
ST R2, OUTPUT_SAVE_R2
ST R7, OUTPUT_SAVE_R7

LEA R2, OUTPUT_NUMS    ; R2 = address of OUTPUT_NUMS

; Initialize new quotient
OUTPUT_NEW_QUOTIENT
AND R1, R1, #0  ; R1 = 0

; Subtract 10 from quotient
OUTPUT_SUB10
ADD R0, R0, #-10
BRzp OUTPUT_BUILD_QUOTIENT

; Quotient found - store remainder in array
ADD R0, R0, #10
STR	R0, R2, #0

; Branch if quotient = 0
ADD R1, R1, #0
BRz OUTPUT_DISPLAY_NEXT

; Prepare for branch
ADD R2, R2, #1 ; Increment OUTPUT_NUMS address
ADD R0, R1, #0 ; R0 = quotient
BRnzp OUTPUT_NEW_QUOTIENT

; Accumulate quotient
OUTPUT_BUILD_QUOTIENT
ADD R1, R1, #1
BRnzp OUTPUT_SUB10

; Output next char
OUTPUT_DISPLAY_NEXT
LDR R0, R2, #0  ; Load int from current address
LD  R1, OUTPUT_CHAR_ZERO  ; R1 = 48
ADD R0, R0, R1  ; Convert to char
OUT             ; Output char

; Prepare for branch
ADD R2, R2, #-1 ; Decrement char array address
LEA R1, OUTPUT_NUMS    ; Load OUTPUT_NUMS address
NOT R1, R1      
ADD R1, R1, #1  ; R1 = -OUTPUT_NUMS address
ADD R0, R2, R1  ; Current address >= OUTPUT_NUMS address ???
BRzp OUTPUT_DISPLAY_NEXT

; Restore registers
LD R1, OUTPUT_SAVE_R1
LD R2, OUTPUT_SAVE_R2
LD R7, OUTPUT_SAVE_R7

RET

; Variables
OUTPUT_SAVE_R1     .BLKW #1
OUTPUT_SAVE_R2     .BLKW #1
OUTPUT_SAVE_R7     .BLKW #1
OUTPUT_CHAR_ZERO   .FILL x0030
OUTPUT_NUMS        .BLKW #5 ; Store result as individual OUTPUT_NUMS

.END