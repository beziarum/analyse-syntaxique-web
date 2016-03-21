
#include <stdio.h>
#include <stdlib.h>
#include "struct.h"

tree tree_create(char * label, bool nullary, bool space, enum type tp,  attributes attr, tree daughters, tree right){
  if ((tp == WORD) && (nullary == false))
    return NULL;
  tree t = malloc(sizeof (tree));
  t->label = label;
  t->nullary = nullary;
  t->space = space;
  t->tp = tp;
  t->attr = attr;
  t->daughters = daughters;
  t->right = right;
  return t;
}

