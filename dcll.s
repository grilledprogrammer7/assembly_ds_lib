# Implementation for doubly circular linked list.

.section .rodata
    NULL:
        .int 0
    TRUE:
        .int 1
    FALSE:
        .int 0
    SUCCESS:
        .int 1
    FAILURE:
        .int 0
    LIST_DATA_NOT_FOUND:
        .int 2
    LIST_EMPTY:
        .int 3
    XMALLOC_ASSERT_FAIL:
        .asciz "xmalloc(): pointer is NULL.\n"
    MAIN_ASSERT_FAIL_LIST_EMPTY:
        .asciz "Main(): List is empty.\n"
    MAIN_ASSERT_LIST_DATA_NOT_FOUND:
        .asciz "Main(): List data not found.\n"
    MAIN_ASSERT_FUNC_RET_FAIL:
        .asciz "Main(): Function returned failure.\n"
    MAIN_ASSERT_NULL_CHECK_FAIL:
        .asciz "Main(): Pointer should be NULL.\n"
    PRINT_LIST_BEG_STRING:
        .asciz "[BEG]<->"
    PRINT_LIST_END_STRING:
        .asciz "[END]"
    SHOW_LIST_DATA_PRINT:
        .asciz "[%d]<->"
    AFTER_CREATE_LIST_MSG:
        .asciz "After create_list():"
    AFTER_INSERT_BEG_MSG:
        .asciz "After insert_beg():"
    AFTER_INSERT_END_MSG:
        .asciz "After insert_end():"
    AFTER_INSERT_AFTER_MSG:
        .asciz "After insert_after():"
    AFTER_INSERT_BEFORE_MSG:
        .asciz "After insert_before():"
    BEG_DATA_MSG:
        .asciz "Beginning data: %d\n"
    END_DATA_MSG:
        .asciz "End data: %d\n"
    AFTER_GET_BEG_END_MSG:
        .asciz "After get_beg() and get_end():"
    POP_BEG_MSG:
        .asciz "Pooped beg data: %d\n"
    POP_END_MSG:
        .asciz "Popped end data: %d\n"
    AFTER_POP_BEG_END_MSG:
        .asciz "After pop_beg() and pop_end():"
    AFTER_REMOVE_BEG_END_MSG:
        .asciz "After remove_beg() and remove_end():"
    AFTER_REMOVE_DATA_MSG:
        .asciz "After remove_data():"
    GET_LENGTH_MSG:
        .asciz "get_length(): %d\n"
    PRINT_DATA_CONTAINS1:
        .asciz "5 is in list"
    PRINT_DATA_CONTAINS2:
        .asciz "-5 is not in list"
    GET_REPEAT_COUNT_MSG:
        .asciz "get_repeat_count(p_list, 5): %d\n"
    PRINT_LIST1_STRING:
        .asciz "List1:"
    PRINT_LIST2_STRING:
        .asciz "List2:"
    PRINT_CONCAT_LIST12_STRING:
        .asciz "After List1 and List2 concat:"
    PRINT_MERGE_LIST12_STRING:
        .asciz "After List1 and List2 merge:"
    PRINT_REVERSE_LIST_STRING:
        .asciz "Reverse of list:"
    PRINT_REVERSED_LIST_STRING:
        .asciz "After list reversed:"
    PRINT_APPEND_LIST_STRING:
        .asciz "After two lists appended:"

.section .data
    output:
        .asciz "Value at node: %d\n"

# Layout of list node
# struct node {
#   int data;
#   struct node *prev;
#   struct node *next;
# };
# size = 12 bytes
#

.section .text
    .globl main
    .type  main, @function

    main:
        pushl %ebp
        movl %esp, %ebp

        # local vars
        # status_t s; // 4 bytes, offset w.r.t %ebp = 4
        # data_t data; // 4 bytes, offset w.r.t %ebp = 8
        # len_t len; // 4 bytes, offset w.r.t %ebp = 12

        # list_t *p_list; // 4 bytes, offset w.r.t %ebp = 16
        # list_t *p_list1, *p_list2; // 8 bytes, offset w.r.t %ebp = 20,24
        # list_t *p_concat_list; // 4 bytes, offset w.r.t %ebp = 28
        # list_t *p_merge_list; // 4 bytes, offset w.r.t %ebp = 32
        # list_t *p_reversed_list; // 4 bytes, offset w.r.t %ebp = 36

        # Allocate memory for local vars on stack and align stack to 16 byte.
        # Total Size = 36 bytes

        subl $36, %esp
        andl $-16, %esp

        # init all pointers to NULL value.
        movl NULL, %ebx    # NULL in %ebx used for init local ptr vars.
        movl %ebx, -16(%ebp) # p_list = NULL; 4th local var
        movl %ebx, -20(%ebp) # p_list1 = NULL;
        movl %ebx, -24(%ebp) # p_list2 = NULL;
        movl %ebx, -28(%ebp) # p_concat_list = NULL;
        movl %ebx, -32(%ebp) # p_merge_list = NULL;
        movl %ebx, -36(%ebp) # p_reversed_list = NULL;

        # call create list and assign val to p_list, ret value will be in %eax
        call create_list
        movl %eax, -16(%ebp) # p_list = create_list();

        movl (%eax), %ecx # just temp printf added, remove later.
        pushl %ecx
        pushl $output
        call printf
        addl $8, %esp

        # call get_beg
        movl -16(%ebp), %ebx # %ebx = p_list
        leal -8(%ebp), %ecx  # %ecx = &data;
        pushl %ecx
        pushl %ebx
        call get_beg
        addl $8, %esp

        movl $101, %ebx        # if exit code is 101 den failed at 1st assert in main
        cmpl LIST_EMPTY, %eax
        jne _main_empty_list_assert

        # call get_end
        movl -16(%ebp), %ebx
        leal -8(%ebp), %ecx
        pushl %ecx
        pushl %ebx
        call get_end
        addl $8, %esp

        movl $102, %ebx
        cmpl LIST_EMPTY, %eax
        jne _main_empty_list_assert

        # call pop_beg
        movl -16(%ebp), %ebx
        leal -8(%ebp), %ecx
        pushl %ecx
        pushl %ebx
        call pop_beg
        addl $8, %esp

        movl $103, %ebx
        cmpl LIST_EMPTY, %eax
        jne _main_empty_list_assert

        # call pop_end
        movl -16(%ebp), %ebx
        leal -8(%ebp), %ecx
        pushl %ecx
        pushl %ebx
        call pop_end
        addl $8, %esp

        movl $104, %ebx
        cmpl LIST_EMPTY, %eax
        jne _main_empty_list_assert

        # call remove_beg
        movl -16(%ebp), %ebx
        pushl %ebx
        call remove_beg
        addl $8, %esp

        movl $105, %ebx
        cmpl LIST_EMPTY, %eax
        jne _main_empty_list_assert

        # call remove_end
        movl -16(%ebp), %ebx
        pushl %ebx
        call remove_end
        addl $8, %esp

        movl $106, %ebx
        cmpl LIST_EMPTY, %eax
        jne _main_empty_list_assert

        # call remove_data
        movl -16(%ebp), %ebx
        pushl $0
        pushl %ebx
        call remove_data
        addl $8, %esp

        movl $107, %ebx
        cmpl LIST_DATA_NOT_FOUND, %eax
        jne _main_list_data_not_found_assert

        # call get_length
        movl -16(%ebp), %ebx
        pushl %ebx
        call get_length
        addl $4, %esp

        movl $108, %ebx
        cmpl $0, %eax
        jne _main_empty_list_assert # special case

        movl -16(%ebp), %ebx
        pushl $AFTER_CREATE_LIST_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # Insert 0-5 values in list
        movl -16(%ebp), %ebx
        movl $0, %ecx
        movl $5, %edx

      _main_loop1:
        cmpl %ecx, %edx
        je _main_loop1_end

        pushl %edx # saving %edx over iteration fucntion call may lost %edx
        pushl %ecx
        pushl %ebx
        call insert_beg
        popl %ebx
        popl %ecx
        popl %edx

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        incl %ecx
        jmp _main_loop1

      _main_loop1_end:

        movl -16(%ebp), %ebx
        pushl $AFTER_INSERT_BEG_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # Insert 5-10 values in list
        movl -16(%ebp), %ebx
        movl $5, %ecx
        movl $10, %edx

      _main_loop2:
        cmpl %ecx, %edx
        je _main_loop2_end

        pushl %edx # saving %edx over iteration fucntion call may lost %edx
        pushl %ecx
        pushl %ebx
        call insert_end
        popl %ebx
        popl %ecx
        popl %edx

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        incl %ecx
        jmp _main_loop2

      _main_loop2_end:

        movl -16(%ebp), %ebx
        pushl $AFTER_INSERT_END_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # call insert_after()
        movl -16(%ebp), %ebx
        pushl $100
        pushl $0
        pushl %ebx
        call insert_after
        addl $12, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -16(%ebp), %ebx
        pushl $AFTER_INSERT_AFTER_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # call insert_before()
        movl -16(%ebp), %ebx
        pushl $200
        pushl $0
        pushl %ebx
        call insert_before
        addl $12, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -16(%ebp), %ebx
        pushl $AFTER_INSERT_BEFORE_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        movl $0, -8(%ebp) # data = 0;
        leal -8(%ebp), %edx
        movl -16(%ebp), %ebx
        pushl %edx
        pushl %ebx
        call get_beg
        addl $8, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -8(%ebp), %edx
        pushl %edx
        pushl $BEG_DATA_MSG
        call printf
        addl $8, %esp

        movl $0, -8(%ebp) # data = 0;
        leal -8(%ebp), %edx
        movl -16(%ebp), %ebx
        pushl %edx
        pushl %ebx
        call get_end
        addl $8, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -8(%ebp), %edx
        pushl %edx
        pushl $END_DATA_MSG
        call printf
        addl $8, %esp

        movl -16(%ebp), %ebx
        pushl $AFTER_GET_BEG_END_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # call pop_beg
        movl $0, -8(%ebp) # data = 0;
        leal -8(%ebp), %edx
        movl -16(%ebp), %ebx
        pushl %edx
        pushl %ebx
        call pop_beg
        addl $8, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -8(%ebp), %edx
        pushl %edx
        pushl $POP_BEG_MSG
        call printf
        addl $8, %esp

        # call pop_end
        movl $0, -8(%ebp) # data = 0;
        leal -8(%ebp), %edx
        movl -16(%ebp), %ebx
        pushl %edx
        pushl %ebx
        call pop_end
        addl $8, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -8(%ebp), %edx
        pushl %edx
        pushl $POP_END_MSG
        call printf
        addl $8, %esp

        movl -16(%ebp), %ebx
        pushl $AFTER_POP_BEG_END_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # call remove_beg
        movl -16(%ebp), %ebx
        pushl %ebx
        call remove_beg
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        # call remove_end
        movl -16(%ebp), %ebx
        pushl %ebx
        call remove_end
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -16(%ebp), %ebx
        pushl $AFTER_REMOVE_BEG_END_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # call remove_data
        movl -16(%ebp), %ebx
        pushl $0
        pushl %ebx
        call remove_data
        addl $8, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -16(%ebp), %ebx
        pushl $AFTER_REMOVE_DATA_MSG
        pushl %ebx
        call show_list
        addl $8, %esp

        # call get_length
        movl -16(%ebp), %ebx
        pushl %ebx
        call get_length
        addl $4, %esp

        pushl %eax
        pushl $GET_LENGTH_MSG
        call printf
        addl $8, %esp

        # call contains
        movl -16(%ebp), %ebx
        pushl $5
        pushl %ebx
        call contains
        addl $8, %esp

        cmpl TRUE, %eax
        jne _main_print_data_contains_skip1

        pushl $PRINT_DATA_CONTAINS1
        call puts

      _main_print_data_contains_skip1:

        # call contains
        movl -16(%ebp), %ebx
        pushl $-5
        pushl %ebx
        call contains
        addl $8, %esp

        cmpl FALSE, %eax
        jne _main_print_data_contains_skip2

        pushl $PRINT_DATA_CONTAINS2
        call puts

      _main_print_data_contains_skip2:

        # call get_repeat_count
        movl -16(%ebp), %ebx
        pushl $5
        pushl %ebx
        call get_repeat_count
        addl $8, %esp

        pushl %eax
        pushl $GET_REPEAT_COUNT_MSG
        call printf
        addl $8, %esp

        # call destroy_list
        leal -16(%ebp), %ebx
        pushl %ebx
        call destroy_list
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert
        cmpl $0, -16(%ebp) # p_list == NULL
        jne _main_null_check_assert

        call create_list
        movl %eax, -20(%ebp)  # p_list1 = create_list();
        call create_list
        movl %eax, -24(%ebp)  # p_list2 = create_list();

        movl $5, -8(%ebp)
        movl -8(%ebp), %ebx # data = 5; %ebx = 5;

      _main_loop3:
        cmpl $105, %ebx
        je _main_loop3_end

        movl -20(%ebp), %eax
        pushl %ebx
        pushl %eax
        call insert_end
        popl %eax
        popl %ebx

        movl -24(%ebp), %eax
        movl %ebx, %ecx
        addl $5, %ecx
        pushl %ebx  # save %ebx
        pushl %ecx
        pushl %eax
        call insert_end
        addl $8, %esp
        popl %ebx

        addl $10, %ebx
        jmp _main_loop3

      _main_loop3_end:
        movl -20(%ebp), %eax
        pushl $PRINT_LIST1_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        movl -24(%ebp), %eax
        pushl $PRINT_LIST2_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        movl -20(%ebp), %eax
        movl -24(%ebp), %ebx
        pushl %ebx
        pushl %eax
        call concat_lists
        addl $8, %esp

        movl %eax, -28(%ebp)
        pushl $PRINT_CONCAT_LIST12_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        # call merge_lists
        movl -20(%ebp), %eax
        movl -24(%ebp), %ebx
        pushl %ebx
        pushl %eax
        call merge_lists
        addl $8, %esp

        movl %eax, -32(%ebp)
        pushl $PRINT_MERGE_LIST12_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        movl -20(%ebp), %eax
        pushl $PRINT_LIST1_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        movl -20(%ebp), %eax
        pushl %eax
        call get_reversed_list
        addl $4, %esp
        movl %eax, -36(%ebp)

        movl -36(%ebp), %eax
        pushl $PRINT_REVERSE_LIST_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        # call reverse_list
        movl -24(%ebp), %eax
        pushl $PRINT_LIST2_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        movl -24(%ebp), %eax
        pushl %eax
        call reverse_list
        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert

        movl -24(%ebp), %eax
        pushl $PRINT_REVERSED_LIST_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        movl -20(%ebp), %eax
        movl -24(%ebp), %ebx
        pushl %ebx
        pushl %eax
        call append_list
        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert
        popl %eax
        popl %ebx
        
        pushl $PRINT_APPEND_LIST_STRING
        pushl %eax
        call show_list
        addl $8, %esp

        # Destroy lists
        leal -20(%ebp), %ebx
        pushl %ebx
        call destroy_list
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert
        cmpl $0, -20(%ebp) # p_list == NULL
        jne _main_null_check_assert

        leal -28(%ebp), %ebx
        pushl %ebx
        call destroy_list
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert
        cmpl $0, -28(%ebp) # p_list == NULL
        jne _main_null_check_assert

        leal -32(%ebp), %ebx
        pushl %ebx
        call destroy_list
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert
        cmpl $0, -32(%ebp) # p_list == NULL
        jne _main_null_check_assert

        leal -36(%ebp), %ebx
        pushl %ebx
        call destroy_list
        addl $4, %esp

        cmpl SUCCESS, %eax
        jne _main_func_ret_fail_assert
        cmpl $0, -36(%ebp) # p_list == NULL
        jne _main_null_check_assert


        movl $0,%ebx
        jmp _main_ret

      _main_empty_list_assert:
        pushl %ebx
        pushl $MAIN_ASSERT_FAIL_LIST_EMPTY
        call printf
        addl $4, %esp
        popl %ebx
        jmp _main_ret

      _main_list_data_not_found_assert:
        pushl %ebx
        pushl $MAIN_ASSERT_LIST_DATA_NOT_FOUND
        call printf
        addl $4, %esp
        popl %ebx
        jmp _main_ret

      _main_func_ret_fail_assert:
        pushl $MAIN_ASSERT_FUNC_RET_FAIL
        call printf
        addl $4, %esp
        movl $109, %ebx
        jmp _main_ret

      _main_null_check_assert:
        pushl $MAIN_ASSERT_NULL_CHECK_FAIL
        call printf
        addl $4, %esp
        movl $110, %ebx
        jmp _main_ret
        
      _main_ret:
        movl %ebp, %esp
        popl %ebp
        movl $1, %eax
        int $0x80


    # List Creation routine
    .type create_list, @function
    create_list:
        pushl %ebp
        movl %esp, %ebp

        # local pointer var
        subl $4, %esp # node_t *p_new_node;

        pushl $0
        call get_list_node # p_new_node = get_list_node(0);
        addl $4, %esp
        movl %eax, -4(%ebp)

        movl %eax, 4(%eax) # p_new_node->prev = p_new_node;
        movl %eax, 8(%eax) # p_new_node->next = p_new_node;

        movl %ebp,%esp
        popl %ebp
        ret

    # Generic insert puts new node between two node (p_beg, p_mid, p_end)
    .type generic_insert, @function
    generic_insert:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        movl 12(%ebp), %ebx
        movl 16(%ebp), %ecx
        movl %ebx, 8(%eax)
        movl %eax, 4(%ebx)
        movl %ecx, 8(%ebx)
        movl %ebx, 4(%ecx)

        movl %ebp, %esp
        popl %ebp
        ret

    # generic delete remove node given as argument(p_del_node)
    .type generic_delete, @function
    generic_delete:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        movl 4(%eax), %ebx
        movl 8(%eax), %ecx
        movl %ecx, 8(%ebx)
        movl %ebx, 4(%ecx)

        pushl %eax
        call free
        addl $4, %esp

        movl %ebp, %esp
        popl %ebp
        ret

    # locate node who's data is given value, return ptr to node(%eax)
    .type locate_node, @function
    locate_node:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %edi
        movl 12(%ebp), %edx
        movl 8(%edi), %ecx

      _locate_node_loop:
        cmpl %ecx, %edi
        je _locate_node_not_found

        movl %ecx, %eax
        cmpl (%ecx), %edx
        je _ret_locate_node
        movl 8(%ecx), %ecx
        jmp _locate_node_loop

      _locate_node_not_found:
        movl NULL, %eax

      _ret_locate_node:
        movl %ebp, %esp
        popl %ebp
        ret

    .type destroy_list, @function
    destroy_list:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %edi # double pointer
        movl (%edi), %edi
        movl 8(%edi), %ecx

      _destroy_list_loop:
        cmpl %ecx, %edi
        je _destory_list_loop_end

        movl %ecx, %ebx
        movl 8(%ecx), %ecx
        pushl %edi
        pushl %ecx
        pushl %ebx
        call free
        addl $4, %esp
        popl %ecx
        popl %edi
        jmp _destroy_list_loop

      _destory_list_loop_end:
        pushl %edi
        call free
        addl $4, %esp
        movl 8(%ebp), %edi
        movl $0, (%edi)  # *pp_list = NULL;
        movl SUCCESS, %eax

        movl %ebp, %esp
        popl %ebp
        ret

    .type get_list_node, @function
    get_list_node:
        pushl %ebp
        movl %esp, %ebp

        subl $4, %esp # node_t *p_new_node;
        movl NULL, %ebx
        movl %ebx, -4(%ebp) # p_new_node = NULL;

        pushl $12
        call xmalloc # p_new_node = xmalloc(sizeof(node_t))
        addl $4, %esp
        movl %eax, -4(%ebp)

        movl 8(%ebp), %ecx # value of data part in %ecx
        movl %ecx, (%eax)  # p_new_node->data = data(%ecx)
        movl $0, 4(%eax) # p_new_node->prev = NULL;
        movl $0, 8(%eax) # p_new_node->next = NULL;

        movl %ebp, %esp
        popl %ebp
        ret

    # xmalloc will accept one arg for size in bytes. Return in %eax add of mem.
    .type xmalloc, @function
    xmalloc:
        pushl %ebp
        movl %esp, %ebp

        # allocate mem of local temp pointer
        subl $4, %esp # void *p;
        movl NULL, %ebx
        movl %ebx, -4(%ebp) # p = NULL;

        movl 8(%ebp), %eax # number of bytes to %eax
        pushl %eax         # argument to malloc number of bytes
        call malloc        # call malloc
        addl $4, %esp
        movl %eax, -4(%ebp) # ptr(%eax) to allocated memory move it to local *p

        cmpl NULL, %eax
        je _xmalloc_assert # assert(p != NULL)

        movl %ebp, %esp
        popl %ebp
        ret

      _xmalloc_assert:
        pushl $XMALLOC_ASSERT_FAIL
        call printf
        addl $4, %esp
        movl $20, %ebx
        movl $1, %eax
        int $0x80

    # Insert new node at the begining of list
    .type insert_beg, @function
    insert_beg:
        pushl %ebp
        movl %esp, %ebp

        movl 12(%ebp), %edx

        pushl %edx
        call get_list_node
        addl $4, %esp

        # new node will be in %eax after call to get_list_node
        movl 8(%ebp), %ecx   # %ecx = p_list;
        movl 8(%ecx), %ebx
        pushl %ebx
        pushl %eax
        pushl %ecx
        call generic_insert
        popl %ecx
        addl $4, %esp
        incl (%ecx)

        movl SUCCESS, %eax
        movl %ebp, %esp
        popl %ebp
        ret

    # Insert new node at the end of list
    .type insert_end, @function
    insert_end:
        pushl %ebp
        movl %esp, %ebp

        movl 12(%ebp), %edx

        pushl %edx
        call get_list_node
        addl $4, %esp

        # new node will be in %eax after call to get_list_node
        movl 8(%ebp), %ecx   # %ecx = p_list;
        movl 4(%ecx), %ebx   # %ebx = p_list->prev;
        pushl %ecx
        pushl %eax
        pushl %ebx
        call generic_insert
        addl $8, %esp
        popl %ecx
        incl (%ecx)

        movl SUCCESS, %eax
        movl %ebp, %esp
        popl %ebp
        ret

    # Insert new node after the node who has val given in argument
    .type insert_after, @function
    insert_after:
        pushl %ebp
        movl %esp, %ebp

        subl $4, %esp
        movl 8(%ebp), %eax
        movl 12(%ebp), %edx
        pushl %edx
        pushl %eax
        call locate_node
        addl $8, %esp
        movl %eax, %edi
        movl %eax, -4(%ebp)

        cmpl NULL, %edi
        je _insert_after_data_not_found

        # get new node
        movl 16(%ebp), %ecx
        pushl %ecx
        call get_list_node
        addl $4, %esp
        movl %eax, %ebx

        movl -4(%ebp), %eax
        movl 8(%eax), %ecx
        pushl %ecx
        pushl %ebx
        pushl %eax
        call generic_insert
        addl $12, %esp

        incl 8(%ebp)
        movl SUCCESS, %eax
        jmp _ret_insert_after
        
      _insert_after_data_not_found:
        movl LIST_DATA_NOT_FOUND, %eax

      _ret_insert_after:
        movl %ebp, %esp
        popl %ebp
        ret

    # Insert new node before the node who has val given in argument
    .type insert_before, @function
    insert_before:
        pushl %ebp
        movl %esp, %ebp

        subl $4, %esp
        movl 8(%ebp), %eax
        movl 12(%ebp), %edx
        pushl %edx
        pushl %eax
        call locate_node
        addl $8, %esp
        movl %eax, %edi
        movl %eax, -4(%ebp)

        cmpl NULL, %edi
        je _insert_before_data_not_found

        # get new node
        movl 16(%ebp), %ecx
        pushl %ecx
        call get_list_node
        addl $4, %esp
        movl %eax, %ebx

        movl -4(%ebp), %eax
        movl 4(%eax), %ecx
        pushl %eax
        pushl %ebx
        pushl %ecx
        call generic_insert
        addl $12, %esp

        incl 8(%ebp)
        movl SUCCESS, %eax
        jmp _ret_insert_before
        
      _insert_before_data_not_found:
        movl LIST_DATA_NOT_FOUND, %eax

      _ret_insert_before:
        movl %ebp, %esp
        popl %ebp
        ret

    # get_beg first value of list
    .type get_beg, @function
    get_beg:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax   # %eax = p_list
        pushl %eax
        call is_list_empty
        addl $4, %esp
        cmpl TRUE, %eax
        je _get_beg_empty_list

        movl 8(%ebp), %eax
        movl 12(%ebp), %ebx
        movl 8(%eax), %edx
        movl (%edx), %ecx
        movl %ecx, (%ebx)
        movl SUCCESS, %eax
        jmp _ret_get_beg

      _get_beg_empty_list:
        movl LIST_EMPTY, %eax

      _ret_get_beg:
        movl %ebp, %esp
        popl %ebp
        ret

    # get_end last value in list
    .type get_end, @function
    get_end:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        pushl %eax
        call is_list_empty
        addl $4, %esp
        cmpl TRUE, %eax
        je _get_end_empty_list

        movl 8(%ebp), %eax
        movl 12(%ebp), %ebx
        movl 4(%eax), %edx
        movl (%edx), %ecx
        movl %ecx, (%ebx)
        movl SUCCESS, %eax
        jmp _ret_get_end

      _get_end_empty_list:
        movl LIST_EMPTY, %eax

      _ret_get_end:
        movl %ebp, %esp
        popl %ebp
        ret

    # pop_beg delete first node and returns value of data field
    .type pop_beg, @function
    pop_beg:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        pushl %eax
        call is_list_empty
        addl $4, %esp

        cmpl TRUE, %eax
        je _pop_beg_empty_list

        movl 8(%ebp), %eax
        movl 12(%ebp), %ebx
        movl 8(%eax), %eax
        movl (%eax),%edx
        movl %edx, (%ebx)

        pushl %eax
        call generic_delete
        addl $4, %esp
        movl SUCCESS, %eax
        jmp _ret_pop_beg

      _pop_beg_empty_list:
        movl LIST_EMPTY, %eax

      _ret_pop_beg:
        movl %ebp, %esp
        popl %ebp
        ret

    # pop_end delete last node and returns value of data field
    .type pop_end, @function
    pop_end:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        pushl %eax
        call is_list_empty
        addl $4, %esp

        cmpl TRUE, %eax
        je _pop_end_empty_list

        movl 8(%ebp), %eax
        movl 12(%ebp), %ebx
        movl 4(%eax), %eax
        movl (%eax),%edx
        movl %edx, (%ebx)

        pushl %eax
        call generic_delete
        addl $4, %esp
        movl SUCCESS, %eax
        jmp _ret_pop_end

      _pop_end_empty_list:
        movl LIST_EMPTY, %eax

      _ret_pop_end:
        movl %ebp, %esp
        popl %ebp
        ret

    # remove_beg delete first node
    .type remove_beg, @function
    remove_beg:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        pushl %eax
        call is_list_empty
        addl $4, %esp

        cmpl TRUE, %eax
        je _remove_beg_empty_list

        movl 8(%ebp), %eax
        movl 8(%eax), %eax

        pushl %eax
        call generic_delete
        addl $4, %esp
        movl SUCCESS, %eax
        jmp _ret_remove_beg

      _remove_beg_empty_list:
        movl LIST_EMPTY, %eax

      _ret_remove_beg:
        movl %ebp, %esp
        popl %ebp
        ret

    # remove_end delete last node
    .type remove_end, @function
    remove_end:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        pushl %eax
        call is_list_empty
        addl $4, %esp

        cmpl TRUE, %eax
        je _remove_end_empty_list

        movl 8(%ebp), %eax
        movl 4(%eax), %eax

        pushl %eax
        call generic_delete
        addl $4, %esp
        movl SUCCESS, %eax
        jmp _ret_remove_end

      _remove_end_empty_list:
        movl LIST_EMPTY, %eax

      _ret_remove_end:
        movl %ebp, %esp
        popl %ebp
        ret

    # Remove data removes that node with data given
    .type remove_data, @function
    remove_data:
        pushl %ebp
        movl %esp, %ebp

        subl $4, %esp # node_t *pe_node;
        movl 12(%ebp), %edx # %edx = r_data
        movl 8(%ebp), %ecx

        pushl %edx
        pushl %ecx
        call locate_node
        addl $8, %esp

        movl %eax, -4(%ebp)
        cmpl NULL, %eax
        je _remove_data_list_data_not_found

        pushl %eax
        call generic_delete
        addl $4, %esp

        movl SUCCESS, %eax
        jmp _ret_remove_data

      _remove_data_list_data_not_found:
        movl LIST_DATA_NOT_FOUND, %eax

      _ret_remove_data:
        movl %ebp, %esp
        popl %ebp
        ret

    # get_length traverse list count nodes and return len in %eax
    .type get_length, @function
    get_length:
        pushl %ebp
        movl %esp, %ebp

        movl $0, %ecx
        movl 8(%ebp), %edi
        movl 8(%edi), %ebx

      _get_length_loop:
        cmpl %ebx, %edi
        je _get_length_loop_end

        movl 8(%ebx), %ebx # p_run = p_run->next;
        incl %ecx
        jmp _get_length_loop

      _get_length_loop_end:
        movl %ecx, %eax

        movl %ebp, %esp
        popl %ebp
        ret

    # contains to check the data is present or not in list
    .type contains, @function
    contains:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %ebx
        movl 12(%ebp), %ecx
        pushl %ecx
        pushl %ebx
        call locate_node
        addl $8, %esp

        cmpl NULL, %eax
        je _ret_contains_false

        movl TRUE, %eax
        jmp _ret_contains

      _ret_contains_false:
        movl FALSE, %eax

      _ret_contains:
        movl %ebp, %esp
        popl %ebp
        ret

    # get_repeat_count returns the frequency of data in list
    .type get_repeat_count, @function
    get_repeat_count:
        pushl %ebp
        movl %esp, %ebp

        movl $0, %ecx
        movl 8(%ebp), %edi
        movl 8(%edi), %ebx
        movl 12(%ebp), %edx

      _repeat_count_loop:
        cmpl %ebx, %edi
        je _repeat_count_loop_end

        cmpl %edx, (%ebx)
        jne _increment_count_skip

        incl %ecx

      _increment_count_skip:
        movl 8(%ebx), %ebx # p_run = p_run->next;
        jmp _repeat_count_loop

      _repeat_count_loop_end:
        movl %ecx, %eax

        movl %ebp, %esp
        popl %ebp
        ret

    # show_list to display the list content with message
    .type show_list, @function
    show_list:
        pushl %ebp
        movl %esp, %ebp

        movl 12(%ebp), %edi
        cmpl NULL, %edi
        je _show_list_msg_print_skip

        pushl %edi
        call puts
        addl $4, %esp

      _show_list_msg_print_skip:
        pushl $PRINT_LIST_BEG_STRING
        call printf
        addl $4, %esp

        movl 8(%ebp), %ebx
        movl 8(%ebx), %edx

      _show_list_loop:
        cmpl %edx, %ebx
        je _show_list_loop_end

        pushl %ebx
        pushl %edx
        movl (%edx), %ecx
        pushl %ecx
        pushl $SHOW_LIST_DATA_PRINT
        call printf
        addl $8, %esp
        popl %edx
        popl %ebx

        movl 8(%edx), %edx
        jmp _show_list_loop

      _show_list_loop_end:
        pushl $PRINT_LIST_END_STRING
        call puts
        addl $4, %esp

        movl %ebp, %esp
        popl %ebp
        ret

    # is_list_empty check the if list empty
    .type is_list_empty, @function
    is_list_empty:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax

        cmpl 4(%eax), %eax
        jne _list_not_empty
        cmpl 8(%eax), %eax
        jne _list_not_empty

        movl TRUE, %eax
        jmp _list_is_empty

      _list_not_empty:
        movl FALSE, %eax

      _list_is_empty:
        movl %ebp, %esp
        popl %ebp
        ret

    # concat_lists 
    .type concat_lists, @function
    concat_lists:
        pushl %ebp
        movl %esp, %ebp

        subl $8, %esp
        call create_list
        movl %eax, -4(%ebp) # p_new_list = create_list();

        movl 8(%ebp), %ebx  # %ebx = p_list1;
        movl 8(%ebx), %edx  # %edx = p_list1->next;

      _concat_lists_loop1:
        cmpl %edx, %ebx
        je _concat_lists_loop1_end

        movl (%edx), %ecx # p_run->data
        pushl %edx  # %edx & %ebx save regs over iteration and func call
        pushl %ebx
        pushl %ecx
        pushl %eax
        call insert_end
        popl %eax
        popl %ecx
        popl %ebx
        popl %edx

        movl 8(%edx), %edx
        jmp _concat_lists_loop1

      _concat_lists_loop1_end:
        movl 12(%ebp), %ebx  # %ebx = p_list2;
        movl 8(%ebx), %edx  # %edx = p_list2->next;

      _concat_lists_loop2:
        cmpl %edx, %ebx
        je _concat_lists_loop2_end

        movl (%edx), %ecx # p_run->data
        pushl %edx  # %edx & %ebx save regs over iteration and func call
        pushl %ebx
        pushl %ecx
        pushl %eax
        call insert_end
        popl %eax
        popl %ecx
        popl %ebx
        popl %edx

        movl 8(%edx), %edx
        jmp _concat_lists_loop2

      _concat_lists_loop2_end:
        # %eax already has the required returned pointer

        movl %ebp, %esp
        popl %ebp
        ret

    # merge_lists
    .type merge_lists, @function
    merge_lists:
        pushl %ebp
        movl %esp, %ebp

        call create_list
        subl $4, %esp
        movl %eax, -4(%ebp) # p_merge_list = create_list();

        movl 8(%ebp), %ecx  # %ecx = p_list1
        movl 12(%ebp), %edx # %edx = p_list2

        movl 8(%ecx), %ecx  # %ecx = p_list1->next
        movl 8(%edx), %edx  # %ecx = p_list2->next

      _merge_lists_loop:
        cmpl 8(%ebp), %ecx  # p_run1 == p_list1;
        jne _merge_lists_if2

        _merge_lists_inner_loop1:
          cmpl 12(%ebp), %edx
          je _merge_lists_inner_loop1_end

          pushl %ecx
          pushl %edx
          movl (%edx), %edi
          pushl %edi
          pushl %eax
          call insert_end
          popl %eax
          popl %edi
          popl %edx
          popl %ecx

          movl 8(%edx), %edx
          jmp _merge_lists_inner_loop1

        _merge_lists_inner_loop1_end:
          jmp _merge_lists_loop_end

        _merge_lists_if2:
          cmpl 12(%ebp), %edx  # p_run2 == p_list2;
          jne _merge_lists_if3
          _merge_lists_inner_loop2:
            cmpl 8(%ebp), %ecx
            je _merge_lists_inner_loop2_end

            pushl %ecx
            pushl %edx
            movl (%ecx), %edi
            pushl %edi
            pushl %eax
            call insert_end
            popl %eax
            popl %edi
            popl %edx
            popl %ecx

            movl 8(%ecx), %ecx
            jmp _merge_lists_inner_loop2

          _merge_lists_inner_loop2_end:
            jmp _merge_lists_loop_end

        _merge_lists_if3:
          movl (%edx), %edi
          cmpl (%ecx), %edi
          jle _merge_lists_else3

          pushl %ecx
          pushl %edx
          movl (%ecx), %edi
          pushl %edi
          pushl %eax
          call insert_end
          popl %eax
          popl %edi
          popl %edx
          popl %ecx

          movl 8(%ecx), %ecx
          jmp _merge_lists_else3_end

        _merge_lists_else3:
            pushl %ecx
            pushl %edx
            movl (%edx), %edi
            pushl %edi
            pushl %eax
            call insert_end
            popl %eax
            popl %edi
            popl %edx
            popl %ecx

            movl 8(%edx), %edx

        _merge_lists_else3_end:
            jmp _merge_lists_loop

      _merge_lists_loop_end:
        movl %ebp, %esp
        popl %ebp
        ret

    # get_reversed_list returns new list which is reverse of old list.
    .type get_reversed_list, @function
    get_reversed_list:
        pushl %ebp
        movl %esp, %ebp

        call create_list

        movl 8(%ebp), %edx
        movl 4(%edx), %edx

      _get_reversed_list_loop:
        cmpl 8(%ebp), %edx
        je _get_reversed_list_loop_end

        movl (%edx), %edi
        pushl %edx
        pushl %edi
        pushl %eax
        call insert_end
        popl %eax
        popl %edi
        popl %edx

        movl 4(%edx), %edx
        jmp _get_reversed_list_loop

      _get_reversed_list_loop_end:
        movl %ebp, %esp
        popl %ebp
        ret

    # list_to_array convert list into array
    .type list_to_array, @function
    list_to_array:
        pushl %ebp
        movl %esp, %ebp

        # data_t *p_array; len_t list_len; node_t *p_run; int i;
        subl $16, %esp

        movl 8(%ebp), %eax
        pushl %eax
        call get_length
        popl %eax
        movl %eax, -8(%ebp)

        movl $4, %ecx
        mull %ecx  # array size in bytes = data_size * len;
        pushl %eax
        call xmalloc
        addl $4, %esp
        movl %eax, -4(%ebp)

        movl 8(%ebp), %edx
        movl 8(%edx), %edx
        movl $0, -16(%ebp)  # i=0;
        movl -16(%ebp), %ecx

      _list_to_array_loop:
        cmpl 8(%ebp), %edx
        je _list_to_array_loop_end

        leal (%eax, %ecx, 4), %edi
        movl (%edx), %ebx
        movl %ebx, (%edi)

        incl %ecx
        movl 8(%edx), %edx
        jmp _list_to_array_loop

      _list_to_array_loop_end:
        movl 12(%ebp), %edx
        movl %eax, (%edx)
        movl 16(%ebp), %edx
        movl %ecx, (%edx)
        movl SUCCESS, %eax

        movl %ebp, %esp
        popl %ebp
        ret

    # array_to_list convert array to linked list
    .type array_to_list, @function
    array_to_list:
        pushl %ebp
        movl %esp, %ebp

        call create_list  # %eax has new list pointer

        movl $0, %ecx
        movl 8(%ebp), %edx

      _array_to_list_loop:
        cmpl 12(%ebp), %ecx
        je _array_to_list_loop_end

        leal (%edx, %ecx, 4), %edi
        movl (%edi), %edi
        pushl %ecx  # reg save
        pushl %edx
        pushl %edi
        pushl %eax
        call insert_end
        popl %eax
        popl %edi
        popl %edx
        popl %ecx

        jmp _array_to_list_loop

      _array_to_list_loop_end:
        movl %ebp, %esp
        popl %ebp
        ret

    # append_list
    .type append_list, @function
    append_list:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %ebx  # %ebx = p_list1;
        movl 12(%ebp), %ecx # %ecx  = p_list2;

        movl 4(%ebx), %ebx  # %ebx = p_list1->prev;
        movl 8(%ecx), %ecx  # %ecx = p_list2->next;
        movl %ecx, 8(%ebx)  # p_list1->prev = p_list2->next;

        movl 8(%ebp), %ebx  # restore %ebx to p_list1
        movl 12(%ebp), %ecx # restore %ecx to p_list2
        
        movl 8(%ecx), %ecx  # %ecx = p_list2->next;
        movl 4(%ebx), %ebx  # %ebx = p_list1->prev;
        movl %ebx, 4(%ecx)  # p_list2->next->prev = p_list1->prev;

        movl 8(%ebp), %ebx  # restore %ebx to p_list1
        movl 12(%ebp), %ecx # restore %ecx to p_list2

        movl 4(%ecx), %ecx  # %ecx = p_list2->prev;
        movl %ecx, 4(%ebx)  # p_list1->prev = p_list2->prev;
        movl %ebx, 8(%ecx)  # p_list2->prev->next = p_list1;

        movl 12(%ebp), %ecx # restore %ecx to p_list2
        pushl %ecx
        call free
        addl $4, %esp

        movl SUCCESS, %eax
        movl %ebp, %esp
        popl %ebp
        ret

    # reverse_list node will get reversed
    .type reverse_list, @function
    reverse_list:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %edi
        movl 4(%edi), %edi  # %edi = p_list->prev;

        movl 4(%edi), %edx  # %edx = p_list->prev->prev;
        movl 8(%ebp), %ecx

      _reverse_list_loop:
        cmpl 8(%ebp), %edx
        je _reverse_list_loop_end
        movl %edx, %eax
        movl 4(%edx), %edx

        pushl %edi  # save before func call
        pushl %edx
        pushl %ecx
        movl 4(%ecx), %ecx
        pushl %eax  # p_run
        pushl %ecx
        call generic_insert
        popl %ecx
        popl %eax
        popl %ecx
        popl %edx
        popl %edi

        jmp _reverse_list_loop

      _reverse_list_loop_end:
        movl %ecx, 4(%edi)
        movl %edi, 8(%ecx)
        movl SUCCESS, %eax

        movl %ebp, %esp
        popl %ebp
        ret

