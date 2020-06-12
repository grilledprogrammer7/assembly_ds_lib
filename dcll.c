#include<stdio.h>
#include<stdlib.h>
#include<assert.h>

#define TRUE 1
#define FALSE 0
#define SUCCESS 1
#define FAILURE 0
#define LIST_DATA_NOT_FOUND 2
#define LIST_EMPTY 3

typedef int data_t;
typedef int status_t;
typedef int len_t;
typedef int bool;
typedef struct node node_t;
typedef node_t list_t;

struct node{
    data_t data;
    struct node* prev;
    struct node* next;
};

// Interface routines declarations
list_t *create_list(void);

status_t insert_beg(list_t *p_list, data_t newdata);
status_t insert_end(list_t *p_list, data_t newdata);
status_t insert_after(list_t *p_list, data_t e_data, data_t newdata);
status_t insert_before(list_t *p_list, data_t e_data, data_t newdata);

status_t get_beg(list_t *p_list, data_t *p_data);
status_t get_end(list_t *p_list, data_t *p_data);
status_t pop_beg(list_t *p_list, data_t *p_data);
status_t pop_end(list_t *p_list, data_t *p_data);

status_t remove_beg(list_t *p_list);
status_t remove_end(list_t *p_list);
status_t remove_data(list_t *p_list, data_t data);

len_t get_length(list_t *p_list);
bool conatins(list_t *p_list, data_t search_data);
bool is_list_empty(list_t *p_list);
node_t *get_location(list_t *p_list, data_t search_data);
int get_repeat_count(list_t *p_list, data_t search_data);
void show_list(list_t *p_list, const char *msg);

list_t *concat_lists(list_t *p_list1, list_t *p_list2);
list_t *merge_lists(list_t *p_list1, list_t *p_list2);
list_t *get_reversed_list(list_t *p_list);
status_t list_to_array(list_t *p_list, data_t **pp_array, size_t *p_size);
list_t *array_to_list(list_t *p_list, data_t *p_array, size_t size);

status_t append_list(list_t *p_list1, list_t *p_list2);
status_t reverse_list(list_t *p_list);

status_t destroy_list(list_t **pp_list);

// List of auxilary routines
void generic_insert(node_t *p_beg, node_t *p_mid, node_t *p_end);
void generic_delete(node_t *p_delete_node);
node_t *locate_node(list_t *p_list, data_t search_data);
node_t *get_list_node(data_t newdata);

// Memory allocation
void *xmalloc(size_t size_in_bytes);

void *xmalloc(size_t size){
    void *ptr = NULL;
    ptr = malloc(size);
    assert(ptr != NULL);
    return (ptr);
}

node_t *get_list_node(data_t newdata){
    node_t *p_new_node = NULL;
    p_new_node = (node_t*) xmalloc(sizeof(node_t));
    p_new_node->data = newdata;
    p_new_node->prev = NULL;
    p_new_node->next = NULL;
    return (p_new_node);
}

list_t *create_list(){
    node_t *p_list = NULL;
    p_list = get_list_node(0);
    p_list->next = p_list;
    p_list->prev = p_list;
    return (p_list);
}

void generic_insert(node_t *p_beg, node_t *p_mid, node_t *p_end){
    p_mid->prev = p_beg;
    p_mid->next = p_end;
    p_beg->next = p_mid;
    p_end->prev = p_mid;
}

status_t insert_beg(list_t* p_list, data_t newdata){
    node_t* p_nn = NULL;
    p_nn = get_list_node(newdata);
    generic_insert(p_list, p_nn, p_list->next);
    p_list->data++;
    return (SUCCESS);
}

status_t insert_end(list_t* p_list, data_t newdata){
    node_t* p_nn = NULL;
    p_nn = get_list_node(newdata);
    generic_insert(p_list->prev, p_nn, p_list);
    p_list->data++;
    return (SUCCESS);
}

node_t* locate_node(list_t *p_list, data_t search_data){
    node_t* p_sn = NULL;
    node_t* p_run = p_list->next;
    while (p_run != p_list)
    {
        if(p_run->data == search_data){
            p_sn = p_run;
            break;
        }
        p_run = p_run->next;
    }
    return (p_sn);
}

status_t insert_after(list_t *p_list, data_t e_data, data_t newdata){
    node_t* p_fn = locate_node(p_list, e_data);
    if(p_fn == NULL){
        return (LIST_DATA_NOT_FOUND);
    }
    generic_insert(p_fn, get_list_node(newdata), p_fn->next);
    p_list->data++;
    return (SUCCESS);
}

status_t insert_before(list_t *p_list, data_t e_data, data_t newdata){
    node_t *p_fn = locate_node(p_list, e_data);
    if( p_fn == NULL ){
        return (LIST_DATA_NOT_FOUND);
    }
    generic_insert(p_fn->prev, get_list_node(newdata), p_fn);
    p_list->data++;
    return (SUCCESS);
}

bool is_list_empty(list_t *p_list){
    return ( p_list->next == p_list && p_list->prev == p_list );
}

status_t get_beg(list_t *p_list, data_t *p_data){
    if(is_list_empty(p_list) == TRUE ){
        return (LIST_EMPTY);
    }
    *p_data = p_list->next->data;
    return (SUCCESS);
}

status_t get_end(list_t *p_list, data_t *p_data){
    if(is_list_empty(p_list) == TRUE ){
        return (LIST_EMPTY);
    }
    *p_data = p_list->prev->data;
    return (SUCCESS);
}

void generic_delete(node_t *p_delete_node){
    p_delete_node->prev->next = p_delete_node->next;
    p_delete_node->next->prev = p_delete_node->prev;
    free(p_delete_node);
    p_delete_node=NULL;
}

status_t pop_beg(list_t *p_list, data_t *p_data){
    if(is_list_empty(p_list)){
        return (LIST_EMPTY);
    }
    *p_data = p_list->next->data;
    generic_delete(p_list->next);
    return (SUCCESS);
}

status_t pop_end(list_t *p_list, data_t *p_data){
    if( is_list_empty(p_list) == TRUE ){
        return (LIST_EMPTY);
    }
    *p_data = p_list->prev->data;
    generic_delete(p_list->prev);
    return (SUCCESS);
}

status_t remove_beg(list_t *p_list){
    if( is_list_empty(p_list) == TRUE ){
        return (LIST_EMPTY);
    }
    generic_delete(p_list->next);
    return (SUCCESS);
}

status_t remove_end(list_t *p_list){
    if( is_list_empty(p_list) ){
        return (LIST_EMPTY);
    }
    generic_delete(p_list->prev);
    return (SUCCESS);
}

status_t remove_data(list_t *p_list, data_t r_data){
    node_t *p_r = locate_node(p_list, r_data);
    if(p_r == NULL){
        return (LIST_DATA_NOT_FOUND);
    }
    generic_delete(p_r);
    return (SUCCESS);
}

len_t get_length(list_t *p_list){
    node_t *p_run;
    len_t len;
    for( p_run = p_list->next, len = 0; p_run != p_list; p_run = p_run->next, ++len ){
    }
    return (len);
}

bool contains(list_t *p_list, data_t search_data) {
    return (locate_node(p_list, search_data) != NULL);
}

node_t *get_location(list_t *p_list, data_t search_data) {
    return (locate_node(p_list, search_data));
}

int get_repeat_count(list_t *p_list, data_t search_data) {
    node_t *p_run;
    int cnt = 0;
    for( p_run = p_list->next; p_run != p_list; p_run = p_run->next ) {
        if( p_run->data == search_data){
            ++cnt;
        }
    }
    return (cnt);
}

void show_list(list_t *p_list, const char *msg){
    node_t *p_run;
    if(msg){
        puts(msg);
    }
    printf("[BEG]<->");
    for( p_run = p_list->next; p_run != p_list; p_run = p_run->next ){
        printf("[%d]<->", p_run->data);
    }
    puts("[END]");
}

list_t *concat_lists(list_t *p_list1, list_t *p_list2){
    list_t *p_list_concat = create_list();
    node_t *p_run;

    for(p_run = p_list1->next; p_run != p_list1; p_run = p_run->next){
        insert_end(p_list_concat, p_run->data);
    }

    for(p_run = p_list2->next; p_run != p_list2; p_run = p_run->next) {
        insert_end(p_list_concat, p_run->data);
    }

    return (p_list_concat);
}

list_t *merge_lists(list_t *p_list1, list_t *p_list2){
    list_t *p_list_merged = create_list();
    node_t *p_run1 = p_list1->next, *p_run2 = p_list2->next;

    while (TRUE)
    {
        if(p_run2 == p_list2){
            while (p_run1 == p_list1)
            {
                insert_end(p_list_merged, p_run1->data);
                p_run1 = p_run1->next;
            }
            break;
        }
        if (p_run1 == p_list1)
        {
            while (p_run2 != p_list2)
            {
                insert_end(p_list_merged, p_run2->data);
                p_run2 = p_run2->next;
            }
            break;
        }
        if(p_run1->data <= p_run2->data){
            insert_end(p_list_merged, p_run1->data);
            p_run1 = p_run1->next;
        }
        else
        {
            insert_end(p_list_merged, p_run2->data);
            p_run2 = p_run2->next;
        }
    }
    return (p_list_merged);
}

list_t *get_reversed_list(list_t *p_list) {
    list_t *p_list_reversed = create_list();
    node_t *p_run;
    for(p_run = p_list->prev; p_run != p_list; p_run = p_run->prev){
        insert_end(p_list_reversed, p_run->data);
    }
    return (p_list_reversed);
}

status_t list_to_array(list_t *p_list, data_t **pp_data_aaray, size_t *p_sz){
    len_t list_len = get_length(p_list);
    data_t *p_array = (data_t*) xmalloc(sizeof(data_t) * list_len);
    node_t *p_run;
    int i;

    for( p_run = p_list->next, i = 0; p_run != p_list; p_run = p_run->next, i++){
        *(p_array + i) = p_run->data;
    }

    *pp_data_aaray = p_array;
    *p_sz = list_len;
    return (SUCCESS);
}

list_t *array_to_list(list_t *p_list, data_t *pp_array, size_t sz){
    node_t *p_run;
    p_list = create_list();
    p_run = p_list;
    int i;

    for(i = 0; i < sz; i++){
        insert_end(p_list, *(pp_array+i));
    }
    return (p_list);
}

status_t append_list(list_t *p_list1, list_t *p_list2) {
    p_list1->prev->next = p_list2->next;
    p_list2->next->prev = p_list1->prev;
    p_list2->prev->next = p_list1;
    p_list1->prev = p_list2->prev;
    free(p_list2);
    p_list2 = NULL;
    return (SUCCESS);
}

status_t reverse_list(list_t *p_list){
    node_t *p_prev, *p_next, *p_mid;
    p_prev = p_list->prev->prev;
    p_mid = p_list->prev;
    p_next = p_list;

    while(p_mid != p_list){
        p_mid->prev = p_next;
        p_next->next = p_mid;
        p_next = p_mid;
        p_mid = p_prev;
        p_prev = p_prev->prev;
    }
    p_mid->prev = p_next;
    p_next->next = p_mid;
    return (SUCCESS);
}

status_t destroy_list(list_t **pp_list){
    node_t *p_run;
    p_run = (*pp_list)->next;
    while( p_run != *pp_list ) {
        p_run = p_run->next;
        free(p_run->prev);
    }
    free(p_run);
    *pp_list = NULL;
    return (SUCCESS);
}

int main(void) {
    status_t s;
    data_t data;
    len_t len;
    list_t *p_list = NULL;
    list_t *p_list1 = NULL, *p_list2 = NULL;
    list_t *p_list_concat = NULL;
    list_t *p_list_merged = NULL;
    list_t *p_list_reversed = NULL;

    p_list = create_list();

    assert(get_beg(p_list, &data) == LIST_EMPTY);
    assert(get_end(p_list, &data) == LIST_EMPTY);
    assert(pop_beg(p_list, &data)== LIST_EMPTY);
    assert(pop_end(p_list, &data) == LIST_EMPTY);

    assert(remove_beg(p_list) == LIST_EMPTY);
    assert(remove_end(p_list) == LIST_EMPTY);
    assert(remove_data(p_list, 0) == LIST_DATA_NOT_FOUND);
    assert(get_length(p_list) == 0);

    show_list(p_list, "After create_list():");

    for (data = 0; data < 5; data++)
    {
        s = insert_beg(p_list, data);
        assert(s == SUCCESS);
    }

    show_list(p_list, "After insert_beg():");

    for(data = 5; data < 10; data++){
        s = insert_end(p_list, data);
        assert( s == SUCCESS );
    }

    show_list(p_list, "After insert_end():");

    s = insert_after(p_list, 0, 100);
    assert( s == SUCCESS );
    show_list(p_list, "After insert_after():");

    s = insert_before(p_list, 0, 200);
    assert( s == SUCCESS );
    show_list(p_list, "After insert_before():");

    data = 0;
    s = get_beg(p_list, &data);
    assert( s == SUCCESS );
    printf("Beg data: %d\n", data);
    data = 0;
    s = get_end(p_list, &data);
    assert( s == SUCCESS );
    printf("End data: %d\n", data);
    show_list(p_list, "After get_beg() and get_end():");

    data = 0;
    s = pop_beg(p_list, &data);
    assert( s == SUCCESS );
    printf("Popped beg data: %d\n", data);
    show_list(p_list, "After pop_beg():");
    data=0;
    s = pop_end(p_list, &data);
    assert( s == SUCCESS );
    printf("Popped end data: %d\n", data);
    show_list(p_list, "After pop_end():");

    s = remove_beg(p_list);
    assert( s == SUCCESS );
    s = remove_end(p_list);
    assert( s == SUCCESS );
    show_list(p_list, "After remove_beg() and remove_end():");

    s = remove_data(p_list, 0);
    assert(s == SUCCESS);

    printf("get_length():%d\n", get_length(p_list));
    if(contains(p_list, 100) == TRUE){
        puts("100 is in list");
    }
    if(contains(p_list, -5) == FALSE){
        puts("-5 is not in list");
    }

    printf("get_repeat_count(p_list, 100): %d", get_repeat_count(p_list, 100));
    s = destroy_list(&p_list);
    assert( s == SUCCESS && p_list == NULL );

    p_list1 = create_list();
    p_list2 = create_list();

    for ( data = 5; data <= 95; data+=10)
    {
        insert_end(p_list1, data);
        insert_end(p_list2, data+5);
    }

    show_list(p_list1, "List1:");
    show_list(p_list2, "List2:");

    p_list_concat = concat_lists(p_list1, p_list2);
    show_list(p_list_concat, "Concat version of list1 and list2:");

    p_list_merged = merge_lists(p_list1, p_list2);
    show_list(p_list_merged, "Merged Version of list1 and list2:");

    p_list_reversed = get_reversed_list(p_list1);
    show_list(p_list1, "List1:");
    show_list(p_list_reversed, "Reversed List1:");

    show_list(p_list2, "List2 before reverse:");
    s = reverse_list(p_list2);
    assert( s == SUCCESS );
    show_list(p_list2, "Reverse List2:");

    s = append_list(p_list1, p_list2);
    assert( s == SUCCESS );
    show_list(p_list1, "After append of list1 and list2:");   
    
    s = destroy_list(&p_list1);
    assert( s == SUCCESS && p_list1 == NULL );

    s = destroy_list(&p_list_concat);
    assert( s == SUCCESS && p_list_concat == NULL );

    s = destroy_list(&p_list_merged);
    assert( s == SUCCESS && p_list_merged == NULL );

    s = destroy_list(&p_list_reversed);
    assert( s == SUCCESS && p_list_reversed == NULL );

    return (EXIT_SUCCESS);
}