// Assignment 1.2
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
    int result = print_count();
    if (result == -1){
        printf(1, "Trace state is OFF. Use user_toggle to enable syscall tracing\n");
        exit();
    }
    exit();
}