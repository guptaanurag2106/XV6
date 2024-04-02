#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// Assignment 1.2
struct FunctionInfo {
    const char* funcName;   // Function name
    int index;              // index in syscalls array
};
#define SYSCALL_COUNT 28

extern int trace_state; //0 for off, 1 for on
extern struct FunctionInfo functionList[SYSCALL_COUNT]; //stores the syscall name along with its num
extern int syscall_count[1 + SYSCALL_COUNT]; // count for each syscall


int strcmp(const char *s1, const char *s2) { // strcmp function for sorting
    while (*s1 && *s1 == *s2) {
        s1++;
        s2++;
    }
    return *(unsigned char *)s1 - *(unsigned char *)s2;
}

void insertion_sort(struct FunctionInfo *functions, int count) {
    for (int i = 1; i < count; i++) {
        struct FunctionInfo key = functions[i];
        int j = i - 1;
        while (j >= 0 && strcmp(functions[j].funcName, key.funcName) > 0) {
            functions[j + 1] = functions[j];
            j --;
        }
        functions[j + 1] = key;
    }
}

int
sys_toggle(void)
{
  trace_state = (trace_state + 1) % 2; // 0->1 and 1->0
  for (int i=0; i<=SYSCALL_COUNT; i++){ // initialize all count to 0
    syscall_count[i] = 0;
  }
  return trace_state;
}


int sys_print_count(void){
  if (trace_state == 0) {
      return -1;
  }
  
  insertion_sort(functionList, SYSCALL_COUNT);
  for (int i = 0; i < SYSCALL_COUNT; i++) {
      int syscall_index = functionList[i].index;
      if (strcmp(functionList[i].funcName, "sys_print_count") == 0)
        continue;
      if (syscall_count[syscall_index]!=0)
        cprintf("%s %d\n", functionList[i].funcName, syscall_count[syscall_index]);
  }

  return 0;
}


int sys_add(void){
  // Get the two arguments from the user
  int a, b;
    if (argint(0, &a) < 0 || argint(1, &b) < 0)
      return -1;
  
    // Return the sum of a and b
    return a + b;
}

int sys_ps(void){
  // Call the ps function defined in proc.c
  ps();

  return 0;
}

// Assignment 1.3
int sys_send(void){
  // Get the sender and receiver process IDs and the message from user space
  int sender_pid, rec_pid;
  char* msg;
  if (argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, 8) < 0)
    return -1;
  
  // Call the send_message function to send the message defined in proc.c
  return send_message(sender_pid, rec_pid, msg);
  
  // struct proc *sender_proc = getprocbyid(sender_pid);
  // struct proc *rec_proc = getprocbyid(rec_pid);

  // if (sender_proc == 0 || rec_proc == 0)
  //   return -1;

  // safestrcpy(sender_proc->shared_memory, msg, 8);

  // wakeup(rec_proc->chan);

  // return 0;
}

int sys_recv(void){
  // Get the message buffer from user space
  char* msg;

  if (argptr(0, &msg, 8) < 0)
    return -1;

  int stat = -1;
  while (stat == -1)
  {
    // recursively check for msg receive (blocking call)
    stat = receive_message(msg);
  }
  return 1;
}

int sys_send_multi(void){
  // Get the sender process ID, receiver process IDs, and the message from user space
  int sender_pid;
  int *rec_pids;
  char *msg;

  if(argint(0, &sender_pid) < 0 || argptr(1, (void*)&rec_pids, 8 * sizeof(int)) < 0 || argptr(2, &msg, 8)<0) {
      return -1;
  }

  // Iterate through the receiver process IDs and call send_message for each valid ID
  for (int i=0; i < 8; i++){
    int rec_pid = *(rec_pids + i);
    if (rec_pid > 0){
      int return_value = send_message(sender_pid, rec_pid, msg);
      if (return_value == -1){
        return -1;
      }
    }
  }

  return 1;
}
