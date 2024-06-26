#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;
   
  // Assignment 3 - Read the ASLR file to see if aslr is ON or OFF
  ushort aslr_flag = 0;
  char c;
  struct inode *aslr_ip;
  if ((aslr_ip = namei(ASLR_FILE)) == 0) {
    cprintf("unable to open %s file\n", ASLR_FILE);
  } else {
    ilock(aslr_ip);
    if (readi(aslr_ip, &c, 0, sizeof(char)) != sizeof(char)) {
      cprintf("unable to read %s file\n", ASLR_FILE);
    } else {
      if(c == '1'){
        aslr_flag = 1;
      }
      else{
        aslr_flag = 0;
      }
    }
    iunlock(aslr_ip);
  }
  // Generate a random offset if aslr is ON
  if (curproc->pid > 2 && aslr_flag == 1) {
    // Get Random Seed
    uint seed = get_seed();
    // Initialize Random Number Generator
    randinit(seed);
    // Generate a Random Number
    curproc->aslr_offset = get_rand();
    // Make sure the offset added is ODD 
    curproc->aslr_offset = (curproc->aslr_offset % 2 == 0) ? curproc->aslr_offset - 1 : curproc->aslr_offset;
    // Generate a stack offset between [2, 8] ( these are the number of pages allocated between stack and user pages)
    curproc->stack_offset += get_rand() % 7;
  }
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + curproc->aslr_offset + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)(ph.vaddr + curproc->aslr_offset), ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate #stack_offset pages at the next page boundary.
  // Make the first N-1  inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + curproc->stack_offset*PGSIZE)) == 0)
    goto bad;
  // Make all but the last page inaccessible
  for (int i = 0; i < curproc->stack_offset - 1; ++i) {
    clearpteu(pgdir, (char*)(sz - (i + 2) * PGSIZE));
  }
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry + curproc->aslr_offset;  // main
  curproc->tf->esp = sp;
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}

