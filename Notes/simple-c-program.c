#include <stdio.h>
#define STOP 0

/* Function: main */
/* Description: counts down from user input to STOP */
main()
{ 
/* variable declarations */
int counter; /* an integer to hold count values */
int startPoint; /* starting point for countdown */

printf("Enter a positive number: ");
scanf("%d", &startPoint);

/* output count down */
for (counter=startPoint; counter >= STOP; counter--)
printf("%d\n", counter);

}