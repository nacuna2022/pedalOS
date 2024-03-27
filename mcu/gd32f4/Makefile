# pull in the config file so we can inspect some other CONFIG_ we are
# interested in.
include $(TOPDIR)/.config
include $(TOPDIR)/scripts/util.mk

# pull in the board make definitions. this will also pull in the toolchain 
# and correct flags for the target system we are building for.
include $(TOPDIR)/board/$(_CONFIG_BOARD_NAME)/defs.mk

# pull in the mcu sources
# MCU make.defs must supply the MCU_SRCS in this file 
#include $(TOPDIR)/mcu/$(_CONFIG_MCU)/Make.def
SRCS-$(CONFIG_GD32F4_ADC) += src/gd32f4xx_adc.c
SRCS-$(CONFIG_GD32F4_CAN) += src/gd32f4xx_can.c
SRCS-$(CONFIG_GD32F4_CRC) += src/gd32f4xx_crc.c
SRCS-$(CONFIG_GD32F4_CTC) += src/gd32f4xx_ctc.c
SRCS-$(CONFIG_GD32F4_DAC) += src/gd32f4xx_dac.c
SRCS-$(CONFIG_GD32F4_DBG) += src/gd32f4xx_dbg.c
SRCS-$(CONFIG_GD32F4_DCI) += src/gd32f4xx_dci.c
SRCS-$(CONFIG_GD32F4_DMA) += src/gd32f4xx_dma.c
SRCS-$(CONFIG_GD32F4_ENET) += src/gd32f4xx_enet.c
SRCS-$(CONFIG_GD32F4_EXMC) += src/gd32f4xx_exmc.c
SRCS-$(CONFIG_GD32F4_EXTI) += src/gd32f4xx_exti.c
SRCS-$(CONFIG_GD32F4_FMC) += src/gd32f4xx_fmc.c
SRCS-$(CONFIG_GD32F4_FWDGT) += src/gd32f4xx_fwdgt.c
SRCS-$(CONFIG_GD32F4_GPIO) += src/gd32f4xx_gpio.c
SRCS-$(CONFIG_GD32F4_I2C) += src/gd32f4xx_i2c.c
SRCS-$(CONFIG_GD32F4_IPA) += src/gd32f4xx_ipa.c
SRCS-$(CONFIG_GD32F4_IREF) += src/gd32f4xx_iref.c
SRCS-$(CONFIG_GD32F4_MISC) += src/gd32f4xx_misc.c
SRCS-$(CONFIG_GD32F4_PMU) += src/gd32f4xx_pmu.c
SRCS-$(CONFIG_GD32F4_RCU) += src/gd32f4xx_rcu.c
SRCS-$(CONFIG_GD32F4_RTC) += src/gd32f4xx_rtc.c
SRCS-$(CONFIG_GD32F4_SDIO) += src/gd32f4xx_sdio.c
SRCS-$(CONFIG_GD32F4_SYSCFG) += src/gd32f4xx_syscfg.c
SRCS-$(CONFIG_GD32F4_TIMER) += src/gd32f4xx_timer.c
SRCS-$(CONFIG_GD32F4_TLI) += src/gd32f4xx_tli.c
SRCS-$(CONFIG_GD32F4_TRNG) += src/gd32f4xx_trng.c
SRCS-$(CONFIG_GD32F4_USART) += src/gd32f4xx_usart.c
SRCS-$(CONFIG_GD32F4_WWDGT) += src/gd32f4xx_wwdgt.c

CFLAGS+=$(CFLAGS-y)

CLEANABLES=$(wildcard src/*.o)
CLEANABLES+=$(wildcard src/*.ddc)

LIBMCU_OBJS=$(SRCS-y:.c=.o)

CFLAGS+=-I$(TOPDIR)/mcu/$(_CONFIG_MCU)/include
CFLAGS+=-I$(TOPDIR)/mcu/$(_CONFIG_MCU)/include/device
CFLAGS+=-I$(TOPDIR)/include/CMSIS
CFLAGS+=$(MCU_CFLAGS)

ifeq ($(CONFIG_GD32F450),y)
CFLAGS+=-DGD32F450
else ifeq ($(CONFIG_GD32F405),y)
CFLAGS+=-DGD32F405
else ifeq ($(CONFIG_GD32F407),y)
CFLAGS+=-DGD32F407
else ifeq ($(CONFIG_GD32F470),y)
CFLAGS+=-DGD32F470
else ifeq ($(CONFIG_GD32F425),y)
CFLAGS+=-DGD32F425
else ifeq ($(CONFIG_GD32F427),y)
CFLAGS+=-DGD32427
endif

CFLAGS+=-DUSE_STDPERIPH_DRIVER
CFLAGS+=-DHXTAL_VALUE=$(CONFIG_HXTAL_VALUE) -DHXTAL_STARTUP_TIMEOUT=$(CONFIG_HXTAL_STARTUP_TIMEOUT)
CFLAGS+=-DIRC16M_VALUE=$(CONFIG_IRC16M_VALUE) -DIRC16M_STARTUP_TIMEOUT=$(CONFIG_IRC16M_STARTUP_TIMEOUT)
CFLAGS+=-DIRC32K_VALUE=$(CONFIG_IRC32K_VALUE) -DLXTAL_VALUE=$(CONFIG_LXTAL_VALUE)

all:

library: $(lib)

$(lib): $(LIBMCU_OBJS)
	$(call archive, $(lib), $^)

%.o: %.c
	$(call compile, $@, $<)

depend: $(SRCS-y:.c=.ddc)

clean:
	$(call remove, $(CLEANABLES))

-include $(SRCS-y:.c=.ddc)

