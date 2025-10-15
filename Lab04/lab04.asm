.ORIG	x3000

; INITIALIZER CODE ==================================
LD R6, STACK_PTR        ; R6 = x6000
LEA	R4,	STATIC_STORAGE  ; R4 = global vars beg. address
ADD R5, R6, #0          ; R5 = x6000

; Execute main()
JSR MAIN
HALT

; Global Variables ----------------------------------
STACK_PTR .FILL x6000
STATIC_STORAGE
.FILL #5 ; arraySize global variable
; END INITIALIZER CODE ==============================




; MAIN ==============================================
MAIN

; Push MAIN return address at x5FFF
ADD R6, R6, #-1
STR	R7,	R6,	#0

; Push previous frame pointer at x5FFE
ADD R6, R6, #-1
STR R5, R6, #0
; Set current frame pointer
ADD R5, R6, #0

; Save R1 at x5FFD
ADD R6, R6, #-1
STR	R1,	R6,	#0

; Initialize array at x5FFC
ADD R6, R6, #-1
LEA	R1,	ARRAY_0
STR	R1,	R6,	#0

; Declare total variable at x5FFB
ADD R6, R6, #-1

; Pass parameter arraySize to sumOfSquares() at x5FFA
ADD	R6,	R6,	#-1
LDR R1, R4, #0
STR R1, R6, #0

; Pass parameter array to sumOfSquares() at x5FF9
ADD	R6,	R6,	#-1
LDR R1, R5, #-2
STR R1, R6, #0

; Execute sumOfSquares(arraySize, array)
JSR SUMOFSQUARES

; Pop array param
ADD R6, R6, #1

; Pop arraySize param
ADD R6, R6, #1

; Pop total var
STR R0, R6, #0 ; int total = R0
ADD R6, R6, #1

; Pop array
ADD R6, R6, #1

; Pop save R1
LDR R1, R6, #0
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6 #0
ADD R6, R6, #1

; Load main() return address
LDR R7, R6 #0
ADD R6, R6, #1

RET

; Main Variables ------------------------------------
ARRAY_0 .FILL #2
ARRAY_1 .FILL #3
ARRAY_2 .FILL #5
ARRAY_3 .FILL #0
ARRAY_4 .FILL #1
; END MAIN ==========================================





; SUMOFSQUARES ======================================
SUMOFSQUARES

; Push sumOfSquares() return address at x5FF8
ADD R6, R6, #-1
STR	R7,	R6,	#0

; Push previous frame pointer at x5FF7
ADD R6, R6, #-1
STR R5, R6, #0
; Set current frame pointer
ADD R5, R6, #0

; Save R1 at x5FF6
ADD R6, R6, #-1
STR R1, R6, #0

; Save R2  at x5FF5
ADD R6, R6, #-1
STR R2, R6, #0

; Initialize counter to 0 at x5FF4
ADD R6, R6, #-1
AND R1, R1, #0
STR R1, R6, #0

; Initialize sum to 0 at x5FF3
ADD R6, R6, #-1
AND R1, R1, #0
STR R1, R6, #0

; Declare int x parameter
ADD R6, R6, #-1

DO_SQUARE
; Load counter and array size
LDR R1, R5, #-3
LDR R2, R5, #3

; counter < arraySize ?
NOT R1, R1
ADD R1, R1, #1
ADD R2, R2, R1
BRnz SUMSQUARES_CTR_DONE

; Pass int x to square() as current array element
LDR	R1,	R5,	#-3 ; R1 = counter
LDR R2, R5, #2  ; R2 = beg. array address
ADD R2, R2, R1  ; R2 = beg. array address + counter
LDR R2, R2, #0  ; R2 = element at array address
STR R2, R6, #0  ; int x = R2

; Execute square(int x)
JSR SQUARE

; Accumulate sum at x5FF2
LDR R1, R5, #-4
ADD R1, R1, R0
STR R1, R5, #-4 ; sum = sum + R0

; Increment counter at x5FF3
LDR R1, R5, #-3
ADD R1, R1, #1
STR R1, R5, #-3 ; counter = counter + 1

BRnzp DO_SQUARE

SUMSQUARES_CTR_DONE

; Pop int x parameter
ADD R6, R6, #1

; Pop sum param
LDR R0, R6, #0 ; R0 = sum
ADD R6, R6, #1

; Pop counter param
ADD R6, R6, #1

; Pop Save R2
LDR R2, R6, #0
ADD R6, R6, #1

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
; END SUMOFSQUARES ==================================





; SQUARE ============================================
SQUARE

; Push square() return address
ADD R6, R6, #-1
STR	R7,	R6,	#0

; Push previous frame pointer
ADD R6, R6, #-1
STR R5, R6, #0
; Set current frame pointer
ADD R5, R6, #0

; Save R1
ADD R6, R6, #-1
STR R1, R6, #0

; Save R2
ADD R6, R6, #-1
STR R2, R6, #0

; Declare int product
ADD R6, R6, #-1

; Load int x parameter as decrement iterator
LDR R0, R5, #2  ; R0 = int x param

; Product variables
LDR R1, R5, #2  ; R1 = int x param
AND R2, R2, #0  ; R2 = 0

DO_ADD
; Check int x = 0
ADD R0, R0, #0
BRz SQUARE_DONE

; Accumulate product
ADD R2, R2, R1

; Decrement iterator
ADD R0, R0, #-1

BRnzp DO_ADD

SQUARE_DONE

; Pop int product
STR R2, R6, #0
ADD R0, R2, #0 ; R0 = product
ADD R6, R6, #1

; Pop Save R2
ADD R6, R6, #1

; Pop Save R1
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Pop square() return address
LDR R7, R6, #0
ADD R6, R6, #1

RET
; END SQUARE ========================================





.END