.ORIG x3000

; INITIALIZER CODE =======================================
LD  R6, STACK_PTR           ; R6 = x6000 (main() return value)
LEA R4, GLOBAL_VARS         ; R4 = global vars beg. address

; Execute main()
JSR MAIN

HALT

; Global Variables ----------------------------------
STACK_PTR   .FILL x6000     
GLOBAL_VARS .BLKW #1        ; global vars start
NEWLINE     .FILL x000A
CHAR_A      .FILL x0041
; END INITIALIZER CODE ===================================


; ===============================================================
; int main()
; ===============================================================
MAIN

; Push main() return address
ADD R6, R6, #-1
STR R7, R6, #0

; Push previous and set current frame pointer
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

; Push R1
ADD R6, R6, #-1
STR R1, R6, #0

; Push R2
ADD R6, R6, #-1
STR R2, R6, #0

; Push some variables
; ADD R6, R6, #-1


; Code
; ---------------------------------------------------------------
JSR FUNCTION


; Pop some variables
; ADD R6, R6, #1

; Pop R2
LDR R2, R6, #0
ADD R6, R6, #1

; Pop R1
LDR R1, R6, #0
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1

RET

; main() variables 
; SOME_VAR .FILL x0000

; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; END int main()
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\





; ===============================================================
; function()
; ===============================================================
FUNCTION

; Push main() return address
ADD R6, R6, #-1
STR R7, R6, #0

; Push previous and set current frame pointer
ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

; Push R1
ADD R6, R6, #-1
STR R1, R6, #0

; Push R2
ADD R6, R6, #-1
STR R2, R6, #0


; Code
; ---------------------------------------------------------------
LDR R0, R4, #1
OUT
OUT
OUT
OUT

; Pop R2
LDR R2, R6, #0
ADD R6, R6, #1

; Pop R1
LDR R1, R6, #0
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1

RET

; function() variables 
; SOME_VAR .FILL x0000

; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; END function()
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.END