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

; Push R3
ADD R6, R6, #-1
STR R3, R6, #0

; Push some variables
; ADD R6, R6, #-1


; Code
; ---------------------------------------------------------------

; param 5
ADD R6, R6, #-1
AND	R0,	R0,	#0
ADD R0, R0, #5
STR R0, R6, #0

; param 3
ADD R6, R6, #-1
AND	R0,	R0,	#0
ADD R0, R0, #3
STR R0, R6, #0

JSR POWER

STR R0, R5, #2

; Pop some variables
; ADD R6, R6, #1

; pop params
ADD R6, R6, #2

; Pop R3
LDR R3, R6, #0
ADD R6, R6, #1

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
; power()
; ===============================================================
POWER

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

; Push R3
ADD R6, R6, #-1
STR R3, R6, #0

; int result
ADD R6, R6, #-1
AND R1, R1, #0
ADD R1, R1, #1
STR R1, R6, #0


; Code
; ---------------------------------------------------------------

ADD R0, R1, #0 ; R0 = 1

; Check y = 0
LDR R3, R5, #2 ; R3 = 3
ADD R3, R3, #0
BRz RETURN


LDR R1, R5, #3 ; R1 = 5
LDR R2, R5, #3 ; R2 = 5
ADD R3, R3, #-1

DO_MULT
AND R0, R0, #0 ; R0 = 0 

DO_ADD
ADD R0, R0, R1
ADD R2, R2, #-1
BRp DO_ADD

ADD R2, R0, #0  ; R2 = R0
ADD R3, R3, #-1
BRp DO_MULT

STR R0, R6, #0 ; result = R0

RETURN

; Pop result
ADD R6, R6, #1

; Pop R3
LDR R3, R6, #0
ADD R6, R6, #1

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