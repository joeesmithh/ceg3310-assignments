.ORIG x3000

; #~#~#~#~#~#~#~#~#
; =-=-=-=-=-=-=-=-=
; INITIALIZER CODE
; # DO NOT TOUCH #
; - - - - - - - - -
LD R6, STACK_PTR ; load stack pointer
LEA R4, STATIC_STORAGE ; load global vars pointer
ADD R5, R6, #0 ; set frame pointer
; current stack pointer is sitting on main's return slot
; there are no arguments to our main function
JSR MAIN
HALT
; SETUP VARS
STACK_PTR .FILL x6000
STATIC_STORAGE
.FILL #5 ; array_size global variable
; - - - - - - - - -
; INITIALIZER OVER
; =-=-=-=-=-=-=-=-=
; #~#~#~#~#~#~#~#~#


; #~#~#~#~#~#~#~#~#
; =-=-=-=-=-=-=-=-=
MAIN;(void)

; push return address
ADD R6, R6, #-1
STR R7, R6, #0

; push previous frame pointer
ADD R6, R6, #-1
STR R5, R6, #0

; set current frame pointer
ADD R5, R6, #0

; allocate local variables
; - - - - - - - - -
; #-1: total
; #-2: array[4]
; #-3: array[3]
; #-4: array[2]
; #-5: array[1]
; #-6: array[0]
; - - - - - - - - -
ADD R6, R6, #-6 ; create 6 spaces on the stack (uninitialized)
; =-=-=-=-=-=-=-=-=

; initialize array contents
LD R0, ARR_0
STR R0, R5, #-6
LD R0, ARR_1
STR R0, R5, #-5
LD R0, ARR_2
STR R0, R5, #-4
LD R0, ARR_3
STR R0, R5, #-3
LD R0, ARR_4
STR R0, R5, #-2

; load array pointer
ADD R0, R5, #-6
; push it as argument
ADD R6, R6, #-1
STR R0, R6, #0

; push size as parameter
AND R0, R0, #0
ADD R0, R0, #5
ADD R6, R6, #-1
STR R0, R6, #0

; push return slot
ADD R6, R6, #-1

; call sum function
JSR SUM

; fetch return value
LDR R0, R6, #0
; total = return value
STR R0, R5, #-1

; pop parameters and return value
ADD R6, R6, #3

; =-=-=-=-=-=-=-=-=
; deallocate local variables
ADD R6, R6, #6

; restore and pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; restore and pop return address
LDR R7, R6, #0
ADD R6, R6, #1

; return to caller
RET
; =-=-=-=-=-=-=-=-=
ARR_0 .FILL #1
ARR_1 .FILL #2
ARR_2 .FILL #6
ARR_3 .FILL #5
ARR_4 .FILL #42
; =-=-=-=-=-=-=-=-=
; #~#~#~#~#~#~#~#~#



; #~#~#~#~#~#~#~#~#
; =-=-=-=-=-=-=-=-=
SUM;(int* array, int size)

; push return address
ADD R6, R6, #-1
STR R7, R6, #0

; push previous frame pointer
ADD R6, R6, #-1
STR R5, R6, #0

; set current frame pointer
ADD R5, R6, #0

; allocate local variables
; - - - - - - - - -
; #-1: counter
; #-2: sum
; - - - - - - - - -
ADD R6, R6, #-2 ; create 2 spaces on the stack (uninitialized)
; =-=-=-=-=-=-=-=-=

; initialize counter and sum to 0
AND R0, R0, #0
STR R0, R5, #-1
STR R0, R5, #-2

ADD_LOOP
LDR R0, R5, #-1
LDR R1, R5, #3
NOT R1, R1
ADD R1, R1, #1
ADD R0, R0, R1
BRzp END_ADD_LOOP

; load array pointer
LDR R0, R5, #4
; load counter
LDR R1, R5, #-1
; go to index counter
ADD R0, R0, R1
; dereference
LDR R0, R0, #0

; load the total
LDR R1, R5, #-2

; accumulate
ADD R0, R0, R1
STR R0, R5, #-2

; increment counter
LDR R0, R5, #-1
ADD R0, R0, #1
STR R0, R5, #-1

BRnzp ADD_LOOP
END_ADD_LOOP

; return sum
LDR R0, R5, #-2
STR R0, R5, #2

; =-=-=-=-=-=-=-=-=
; deallocate local variables
ADD R6, R6, #2

; restore and pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; restore and pop return address
LDR R7, R6, #0
ADD R6, R6, #1

; return to caller
RET
; =-=-=-=-=-=-=-=-=
; #~#~#~#~#~#~#~#~#

.END