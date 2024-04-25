#include "types.h"
#include "defs.h"

#define RAND_MAX 10000000

static uint seed = 1;

void set_seed(uint s) { seed = s; }

uint rand() {
  seed = (1664525 * seed + 1013904223) & 0x7fffffff;
  return seed % RAND_MAX;
}
