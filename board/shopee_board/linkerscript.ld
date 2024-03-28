MEMORY
{
        FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 512K
        SRAM  (rwx)     : ORIGIN = 0x20000000, LENGTH = 192K
}

ENTRY(__arm_reset)

SECTIONS
{
        .text : {
                *(.vector)

                . = ALIGN(256);
                *(.rominfo)
                *(.headers)

                . = ALIGN(8);
                *(.text*)

                *(.rodata*)

                KEEP(*(.eh_frame*))

                __copy_info = .;
                LONG(__etext);
                LONG(__data_start);
                LONG(__data_end - __data_start);

                __zero_info = .;
                LONG(__bss_start);
                LONG(__bss_end - __bss_start);
        } > FLASH

        __etext = ALIGN (4);

        .data : AT (__etext) {
                . = ALIGN(8);
                __data_start = .;
                *(.data)

                . = ALIGN(4);
                __data_end = .;
        } > SRAM

        .bss :  {
                . = ALIGN(8);
                __bss_start = .;
                *(.bss)

                . = ALIGN(4);
                __bss_end = .;
        } > SRAM

        .heap (NOLOAD) : {
                . = ALIGN(8);
                __initial_brk = .;
        } > SRAM

        # 4k initial stack from end of RAM
        .stack (ORIGIN(SRAM) + LENGTH(SRAM) - 0x1000) (NOLOAD) : {
                . = ALIGN(8);
               __SP_main = .;
        } > SRAM
}

