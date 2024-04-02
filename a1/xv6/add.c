// Assignment 1.2
#include "types.h"
#include "stat.h"
#include "user.h"

int is_number(char *str) {
    for (int i = 0; str[i] != '\0'; i++) {
        if ((str[i] < '0' || str[i] > '9') && str[i] != '+' && str[i] != '-') {
            return 0; 
        }
    }
    return 1;
}

int main(int argc, char *argv[]){
     if (argc != 3 || !is_number(argv[1]) || !is_number(argv[2])) {
        printf(2, "Usage: %s <num1> <num2>\n", argv[0]);
        exit();
    }

    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
    int output = add(a, b);

    // if(output == -1){
    //     printf(1, "addition failed\n");
    //     exit();
    // }
    printf(1, "%d", output);
    exit();
}