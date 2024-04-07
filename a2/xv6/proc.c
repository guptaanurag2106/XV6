#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

//////////////////////// Assignment - 2 //////////////////////////////////////////////
#define UINT32_MAX 4294967295U
#define CEIL(a, b) (((a) + (b) - 1) / (b))

////// Helper Functions and Hardcoded Values
//// Helper Function to swap
void
swap(struct proc **a, struct proc **b)
{
    struct proc *temp = *a;
    *a = *b;
    *b = temp;
}
//// Helper Function for sorting, using QuickSort Algorithm
// Partition function modified to accept a comparator function directly in its parameters
int partition(struct proc **arr, int low, int high, int (*comp)(const struct proc *, const struct proc *))
{
    struct proc *pivot = arr[high];
    int i = low - 1;
    for (int j = low; j <= high - 1; j++) {
        if (comp(arr[j], pivot) < 0) { // Using the comparator function
            i++;
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return (i + 1);
}
// Quicksort function to sort an array of proc struct pointers
void quicksort(struct proc **arr, int low, int high, int (*comp)(const struct proc *, const struct proc *))
{
    if (low < high) {
        int pi = partition(arr, low, high, comp);
        quicksort(arr, low, pi - 1, comp);
        quicksort(arr, pi + 1, high, comp);
    }
}
// n * (2^(1/n) - 1) , Precomputed CPU Utilization bounds for Liu Layland Schedulability check
float liu_layland_bound[64] = {
  1.0, 0.82842712, 0.77976315, 0.75682846, 0.74349177, 0.73477229, 0.7286266, 0.72406186, 0.72053765, 0.71773463,
  0.71545198, 0.71355713, 0.71195899, 0.71059294, 0.70941184, 0.70838052, 0.70747218, 0.70666607, 0.70594584, 
  0.70529848, 0.70471344, 0.70418215, 0.70369753, 0.70325368, 0.70284567, 0.70246932, 0.70212109, 0.70179794, 
  0.70149725, 0.70121676, 0.7009545, 0.70070876, 0.70047801, 0.70026093, 0.70005633, 0.69986317, 0.69968052, 
  0.69950754, 0.69934349, 0.69918768, 0.69903952, 0.69889845, 0.69876398, 0.69863566, 0.69851306, 0.69839583, 
  0.6982836, 0.69817608, 0.69807296, 0.69797399, 0.69787892, 0.69778752, 0.69769958, 0.69761492, 0.69753334, 
  0.69745469, 0.69737882, 0.69730557, 0.69723481, 0.69716642, 0.69710028, 0.69703628, 0.69697432, 0.69691431
};
//////////////////////// Assignment - 2 //////////////////////////////////////////////

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  //////////////////////// Assignment - 2 //////////////////////////////////////////////
  p->sched_policy = -1;
  p->exec_time = 0;
  p->deadline = 0;
  p->rtp_arrival_time = 0;
  p->elapsed_time = 0;
  p->rate = 0;
  p->weight = 0;
  //////////////////////// Assignment - 2 //////////////////////////////////////////////
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//////////////////////// Assignment - 2 //////////////////////////////////////////////
struct proc*
scheduler_edf(void)
{
  struct proc *p, *sched_p = 0;
  // Variables to track deadline
  uint earliest_deadline = UINT32_MAX, current_deadline;
  // Traverse the ptable t find the process with earliest deadline, if same deadline then smallest pid
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if((p->state == RUNNABLE || p->state == RUNNING) && p->sched_policy == 0) {
      // Calculate current deadline
      current_deadline = p->rtp_arrival_time + p->deadline;
      if(current_deadline < earliest_deadline) {
          earliest_deadline = current_deadline;
          sched_p = p;
      }
      else if(current_deadline == earliest_deadline) {
        if(p->pid < sched_p->pid)
          sched_p = p;  
      }
    }
  }
  return sched_p; // Pointer to the process chosen for scheduling
}

struct proc*
scheduler_rma(void)
{
  struct proc *p, *sched_p = 0;
  // Variables to track deadline
  uint min_weight = UINT32_MAX;
  // Traverse the ptable t find the process with earliest deadline, if same deadline then smallest pid
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if((p->state == RUNNABLE || p->state == RUNNING) && p->sched_policy == 1) {
      if(p->weight < min_weight) {
          min_weight = p->weight;
          sched_p = p;
      }
      else if(p->weight == min_weight) {
        if(p->pid < sched_p->pid)
          sched_p = p;  
      }
    }
  }
  return sched_p; // Pointer to the process chosen for scheduling
}
//////////////////////// Assignment - 2 //////////////////////////////////////////////
//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p = 0;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // Check for EDF scheduled set of process
    p = scheduler_edf();
    if(p == 0) // No EDF scheduled process, try RMA
      p = scheduler_rma();
    // EDF/RMA scheduled process found, perform context switch
    if(p != 0) {
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process ran for 1 tick, Only tracked for Real Time Process
      p->elapsed_time++; 
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      // Release ptable lock
      release(&ptable.lock);
      // Continue with the infinite loop
      continue;
    }
    // No EDF/RMA scheduled process, deafult to ROUND-ROBIN
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
  }
}
//////////////////////// Assignment - 2 //////////////////////////////////////////////

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
//////////////////////// Assignment - 2 //////////////////////////////////////////////
// Schedulibilty Check EDF
int
edf_schedulability_check(int timer_ticks)
{
  struct proc *p;
  // Total CPU Utilization in fraction (in simplest form), denoted by a numerator and denominator 
  float utilization = 0;
  // Per process execution time and deadline
  int e_i, d_i;
  // Traverse the ptable to find set of edf scheduled RT processes
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    // Check if process is not in RUNNABLE or RUNNING or meant to be killed
    if(! (p->state == RUNNABLE || p->state == RUNNING) || p->killed == 1)
      continue;
    // Check if process is EDF scheduled
    if(p->sched_policy == 0) {
      // Set e_i as exec_time - elapsed_time of the process
      e_i = p->exec_time - p->elapsed_time;
      // Set d_i as absoulte deadline - current ticks
      d_i = p->rtp_arrival_time + p->deadline - timer_ticks;
      // Check if e_i > d_i or d_i < 0
      if(e_i > d_i || d_i <= 0) {
        return -22; // Deadline Missed
      }
      // Update utililization
      utilization += ((float) e_i) / d_i;
    }
  }
  // Check if deadline miss doesnt occur & total utilization <= 1, If yes then schedulable
  return (utilization <= 1.0) ? 0 : -22;
}

//// Schedulibilty Check RMA
int
compare_rma(const struct proc *a, const struct proc *b)
{
  // Sort in descedning order
  return b->rate - a->rate;
}
// Function to check Liu_Lehoczky's condition
int
liu_lehoczky_check(int num_proc)
{
  // Store the RMA scheduled processes in a proc
  struct proc* proc_array[num_proc];
  int index = 0;
  for (int i = 0; i < NPROC; i++){
    struct proc *p = &ptable.proc[i];
    // Check if a process is not in RUNNABLE or RUNNING or meant to be killed
    if(! (p->state == RUNNABLE || p->state == RUNNING) || p->killed == 1)
      continue;
    // Add the process to proc_array if scheduling policy is RMA
    if (p->sched_policy == 1)
      proc_array[index++] = p;
  }
  // Sort the array in decending order of rate
  quicksort(proc_array, 0, num_proc - 1, compare_rma);
  // Check if all processes meet their deadlines under zero_phasing (deadline = period)
  for(int i = 0; i < num_proc; i++) {
      // Calculate sum(p_i/p_j * e_j) for all interfering processes, this is the virtual execution time that has to be met within the deadline
      int virtual_exec_time = proc_array[i]->exec_time;
      for(int j = 0; j < i; j++) {
          virtual_exec_time += CEIL(proc_array[j]->rate, proc_array[i]->rate) * proc_array[j]->exec_time;
      }
      // Check if virtual exec_time (in ticks) < period * 100 , or virtual exec_time (in ticks) * rate <= 100
      if(virtual_exec_time * proc_array[i]->rate > 100)
        return -22; // Condition violated, not schedulable
  }
  // All processes meet their deadlines under zero-phasing => Schedulable under RMA
  return 0;
}
// Main RMA schedulibility check functiion
int
rma_schedulability_check(int timer_ticks)
{
  struct proc *p;
  int num_proc = 0; // Number of RMA Scheduled Processes
  float utilization = 0; // Total CPU Utilization
  // Traversing the ptable
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    // Check if process is not in RUNNABLE or RUNNING or meant to be killed
    if(! (p->state == RUNNABLE || p->state == RUNNING) || p->killed == 1)
      continue;
    // Check if scheduling policy is 1 (RMA)
    if (p->sched_policy == 1){
      num_proc ++; // Incremenet num_proc
      utilization += (p->exec_time * p->rate) * 0.01; // Utilization = exec_time * rate * 0.01(seconds / tick)
    }
  } 
  // If no RMA scheduled process, the previous set of processes is schedulable
  if (num_proc == 0)
    return 0;
  // If total utilizationis > 1, the set of processes is not schedulable under any scheduling policy
  if (utilization > 1)
    return -22; // CPU utilization can't be greater than 1
  // Check for liu_layland condition
  if (utilization <= liu_layland_bound[num_proc - 1])
    return 0; // schedulable under RMA
  // Check for Liu-Lehoczky's condition 
  if (liu_lehoczky_check(num_proc) == 0)
    return 0;
  // Set of processes not schedulable under RMA
  return -22;
}

// Logic for sched_policy syscall
int
set_sched_policy(int pid, int policy)
{
  struct proc *p;
  // Invalid policy argument
  if(policy < 0 || policy > 1)
    return -22;
  // Flags for valid_pid argument and to check if the parameters of a given policy are set before scheduling 
  int valid_pid = 0, set_param = 0, schedulable, timer_ticks;
  // Read the timer_ticks count
  acquire(&tickslock);
  timer_ticks = ticks;
  release(&tickslock);
  // Acquire ptable lock
  acquire(&ptable.lock);
  // Traverse the ptable and set the flags
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->pid == pid) {
      valid_pid = 1; // Pid found, argument is valid
      // Check if the required parameters for EDF policy are set
      if(policy == 0) {
        if(p->exec_time && p->deadline) {
          set_param = 1;
        }
      }
      // Check if the required parameters for RMA policy are set
      else {
        if(p->exec_time && p->rate) {
          set_param = 1;
        }
      }
      break;
    }
  }
  // If invalid pid or parameters not set, the new ptable is schedulable as original was schedulable as well and no change in policy was made
  if(!valid_pid || !set_param) {
    release(&ptable.lock);
    return -1; // The current set of processes is schedulable / Wrong Call
  }
  // Set the sched_policy field
  p->sched_policy = policy;
  // Set the rtp_arrival time
  p->rtp_arrival_time = timer_ticks;
  // Check schedulability according to the policy
  schedulable = (policy == 0) ? edf_schedulability_check(timer_ticks) : rma_schedulability_check(timer_ticks);
  // if schedulable then return 0, otherwise kill the process
  if(schedulable == 0) {
    release(&ptable.lock);
    return 0;
  }
  p->killed = 1; // Set the killed field to non zero value so that program is terminated by the kernel
  release(&ptable.lock); // Release the lock
  return -22; // New Set of Tasks not schedulable
}
// Logic for exec_time syscall
int
set_exec_time(int pid, int exec_time)
{
  struct proc *p;
  // Non positive exec time as argument
  if(exec_time <= 0)
    return -22;
  // Acquire ptable lock
  acquire(&ptable.lock);
  // Traverse the ptable to find the process
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->pid == pid) {
      // Check if the parameter is already set (process has already been scheduled with some parameters  and a RT scheduling policyonce)
      if(p->sched_policy != -1) {
        release(&ptable.lock);
        return -22;
      }
      // Set the parameter
      p->exec_time = exec_time;
      release(&ptable.lock);
      return 0;
    }
  }
  // PID Invalid or not found
  release(&ptable.lock);
  return -22;
}

// Logic for deadline syscall
int
set_deadline(int pid, int deadline)
{
  struct proc *p;
  // Non positive exec time as argument
  if(deadline <= 0)
    return -22;
  // Acquire ptable lock
  acquire(&ptable.lock);
  // Traverse the ptable to find the process
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->pid == pid) {
      // Check if the parameter is already set (process has already been scheduled with some parameters  and a RT scheduling policyonce)
      if(p->sched_policy != -1) {
        release(&ptable.lock);
        return -22;
      }
      // Set the parameter
      p->deadline = deadline;
      release(&ptable.lock);
      return 0;
    }
  }
  // PID Invalid or not found
  release(&ptable.lock);
  return -22;
}

// Logic for rate syscall
int
set_rate(int pid, int rate)
{
  struct proc *p;
  // Non positive exec time as argument
  if(rate <= 0)
    return -22;
  // Acquire ptable lock
  acquire(&ptable.lock);
  // Traverse the ptable to find the process
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->pid == pid) {
      // Check if the parameter is already set (process has already been scheduled with some parameters  and a RT scheduling policyonce)
      if(p->sched_policy != -1) {
        release(&ptable.lock);
        return -22;
      }
      // Set the parameter
      p->rate = rate;
      if(p->rate <= 10)
        p->weight = 3;
      else if(p->rate <= 20)
        p->weight = 2;
      else
        p->weight = 1;
      release(&ptable.lock);
      return 0;
    }
  }
  // PID Invalid or not found
  release(&ptable.lock);
  return -22;
}
//////////////////////// Assignment - 2 //////////////////////////////////////////////                          