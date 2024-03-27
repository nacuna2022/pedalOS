
SCRIPTS_DIR:=$(TOPDIR)/scripts

# add the system include dir
CFLAGS+=-I$(TOPDIR)/include

# add the FreeRTOS portable directory
FREERTOS_PORTABLE_DIR:=$(patsubst "%",%,$(CONFIG_PORTABLE_FREERTOS_CONFIG))
CFLAGS+=-I$(TOPDIR)/FreeRTOS/portable/$(FREERTOS_PORTABLE_DIR)

define make_depend_c
	#@echo "DEP $(notdir $(1))"
	@$(CC) $(CFLAGS) $(DEPFLAGS) -MT $(patsubst %.c,%.o,$(2)) $(2) > $(1)
endef 

define make_depend_s
	#@echo "DEP $(notdir $(1))"
	@$(CC) $(CFLAGS) $(DEPFLAGS) -MT $(patsubst %.S,%.o,$(2)) $(2) > $(1)
endef

define compile
	@echo "CC $(notdir $(1))"
	@$(CC) -c $(CFLAGS) $(2) -o $(1)
endef 

define mkbin
	@echo "BIN $(notdir $(1))"
	@$(OBJCOPY) --output-target binary $(2) $(1)
endef 

define mkhex
	@echo "HEX $(notdir $(1))"
	@$(OBJCOPY) --output-target ihex $(2) $(1)
endef 

define mksyx
	@echo "SYX $(notdir $(1))"
	@echo "no syx converter implemented yet. :-("
endef 

define assemble
	@echo "AS $(notdir $(1))"
	@$(CC) -c $(CFLAGS) $(2) -o $(1)
endef 


define archive
	@echo "AR $(notdir $(1))"
	@$(AR) -rfc $(1) $(2)
endef

define remove
	@rm -rf $(1)
endef

define mkconfig
	@python $(SCRIPTS_DIR)/mkconfig.py --config $(1) --header $(2)
endef

define gensym
	@echo "SYM $(notdir ($1))"
	$(NM) -a $(2) > $(1)
endef

define mkfreertosconfig
	@python $(SCRIPTS_DIR)/mkfreertosconfig.py --config $(1) --freertosconfig $(2)
endef

%.ddc: %.c
	$(call make_depend_c, $@, $<)

%.ddS: %.S
	$(call make_depend_s, $@, $<)
