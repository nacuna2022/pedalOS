#include <board.h>

void start_kernel(void)
{
        /* initialize the facilities that 
         * user level code will use
         *
         * scheduler subsystem
         * interrupt subsystem
         * timer subsystem
         * driver subsystem
         */

        /* here, user will initialize the board peripherals used by the product.
         * they will probably :
         *
         * 1) start tasks
         * 2) register their lowlevel drivers to the driver subsystem
         * 3) start some background tasks thru timers
         * 4) allocate memory for their data strutures.
         */
        initialize_board();
        
        /* start the scheduler here ... */

        return;
}


