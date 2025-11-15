.ORIG x4000

; Callee saves
ST	R1,	SAVE_R1
ST	R2,	SAVE_R2
ST	R7,	SAVE_R7

BRnzp INPUT ; Branch unconditionally on first call to INPUT

ERROR ; Branch target for invalid integer input
AND R0, R0, #0
ADD R0, R0, x000A
OUT ; Output new line
LEA R0, ERROR_MSG
PUTS ; Output error message

INPUT

GETC ; Input 1st character
OUT  ; Output 1st character
LD R1, NEG_48
ADD R2, R0, R1 ; R2 = 1st int

ADD R1, R2, #-9 ; Validate 1st int <= 9
BRp ERROR
ADD R1, R1, #9  ; Validate 1st int >= 0
BRn ERROR

GETC ; Input 2nd character

; Check if 2nd char == newline
AND R1, R1, #0
ADD R1, R1, #-10
ADD R1, R0, R1
BRz SINGLE_DIGIT

; Integer still double-digit at this point

OUT ; Output 2nd character
LD R1, NEG_48 
ADD R0, R0, R1 ; R0 = 2nd int

ADD R1, R0, #-9 ; Validate 2nd int <= 9
BRp ERROR
ADD R1, R1, #9  ; Validate 2nd int >= 0
BRn ERROR

; (1st int x 10) + 2nd int
AND R1, R1, #0
ADD R1, R1, #10
EXPAND
ADD R0, R0, R2
ADD R1, R1, #-1
BRnp EXPAND

; R0 now holds double-digit result

BRnzp DOUBLE_DIGIT

SINGLE_DIGIT ; Branch target if 2nd char == new line
AND R0, R0, #0
ADD R0, R0, R2 ; Store first digit in R0

DOUBLE_DIGIT ; Branch target if 2nd char == integer

; Callee loads
LD R1, SAVE_R1
LD R2, SAVE_R2
LD R7, SAVE_R7

RET

; GETNUM VARS - - - - - - - - - - - - - - - - -
SAVE_R1   .BLKW #1
SAVE_R2   .BLKW #1
SAVE_R7   .BLKW #1
NEG_48    .FILL xFFD0
ERROR_MSG .STRINGZ "Invalid input! Stay within (0-99): "

.END