#include <compiler.h>
#define __ASSEMBLY__

        .thumb
        .syntax unified
        .globl __arm_reset
        .extern start_board

        .align
        .section .text, "ax"
__arm_reset:
        b       start_kernel

        b       .
