#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <setjmp.h>
#include <semaphore.h>
#include <pthread.h>
#include <sys/time.h>

#define JB_BX    0
#define JB_SI    1
#define JB_DI    2
#define JB_BP    3
#define JB_SP    4
#define JB_PC    5
#define JB_SIZE 24

#define READY 1
#define RUNNING 2
#define EXITED 3
#define BLOCKED 4
struct sigaction sa;
static int ptr_mangle(int p);
struct TCB;
int pthread_create(pthread_t *thread,const pthread_attr_t *attr,void *(*start_routine) (void *),void *arg);
void  timer_handler(int sig);
void pthread_exit(void *value_ptr);
pthread_t pthread_self(void);
void schedule(void);
int pthread_join(pthread_t thread, void **value_ptr);
sem_t Semamphore;
int sem_init(sem_t *sem, int pshared, unsigned value);
int sem_wait(sem_t *sem);
int sem_post(sem_t *sem);
int sem_destroy(sem_t *sem);
pthread_t CurrentthreadID = 0;
pthread_t threadID = 0;
int spot = 0;
int totalCount = 0;
static int ptr_mangle(int p)
{
    unsigned int ret;
    asm(" movl %1, %%eax;\n"
        " xorl %%gs:0x18, %%eax;"
        " roll $0x9, %%eax;"
        " movl %%eax, %0;"
        : "=r"(ret)
        : "r"(p)
        : "%eax"
        );
    return ret;
}

struct TCB //This is your thread structure
{
    int state;
    void* stackPtr;
    pthread_t ID;
    int exit_status;
    jmp_buf context;
};

struct TCB TCBarray[129]; //129 threads to account for main

int pthread_create(pthread_t *thread,const pthread_attr_t *attr,void *(*start_routine) (void *),void *arg)
{
    int sizeStack = 32767; //size of stack
    if (totalCount == 0) //only on first call ever
    {
        int i;
        for (i = 1; i < 129; ++i) //initialize threads to exited
        {
            TCBarray[i].state = EXITED;
        }
        
        
        
        sa.sa_handler = &timer_handler; //create alarm and signal handler
        sa.sa_flags = SA_NODEFER;
        sigaction (SIGALRM, &sa, NULL);
        ualarm(50000, 50000);
        
        
        
        struct TCB mainthread; //initialize main thread
        TCBarray[0] = mainthread;
        TCBarray[0].ID = 0;
        threadID = 1;
        TCBarray[0].state = RUNNING;
        setjmp(TCBarray[0].context);
        
        totalCount++;
        CurrentthreadID = 0;
        *thread = CurrentthreadID;
    }
    
    int next_spot = spot + 1;
    while (TCBarray[next_spot].state == READY || TCBarray[next_spot].state == RUNNING)//find next available thread slot to create
    {
        if (next_spot == 128)
        {
            next_spot = 0;
        }
        else
        {
            next_spot++;
        }
    }
    struct TCB t;
    TCBarray[next_spot] = t;
    unsigned int *stack_ptr;
    stack_ptr = (void*)malloc(sizeStack); //make space for stack
    TCBarray[next_spot].stackPtr = stack_ptr;
    TCBarray[next_spot].ID = threadID;
    *thread = threadID;
    threadID++;
    void * ptr = TCBarray[next_spot].stackPtr + 32767; //move to top of stack
    ptr = ptr-4;
    *((unsigned long int*)ptr) = (unsigned long int) arg; //add arg
    ptr = ptr -4;
    *((unsigned long int*)ptr) = (unsigned long int)pthread_exit; //add exit
    TCBarray[next_spot].state = READY;
    setjmp(TCBarray[next_spot].context);
    TCBarray[next_spot].context[0].__jmpbuf[JB_SP] = ptr_mangle((unsigned long int)(ptr));
    TCBarray[next_spot].context[0].__jmpbuf[JB_PC] = ptr_mangle((unsigned long int)start_routine);
    totalCount++;
    schedule();
    return 0;
}

void pthread_exit(void *value_ptr)
{
    TCBarray[spot].state = EXITED;
    free(TCBarray[spot].stackPtr);
    --totalCount;
    schedule();
    __builtin_unreachable;
}


pthread_t pthread_self(void)
{
    return CurrentthreadID;
}

void schedule (void)
{
    
    
    if(setjmp(TCBarray[spot].context))
    {
        return;
    }
    
    int counter = 0;
    int next_spot = spot + 1;
    if (TCBarray[spot].state == RUNNING)
    {
        TCBarray[spot].state = READY;
    }
    while (TCBarray[next_spot].state != READY)
    {
        if (next_spot == 128)
        {
            next_spot = 0;
        }
        else if (counter >= 128)
        {
            next_spot = 0;
        }
        else
        {
            next_spot++;
        }
        counter++;
        
    }
    TCBarray[next_spot].state = RUNNING;
    CurrentthreadID = TCBarray[next_spot].ID;
    spot = next_spot;
    longjmp(TCBarray[next_spot].context, 1);
    
    
    
    
}
void  timer_handler(int sig)
{
    schedule();
}


void lock()
{
    
    sigemptyset(&sa.sa_mask);
    sigaddset(&sa.sa_mask, SIGALRM);
    sigprocmask(SIG_BLOCK, &sa.sa_mask, NULL);
    
    
}

void unlock()
{
    sigemptyset(&sa.sa_mask);
    sigaddset(&sa.sa_mask, SIGALRM);
    sigprocmask(SIG_UNBLOCK, &sa.sa_mask, NULL);
    
}


void pthread_exit_wrapper()
{
    unsigned int res;
    asm("movl %%eax, %0\n":"=r"(res));
    pthread_exit((void *) res);
}

int pthread_join(pthread_t thread, void **value_ptr)
{
    return 0;
}

int sem_init(sem_t *sem, int pshared, unsigned value)
{
   
    return 0;
}

int sem_wait(sem_t *sem)
{
    
    return 0;
}
int sem_post(sem_t *sem)
{
   
    return 0;
}
int sem_destroy(sem_t *sem)
{
    
    return 0;
}











