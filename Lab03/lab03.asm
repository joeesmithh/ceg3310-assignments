.ORIG x3000
; = = = = = = = = = = = = = = = = =

; Display prompt
LEA	R0,	PROMPT1
PUTS
JSR	GETNUM

; Store number in R1
AND R4, R4, #0
ADD R4, R4, R0

HALT
; - - - - - - - - - - - - - - - - -

PROMPT1 .STRINGZ "Enter first number (0-99): "
PROMPT2 .STRINGZ "Enter second number (0-99): "
; = = = = = = = = = = = = = = = = =



; = = = = = = = = = = = = = = = = =
DISPLAY

; DISPLAY CODE HERE

RET
; - - - - - - - - - - - - - - - - -

; DISPLAY VARS
; = = = = = = = = = = = = = = = = =



; GETNUM = = = = = = = = = = = = = = = = =
; Stores user integer from 0-99 in R0.
; Single-digit integers are input by pressing
; [ENTER] on the keyboard after input of 1st digit.
; If the integer is not within the correct range,
; the PC branches to the start of the subroutine.
GETNUM

; Callee saves
ST	R1,	GETNUM_R1
ST	R2,	GETNUM_R2
ST	R7,	GETNUM_R7

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
LD	R1,	GETNUM_R1
LD  R2, GETNUM_R2
LD	R7,	GETNUM_R7

RET

; GETNUM Variables
GETNUM_R1 .BLKW	#1
GETNUM_R2 .BLKW	#1
GETNUM_R7 .BLKW	#1
NEG_48 .FILL xFFD0
ERROR_MSG .STRINGZ "Invalid input! Stay within (0-99): "

; END GETNUM = = = = = = = = = = = = = = = = =




; = = = = = = = = = = = = = = = = =
GETOP

; GETOP CODE HERE

RET
; - - - - - - - - - - - - - - - - -

; GETOP VARS
; = = = = = = = = = = = = = = = = =




; = = = = = = = = = = = = = = = = =
CALC

; CALC CODE HERE

RET
; - - - - - - - - - - - - - - - - -

; CALC VARS
; = = = = = = = = = = = = = = = = =



.END