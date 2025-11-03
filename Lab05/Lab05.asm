.ORIG	x3000





; INITIALIZER CODE =======================================
LD  R6, STACK_PTR    ; R6 = x6000 (stack start)
LEA R4, GLOBAL_VARS  ; R4 = global vars beg. address

; Execute main()
JSR MAIN

HALT

; Global Variables ----------------------------------
STACK_PTR   .FILL x6000     
GLOBAL_VARS .BLKW #1    ; global vars start
NEG_48      .FILL xFFD0 ; NEG_48 = -48
POS_48      .FILL x0030 ; POS_48 =  48
NL          .FILL x000A ; NL     =  \n
; END INITIALIZER CODE ===================================





; MAIN ===================================================
MAIN

; Set MAIN return address at stack start
STR R7, R6, #0

; Set current frame pointer to stack start (no previous frame to push)
ADD R5, R6, #0

; Save R1
ADD R6, R6, #-1
STR R1, R6, #0

; Save R2
ADD R6, R6, #-1
STR R2, R6, #0

; Define int n
ADD R6, R6, #-1
LEA R0, PROMPT
PUTS
GETC            ; R0 = input
OUT
LDR R1, R4, #1  ; R1    = -48
ADD R0, R0, R1  ; R0    = input - 48
STR R0, R6, #0  ; int n = input - 48

; Define int n parameter
ADD R6, R6, #-1
STR R0, R6, #0  ; int n parameter = int n

; Declare int result
ADD R6, R6, #-1

; int result = fibonacci(n) ------------------------------
JSR FIBONACCI
STR R0, R5, #-5

; Output result ------------------------------------------
LEA R2, NUMS    ; Load NUMS address

; Output "\n"
LDR R0, R4, #3
OUT

; Output "F(n) = "
LEA R0, RES_LHS
PUTS
LDR R0, R5, #-3
LDR R1, R4, #2
ADD R0, R0, R1
OUT
LEA R0, RES_RHS
PUTS

; Load int result
LDR R0, R5, #-5

; Initialize new quotient
NEW_QUOTIENT
AND R1, R1, #0  ; R1 = 0

; Subtract 10 from quotient
SUB10
ADD R0, R0, #-10
BRzp BUILD_QUOTIENT

; Quotient found - store remainder in array
ADD R0, R0, #10
STR	R0, R2, #0

; Branch if quotient = 0
ADD R1, R1, #0
BRz DISPLAY_NEXT

; Prepare for branch
ADD R2, R2, #1 ; Increment NUMS address
ADD R0, R1, #0 ; R0 = quotient
BRnzp NEW_QUOTIENT

; Accumulate quotient
BUILD_QUOTIENT
ADD R1, R1, #1
BRnzp SUB10

; Output next char
DISPLAY_NEXT
LDR R0, R2, #0  ; Load int from current address
LDR R1, R4, #2  ; R1 = 48
ADD R0, R0, R1  ; Convert to char
OUT             ; Output char

; Prepare for branch
ADD R2, R2, #-1 ; Decrement char array address
LEA R1, NUMS    ; Load NUMS address
NOT R1, R1      
ADD R1, R1, #1  ; R1 = -NUMS address
ADD R0, R2, R1  ; Current address >= NUMS address ???
BRzp DISPLAY_NEXT

; Stack pop ----------------------------------------------
; Pop local variables
ADD R6, R6, #3

; Pop save R2
LDR R2, R6, #0
ADD R6, R6, #1

; Pop save R1
LDR R1, R6, #0
ADD R6, R6, #1

; Load main() return address and frame pointer
ADD R5, R6, #0
LDR R7, R6 #0

RET
; MAIN Variables -----------------------------------------
PROMPT  .STRINGZ	"Please enter a number n: "
RES_LHS .STRINGZ	"F("
RES_RHS .STRINGZ	") = "
NUMS    .BLKW       #5 ; Store result as individual nums
; END MAIN ===============================================





; FIBONACCI ==============================================
FIBONACCI

; Push fibonacci() return address
ADD R6, R6, #-1
STR	R7,	R6,	#0  ; Store return address

; Push previous frame pointer
ADD R6, R6, #-1
STR R5, R6, #0  ; Store previous frame pointer
ADD R5, R6, #0  ; Set current frame pointer

; Save R1
ADD R6, R6, #-1
STR R1, R6, #0

; Declare int n1
ADD R6, R6, #-1
LDR R0, R5, #3  ; Load int n parameter
ADD R1, R0, #-1
STR R1, R6, #0  ; int n1 = n - 1 

; Delcare int n2
ADD R6, R6, #-1
LDR R0, R5, #3  ; Load int n parameter
ADD R1, R0, #-2
STR R1, R6, #0  ; int n2 = n - 2

; Declare int n parameter
ADD R6, R6, #-1

; Declare int result
ADD R6, R6, #-1

; Check n <= 1
LDR R0, R5, #3  ; Load int n parameter
ADD R1, R0, #-1
BRnz RETURN_N

; n > 1 --------------------------------------------------
; fibonacci(n - 1)
LDR R1, R5, #-2
STR R1, R5, #-4 ; int n parameter = n - 1
JSR FIBONACCI
STR R0, R5, #-5 ; int result = fibonacci(n - 1)

; fibonacci(n - 2)
LDR R1, R5, #-3
STR R1, R5, #-4 ; int n parameter = n - 2
JSR FIBONACCI
LDR R1, R5, #-5 ; R1 = int result
ADD R0, R0, R1  ; R0 = fibonacci(n - 1) + fibonacci(n - 2)
BRnzp RETURN

; n <= 1 -------------------------------------------------
RETURN_N
LDR R0, R5, #3  ; R0 = int n parameter
BRnzp RETURN

; return -------------------------------------------------
RETURN
STR R0, R5, #-5 ; int result = R0

; Pop local variables
ADD R6, R6, #4

; Pop save R1
LDR R1, R6, #0
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Pop sumOfSquares() return address
LDR R7, R6, #0 
ADD R6, R6, #1

RET
; END FIBONACCI ==========================================





.END