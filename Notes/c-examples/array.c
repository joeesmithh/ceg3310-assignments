#include <stdio.h>
#define ARRSIZE 10

int main()
{
    int a[ARRSIZE]; // a holds 10 integers
    int *p;         // p is a pointer to an integer
    int i;          // loop counter

    for (i = 0; i < ARRSIZE; i++)
    {
        a[i] = 2 * i;
    }

    p = a;    // The name of the array works like a pointer!
    p[3] = 5; // I can use the pointer like an array!
    
    for (i = 0; i < ARRSIZE; i++)
    {
        printf("a[%d] = %d\n", i, a[i]);
    }

    return 0;
}