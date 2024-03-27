include $(TOPDIR)/.config
include $(TOPDIR)/scripts/util.mk
include $(TOPDIR)/board/$(_CONFIG_BOARD_NAME)/defs.mk

SRCS+=src/arm_head.c
ASRCS+=src/arm_reset.S

CLEANABLES+=$(SRCS:.c=.o)
CLEANABLES+=$(ASRCS:.S=.o)
CLEANABLES+=$(SRCS:.c=.ddc)
CLEANABLES+=$(ASRCS:.S=.ddS)

all:

library: $(lib)

$(lib): $(SRCS:.c=.o) $(ASRCS:.S=.o)
	$(call archive, $@, $^)

%.o: %.c
	$(call compile, $@, $<)

%.o: %.S
	$(call assemble, $@, $< )

depend: $(SRCS:.c=.ddc) $(ASRCS:.S=.ddS)

LIBPATHS=$(dir $(patsubst %,-L$(TOPDIR)/%, $(LIBS)))
LIBRARIES=$(patsubst lib%,-l%,$(notdir $(basename $(LIBS))))

firmware:
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBPATHS) $(LIBRARIES) \
		-specs=nano.specs --entry=__arm_reset -nostartfiles \
		-u __vectors -o $(TOPDIR)/$(ELF)

clean:
	$(call remove, $(CLEANABLES))

-include $(SRCS:.c=.ddc) $(ASRCS:.S=.ddS)

