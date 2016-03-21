
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
