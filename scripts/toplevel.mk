
CFLAGS=
include $(TOPDIR)/board/$(_CONFIG_BOARD_NAME)/defs.mk
include $(TOPDIR)/scripts/util.mk

_CONFIG_IMAGE_NAME:=$(patsubst "%",%,$(CONFIG_IMAGE_NAME))
ELF=$(_CONFIG_IMAGE_NAME).elf
BIN=$(_CONFIG_IMAGE_NAME).bin
HEX=$(_CONFIG_IMAGE_NAME).hex
SYX=$(_CONFIG_IMAGE_NAME).syx
MAPFILE=$(_CONFIG_IMAGE_NAME).map
SYM=$(_CONFIG_IMAGE_NAME).sym

all: $(ELF)
.PHONY: BIN depend prebuild_autogenerated

ifeq ($(CONFIG_GENERATE_SYMBOL_FILE),y)
all: $(SYM)
endif

ifeq ($(CONFIG_RAW_BINARY),y)
all: $(BIN)
endif

ifeq ($(CONFIG_INTEL_HEX),y)
all: $(HEX)
endif

ifeq ($(CONFIG_MUSICTRIBE_SYX),y)
all: $(SYX)
endif



include $(TOPDIR)/scripts/libs.mk

FREERTOS_PORTABLE_DIR:=$(patsubst "%",%,$(CONFIG_PORTABLE_FREERTOS_CONFIG))
CFLAGS+=-I$(TOPDIR)/FreeRTOS/portable/$(FREERTOS_PORTABLE_DIR)

prebuild_autogenerated: include/config.h

include/config.h: .config
	$(call mkconfig, $(TOPDIR)/.config,$(TOPDIR)/$@)

$(SYM): $(ELF)
	$(call gensym, $@, $<)

$(SYX): $(HEX)
	$(call mksyx, $@, $<)
	
$(HEX): $(ELF)
	$(call mkhex, $@, $<)

$(BIN): $(ELF)
	$(call mkbin, $@, $<)

$(ELF): $(LIBS)
	@$(MAKE) -C arm/$(_CONFIG_ARM_ARCH) firmware ELF=$(ELF) LIBS="$(LIBS)" MAPFILE=$(MAPFILE)

depend: prebuild_autogenerated
	@for dir in $(LIBDIRS); do 	\
		$(MAKE) -C $$dir depend;\
	done

clean:
	@for dir in $(LIBDIRS); do 	\
		$(MAKE) -C $$dir clean;	\
	done
	$(call remove, $(LIBS))
	$(call remove, $(ELF))
	$(call remove, $(MAPFILE))
	$(call remove, $(BIN))
	$(call remove, $(HEX))
	$(call remove, $(SYX))
	$(call remove, $(SYM))

menuconfig:
	kconfig-mconf Kconfig
