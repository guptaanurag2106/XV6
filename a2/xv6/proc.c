#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#define UINT32_MAX 4294967295U

//////////////////////// Assignment - 2 //////////////////////////////////////////////
//// Helper Functions
// Function to find the Greatest Common Divisor (GCD)
int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}
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
  p->tot_runtime = 0;
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
    if(p->state == RUNNABLE && p->sched_policy == 0) {
      // Calculate current deadline
      current_deadline = p->rtp_arrival_time + p->deadline;
      if(current_deadline < earliest_deadline) {
          earliest_deadline = current_deadline;
          sched_p = p;
      }
      else if(current_deadline == earliest_deadline) {
        if(p->pid < sched_p->pid)
          sched_p = p;
        else
          continue;   
      }
      else
        continue;
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
    if(p->state == RUNNABLE && p->sched_policy == 0) {
      if(p->weight < min_weight) {
          min_weight = p->weight;
          sched_p = p;
      }
      else if(p->weight == min_weight) {
        if(p->pid < sched_p->pid)
          sched_p = p;
        else
          continue;   
      }
      else
        continue;
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
      // Process ran for 1 tick
      p->tot_runtime++;
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
      // Process ran for 1 tick
      p->tot_runtime++;
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
edf_schedulability_check(void)
{
  struct proc *p; int deadline_miss = 0;
  // Total CPU Utilization in fraction (in simplest form), denoted by a numerator and denominator 
  int util_num = 0, util_den = 1;
  // Per process execution time and deadline
  int e_i, d_i;
  // Traverse the ptable to find set of edf scheduled RT processes
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    // Check if process is EDF scheduled
    if(p->sched_policy == 0) {
      // Set e_i as exec_time - tot_runtime of the process
      e_i = p->exec_time - p->tot_runtime;
      // Set d_i as absoulte deadline - current ticks
      acquire(&tickslock);
      d_i = p->rtp_arrival_time + p->deadline - ticks;
      release(&tickslock);
      // Check if e_i > d_i or d_i < 0
      if(e_i > d_i || d_i < 0) {
        deadline_miss = 1;
        break;
      }
      // Update util_num and utll_den
      util_num = util_num * d_i + e_i * util_den;
      util_den = util_den * d_i;
      // Simplify the fraction
      int util_gcd = gcd(util_num, util_den);
      util_num /= util_gcd;
      util_den /= util_gcd;
    }
  }
  // Check if deadline miss doesnt occur & total utilization <= 1, If yes then schedulable
  return (!deadline_miss && util_num <= util_den) ? 0 : -22;
}

// Schedulibilty Check RMA
int
rma_schedulability_check(void)
{
  return 0;
}

// Logic for sched_policy syscall
int
sched_policy(int pid, int policy)
{
  struct proc *p;
  // Invalid policy argument
  if(policy < 0 || policy > 1)
    return -22;
  // Flags for valid_pid argument and to check if the parameters of a given policy are set before scheduling 
  int valid_pid = 0, set_param = 0, schedulable;
  // Acquire ptable lock
  acquire(&ptable.lock);
  // Traverse the ptable and set the flags
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->pid == pid) {
      valid_pid = 1;
      if(policy == 0) {
        if(p->exec_time && p->deadline) {
          set_param = 1;
        }
      }
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
    return 0; // The current set of processes is schedulable
  }
  // Set the sched_policy field
  p->sched_policy = policy;
  // Set the rtp_arrival time, acquire ticks lock to avoid data race
  acquire(&tickslock);
  p->rtp_arrival_time = ticks;
  release(&tickslock);
  // Check schedulability according to the policy
  schedulable = (policy == 0) ? edf_schedulability_check() : rma_schedulability_check();
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
exec_time(int pid, int exec_time)
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

// Lgic for deadline syscall
int
deadline(int pid, int deadline)
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
rate(int pid, int rate)
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
      release(&ptable.lock);
      return 0;
    }
  }
  // PID Invalid or not found
  release(&ptable.lock);
  return -22;
}
//////////////////////// Assignment - 2 //////////////////////////////////////////////                          