
TOPDIR:=$(shell echo "$(CURDIR)" | sed -e "s/ /\\\ /g")
CONFIG:=$(TOPDIR)/.config

MAKE:=$(MAKE) -s --no-print-directory

ifeq ($(wildcard .config),)
.DEFAULT default:
	@echo "please provide a configuration file .config"
else
export TOPDIR
export CONFIG
include $(CONFIG)

# some config values that we use inside the makefile must have unquoted
# versions
_CONFIG_ARM_ARCH:=$(patsubst "%",%,$(CONFIG_ARM_ARCH))
_CONFIG_BOARD_NAME:=$(patsubst "%",%,$(CONFIG_BOARD_NAME))
_CONFIG_IMAGE_NAME:=$(patsubst "%",%,$(CONFIG_IMAGE_NAME))
_CONFIG_MCU:=$(patsubst "%",%,$(CONFIG_MCU))
export _CONFIG_ARM_ARCH
export _CONFIG_BOARD_NAME
export _CONFIG_IMAGE_NAME
export _CONFIG_MCU

# also generate .version when the ff are true:
# 1) .version does not exist
# 2) we have an updated version tag that is different from the current .version
#
# .version is used by the toplevel makefile to generate include/version_config.h
#
# commits points that are also firmware releases should be tagged with an 
# annotated tag of the form vX.Y.Z where:
# X: major version
# Y: minor version
# z: patch level
#
# ----- RULES -----
# repository must always have the fallback tag v0.0.0
#
# X,Y,Z can only be digits.
#
# alternate form of the version tag can be vX.Y.Z-string
#
# where string is a pre release descriptor that can be alpahnumeric and an
# underscrore only.
$(shell ./scripts/init_version.py)

include scripts/toplevel.mk
endif

