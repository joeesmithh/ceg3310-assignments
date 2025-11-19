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

; node_t *head = 0
AND R0, R0, #0          ; R0 = 0
STR R0, R6, #0          ; node_t *head = 0

; Push char selection variable
ADD R6, R6, #-1         ; R6 = x5FFC

; do
; ------------------------------
DO

; printf("Available options:\n");
; ...
LEA R0, PROMPT_MENU
PUTS

; scanf(" %c", &selection)
GETC                    ; R0 = input
OUT
STR	R0,	R5, #-2         ; selection = input

; Print newline
LD R0, NEWLINE
OUT

; if(selection == 'p')
; ------------------------------
LD R1, NEG_LOWERCASE_P  ; R1 = -'p'
LDR R0, R5, #-2         ; R0 = selection
ADD R0, R0, R1          ; selection - 'p'
BRnp ELSE_IF_A          ; selection != 'p'

    ; Push node_t **head parameter
    ADD R6, R6, #-1         ; R6 = x5FFB
    ADD R0, R5, #-1         ; R0 = &head
    STR R0, R6, #0          ; **head = &head

    ; printf("Contents of the linked list: ")
    LEA R0, PROMPT_PRINT
    PUTS

    ; Print newline
    LD R0, NEWLINE
    OUT

    ; printList(&head)
    JSR PRINT_LIST

    ; Print newline
    LD R0, NEWLINE
    OUT

    ; Pop node_t **head parameter
    ADD R6, R6, #1          ; R6 = x5FFC

    BRnzp WHILE

; else if(selection == 'a')
; ------------------------------
ELSE_IF_A
LD R1, NEG_LOWERCASE_A  ; R1 = -'a'
LDR R0, R5, #-2         ; R0 = selection
ADD R0, R0, R1          ; selection - 'a'
BRnp ELSE_IF_R          ; selection != 'a'

    ; Push int a variable
    ADD R6, R6, #-1         ; R6 = x5FFB

    ; int a = 0
    AND R0, R0, #0          ; R0 = 0
    STR R0, R6, #0

    ; printf("Type a number to add: ")
    LEA R0, PROMPT_ADD      ; Print input prompt
    PUTS

    ; scanf("%d", &a)
    TRAP x40                ; R0 = input
    STR R0, R6, #0          ; a = input

    ; Print newline
    LD R0, NEWLINE
    OUT

    ; Push int a parameter
    ADD R6, R6, #-1         ; R6 = x5FFA
    LDR R0, R5, #-3         ; R0 = a
    STR R0, R6, #0          ; a param = a

    ; Push node_t **head parameter
    ADD R6, R6, #-1         ; R6 = x5FFB
    ADD R0, R5, #-1         ; R0 = &head
    STR R0, R6, #0          ; **head = &head

    ; addValue(&head, a)
    JSR ADD_VALUE

    ; Print newline
    LD R0, NEWLINE
    OUT

    ; Pop **head, a param, and a
    ADD R6, R6, #3          ; R6 = x5FFC

    ; Branch unconditionally to while check
    BRnzp WHILE

; else if(selection == 'r')
; ------------------------------
ELSE_IF_R
LD R1, NEG_LOWERCASE_R  ; R1 = -'r'
LDR R0, R5, #-2         ; R0 = selection
ADD R0, R0, R1          ; selection - 'r'
BRnp WHILE              ; selection != 'r'

    ; Push int r variable
    ADD R6, R6, #-1         ; R6 = x5FFB

    ; int r = 0
    AND R0, R0, #0          ; R0 = 0
    STR R0, R6, #0

    ; printf("Type a number to remove: ")
    LEA R0, PROMPT_REMOVE   ; Print input prompt
    PUTS

    ; scanf("%d", &r)
    TRAP x40                ; R0 = input
    STR R0, R6, #0          ; r = input

    ; Print newline
    LD R0, NEWLINE
    OUT

    ; Push int r parameter
    ADD R6, R6, #-1
    LDR R0, R5, #-3         ; R0 = r
    STR R0, R6, #0          ; r param = r

    ; Push node_t **head parameter
    ADD R6, R6, #-1         ; R6 = x5FFB
    ADD R0, R5, #-1         ; R0 = &head
    STR R0, R6, #0          ; **head = &head

    ; removeValue(&head, r);
    JSR REMOVE_VALUE

    ; Print newline
    LD R0, NEWLINE
    OUT

    ; Pop ** head, r param, r
    ADD R6, R6, #3

; while(selection != 'q');
; ------------------------------
WHILE
LD R1, NEG_LOWERCASE_Q  ; R1 = -'q'
LDR R0, R5, #-2         ; R0 = selection
ADD R0, R0, R1          ; selection - 'q'
BRnp DO                 ; selection != 'q'

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
NEWLINE         .FILL    x000A
PROMPT_MENU     .STRINGz "Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT    .STRINGz "Contents of the linked list: "
PROMPT_ADD      .STRINGz "Type a number to add: "
PROMPT_REMOVE   .STRINGz "Type a number to remove: "
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

; Push node_t *current variable
ADD R6, R6, #-1

; node_t *current = *head
LDR R0, R5, #2          ; R0 = **head
LDR R0, R0, #0          ; R0 = *head
STR R0, R6, #0          ; *current = *head

; while(current != 0)
; ------------------------------
PRINT_LIST_WHILE
LDR R0, R5, #-1         ; R0 = *current
ADD R0, R0, #0
BRz PRINT_LIST_RETURN

    ; printf("%d", current->value)
    LDR R0, R5, #-1         ; R0 = *current
    LDR R0, R0, #0          ; R0 = current->value
    TRAP x41                ; Print R0

    ; current = current->next
    LDR R0, R5, #-1         ; R0 = *current
    LDR R0, R0, #1          ; R0 = current->*next
    STR R0, R5, #-1         ; *current = *current->next

    ; if(current != 0)
    ; ------------------------------
    LDR R0, R5, #-1         ; R0 = *current
    ADD R0, R0, #0
    BRz PRINT_LIST_WHILE

        ; printf(" -> ")
        LEA R0, PRINT_LIST_ARROW
        PUTS

    ; 
    ; Continue to while(current != 0)
    BRnzp PRINT_LIST_WHILE

; return
; ------------------------------
PRINT_LIST_RETURN

; printf("\n")
LD R0, PRINT_LIST_NEWLINE
OUT

; Pop node_t *current
ADD R6, R6, #1

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1

RET
; printList() Variables
PRINT_LIST_ARROW   .STRINGz " -> "
PRINT_LIST_NEWLINE .FILL    x000A
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

; Push node_t *current variable
ADD R6, R6, #-1

; node_t *current = *head
LDR R0, R5, #2          ; R0 = **head
LDR R0, R0, #0          ; R0 = *head
STR R0, R6, #0

; if(current == 0)
; ------------------------------
LDR R0, R5, #-2         ; R0 = *current
ADD R0, R0, #0
BRnp ADD_VALUE_WHILE

    ; Push node_t *newNode variable
    ADD R6, R6, #-1

    ; node_t *newNode = (node_t *) malloc(sizeof(node_t))
    LDR R0, R4, #1 ; R0 = global malloc address
    STR R0, R6, #0 ; *newNode = global malloc address
    ADD R0, R0, #2 ; global malloc address  += 2
    STR R0, R4, #1 ; global malloc variable = global malloc address  += 2

    ; newNode->value = added
    LDR R0, R5, #-3         ; R0 = *newNode
    LDR R1, R5, #3          ; R1 = added
    STR R1, R0, #0          ; newNode->value = added

    ; newNode->next = 0
    LDR R0, R5, #-3         ; R0 = *newNode
    AND R1, R1, #0          ; R1 = 0
    STR R1, R0, #1          ; newNode->*next = 0

    ; *head = newNode
    LDR R0, R5, #2          ; R0 = **head
    LDR R1, R5, #-3          ; R1 = *newNode
    STR R1, R0, #0          ; *head = *newNode

    ; Pop node_t *newNode variable
    ADD R6, R6, #1

    ; Branch unconditionally to function return
    BRnzp ADD_VALUE_RETURN

; while(current != 0)
; ------------------------------
ADD_VALUE_WHILE
LDR R0, R5, #-2         ; R0 = *current
ADD R0, R0, #0
BRz ADD_VALUE_RETURN

    ; if(current->next == 0)
    ; ------------------------------
    LDR R0, R5, #-2         ; R0 = *current
    LDR R0, R0, #1          ; R0 = current->*next
    ADD R0, R0, #0
    BRnp ADD_VALUE_WHILE_CONTINUE

        ; Push node_t *newNode variable
        ADD R6, R6, #-1

        ; node_t *newNode = (node_t *) malloc(sizeof(node_t))
        LDR R0, R4, #1 ; R0 = global malloc address
        STR R0, R6, #0 ; *newNode = global malloc address
        ADD R0, R0, #2 ; global malloc address  += 2
        STR R0, R4, #1 ; global malloc variable = global malloc address  += 2

            ; newNode->value = added
            LDR R0, R5, #-3         ; R0 = *newNode
            LDR R1, R5, #3          ; R1 = added
            STR R1, R0, #0          ; *newNode->value = added

            ; newNode->next = 0
            LDR R0, R5, #-3         ; R0 = *newNode
            AND R1, R1, #0          ; R1 = 0
            STR R1, R0, #1          ; newNode->*next = 0

            ; current->next = newNode
            LDR R0, R5, #-2         ; R0 = *currentNode
            LDR R1, R5, #-3         ; R1 = *newNode
            STR R1, R0, #1          ; currentNode->*next = *newNode

        ; Pop node_t *newNode variable
        ADD R6, R6, #1

        ; return
        BRnzp ADD_VALUE_RETURN

    ; current = current->next
    ADD_VALUE_WHILE_CONTINUE
    LDR R0, R5, #-2         ; R0 = *current
    LDR R0, R0, #1          ; R0 = current->*next
    STR R0, R5, #-2         ; *current = *current->next

    ; Continue while(current != 0)
    BRnzp ADD_VALUE_WHILE

; return
; ------------------------------
ADD_VALUE_RETURN

; Pop node_t *current
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

; Push node_t *prev (node_t *prev = *head)
ADD R6, R6, #-1
LDR R0, R5, #2          ; R0 = **head
LDR R0, R0, #0          ; R0 = *head
STR R0, R6, #0          ; *prev = *head

; Push node_t *current
ADD R6, R6, #-1

; if(prev == 0)
; ------------------------------
LDR R0, R5, #-2         ; R0 = *prev
ADD R0, R0, #0
BRz REMOVE_VALUE_RETURN;return


; if((*head)->value == removed)
; ------------------------------
LDR R0, R5, #2          ; R0 = **head
LDR R0, R0, #0          ; R0 = *head
LDR R0, R0, #0          ; R0 = head->value
LDR R1, R5, #3          ; R1 = removed
NOT R1, R1
ADD R1, R1, #1          ; R1 = -removed
ADD R0, R0, R1
BRnp REMOVE_VALUE_CONTINUE

    ; (*head) = (*head)->next
    LDR R0, R5, #2          ; R0 = **head
    ADD R1, R0, #0          ; R1 = **head
    LDR R1, R1, #0          ; R1 = *head
    LDR R1, R1, #1          ; R1 = head->*next
    STR R1, R0, #0          ; (*head) = (*head)->*next

    ; free(prev); 
    LDR R0, R5, #-2         ; R0 = *prev
    AND R1, R1, #0          ; R1 = 0
    STR R1, R0, #0          ; prev->value = 0
    STR R1, R0, #1          ; prev->*next = 0

    ; return
    BRnzp REMOVE_VALUE_RETURN

; node_t *current = (*head)->next
REMOVE_VALUE_CONTINUE
LDR R0, R5, #2              ; R0 = **head
LDR R0, R0, #0              ; R0 =  *head
LDR R0, R0, #1              ; R0 = head->*next
STR R0, R5, #-3             ; current = (*head)->*next


; while(current != 0)
; ------------------------------
REMOVE_VALUE_WHILE
LDR R0, R5, #-3             ; R0 = current
ADD R0, R0, #0
BRz REMOVE_VALUE_RETURN

    ; if(current->value == removed)
    ; ------------------------------
    LDR R0, R5, #-3             ; R0 = *current
    LDR R0, R0, #0              ; R0 = current->value
    LDR R1, R5, #3              ; R1 = removed
    NOT R1, R1
    ADD R1, R1, #1              ; R1 = -removed
    ADD R0, R0, R1              ; current->value - removed
    BRnp REMOVE_VALUE_WHILE_IF2

        ; prev->next = current->next
        LDR R0, R5, #-3             ; R0 = *current
        LDR R0, R0, #1              ; R0 = current->*next
        LDR R1, R5, #-2             ; R1 = *prev
        STR R0, R1, #1              ; prev->*next = current->*next

        ; free(current)
        LDR R0, R5, #-3             ; R0 = *current
        AND R1, R1, #0              ; R1 = 0
        STR R1, R0, #0              ; current->value = 0
        STR R1, R0, #1              ; current->*next  = 0

        ; return
        BRnzp REMOVE_VALUE_RETURN

    ; if (current != 0)
    ; ------------------------------
    REMOVE_VALUE_WHILE_IF2
    LDR R0, R5, #-3             ; R0 = *current
    ADD R0, R0, #0
    BRz REMOVE_VALUE_WHILE      

        ; prev = current
        LDR R0, R5, #-3         ; R0 = *current
        STR R0, R5, #-2         ; *prev = *current

        ; current = current->next
        LDR R0, R5, #-3         ; R0 = *current
        LDR R0, R0, #1          ; R0 = current->next
        STR R0, R5, #-3         ; *current = current->*next

    BRnzp REMOVE_VALUE_WHILE

; return
REMOVE_VALUE_RETURN

; Pop local vars
ADD R6, R6, #2

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