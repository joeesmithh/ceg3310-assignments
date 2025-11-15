.ORIG x3000
; ===============================================================
; int main()
; ===============================================================

; Stack start = int main() return value
LD R6, STACK_BASE       ; R6 = x6000

; Push main() return address
ADD R6, R6, #-1         ; R6 = x5FFF
STR R7, R6, #0          ; R7 → x5FFF

; Push previous and set current frame pointer
ADD R6, R6, #-1         ; R6 = x5FFE
STR R5, R6, #0          ; R5 → x5FFE 
ADD R5, R6, #0          ; R5 = x5FFE

; Push node_t *head variable
ADD R6, R6, #-1         ; R6 = x5FFD
AND R0, R0, #0          ; R0 = 0
STR R0, R6, #0

; Push char selection variable
ADD R6, R6, #-1         ; R6 = x5FFC

; Main menu loop
; ---------------------------------------------------------------

; do
; ------------------------------
DO

; Menu prompt
LEA R0, PROMPT_MENU
PUTS

; Input
GETC
OUT
STR	R0,	R5, #2

; if(selection == 'p')
; ------------------------------
LD R1, NEG_LOWERCASE_P
LDR R0, R5, #2
ADD R0, R0, R1
BRnp ELSE_IF_A          ; selection != 'p'


; else if(selection == 'a')
; ------------------------------
ELSE_IF_A
LD R1, NEG_LOWERCASE_A
LDR R0, R5, #2
ADD R0, R0, R1
BRnp ELSE_IF_R          ; selection != 'a'


; else if(selection == 'r')
; ------------------------------
ELSE_IF_R
LD R1, NEG_LOWERCASE_R
LDR R0, R5, #2
ADD R0, R0, R1
BRnp WHILE              ; selection != 'r'


; while(selection != 'q');
; ------------------------------
WHILE
LD R1, NEG_LOWERCASE_Q
LDR R0, R5, #2
ADD R0, R0, R1
BRnp DO                 ; selection != 'q'

; End main menu loop
; ---------------------------------------------------------------

; Print newline
LD R0, NEWLINE
OUT






; Pop main() local variables
ADD R6, R6, #2          ; R6 = x5FFE

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1          ; R6 = x5FFF

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1          ; R6 = x6000

HALT

; main() variables 
STACK_BASE      .FILL    x6000
NEG_LOWERCASE_A .FILL    xFF9F
NEG_LOWERCASE_P .FILL    xFF90
NEG_LOWERCASE_Q .FILL    xFF8F
NEG_LOWERCASE_R .FILL    xFF8E
NEWLINE         .FILL    #10
PROMPT_MENU     .STRINGz "Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT    .STRINGz "\nContents of the linked list:\n"
PROMPT_ADD      .STRINGz "\nType a number to add: "
PROMPT_REMOVE   .STRINGz "\nType a number to remove: "

.END