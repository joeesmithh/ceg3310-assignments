.ORIG x3000

ARRAY .BLKW #10 ; Block-write - allocate 10 locations in memory starting at the instruction location

WORD .STRINGZ "Hello" ; Write ASCII characters sequentially starting at location of instruction

HALT

.END