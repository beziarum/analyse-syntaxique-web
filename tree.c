
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


attributes attributes_create (char * key, char * value, struct attributes_t * next) {
  attributes attr = malloc(sizeof(attributes));
  attr->key=key;
  attr->value=value;
  attr->next = next;
  return attr;
}

char * get_attribute_key (attributes attr) {
  return attr->key;
}
 
void set_attribute_key (attributes attr, char * key) {
  attr->key = key;
}

char * get_attribute_value (attributes attr) {
  return attr->value;
}

void set_attribute_value (attributes attr, char * value) {
  attr->value = value;
}

attributes get_attribute_next (attributes attr) {
  return attr->next;
}

void set_attribute_next (attributes attr, attributes next) {
  attr->next = next;
}



