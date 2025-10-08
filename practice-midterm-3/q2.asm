; Write an LC3 assembly program originating at memory address x3000 that will get two single digit integers from the keyboard, perform a integer division, then, display the result, then loop indefinitely. Do not allow for 2 digit or negative numbers.
; To perform integer division for the integers A/B, run a loop that subtracts A =  A - B. Count the amount of loops required to reach but not exceed 0 and that will give you the division result.
;
; Example:
; 9 / 3:
; 9 - 3 = 6    Loop iteration 1
; 6 - 3 = 3    Loop iteration 2
; 3 - 3 = 0    Loop iteration 3
; It took 3 loop iterations before we exceed 0 which means 9 / 3 = 3
;
; Example:
; 5 / 2:
; 5 - 2 = 3    Loop iteration 1
; 3 - 2 = 1    Loop iteration 2
;
; It took 2 loop iterations before we exceed 0 which means 5 / 2 = 2 with a remainder of 1
;
; Here is an example execution:
; Please enter a digit: 9
; Please enter a digit: 3
; 9 / 3 = 3
; Please enter a digit: 5
; Please enter a digit: 2
; 5 / 2 = 2
; Please enter a digit: 8
; Please enter a digit: 2
; 8 / 2 = 4
; Please enter a digit: 2
; Please enter a digit: 6
; 2 / 6 = 0

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