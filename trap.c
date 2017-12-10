#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;
uint rcr22;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT://cs153
    //uint rcr22;
    rcr22 = rcr2();
    cprintf("Stack bottom: %d, Rcr2: %d\n", myproc()->stack_sz, rcr22);
    //cprintf(" Page size: %d", PGSIZE);
    //cprintf(" Top heap: %d", myproc()->sz);
    if(PGROUNDDOWN(rcr22) < myproc()->stack_sz){
    /*  //cprintf(" rcr2() ok");
      if((allocuvm(myproc()->pgdir, (myproc()->stack_sz-1)-PGSIZE, myproc()->stack_sz-1)) == 0){
        cprintf("Allocation failed\n");
      }
      else{
        myproc()->stack_sz = PGROUNDDOWN(myproc()->stack_sz-1);
	//cprintf("Updated stack bot: %d\n", myproc()->stack_sz);
        cprintf("Memory allocated\n");
      }
    }*/
      int np = ((myproc()->stack_sz - PGROUNDDOWN(rcr22))/PGSIZE);//number of pages
      for(int i = 0; i < np; i++){
        allocuvm(myproc()->pgdir, myproc()->stack_sz-PGSIZE-1, myproc()->stack_sz-1);
        myproc()->stack_sz = myproc()->stack_sz-PGSIZE;
        cprintf("Mem allocated\n");
      }
    }
    else{
      panic("Address not below");
    }
    //lapiceoi();
    //switchuvm(myproc());
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  /*if(tf->trapno == T_PGFLT){//cs153 case for trap 14 page faults
    //cprintf("In trap 14\n");
    char* new_page;
    uint page_bottom;
    page_bottom = PGROUNDDOWN(rcr2());// nearest page mark below
    new_page = kalloc();//returns physical page
    if(new_page == 0){ //checks if memory left
      cprintf("no memory left\n");
    }
    else if(page_bottom < myproc()->stack_sz){// check that address is below
      memset(new_page, 0, PGSIZE);
      mappages(myproc()->pgdir, (void*) page_bottom, PGSIZE, V2P(new_page), PTE_W|PTE_U);
      myproc()->stack_sz = page_bottom; // update stack bottom
      cprintf("Allocated a new page at %d\n", myproc()->stack_sz);
    }
    else{//default handler
      panic("Address is too far\n");
    }
    return;
  }*/

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
