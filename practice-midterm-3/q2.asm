.ORIG x3000

START

; Input int 1
LEA R0, PROMPT
PUTS
GETC
OUT
ADD R1, R0, #0

; New line
LD, R0, NL
OUT

; Input int 2
LEA R0, PROMPT
PUTS
GETC
OUT
ADD R2, R0, #0

; New line
LD, R0, NL
OUT

; Output "R1 / R2 = "
ADD R0, R1, #0
OUT

LEA R0, DIV
PUTS

ADD R0, R2, #0
OUT

LEA R0, EQ
PUTS
; ------------------------------

; Convert char ints to numbers
LD R0, NEG48
ADD R1, R1, R0
ADD R2, R2, R0

; R3 = 0
AND R3, R3, #0

; R2 = -R2
NOT R2, R2
ADD R2, R2, #1

; Subtract until nothing left to subtract
SUB
ADD R1, R1, R2
BRzp INC

BRnzp END

INC
ADD R3, R3, #1
BRnzp SUB

END
; ------------------------------

; Convert result to char and print
LD R0, POS48
ADD R3, R3, R0
ADD R0, R3, #0
OUT

; New line
LD, R0, NL
OUT

; Back to start
BRnzp START

HALT

; Variables
NEG48 .FILL xFFD0
POS48 .FILL x0030
NL .FILL x000A
PROMPT .STRINGZ	"Please enter a digit: "
DIV .STRINGZ	" / "
EQ .STRINGZ	" = "

.END