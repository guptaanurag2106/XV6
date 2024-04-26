#include "types.h"
#include "defs.h"
#include "x86.h"
#include "spinlock.h"

// static struct {
//   uint seed;
//   struct spinlock lock;
// } rand;
uint seed;


void randinit(uint s) {
  // rand.seed = s;
  // initlock(&rand.lock, "rand");
  seed = s;
}

uint get_seed(void){
  uint timer;
  timer = (uint)inb(0x61);

  return timer;
}

uint get_rand(void) {
  uint e;
  // acquire(&rand.lock);
  // e = rand.seed;
  e = seed;
  seed = (1664525 * e + 1013904223) & 0x7fffffff;
  // release(&rand.lock);
  return seed % RAND_MAX;
}
