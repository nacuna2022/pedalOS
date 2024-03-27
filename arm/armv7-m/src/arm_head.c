#include <config.h>
#include <compiler.h>
#include <types.h>

//extern void __sp_main[];
extern unsigned long __arm_reset[];

const void * __vectors[] __section(".vector") __used = {
        0,      /* SP_main */
        __arm_reset,      /* reset */
        0,      /* nmi */
        0,      /* hard fault */
        0,      /* mem manage */
        0,      /* bus fault */
        0,      /* usage fault */
        0,      /* reserved */
        0,      /* reserved */
        0,      /* reserved */
        0,      /* reserved */
        0,      /* svcall */
        0,      /* debug monitor */
        0,      /* reserved */
        0,      /* pendsv */
        (void*)0xdead,      /* systick */

        [16 ... (CONFIG_MCU_INTERRUPT_COUNT-1)] = 0,
};

