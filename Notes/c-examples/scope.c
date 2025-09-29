#include <stdio.h>

int myNumber0 = 10; // Global variable

void otherFunction();

int main()
{
    int myNumber1 = 15; // Local to main
    printf("%d\n", myNumber0);
    printf("%d\n", myNumber1);
    otherFunction();
    return 0;
}
void otherFunction()
{
    int myNumber2 = 20; // Local to otherFunction()
    printf("%d\n", myNumber2);
}