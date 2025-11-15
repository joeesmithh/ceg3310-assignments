.ORIG x4000

TRAP_INPUT

; Callee saves
ST R1, INPUT_SAVE_R1
ST R2, INPUT_SAVE_R2
ST R7, INPUT_SAVE_R7

BRnzp INPUT_INPUT ; Branch unconditionally on first call to INPUT

INPUT_ERROR ; Branch target for invalid integer input
AND R0, R0, #0
ADD R0, R0, x000A
OUT ; Output new line
LEA R0, INPUT_ERROR_MSG
PUTS ; Output INPUT_ERROR message

INPUT_INPUT

GETC ; Input 1st character
OUT  ; Output 1st character
LD R1, INPUT_NEG_48
ADD R2, R0, R1 ; R2 = 1st int

ADD R1, R2, #-9 ; Validate 1st int <= 9
BRp INPUT_ERROR
ADD R1, R1, #9  ; Validate 1st int >= 0
BRn INPUT_ERROR

GETC ; Input 2nd character

; Check if 2nd char == newline
AND R1, R1, #0
ADD R1, R1, #-10
ADD R1, R0, R1
BRz INPUT_SINGLE_DIGIT

; Integer still double-digit at this point

OUT ; Output 2nd character
LD R1, INPUT_NEG_48 
ADD R0, R0, R1 ; R0 = 2nd int

ADD R1, R0, #-9 ; Validate 2nd int <= 9
BRp INPUT_ERROR
ADD R1, R1, #9  ; Validate 2nd int >= 0
BRn INPUT_ERROR

; (1st int x 10) + 2nd int
AND R1, R1, #0
ADD R1, R1, #10
INPUT_EXPAND
ADD R0, R0, R2
ADD R1, R1, #-1
BRnp INPUT_EXPAND

; R0 now holds double-digit result

BRnzp INPUT_DOUBLE_DIGIT

INPUT_SINGLE_DIGIT ; Branch target if 2nd char == new line
AND R0, R0, #0
ADD R0, R0, R2 ; Store first digit in R0

INPUT_DOUBLE_DIGIT ; Branch target if 2nd char == integer

; Callee loads
LD R1, INPUT_SAVE_R1
LD R2, INPUT_SAVE_R2
LD R7, INPUT_SAVE_R7

RET

; GETNUM VARS - - - - - - - - - - - - - - - - -
INPUT_SAVE_R1         .BLKW    #1
INPUT_SAVE_R2         .BLKW    #1
INPUT_SAVE_R7         .BLKW    #1
INPUT_NEG_48          .FILL    xFFD0
INPUT_ERROR_MSG .STRINGZ "Invalid input! Stay within (0-99): "

.END