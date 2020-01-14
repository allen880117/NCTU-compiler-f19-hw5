#include <stdio.h>

void print(int value)
{
    printf("%d\n", value);
}

int read()
{
    int value;
    scanf("%d", &value);
    return value;
}

void print_real(int real)
{
    printf("%f\n", real);
}

float read_real(){
    float real;
    scanf("%f", &real);
    return real;
}