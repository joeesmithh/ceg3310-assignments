.ORIG x3000
; MAIN
; ==========================================================================

; SAVING
; -----------------------------------------------
; main return address
LD R6, STACK_BOTTOM         ; R6  = x6000
STR R7, R6, #0              ; R7 s-> x6000, main's return address

; Previous frame pointer
ADD R6, R6, #-1             ; R6  = x5FFF
STR R5, R6, #0              ; R5 s-> x5FFF
ADD R5, R6, #0              ; R5  = x5FFF

; Save R0
ADD R6, R6, #-1             ; R6 = x5FFE
STR R0, R6, #0              ; R0 s-> x5FFE

; Save R1
ADD R6, R6, #-1             ; R6 = x5FFD
STR R1, R6, #0              ; R1 s-> x5FFE

; OPERATIONS
; -----------------------------------------------
; Initialize int x
ADD R6, R6, #-1             ; R6 = x5FFC
LD R0, INIT_X               ; R0 = INIT_X = #10
STR R0, R6, #0              ; INIT_X s-> x5FFC

; Initialize int y
ADD R6, R6, #-1             ; R6 = x5FFB
LD R0, INIT_Y               ; R0 = INIT_Y = #11
STR R0, R6, #0              ; INIT_Y s-> x5FFC

; Declare int val
ADD R6, R6, #-1             ; R6 = x5FFA

; MAX PREP
; -----------------------------------------------
; Pass parameter int a to max()
ADD R6, R6, #-1             ; R6 = x5FF9
LDR R0, R5, #-3             ; R0 = int x = #10
ADD R0, R0, #10             ; R0 = x + 10
STR R0, R6, #0              ; R0 s-> x5FF9

; Pass parameter int b to max()
ADD R6, R6, #-1             ; R6 = x5FF8
LDR R0, R5, #-4             ; R0 = int y = #11
STR R0, R6, #0              ; R0 s-> x5FF8

JSR MAX

; MAX RETURN
; -----------------------------------------------
; Store return value
STR R0, R5, #-5             ; val = max (x + 10, y)

; pop int b
ADD R6, R6, #1              ; R6 = x5FF9

; pop int a
ADD R6, R6, #1              ; R6 = x5FFA


STACK_BOTTOM .FILL X6000    ; Initilize bottom of stack
INIT_X .FILL #10
INIT_Y .FILL #11

; MAX
; ==========================================================================
MAX
; SAVING
; -----------------------------------------------
; max() return address
LD R6, STACK_BOTTOM         ; R6  = x5FF7
STR R7, R6, #0              ; R7 s-> x5FF7, max's return address

; Previous frame pointer
ADD R6, R6, #-1             ; R6  = x5FF6
STR R5, R6, #0              ; R5 s-> x5FF6
ADD R5, R6, #0              ; R5  = x5FF6

; Save R0
ADD R6, R6, #-1             ; R6 = x5FF5
STR R0, R6, #0              ; R0 s-> x5FF5

; Save R1
ADD R6, R6, #-1             ; R6 = x5FF4
STR R1, R6, #0              ; R1 s-> x5FF4

; Initialize int result
ADD R6, R6, #-1             ; R6 = x5FF3

; OPERATIONS
; -----------------------------------------------
; Load int a
LDR R0, R5, #3              ; R0 = int a
STR R0, R6, #0              ; R0 s-> x5FF3

; Load int b
LDR R1, R5, #2              ; R1 = int b
NOT R1, R1
ADD R1, R1, #1              ; R1 = -b
ADD R1, R0, R1              ; R1 = a - b

; if (b > a)
; result = b
BZzp RETURN                 ; a >= b, return
LDR R1, R5, #2              ; R1 = int b
STR R1, R5, #-3             ; R1 s-> x5FF6

RETURN
LDR R0, R5, #-3             ; R0 = result

; POPPING
; -----------------------------------------------
; pop int result
ADD R6, R6, #1              ; R6 = x5FF4

; pop save R1
LDR R1, R6, #0              ; R1 <-L x5FF4
ADD R6, R6, #1              ; R6 = x5FF5

; pop save R0
LDR R0, R6, #0              ; R0 <-L x5FF5
ADD R6, R6, #1              ; R6 = x5FF6

; pop previous frame pointer (R5)
LDR R5, R6, #0              ; R5 <-L x5FF6
ADD R6, R6, #1              ; R6 = x5FF7

; pop max's return address (R7)
LDR R7, R6, #0              ; R5 <-L x5FF7
ADD R6, R6, #1              ; R6 = x5FF8

RET
; ==========================================================================

.END