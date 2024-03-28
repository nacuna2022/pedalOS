# pull in the config file so we can inspect some other CONFIG_ we are
# interested in.
include $(TOPDIR)/.config
include $(TOPDIR)/scripts/util.mk

# pull in the board make definitions. this will also pull in the toolchain 
# and correct flags for the target system we are building for.
include $(TOPDIR)/board/$(_CONFIG_BOARD_NAME)/defs.mk

include $(TOPDIR)/board/makefile.defs

SRCS+=src/gd32f425_board.c

CLEANABLES+=$(SRCS:.c=.o)
CLEANABLES+=$(SRCS:.c=.ddc)

all:

library: $(lib)

$(lib): $(SRCS:.c=.o)
	$(call archive, $@, $^)

%.o: %.c
	$(call compile, $@, $<)

depend: $(SRCS:.c=.ddc)

clean:
	$(call remove, $(CLEANABLES))

-include $(SRCS:.c=.ddc)



