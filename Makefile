
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
include scripts/toplevel.mk
endif

