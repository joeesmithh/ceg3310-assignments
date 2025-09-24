.ORIG x3000
; MAIN = = = = = = = = = = = = = = = = =

MAIN

; Get lhs op
LEA	R0,	PROMPT1
PUTS
JSR	GETNUM
ST	R0,	OPERAND_LHS

; Output new line
LD R0, NEWLINE_CHAR
OUT

; Get operator
LEA	R0,	PROMPT2
PUTS
JSR	GETOP
ST	R0,	OPERATOR

; Output new line
LD R0, NEWLINE_CHAR
OUT

; Get rhs op
LEA	R0,	PROMPT3
PUTS
JSR	GETNUM
ST	R0,	OPERAND_RHS

; Output new line
LD R0, NEWLINE_CHAR
OUT

; Calculate with inputs R0-R2
LD	R0,	OPERAND_LHS
LD	R1,	OPERAND_RHS
LD	R2,	OPERATOR
JSR CALC

; Output result
JSR DISPLAY

; Output new lines
LD R0, NEWLINE_CHAR
OUT
OUT

; Unconditional to beginning
BRnzp MAIN

HALT

; MAIN VARS - - - - - - - - - - - - - - - - -
OPERAND_LHS     .BLKW #1
OPERAND_RHS     .BLKW #1
OPERATOR        .BLKW #1
NEWLINE_CHAR    .FILL x000A
PROMPT1         .STRINGZ "Enter first number (0-99): "
PROMPT2         .STRINGZ "Enter an operation (+, -, *): "
PROMPT3         .STRINGZ "Enter second number (0-99): "
; End of MAIN = = = = = = = = = = = = = = = = =



; DISPLAY = = = = = = = = = = = = = = = = =
; Outputs 1-4 digit integer in R0 to console.
DISPLAY

; Callee saves
ST R1, DISPLAY_SAVE_R1
ST R2, DISPLAY_SAVE_R2
ST R3, DISPLAY_SAVE_R3
ST R7, DISPLAY_SAVE_R7
LEA R2, DISPLAY_ARRAY

; Save R0 in R1
AND R1, R1, #0
ADD R1, R1, R0

; Output "Result: "
LEA R0, DISPLAY_PROMPT
PUTS

; Test negative
ADD R1, R1, #0
BRzp NOT_NEGATIVE

; Num was negative
LD R0, DISPLAY_NEG_CHAR
OUT
NOT R1, R1
ADD R1, R1, #1 ; Convert stored num to positive

; BRANCH TARGET: Load positive number back into R0
NOT_NEGATIVE
AND R0, R0, #0
ADD R0, R0, R1

; BRANCH TARGET: Initialize new quotient
NEW_QUOTIENT
AND R1, R1, #0

; BRANCH TARGET: Subtract 10 from quotient
SUB10
ADD R0, R0, #-10
BRzp BUILD_QUOTIENT


; Quotient found - store remainder in array
ADD R0, R0, #10
STR	R0, R2, #0

; Branch if quotient = 0
ADD R1, R1, #0
BRz DISPLAY_SHOW

; Prepare for branch
ADD R2, R2, #1 ; Increment DISPLAY_CHARS address
AND R0, R0, #0
ADD R0, R0, R1 ; R0 = quotient
BRnzp NEW_QUOTIENT

; BRANCH TARGET: Accumulate quotient
BUILD_QUOTIENT
ADD R1, R1, #1
BRnzp SUB10

; BRANCH TARGET: Initialize display
DISPLAY_SHOW
LD R1, DISPLAY_48       ; R1 = #48
LEA R3, DISPLAY_ARRAY
NOT R3, R3
ADD R3, R3, #1          ; R3 = -DISPLAY_ARRAY address

; BRANCH TARGET: Output next char
DISPLAY_NEXT
LDR R0, R2, #0  ; Load int from current address
ADD R0, R0, R1  ; Convert to char
OUT             ; Output char

; Prepare for branch
ADD R2, R2, #-1 ; Decrement char array address
ADD R0, R2, R3  ; Check if current address < starting address
BRzp DISPLAY_NEXT

; Callee loads
LD R1, DISPLAY_SAVE_R1
LD R2, DISPLAY_SAVE_R2
LD R3, DISPLAY_SAVE_R2
LD R7, DISPLAY_SAVE_R7

RET
; DISPLAY VARS - - - - - - - - - - - - - - - - -
DISPLAY_SAVE_R1  .BLKW     #1
DISPLAY_SAVE_R2  .BLKW     #1
DISPLAY_SAVE_R3  .BLKW     #1
DISPLAY_SAVE_R7  .BLKW     #1
DISPLAY_48       .FILL     x0030
DISPLAY_NEG_CHAR .FILL     x002D
DISPLAY_ARRAY    .BLKW	   #4
DISPLAY_PROMPT   .STRINGZ "Result: "
; End of DISPLAY = = = = = = = = = = = = = = = =



; GETNUM = = = = = = = = = = = = = = = = =
; Stores user integer from 0-99 in R0.
; Single-digit integers are input by pressing
; [ENTER] on the keyboard after input of 1st digit.
; If the integer is not within the correct range,
; the PC branches to the start of the subroutine.
GETNUM

; Callee saves
ST	R1,	GETNUM_SAVE_R1
ST	R2,	GETNUM_SAVE_R2
ST	R7,	GETNUM_SAVE_R7

BRnzp GETNUM_INPUT ; Branch unconditionally on first call to INPUT

GETNUM_ERROR ; Branch target for invalid integer input
AND R0, R0, #0
ADD R0, R0, x000A
OUT ; Output new line
LEA R0, GETNUM_ERROR_MSG
PUTS ; Output error message

GETNUM_INPUT

GETC ; Input 1st character
OUT  ; Output 1st character
LD R1, GETNUM_NEG_48
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
LD R1, GETNUM_NEG_48 
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
LD	R1,	GETNUM_SAVE_R1
LD  R2, GETNUM_SAVE_R2
LD	R7,	GETNUM_SAVE_R7

RET

; GETNUM VARS - - - - - - - - - - - - - - - - -
GETNUM_SAVE_R1   .BLKW	  #1
GETNUM_SAVE_R2   .BLKW	  #1
GETNUM_SAVE_R7   .BLKW	  #1
GETNUM_NEG_48    .FILL    xFFD0
GETNUM_ERROR_MSG .STRINGZ "Invalid input! Stay within (0-99): "
; End of GETNUM = = = = = = = = = = = = = = = = =



; GETOP = = = = = = = = = = = = = = = = = = =
; Stores user input operator (+, -, or *) in R0.
; Input is validated from within the subroutine
; until the input is correct.
GETOP

; Callee saves
ST R1, GETOP_SAVE_R1
ST R7, GETOP_SAVE_R7

BRnzp GETOP_INPUT ; Branch unconditionally past error message

GETOP_ERROR ; Branch target for invalid input
AND R0, R0, #0
ADD R0, R0, x000A
OUT ; Output new line
LEA R0, GETOP_ERROR_MSG
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
LD	R1,	GETOP_SAVE_R1
LD	R7,	GETOP_SAVE_R7

RET

; GETOP VARS - - - - - - - - - - - - - - - - -
GETOP_SAVE_R1    .BLKW	  #1
GETOP_SAVE_R7    .BLKW	  #1
GETOP_TIMES_CHAR .FILL    xFFD6 ; Negated ASCII op chars
GETOP_PLUS_CHAR  .FILL    xFFD5 ;
GETOP_MINUS_CHAR .FILL    xFFD3 ;
GETOP_ERROR_MSG  .STRINGZ "Invalid input! Enter one of (+, -, or *): "
; End of GETOP = = = = = = = = = = = = = = = = =



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
ST R3, CALC_SAVE_R3
ST R7, CALC_SAVE_R7

; Branch to respective operator if match
LD R3, CALC_TIMES_CHAR
ADD R3, R2, R3
BRz CALC_MULTIPLY      ; Branch to multiply
LD R3, CALC_PLUS_CHAR
ADD R3, R2, R3
BRz CALC_ADD           ; Branch to add
LD R3, CALC_MINUS_CHAR
ADD R3, R2, R3
BRz CALC_SUBTRACT      ; Branch to subtract

; Branch unconditionally if no valid operator
BRnzp CALC_END

; BRANCH TARGET: Multiply
CALC_MULTIPLY

; Branch if either operand = 0
ADD R0, R0, #0
BRz ZERO_PRODUCT
ADD R1, R1, #0
BRz ZERO_PRODUCT

; Assign R3 = rhs operator - 1
AND R3, R3, #0
ADD R3, R3, R1
ADD R3, R3, #-1

; Set R1 = lhs operator
AND R1, R1, #0
ADD R1, R1, R0

; Add lhs, rhs times
DO_MULTIPLY
ADD R0, R0, R1
ADD R3, R3, #-1
BRnp DO_MULTIPLY
BRnzp CALC_END

; BRANCH TARGET: Add
CALC_ADD
ADD R0, R0, R1
BRnzp CALC_END

; BRANCH TARGET: Subtract
CALC_SUBTRACT
NOT R1, R1
ADD R1, R1, #1
ADD R0, R0, R1
BRnzp CALC_END

; Brach here if either R0 or R1 == 0
ZERO_PRODUCT
AND R0, R0, #0 ; Assign R0 = 0

; All operations branch here unconditionally
CALC_END

; Callee loads
LD R3, CALC_SAVE_R3
LD R7, CALC_SAVE_R7

RET
; CALC VARS - - - - - - - - - - - - - - - - -
CALC_SAVE_R3    .BLKW #1
CALC_SAVE_R7    .BLKW #1
CALC_TIMES_CHAR .FILL xFFD6 ; Negated ASCII op chars
CALC_PLUS_CHAR  .FILL xFFD5 ;
CALC_MINUS_CHAR .FILL xFFD3 ;
; End of CALC = = = = = = = = = = = = = = = = =

.END