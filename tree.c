
#include <stdio.h>
#include <stdlib.h>
#include "struct.h"

void display_tree_rec(tree t,int p);

tree tree_create(char * label, bool nullary, bool space, enum type tp,  attributes attr, tree daughters, tree right){
  if ((tp == WORD) && (nullary == false))
    return NULL;
  tree t = malloc(sizeof (*t));
  t->label = label;
  t->nullary = nullary;
  t->space = space;
  t->tp = tp;
  t->attr = attr;
  t->daughters = daughters;
  t->right = right;
  return t;
}

tree get_daughters(tree t){
  return t->daughters;
}

void set_daughters (tree t,tree d){
  t->daughters = d;
}

tree get_right(tree t){
  return t->right;
}

void set_right (tree t,tree r){
  t->right = r;
}

char* get_label(tree t){
  return t->label;
}

void set_label (tree t,char * label){
  t->label = label;
}

attributes get_attributes(tree t){
  return t->attr;
}

void set_attributes (tree t,attributes attr){
  t->attr = attr;
}

bool get_nullary(tree t){
  return t->nullary;
}

void set_nullary (tree t,bool nullary){
  t->nullary = nullary;
}

bool get_space(tree t){
  return t->space;
}

void set_space (tree t,bool space){
  t->space = space;
}

enum type get_enum(tree t){
  return t->tp;
}

void set_enum(tree t,enum type tp){
  t->tp = tp;
  if (tp == WORD)
    t->nullary = true;
}


void ajouter_frere(tree t,tree f){
  if(t->right == NULL)
    set_right(t,f);
  else
    ajouter_frere(t->right,f);
}

void ajouter_fils(tree t, tree f){
  if (t->daughters == NULL)
    set_daughters(t,f);
  else
    ajouter_frere(t->daughters,f);
}





/*void display_tree(tree t,int fils,int frere){
  if((fils == 0) && (frere==0))
    printf("racine de l'arbre ");
  else 
    printf("profondeur fils = %d et frere = %d ",fils,frere);
  printf("label = %s \n",t->label);
  display_tree(t->daughters,fils+1,frere);
  display_tree(t->right,fils,frere+1);
  }*/


void display_tree(tree t){
  display_tree_rec(t,1);
}

void display_tree_rec(tree t,int p){
  if(t == NULL)
    return;
  for(int i =0; i<p;i++)
    printf("| ");
  printf("%s\n",t->label);
  display_tree_rec(t->daughters,p+1);
  display_tree_rec(t->right,p);
}
