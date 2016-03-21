
#include <stdio.h>
#include <stdlib.h>
#include "struct.h"

attributes attributes_create(char * key, char * value)
{
  attributes a = malloc(sizeof(attributes));
  a->key = key;
  a->value = value;
  a->next = NULL;
  return a;
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
