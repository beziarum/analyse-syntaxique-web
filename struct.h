
#include <stdbool.h>

struct tree_t;
struct attributes_t;

enum type {TREE,WORD};        //typage des nœuds: permet de savoir si un nœud construit
                               //un arbre ou s'il s'agit simplement de texte

struct attributes_t{
    char * key;               //nom de l'attribut
    char * value;             //valeur de l'attribut
    struct attributes_t * next; //attribut suivant
};

struct tree_t {
    char * label;              //étiquette du nœud
    bool nullary;              //nœud vide, par exemple <br/>
    bool space;                //nœud suivi d'un espace
    enum type tp;              //type du nœud. nullary doit être true si tp vaut word
    struct attributes_t * attr;  //attributs du nœud
    struct tree_t * daughters;   //fils gauche, qui doit être NULL si nullary est true
    struct tree_t * right;       //frère droit
};

typedef struct tree_t * tree;
typedef struct attributes_t * attributes;


tree get_daughters(tree t);
void set_daughters (tree t,tree d);
tree get_right(tree t);
void set_right (tree t,tree r);
char* get_label(tree t);
void set_label (tree t,char * label);
attributes get_attributes(tree t);
void set_attributes (tree t,attributes attr);
bool get_nullary(tree t);
void set_nullary (tree t,bool nullary);
bool get_space(tree t);
void set_space (tree t,bool space);
enum type get_enum(tree t);
void set_enum(tree t,enum type tp);
