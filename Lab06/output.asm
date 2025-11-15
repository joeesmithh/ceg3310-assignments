.ORIG x5000

; Save registers
ST R1, SAVE_R1
ST R2, SAVE_R2
ST R7, SAVE_R7

LEA R2, NUMS    ; R2 = address of NUMS

; Initialize new quotient
NEW_QUOTIENT
AND R1, R1, #0  ; R1 = 0

; Subtract 10 from quotient
SUB10
ADD R0, R0, #-10
BRzp BUILD_QUOTIENT

; Quotient found - store remainder in array
ADD R0, R0, #10
STR	R0, R2, #0

; Branch if quotient = 0
ADD R1, R1, #0
BRz DISPLAY_NEXT

; Prepare for branch
ADD R2, R2, #1 ; Increment NUMS address
ADD R0, R1, #0 ; R0 = quotient
BRnzp NEW_QUOTIENT

; Accumulate quotient
BUILD_QUOTIENT
ADD R1, R1, #1
BRnzp SUB10

; Output next char
DISPLAY_NEXT
LDR R0, R2, #0  ; Load int from current address
LD  R1, CHAR_ZERO  ; R1 = 48
ADD R0, R0, R1  ; Convert to char
OUT             ; Output char

; Prepare for branch
ADD R2, R2, #-1 ; Decrement char array address
LEA R1, NUMS    ; Load NUMS address
NOT R1, R1      
ADD R1, R1, #1  ; R1 = -NUMS address
ADD R0, R2, R1  ; Current address >= NUMS address ???
BRzp DISPLAY_NEXT

; Restore registers
LD R1, SAVE_R1
LD R2, SAVE_R2
LD R7, SAVE_R7

RET

; Variables
SAVE_R1     .BLKW #1
SAVE_R2     .BLKW #1
SAVE_R7     .BLKW #1
CHAR_ZERO   .FILL x0030
NUMS        .BLKW #5 ; Store result as individual nums

.END