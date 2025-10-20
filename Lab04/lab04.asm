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

; Declare array
ADD R6, R6, #-5

; Initialize array
AND R0, R0, #0
ADD R0, R0, #2
STR R0, R5, #-5 ; array[0] = 2
AND R0, R0, #0
ADD R0, R0, #3
STR R0, R5, #-4 ; array[1] = 3
AND R0, R0, #0
ADD R0, R0, #5
STR R0, R5, #-3 ; array[2] = 5
AND R0, R0, #0
STR R0, R5, #-2 ; array[3] = 0
AND R0, R0, #0
ADD R0, R0, #1
STR R0, R5, #-1 ; array[4] = 1

; Declare total variable
ADD R6, R6, #-1

; Define array parameter for sumOfSquares()
ADD	R6,	R6,	#-1
ADD R0, R5, #-5
STR R0, R6, #0  ; array parameter = array[0] address

; Define arraySize parameter for sumOfSquares()
ADD	R6,	R6,	#-1
LDR R0, R4, #1  ; Load arraySize from global vars
STR R0, R6, #0  ; arraySize parameter = 5

; Execute sumOfSquares(array, arraySize)
JSR SUMOFSQUARES

; total = R0
STR R0, R5, #-6

; Pop array and arraySize params
ADD R6, R6, #2

; Pop total
LDR R0, R6, #0
ADD R6, R6, #1

; Pop array
ADD R6, R6, #5

; Load main() return address and frame pointer
ADD R5, R6, #0
LDR R7, R6 #0

RET
; END MAIN ===============================================





; SUMOFSQUARES ===========================================
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
LDR R0, R5, #-2 ; R0 = counter
LDR R1, R5, #2  ; R1 = arraySize

; counter < arraySize ?
NOT R0, R0
ADD R0, R0, #1
ADD R1, R1, R0
BRnz SUMSQUARES_CTR_DONE

; Define int x parameter = array[counter]
LDR	R0,	R5,	#-2 ; R0 = counter
LDR R1, R5, #3  ; R1 = array[0] address
ADD R1, R1, R0  ; R1 = array[counter] address
LDR R1, R1, #0  ; R1 = array[counter]
STR R1, R6, #0  ; int x = array[counter]

; Execute square(int x)
JSR SQUARE

; Accumulate sum
LDR R1, R5, #-3
ADD R1, R1, R0
STR R1, R5, #-3 ; sum = sum + R0

; Increment counter
LDR R1, R5, #-2
ADD R1, R1, #1
STR R1, R5, #-2 ; counter = counter + 1

BRnzp DO_SQUARE

SUMSQUARES_CTR_DONE

; Pop int x parameter
ADD R6, R6, #1

; Pop sum param
LDR R0, R6, #0 ; R0 = sum
ADD R6, R6, #1

; Pop counter param
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
; END SUMOFSQUARES =======================================





; SQUARE =================================================
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

; int product = 0
ADD R6, R6, #-1
AND R0, R0, #0
STR R0, R6, #0

; Load int x parameter as decrement iterator
LDR R0, R5, #2  ; R0 = int x = array[counter]

; Product variables
LDR R1, R5, #2  ; R1 = int x = array[counter]
AND R2, R2, #0  ; R2 = 0

DO_ADD
; Check R0 = 0
ADD R0, R0, #0
BRz SQUARE_DONE

; Accumulate product
ADD R2, R2, R1
; Store new product
STR R2, R5, #-3

; Decrement iterator
ADD R0, R0, #-1

BRnzp DO_ADD

SQUARE_DONE

; Pop int product
LDR R0, R6, #0 ; R0 = product
ADD R6, R6, #1

; Pop Save R2
LDR R2, R6, #0
ADD R6, R6, #1

; Pop Save R1
LDR R1, R6, #0
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Pop square() return address
LDR R7, R6, #0
ADD R6, R6, #1

RET
; END SQUARE =============================================





.END