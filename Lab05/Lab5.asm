.ORIG	x3000





; INITIALIZER CODE =======================================
LD  R6, STACK_PTR    ; R6 = x6000 (stack start)
LEA	R4,	GLOBAL_VARS  ; R4 = global vars beg. address

; Execute main()
JSR MAIN

; Store result in TOTAL for debug purposes
ST R0, TOTAL

HALT

; Global Variables ----------------------------------
STACK_PTR .FILL x6000
TOTAL       .BLKW #1 ; final total      
GLOBAL_VARS .BLKW #1 ; global vars start
ARRAY_SIZE  .FILL #5 ; arraySize
; END INITIALIZER CODE ===================================





; MAIN ===================================================
MAIN

; Set MAIN return address at stack start
STR	R7,	R6,	#0

; Set current frame pointer to stack start (no previous frame to push)
ADD R5, R6, #0

; TODO: push factorial input (n) as parameter

JSR FACTORIAL

; Load main() return address and frame pointer
ADD R5, R6, #0
LDR R7, R6 #0

RET
; END MAIN ===============================================





; FACTORIAL
FACTORIAL

; TODO: Check n = 0, 1

; TODO: Call factorial (n-1)

RET
; END FACTORIAL ==========================================