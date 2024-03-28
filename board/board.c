#include <board.h>



void board_zero_bss(void)
{
        return;
}

void board_relocate_rodata(void)
{
        return;
}

//void __weak initialize_board(void)
//{
//        return;
//}

void myfunc(void);
void start_kernel(void);

void start_board(void)
{
        myfunc();
        start_kernel();
        /* diable interrupts 
         *
         * initialize FreeRTOS
         * initialize the subsystems
         * register exception handlers.. systick included
         * call board_initialize()
         * enable all interrupts? study this further
         * start the scheduler
         */
        //__disable_irq();
        //initialize_board();
        //__enable_irq();
        //vTaskStartScheduler();
        /* if we got here something went wrong */
        initialize_board();
        while(1) {
                /* log this gross error onto flash? */
                /* soft reset maybe? */
        }
        return;
}

