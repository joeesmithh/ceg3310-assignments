.ORIG x3000
; = = = = = = = = = = = = = = = = =

; Get first number
LEA	R0,	PROMPT1
PUTS
JSR	GETNUM

; Store number in R3
AND R3, R3, #0
ADD R3, R3, R0

; Output new line
LD R0, NEWLINE_CHAR
OUT

; Get operator
LEA	R0,	PROMPT2
PUTS
JSR	GETOP

; Store operator in R2
AND R2, R2, #0
ADD R2, R2, R0

; Output new line
LD R0, NEWLINE_CHAR
OUT

; Get second number
LEA	R0,	PROMPT3
PUTS
JSR	GETNUM

; Store second number in R1
AND R1, R1, #0
ADD R1, R1, R0

; Output new line
LD R0, NEWLINE_CHAR
OUT

; Store first number in R0 and run CALC
AND R0, R0, #0
ADD R0, R0, R3
JSR CALC

AND R4, R4, #0
ADD R4, R4, R0

HALT
; - - - - - - - - - - - - - - - - -
; MAIN VARS
NEWLINE_CHAR .FILL x000A
PROMPT1 .STRINGZ "Enter first number (0-99): "
PROMPT2 .STRINGZ "Enter an operation (+, -, *): "
PROMPT3 .STRINGZ "Enter second number (0-99): "
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

BRnzp GETNUM_INPUT ; Branch unconditionally on first call to INPUT

GETNUM_ERROR ; Branch target for invalid integer input
AND R0, R0, #0
ADD R0, R0, x000A
OUT ; Output new line
LEA R0, ERROR_MSG
PUTS ; Output error message

GETNUM_INPUT

GETC ; Input 1st character
OUT  ; Output 1st character
LD R1, NEG_48
ADD R2, R0, R1 ; R2 = 1st int

ADD R1, R2, #-9 ; Validate 1st int <= 9
BRp GETNUM_ERROR
ADD R1, R1, #9  ; Validate 1st int >= 0
BRn GETNUM_ERROR

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
BRp GETNUM_ERROR
ADD R1, R1, #9  ; Validate 2nd int >= 0
BRn GETNUM_ERROR

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
; - - - - - - - - - - - - - - - - -
; GETNUM VARS
GETNUM_R1 .BLKW	#1
GETNUM_R2 .BLKW	#1
GETNUM_R7 .BLKW	#1
NEG_48 .FILL xFFD0
ERROR_MSG .STRINGZ "Invalid input! Stay within (0-99): "
; END GETNUM = = = = = = = = = = = = = = = = =




; GETOP = = = = = = = = = = = = = = = = = = =
; Stores user input operator (+, -, or *) in R0.
; Input is validated from within the subroutine
; until the input is correct.
GETOP

; Callee saves
ST R1, GETOP_R1
ST R7, GETOP_R7

BRnzp GETOP_INPUT ; Branch unconditionally past error message

GETOP_ERROR ; Branch target for invalid input
AND R0, R0, #0
ADD R0, R0, x000A
OUT ; Output new line
LEA R0, OP_ERROR_MSG
PUTS

GETOP_INPUT

; User input
GETC
OUT

; Validate input
LD R1, GETOP_TIMES_CHAR
ADD R1, R0, R1
BRz GETOP_SUCCESS

LD R1, GETOP_PLUS_CHAR
ADD R1, R0, R1
BRz GETOP_SUCCESS

LD R1, GETOP_MINUS_CHAR
ADD R1, R0, R1
BRz GETOP_SUCCESS

BRnzp GETOP_ERROR ; Branch to error message, try new input

GETOP_SUCCESS ; Branch target for input validation

; Callee loads
LD	R1,	GETOP_R1
LD	R7,	GETOP_R7

RET
; - - - - - - - - - - - - - - - - -
; GETOP VARS
GETOP_R1 .BLKW	#1
GETOP_R7 .BLKW	#1
GETOP_TIMES_CHAR .FILL xFFD6 ; Negated ASCII op chars
GETOP_PLUS_CHAR .FILL xFFD5  ;
GETOP_MINUS_CHAR .FILL xFFD3 ;
OP_ERROR_MSG .STRINGZ "Invalid input! Enter one of (+, -, or *): "
; END GETOP = = = = = = = = = = = = = = = = =




; CALC = = = = = = = = = = = = = = = = =
; Takes registers R0-R3 as operands and operator,
;   respectively, and stores the result in R0;
;
; Input:
;       R0  (int): left operand
;       R1  (int): right operand
;       R2 (char): operator
; Output:
;       R0  (int): result
CALC

; Callee saves
ST R3, CALC_R3
ST R7, CALC_R7

; Branch to respective operator if match
LD R3, CALC_TIMES_CHAR
ADD R3, R2, R3
BRz CALC_MULTIPLY         ; Multiply
LD R3, CALC_PLUS_CHAR
ADD R3, R2, R3
BRz CALC_ADD              ; Add
LD R3, CALC_MINUS_CHAR
ADD R3, R2, R3
BRz CALC_SUBTRACT         ; Subtract

BRnzp CALC_END ; Unconditional branch to end of subroutine

; Multiply
;--------------------------------------
CALC_MULTIPLY

; Branch if either operator == 0
ADD R0, R0, #0
BRz TIMES_ZERO
ADD R1, R1, #0
BRz TIMES_ZERO

; Assign R3 = rhs operator - 1      5*6 5+5+5+5+5+5
AND R3, R3, #0
ADD R3, R3, R1
ADD R3, R3, #-1

; Set R1 = lhs operator
AND R1, R1, #0
ADD R1, R1, R0

DO_MULTIPLY
ADD R0, R0, R1
ADD R3, R3, #-1
BRnp DO_MULTIPLY

BRnzp CALC_END

; Add
;--------------------------------------
CALC_ADD


BRnzp CALC_END


; Subtract
;--------------------------------------
CALC_SUBTRACT


BRnzp CALC_END

TIMES_ZERO
AND R0, R0, #0 ; R0 = 0

CALC_END ; No valid operator

LD R3, CALC_R3
LD R7, CALC_R7 ; Callee loads

RET
; - - - - - - - - - - - - - - - - -

; CALC VARS
CALC_R3 .BLKW #1
CALC_R7 .BLKW #1
CALC_TIMES_CHAR .FILL xFFD6 ; Negated ASCII op chars
CALC_PLUS_CHAR .FILL xFFD5  ;
CALC_MINUS_CHAR .FILL xFFD3 ;
; = = = = = = = = = = = = = = = = =



.END