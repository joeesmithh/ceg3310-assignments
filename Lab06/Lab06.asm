.ORIG x3000

; INITIALIZER CODE =======================================
LD  R6, STACK_PTR    ; R6 = x6000 (main() return value)
LEA R4, GLOBAL_VARS  ; R4 = global vars beg. address

; Execute main()
JSR MAIN

HALT

; Global Variables ----------------------------------
STACK_PTR   .FILL x6000     
GLOBAL_VARS .BLKW #1    ; global vars start
MALLOC      .FILL x8000 ; increment by 2 every new node
; END INITIALIZER CODE ===================================





; ===============================================================
; int main()
; ===============================================================
MAIN

; Push main() return address
ADD R6, R6, #-1         ; R6 = x5FFF
STR R7, R6, #0          ; R7 → x5FFF

; Push previous and set current frame pointer
ADD R6, R6, #-1         ; R6 = x5FFE
STR R5, R6, #0          ; R5 → x5FFE 
ADD R5, R6, #0          ; R5 = x5FFE

; Push node_t *head variable
ADD R6, R6, #-1         ; R6 = x5FFD
AND R0, R0, #0          ; R0 = 0
STR R0, R6, #0

; Push char selection variable
ADD R6, R6, #-1         ; R6 = x5FFC

; Main menu loop
; ---------------------------------------------------------------

; do
; ------------------------------
DO

; Menu prompt
LEA R0, PROMPT_MENU
PUTS

; Input
GETC
OUT
STR	R0,	R5, #-2

; if(selection == 'p')
; ------------------------------
LD R1, NEG_LOWERCASE_P
LDR R0, R5, #-2
ADD R0, R0, R1
BRnp ELSE_IF_A          ; selection != 'p'

; node_t **head parameter
ADD R6, R6, #-1         ; R6 = x5FFB
ADD R0, R5, #-1         ; R0 = node_t *head address
STR R0, R6, #0          ; R0 → x5FFB




; Pop if(selection == 'p') variables
ADD R6, R6, #1          ; R6 = x5FFC

BRnzp WHILE

; else if(selection == 'a')
; ------------------------------
ELSE_IF_A
LD R1, NEG_LOWERCASE_A
LDR R0, R5, #-2
ADD R0, R0, R1
BRnp ELSE_IF_R          ; selection != 'a'

; Push int a variable
ADD R6, R6, #-1         ; R6 = x5FFB

; Input number
LEA R0, PROMPT_ADD      ; Print input prompt
PUTS
TRAP x40                ; R0 = user number → x5FFB
STR R0, R6, #0
LD R0, NEWLINE
OUT                     ; Print newline

; Push int a parameter
ADD R6, R6, #-1         ; R6 = x5FFA
LDR R0, R5, #-3         ; R0 = int a → x5FFA
STR R0, R6, #0

; Push node_t **head parameter
ADD R6, R6, #-1         ; R6 = x5FF9
ADD R0, R5, #-1         ; R0 = node_t *head address → x5FF9
STR R0, R6, #0

; addValue(&head, a)
JSR ADD_VALUE

; Pop if(selection == 'a') variables
ADD R6, R6, #3          ; R6 = x5FFC

; Branch unconditionally to while check
BRnzp WHILE

; else if(selection == 'r')
; ------------------------------
ELSE_IF_R
LD R1, NEG_LOWERCASE_R
LDR R0, R5, #-2
ADD R0, R0, R1
BRnp WHILE              ; selection != 'r'

; node_t **head parameter
ADD R6, R6, #-1         ; R6 = x5FFB
ADD R0, R5, #-1         ; R0 = node_t *head address
STR R0, R6, #0          ; R0 → x5FFB




; Pop if(selection == 'p') variables
ADD R6, R6, #1          ; R6 = x5FFC

; while(selection != 'q');
; ------------------------------
WHILE
LD R1, NEG_LOWERCASE_Q
LDR R0, R5, #-2
ADD R0, R0, R1
BRnp DO                 ; selection != 'q'

; End main menu loop
; ---------------------------------------------------------------

; Print newline
LD R0, NEWLINE
OUT






; Pop main() local variables
ADD R6, R6, #2          ; R6 = x5FFE

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1          ; R6 = x5FFF

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1          ; R6 = x6000

RET

; main() variables 
STACK_BASE      .FILL    x6000
NEG_LOWERCASE_A .FILL    xFF9F
NEG_LOWERCASE_P .FILL    xFF90
NEG_LOWERCASE_Q .FILL    xFF8F
NEG_LOWERCASE_R .FILL    xFF8E
NEWLINE         .FILL    #10
PROMPT_MENU     .STRINGz "Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT    .STRINGz "\nContents of the linked list:\n"
PROMPT_ADD      .STRINGz "\nType a number to add: "
PROMPT_REMOVE   .STRINGz "\nType a number to remove: "
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; END int main()
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




; ===============================================================
; void printList(node_t **head)
; ===============================================================
PRINT_LIST

; Push return address
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
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; END void printList(node_t **head)
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



; ===============================================================
; void addValue(node_t **head, int added)
; ===============================================================
ADD_VALUE

; Push return address
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

; Push node_t *current
ADD R6, R6, #-1
LDR R0, R5, #2          ; R0 = **head
LDR R0, R0, #0          ; R0 = *head
STR R0, R6, #0

; if(current == 0)
; ------------------------------
ADD R0, R0, #0
BRnp ADD_VALUE_WHILE

    ; Push node_t *newNode malloc
    ADD R6, R6, #-1
    LDR R0, R4, #1 ; R0 = current global malloc address
    STR R0, R6, #0 ; *newNode = R0
    ADD R0, R0, #2 ; R0 = R0 + 2
    STR R0, R4, #1 ; global malloc address = R0

    ; newNode->value = added
    LDR R0, R5, #-4         ; R0 = *newNode
    LDR R1, R5, #3          ; R1 = added
    STR R1, R0, #0          ; *newNode->value = R1

    ; newNode->next = 0
    ADD R0, R0, #1          ; R0 = *newNode + 1
    AND R1, R1, #0          ; R1 = 0
    STR R1, R0, #0          ; *newNode->next = 0

    ; *head = newNode
    LDR R0, R5, #2          ; R0 = **head
    LDR R1, R5, #-4          ; R1 = *newNode
    STR R1, R0, #0          ; *head = *newNode

    ; Pop node_t *newNode
    ADD R6, R6, #1

    ; Branch unconditionally to function return
    BRnzp ADD_VALUE_RETURN

; while(current != 0)
; ------------------------------
ADD_VALUE_WHILE
LDR R0, R5, #-3         ; R0 = *current
ADD R0, R0, #0
BRz ADD_VALUE_RETURN

    ; if(current->next == 0)
    ; ------------------------------
    ADD R0, R0, #1          ; R0 = *current + 1
    LDR R0, R0, #0          ; R0 = current->next
    ADD R0, R0, #0
    BRnp ADD_VALUE_WHILE_CONTINUE

        ; Push node_t *newNode
        ADD R6, R6, #-1
        LDR R0, R4, #1 ; R0 = current global malloc address
        STR R0, R6, #0 ; *newNode = R0
        ADD R0, R0, #2 ; R0 = R0 + 2
        STR R0, R4, #1 ; global malloc address = R0

            ; newNode->value = added
            LDR R0, R5, #-4         ; R0 = *newNode
            LDR R1, R5, #3          ; R1 = added
            STR R1, R0, #0          ; *newNode->value = R1

            ; newNode->next = 0
            ADD R0, R0, #1          ; R0 = *newNode + 1
            AND R1, R1, #0          ; R1 = 0
            STR R1, R0, #0          ; *newNode->next = 0

            ; current->next = newNode
            LDR R0, R5, #-3         ; R0 = *currentNode
            ADD R0, R0, #1          ; R0 = *currentNode + 1
            LDR R1, R5, #-4         ; R1 = *newNode
            STR R1, R0, #0          ; *currentNode->next = *newNode

        ; Pop node_t *newNode
        ADD R6, R6, #1

    ; Branch unconditionally to function return
    BRnzp ADD_VALUE_RETURN

    ADD_VALUE_WHILE_CONTINUE
    LDR R0, R5, #-3         ; R0 = *current
    ADD R0, R0, #1          ; R0 = *current + 1
    LDR R0, R0, #0          ; R0 = current->next
    STR R0, R5, #-3         ; *current = *current->next

    ; Branch unconditionally to while(current != 0)
    BRnzp ADD_VALUE_WHILE

; return
; ------------------------------
ADD_VALUE_RETURN

; Pop node_t *current
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
; addValue() Variables
ADD_VALUE_ORIGIN .FILL x8000
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; END void addValue(node_t **head, int added)
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



; ===============================================================
; void removeValue(node_t **head, int removed)
; ===============================================================
REMOVE_VALUE

; Push return address
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
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; END void removeValue(node_t **head, int removed)
; \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.END