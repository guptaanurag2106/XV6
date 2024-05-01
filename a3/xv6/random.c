#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
// Random Number Generator Parameters
#define LCG_A    1103515245
#define LCG_C    12345
#define LCG_M    (1UL << 31)
#define RAND_MAX 293

// Define seed
static uint seed;

// Initialize the RNG with a given state
void randinit(uint s) {
  seed = s;
}

// Create a RNG_STATE with a composite of system states
uint get_seed(void) {
    uint rng_state;
    // Read current value of ticks ( the timer interrupts)
    acquire(&tickslock);
    rng_state = ticks;
    release(&tickslock);
    // XOR with bytes read from  Port 0x61.
    rng_state ^= (uint) inb(0x61);
    return rng_state;
}

// Generates a random number using a Linear Congruential Generator (LCG)
uint get_rand(void) {
    // Linear Congruential Generator formula
    seed = (LCG_A * seed + LCG_C) % LCG_M;
    // Return a number between 0 and RAND_MAX
    return seed % RAND_MAX;
}
