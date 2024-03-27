_CONFIG_TOOLCHAIN_PREFIX:=$(patsubst "%",%,$(CONFIG_TOOLCHAIN_PREFIX))

CC:=$(_CONFIG_TOOLCHAIN_PREFIX)-gcc
AS:=$(_CONFIG_TOOLCHAIN_PREFIX)-as
AR:=$(_CONFIG_TOOLCHAIN_PREFIX)-ar
LD:=$(_CONFIG_TOOLCHAIN_PREFIX)-ld
NM:=$(_CONFIG_TOOLCHAIN_PREFIX)-nm
OBJDUMP:=$(_CONFIG_TOOLCHAIN_PREFIX)-objdump
OBJCOPY:=$(_CONFIG_TOOLCHAIN_PREFIX)-objcopy

ARCH_INC_DIR:=$(TOPDIR)/arm/$(_CONFIG_ARM_ARCH)/include
ARCH_SRC_DIR:=$(TOPDIR)/arm/$(_CONFIG_ARM_ARCH)/src


DEPFLAGS=-MM -MP

#define the the arm arch specific include directory here
CFLAGS+=-I$(ARCH_INC_DIR)

#always default to little endian
#ifeq ($(CONFIG_ENDIAN),y)
#CFLAGS+=-mlittle-endian
#endif

#optimization
# we have three none -O0, normal -O2, aggressive -O3
# gcc have other optimization levels like optimizing for speed -Os and 
# optimizing for size -Os but we limit ourselves to safe values
ifeq ($(CONFIG_OPTIMIZATION_NONE),y)
OPTIMIZATION_FLAGS=-O0 -ggdb
else ifeq ($(CONFIG_OPTIMIZATION_NORMAL),y)
OPTIMIZATION_FLAGS=-O2 -ggdb
else ifeq ($(CONFIG_OPTIMIZATION_AGRRESSIVE),y)
OPTIMIZATION_FLAGS=-O3 -ggdb
endif
CFLAGS+=$(OPTIMIZATION_FLAGS)

LDFLAGS+=-T$(LINKERSCRIPT)

#print memory usage 
LDFLAGS+=-Wl,--print-memory-usage

ifeq ($(CONFIG_GENERATE_LINK_MAP),y)
LDFLAGS+=-Wl,-Map $(TOPDIR)/$(MAPFILE)
endif

