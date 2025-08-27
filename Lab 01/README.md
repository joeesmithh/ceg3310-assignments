## LC3 Simulator Steps:
1. Add decimal number -23 to memory location x3000
2. Add student UID (0710) to memory location x3001
3. Append string "Hello, my name is Joe" from memory location x3002 using ASCII:

    `72 101 108 108 111 44 32 109 121 32 110 97 109 101 32 105 115 32 74 111 101 46`
    | Location  | Value |
    | ---       | ---   |
    | x3002     | 72    |
    | x3003     | 101   |
    | x3004     | 108   |
    | x3005     | 108   |
    | ...       | ...   |

4. Construct linked list from memory location x4000.
    | Location  | Value |
    | ---       | ---   |
    | x4000     | -2    |
    | x4001     | x4002 |
    | x4002     | -4    |
    | x4003     | x4004 |
    | x4004     | -6    |
    | x4005     | x4006 |
    | x4006     | -8    |
    | x4007     | x4008 |
    | x4008     | -10   |