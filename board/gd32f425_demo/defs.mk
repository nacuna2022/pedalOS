# board level defs.mk should pull in the ARM gnu_defs.mk
# so the system knows how to compile stuff.
include $(TOPDIR)/arm/$(_CONFIG_ARM_ARCH)/gnu_defs.mk

# board level compiler flags go here
# we include the board include here because this is where we store the 
# FreeRTOSConfig.h 
# normally, we should not expose all board headers like this.
CFLAGS+=-I$(TOPDIR)/board/$(_CONFIG_BOARD_NAME)/include/

LINKERSCRIPT=$(TOPDIR)/board/$(_CONFIG_BOARD_NAME)/linkerscript.ld

