#if 0
size_t critical_section_count;

static struct list_head runqueue;
struct sched_task *current;
struct sched_task *idle_task;

static struct sched_task inittask;
static struct list_head runqueue;
static struct list_head exitqueue;

static void sched_init_task(struct sched_task *t, const char *name)
{
        memset(t, 0, sizeof(struct sched_task));
        sched_set_task_name(t, name);
        return;
}

void sched_set_task_name(struct sched_task *t, const char *name)
{
        size_t len = strlen(name);
        if (len > SCHED_MAX_NAME_LEN) {
                len = SCHED_MAX_NAME_LEN;
        }
        memcpy(t->name, name, len);
        return;
}

int sched_init(void)
{
        current = NULL;

        /* initialize the queues */
        list_init(&runqueue);
        list_init(&exitqueue);
        critical_section_count = 1;
        /* create the startup thread */
        struct sched_task *t = &inittask;
        sched_init_task(t, "inittask");
        t->state = SCHED_TASK_STATE_RUNNING;
        /* set it as the current thread */
        current = t;
        return 0;
}

static void sched_gc(void)
{
        struct list_head *pos;
        struct list_head *n;
        struct sched_task *t;
        enter_critical_section();
        LIST_FOR_EACH_SAFE(pos, n, &exitqueue) {
                t = CONTAINER_OF(pos, struct sched_task, node);
                BUG_ON(t->state != SCHED_TASK_STATE_DEAD);
                list_del(&t->node);
                free(t);
        }
        exit_critical_section();
        return;
}

static void idle_thread_loop(void)
{
        for (;;) {
                sched_gc();
                sched_yield_task();
        }
        return;
}

void sched_become_idle(void)
{
        sched_set_task_name(current, "idle");
        idle_task = current;
        idle_thread_loop();
        return;
}

/* police the state transitions of a task life cycle. so that no illegal
 * transitions occur from one state to the next. */
static void sched_set_task_next_state(struct sched_task *t,
                                      enum sched_task_state next_state)
{
        switch(t->state) {
        case SCHED_TASK_STATE_NEW:
                if (next_state == SCHED_TASK_STATE_READY) {
                        break;
                } else {
                        BUG_ON(1);
                }
        case SCHED_TASK_STATE_READY:
                if (next_state == SCHED_TASK_STATE_RUNNING) {
                        break;
                } else {
                        BUG_ON(1);
                }
        case SCHED_TASK_STATE_RUNNING:
                if ((next_state == SCHED_TASK_STATE_READY) ||
                    (next_state == SCHED_TASK_STATE_DEAD) ||
                    (next_state == SCHED_TASK_STATE_BLOCKED)) {
                        break;
                } else {
                        BUG_ON(1);
                }
        case SCHED_TASK_STATE_BLOCKED:
                if (next_state == SCHED_TASK_STATE_READY) {
                        break;
                } else {
                        BUG_ON(1);
                }
        case SCHED_TASK_STATE_DEAD:
        default:
                BUG_ON(1);
        }
        t->state = next_state;
        return;
}

/* pick next task and switch to it */
void sched_reschedule(void)
{
        struct sched_task *oldtask;
        struct sched_task *newtask;
        struct list_head *nodeptr;

        /* currently running task is now the old task */
        oldtask = current;

        /* get next task which will become our new task */
        nodeptr = runqueue.next;
        list_del(nodeptr);
        newtask = CONTAINER_OF(nodeptr, struct sched_task, node);

        /* new task should transition to running now... */
        sched_set_task_next_state(newtask, SCHED_TASK_STATE_RUNNING);

        /* are we the same thread? */
        if (newtask == oldtask) {
                /* no need to context switch to self */
                return;
        }
        current = newtask;
        arch_context_switch(&oldtask->sp, newtask->sp);
        return;
}

void sched_yield_task(void)
{
        sched_set_task_next_state(current, SCHED_TASK_STATE_READY);
        enter_critical_section();
        list_add_tail(&current->node, &runqueue);
        sched_reschedule();
        exit_critical_section();
        return;
}

struct sched_task *sched_create_task(const char *name,
                                     sched_task_entry entry,
                                     void *arg,
                                     const size_t stack_size)
{
        struct sched_task *t;
        size_t real_stack_size;

        real_stack_size = stack_size + ((1 << SCHED_STACK_SHIFT)-1);
        real_stack_size &= ~((1 << SCHED_STACK_SHIFT)-1);
        t = malloc(sizeof(struct sched_task) + real_stack_size);
        if (!t) {
                return NULL;
        }
        sched_init_task(t, name);
        t->entry = entry;
        t->arg = arg;
        t->state = SCHED_TASK_STATE_NEW;
        t->stack_size = real_stack_size;
        arch_initialize_task(t);
        return t;
}

void sched_resume_task(struct sched_task *t)
{
        sched_set_task_next_state(t, SCHED_TASK_STATE_READY);
        enter_critical_section();
        list_add_tail(&t->node, &runqueue);
        exit_critical_section();
        return;
}

void sched_exit_task(void)
{
        sched_set_task_next_state(current, SCHED_TASK_STATE_DEAD);
        list_add_tail(&current->node, &exitqueue);
        enter_critical_section();
        sched_reschedule();
        panic("rescheduled a dead task\r\n");
        return;
}
#endif

