
#include <stdio.h>
#include <stdlib.h>
#include "struct.h"


int main (int argc , void** argv){
  attributes a = attributes_create("caca","val");
  tree t10 = tree_create("tamere 10",true,true,WORD,a,NULL,NULL);
  tree t9 = tree_create("tamere 9",true,true,WORD,a,t10,NULL);
  tree t8 = tree_create("tamere 8",true,true,WORD,a,NULL,t9);
  tree t7 = tree_create("tamere 7",true,true,WORD,a,NULL,NULL);
  tree t6 = tree_create("tamere 6",true,true,WORD,a,NULL,NULL);
  tree t5 = tree_create("tamere 5",true,true,WORD,a,t8,t7);
  tree t4 = tree_create("tamere 4",true,true,WORD,a,NULL,NULL);
  tree t3 = tree_create("tamere 3",true,true,WORD,a,t5,NULL);
  tree t2 = tree_create("tamere 2",true,true,WORD,a,t4,t6);
  tree t1 = tree_create("tamere 1",true,true,WORD,a,t2,t3);
  display_tree(t1);
  return 1;
}
