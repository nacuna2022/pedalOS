LIBDIRS+=kernel
LIBDIRS+=mcu/$(_CONFIG_MCU)
LIBDIRS+=arm/$(CONFIG_ARM_ARCH)
LIBDIRS+=board/$(_CONFIG_BOARD_NAME)

LIBS+=arm/libarm.a
LIBS+=kernel/libkernel.a
LIBS+=mcu/libmcu.a
LIBS+=board/libboard.a

kernel/libkernel.a: depend
	@$(MAKE) -C kernel library lib=$(TOPDIR)/$@

mcu/libmcu.a: depend
	@$(MAKE) -C mcu/$(_CONFIG_MCU) library lib=$(TOPDIR)/$@

arm/libarm.a: depend
	@$(MAKE) -C arm/$(_CONFIG_ARM_ARCH) library lib=$(TOPDIR)/$@

board/libboard.a: depend
	@$(MAKE) -C board/$(_CONFIG_BOARD_NAME) library lib=$(TOPDIR)/$@
