; Write an LC3 assembly program originating at memory address x3000 that will calculate the volume of a rectangular prism. The volume of a rectangular prism is:
; volume = length x width x height
; The length, width, and height must be stored inside of a .FILL inside of your program. After calculating the volume, place the result into memory address x8000.
; Example, if you have the following .FILL locations in your program:
; LENGTH 	.FILL #5
; WIDTH	.FILL #2
; HEIGHT	.FILL #27

.ORIG x3000

LD R0, LENGTH   ; R0 = length
LD R1, WIDTH    ; R1 = width

AND R2, R2, #0  ; R2 = 0

LW
ADD R2, R2, R0
ADD R1, R1, #-1
BRnp LW

; R2 = length x width

LD R1, HEIGHT   ; R1 = height
ADD R0, R2, #0  ; R0 = length x width
AND R2, R2, #0  ; R2 = 0

LWH
ADD R2, R2, R0
ADD R1, R1, #-1
BRnp LWH

; R2 = length x width x height

STI	R2, RESULT

HALT

; Variables
LENGTH .FILL #5
WIDTH .FILL #2
HEIGHT .FILL #27
RESULT .FILL x8000

.END