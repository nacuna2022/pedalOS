/*
 * utils.h
 *
 *  Created on: Aug 16, 2022
 *      Author: alvin.abitria
 */

#ifndef __LIST_H__
#define __LIST_H__

#include <stddef.h>

struct list_head {
    struct list_head *prev;
    struct list_head *next;
};

static inline void list_init (struct list_head *list)
{
	list->next = list;
	list->prev = list;
}


static inline void __list_add (struct list_head *new, struct list_head *prev, struct list_head *next)
{
	next->prev = new;
	new->next = next;
	new->prev = prev;
	prev->next = new;
}


// Add to head of the list
static inline void list_add (struct list_head *new, struct list_head *head)
{
	__list_add(new, head, head->next);
}


static inline void list_add_tail(struct list_head *new, struct list_head *head)
{
	__list_add(new, head->prev, head);
}


static inline void __list_del (struct list_head *prev, struct list_head *next)
{
	next->prev = prev;
	prev->next = next;
}


static inline void __list_del_entry (struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
}


static inline void list_del (struct list_head *entry)
{
	__list_del_entry(entry);
	entry->next = NULL;
	entry->prev = NULL;
}

static inline int list_is_head(const struct list_head *list, const struct list_head *head)
{
	return list == head;
}


static inline int list_empty(const struct list_head *head)
{
	return head->next == head;
}

static inline void __list_splice(struct list_head *list,
                                 struct list_head *prev,
                                 struct list_head *next)
{
        struct list_head *first = list->next;
        struct list_head *last = list->prev;

        first->prev = prev;
        prev->next = first;

        last->next = next;
        next->prev = last;
}

static inline void list_splice_init(struct list_head *list,
                                    struct list_head *head)
{
        if (!list_empty(list)) {
                __list_splice(list, head, head->next);
                list_init(list);
        }
}

/*
 * Loop to iterate on each entry; safe for list deleting providing the list being deleted
 * is the list being iterated; only the list pointed to by 'pos' can be removed.
 */
#define LIST_FOR_EACH_SAFE(pos, N, head) \
	for (pos = (head)->next, N = pos->next; \
	     !list_is_head(pos, (head)); \
	     pos = N, N = pos->next)

#define OFFSET_OF(type, member)		((size_t)&((type *)0)->member)

#define CONTAINER_OF(ptr, type, member)	({      \
	void *mptr = (void *)(ptr);             \
        ((type *)(mptr - OFFSET_OF(type, member)));})

#define LOCK()			__disable_irq()
#define UNLOCK()		__enable_irq()

#endif /* __UTILS_H__ */
