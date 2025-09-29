#include <stdio.h>
#include <string.h>

/** Struct - i.e, an array of values stored sequentially. */
struct myStructure {
    int a;
    float b;
    char c[30];
};

/** Output to console the values of a myStructure struct. 
    @param myStructure The struct to output */
void printStruct(struct myStructure s);

/** main */
int main() {
    // Create a structure variable and assign values to it
    struct myStructure s1 = {13, 0.125, "Some text"};
    
    // Modify values
    s1.a = 30;
    s1.b = -1.25f;
    
    // Set the character array of the struct
    strcpy(s1.c, "Something else");
    
    // Print values
    printStruct(s1);
    
    return 0;
}

void printStruct(struct myStructure s){
    /**
     *  %d - decimal integer
     *  %x - hexadecimal integer
     *  %c - ASCII character
     *  %s - character array
     *  %f - floating-point number
     */
    printf("%d %f %s", s.a, s.b, s.c);
}