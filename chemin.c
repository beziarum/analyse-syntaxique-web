#include <stdlib.h>
#include "chemin.h"

struct path * create_path(int n,char* str,enum descr x){
  struct path * p = malloc(sizeof(*p));
  p->n=n;
  p->dir = create_dir(str,x);
  return p;
}

struct dir * create_dir(char* str , enum descr x){
  struct dir * d = malloc(sizeof(*d));
  d->str=str;
  d->descr=x;
  d->dir=NULL;
  return d;
}
