
#include <stdio.h>
#include <stdlib.h>
#include "struct.h"

attributes attributes_create(char * key, char * value)
{
  attributes attr = malloc(sizeof(* attr));
  attr->key = key;
  attr->value = value;
  attr->next = NULL;
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

void display_attributes(attributes attr, int i) {
  printf("Attribute %d :\nKey : %s\nValue : %s\n\n", i, attr->key, attr->value);
  if (attr->next) {
    display_attributes(attr->next, i+1);
  }
}


void ajouter_suivant(attributes attr1, attributes attr2){
  if(attr1->next == NULL)
    attr1->next = attr2;
  else
    ajouter_suivant(attr1->next,attr2);
}

