.ORIG x3000

PROG_START

LEA R0, PROMPT
PUTS
GETC                ; R0 = num (char)
OUT

LD R1, NEG_48
ADD R0, R0, R1      ; R0 = num (int)

AND R2, R2, #0
ADD R2, R2, #-5     ; R2 = -5

; less than
; ----------------------------------------
ADD R0, R0, R2      
BRzp GOTO_GT

; print result
LEA R0, RESULT
PUTS
LEA R0, LT
PUTS

; return
BRnzp RETURN

; greater than
; ----------------------------------------
GOTO_GT
ADD R0, R0, #5      ; add 5 back to R0
ADD R0, R0, R2
BRnz GOTO_EQ

; print result
LEA R0, RESULT
PUTS
LEA R0, GT
PUTS

; return
BRnzp RETURN

; equal to
; ----------------------------------------
GOTO_EQ

; print result
LEA R0, RESULT
PUTS
LEA R0, EQ
PUTS

; return
; ----------------------------------------
RETURN

; loop
BRnzp PROG_START

HALT
; Variables
PROMPT .STRINGZ	"Please enter a number: "
RESULT .STRINGZ	"\nThe number you entered was "
LT .STRINGZ	"less than 5!\n\n"
GT .STRINGZ	"greater than 5!\n\n"
EQ .STRINGZ	"equal to 5!\n\n"
NEG_48 .FILL xFFD0

.END