
include .config

BUILD_VARIANT = $(CONFIG_BUILD_VARIANT)
export BUILD_VARIANT
#PRODUCT = $(CONFIG_PRODUCT)
#export PRODUCT

ifeq ($(CONFIG_DEBIAN_SUITE_STABLE)$(CONFIG_DEBIAN_SUITE_TESTING),y)
components-$(CONFIG_SOC_BCM) += main,non-free-firmware
components-$(CONFIG_SOC_IMX) += main,non-free-firmware
endif
ifeq ($(CONFIG_DEBIAN_SUITE_OLDSTABLE)$(CONFIG_DEBIAN_SUITE_OLDOLDSTABLE),y)
components-$(CONFIG_SOC_BCM) += main,non-free
components-$(CONFIG_SOC_IMX) += main,non-free
endif

include unipi/Makefile
include scripts/Makefile

skip-$(CONFIG_CLEAN_APT_LIST) += --skip=cleanup/apt
skip-$(CONFIG_CLEAN_MACHINE_ID) += --skip=cleanup/reproducible
mmopt-$(CONFIG_EXCLUDE_MAN_PAGES) += --dpkgopt=path-exclude=/usr/share/man/*

IMAGE_FORMAT = $(CONFIG_IMAGE_FORMAT)
IMAGE_SIZE = $(if $(CONFIG_IMAGE_SIZE),$(CONFIG_IMAGE_SIZE)M)

include addons/Makefile
