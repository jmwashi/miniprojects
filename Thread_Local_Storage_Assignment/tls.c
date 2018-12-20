//
//  tls.c
//  
//
//  Created by Jon Washington on 11/26/17.
//

#include "tls.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <signal.h>

int PAGESIZE;
//int indexing = 0;
int initialized = 0;
int numThreads = 0;
void tls_handle_page_fault(int sig, siginfo_t *si, void *context);
typedef struct thread_local_storage
{
    pthread_t tid;
    unsigned int size;
    unsigned int page_num;
    struct page **pages;
} TLS;

struct page {
    unsigned int address;
    int ref_count;
};
 struct hash_element
{
    pthread_t tid;
    TLS *tls;
    struct hash_element *next;
    int init;
};

struct hash_element hashtable[128];

void tls_init()
{
    struct sigaction sigact;
    PAGESIZE = getpagesize();
    sigemptyset(&sigact.sa_mask);
    sigact.sa_flags = SA_SIGINFO;
    //sigact.sa_sigaction = tls_handle_page_fault(0,SA_SIGINFO,NULL);
    tls_handle_page_fault(0,SA_SIGINFO,NULL);
    sigaction(SIGBUS, &sigact, NULL);
    sigaction(SIGSEGV,&sigact,NULL);
    int i;
    for(i =0; i<numThreads;i++)
    {
        hashtable[i].init = 0;
    }
}

//FINISH THIS HANDLE SIGSEGV
void tls_handle_page_fault(int sig, siginfo_t *si, void *context)
{
    struct page *p;
   int p_fault = ((unsigned int) si->si_addr) & ~(PAGESIZE-1);
    if(p->address == p_fault){
        pthread_exit(NULL);
    }
    signal(SIGSEGV,SIG_DFL);
    signal(SIGBUS,SIG_DFL);
    raise(sig);
}
int locate_index(int inNum){
    int i;
    for(i = 0; i < 128;i++)
    {
        if((int)hashtable[i].tid == inNum)
        {
            return i;
        }
    }
    return -1;
}
int tls_create(unsigned int size)
{
    if(initialized == 0)
        tls_init();
    int indexing = locate_index((int)pthread_self());
    if(size <= 0)
        return -1;
    if(indexing != -1)
    {
        if(hashtable[indexing].init != 0)
            return -1;
        
    }
    else{
        indexing = numThreads++;
    }
    int i;
    hashtable[indexing].tls = calloc(1,sizeof(TLS));
    hashtable[indexing].tls->pages = calloc(size/4096 + (size%4096!=0),sizeof(struct page));
    for(i = 0; i < (size/4096) + (size%4096!=0); i++)
    {
        struct page *p = calloc(1,sizeof(struct page));
        p->address = (unsigned int)mmap(0,PAGESIZE,0,MAP_ANON | MAP_PRIVATE,0,0);
        p->ref_count = 1;
        hashtable[indexing].tls ->pages[i] = p;
        hashtable[indexing].tid = pthread_self();
        hashtable[indexing].tls->size+=PAGESIZE;
        hashtable[indexing].tls->page_num++;
        hashtable[indexing].init = 1;
    }
    //do step 6 in discussion slides
    return 0;
}
void tls_protect(struct page *p)
{
    if(mprotect((void*)p->address,PAGESIZE,0)){
        fprintf(stderr,"tls_protect: could not protect page\n");
        exit(1);
    }
}
void tls_unprotect(struct page *p)
{
    if(mprotect((void*)p->address,PAGESIZE,PROT_READ | PROT_WRITE)){
        fprintf(stderr,"tls_unprotect: could not protect page\n");
        exit(1);
    }
}

int tls_read(unsigned int offset, unsigned int length, char *buffer)
{
    int i;
    int indexing = locate_index((int)pthread_self());
    if(initialized != 1)
        return -1;
    if((offset + length) > hashtable[indexing].tls->size)
        return -1;
    for(i = 0; i < hashtable[indexing].tls->page_num; i++)
    {
        tls_unprotect(hashtable[indexing].tls->pages[i]);
    }
    int cnt,idx;
    char *src;
    for (cnt= 0, idx= offset; idx< (offset + length); ++cnt, ++idx)
    {
        struct page *p;
        unsigned int pn, poff;
        pn = idx/PAGESIZE;
        poff = idx % PAGESIZE;
        
        p = hashtable[indexing].tls->pages[pn];
        src = ((char*)p->address) + poff;
        buffer[cnt] = *src;
        
    }
    for(i = 0; i < hashtable[indexing].tls->page_num; i++)
    {
        tls_protect(hashtable[indexing].tls->pages[i]);
    }
    return 0;
}

int tls_write(unsigned int offset, unsigned int length, char *buffer)
{
    int indexing = locate_index((int)pthread_self());
    /*if(indexing == -1)
        return -1;*/
    if((offset + length) > hashtable[indexing].tls->size)
        return -1;
    //if(hashtable[indexing].init ==0 || initialized == 0)
    if(initialized != 1)
        return -1;
    int cnt,idx;
    int i;
    char *dst;
    for(i = 0; i < hashtable[indexing].tls->page_num; i++)
    {
        tls_unprotect(hashtable[indexing].tls->pages[i]);
    }
    for (cnt= 0, idx= offset; idx< (offset + length); ++cnt, ++idx)
    {
        struct page *p, *copy;
        unsigned int pn, poff;
        pn = idx/PAGESIZE;
        poff = idx % PAGESIZE;
        p = hashtable[indexing].tls->pages[pn];
        if(p->ref_count > 1)
        {
            copy = (struct page *)calloc(1,sizeof(struct page));
            copy->address = (unsigned int)mmap(0,PAGESIZE,PROT_WRITE,MAP_ANON | MAP_PRIVATE,0,0);
            copy ->ref_count = 1;
            hashtable[indexing].tls->pages[pn] = copy;
            p->ref_count--;
            tls_protect(p);
            p =  copy;
        }
        dst = ((char*)p->address) + poff;
        *dst = buffer[cnt];
        
    }
    for(i = 0; i < hashtable[indexing].tls->page_num; i++)
    {
        tls_protect(hashtable[indexing].tls->pages[i]);
    }
    return 0;
}
int tls_clone(pthread_t tid)

{
    int indexing = locate_index((int)pthread_self());
    if( indexing != -1)
    {
        if(hashtable[indexing].init != 0)
        {
            return -1;
        }
    }
    else
    {
        indexing = numThreads++;
    }
    int threadID = locate_index(tid);
    if( threadID == -1)
    {
        return -1;
    }
    if( hashtable[threadID].init ==0 || initialized ==0)
    {
        return -1;
    }
    int i;
    int size = hashtable[threadID].tls->size;
    hashtable[indexing].tls = calloc(1,sizeof(TLS));
    hashtable[indexing].tls -> pages = calloc(hashtable[threadID].tls->page_num,sizeof(struct page));
    for (i =0;i < hashtable[threadID].tls->page_num;i++)
    {
        hashtable[indexing].tls->pages[i] = hashtable[threadID].tls->pages[i];
        hashtable[indexing].tls->pages[i]->ref_count++;
    }
    hashtable[indexing].init =1;
    hashtable[indexing].tls->page_num = hashtable[threadID].tls->page_num;
    hashtable[indexing].tls->size = hashtable[threadID].tls->size;
    hashtable[indexing].tid= pthread_self();
    
    
    
    return 0;
    
}
int tls_destroy()
{
    int i;
    int indexing = locate_index((int)pthread_self());
    if(initialized != 1)
        return -1;
    for(i = 0; i < hashtable[indexing].tls->page_num; i++)
    {
        free(hashtable[indexing].tls->pages[i]);
    }
    
    return 0;
}


