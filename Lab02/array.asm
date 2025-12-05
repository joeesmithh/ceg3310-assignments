.ORIG x3000

; Loading
LD R1, ARRAY_SIZE
NOT R1
ADD R1, R1, #1              ; R1, Negated array size
LEA R2, ARRAY_START         ; R2, Array start address
LD R3, NEG_48               ; R3, #-48
AND R4, R4, #0              ; R4, Loop iterator

LOOP_START LEA R0, PROMPT   ; Load prompt string address into r0
PUTS                        ; Print string starting at R0
TRAP x20                    ; GETC - Store char input in R0
ADD R0, R0, R3              ; Subtract 48 from R0
STR R0, R2, #0              ; Store R0 value at address stored in R2
LD R0, NEWLINE_CHAR         ; Store NEWLINE-CHAR in R0
TRAP x21                    ; OUT - Print new line to console
ADD R2, R2, #1              ; Add 1 to address stored in R2
ADD R4, R, #-1             ; Decrement R1 (ARRAY_SIZE)
BRnp LOOP_START

HALT

; Variables
ARRAY_SIZE .FILL #5
ARRAY_START .BLKW #20
PROMPT .STRINGZ "Input a number between 0 and 9: "
NEWLINE_CHAR .FILL x0A
NEG_48 .FILL xFFD0

.END