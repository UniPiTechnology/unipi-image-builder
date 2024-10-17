
ifeq ($(CONFIG_DEBIAN_SUITE),"buster")
pkgs-$(CONFIG_NETWORKD) += systemd-networkd
endif
mmopt-$(CONFIG_NETWORKD_IF) += --hook-dir=scripts/network/networkd
mmpost-$(CONFIG_RESOLVED) += --hook-dir=scripts/network/resolved
pkgs-$(CONFIG_RESOLVED) += '?not(?virtual)?exact-name(libnss-resolve)'

include scripts/network/ifupdown/Makefile

mmopt-$(CONFIG_NETWORK_NAMES) += --hook-dir='scripts/network/network-names'
mmopt-$(CONFIG_WAIT_ONLINE) += --hook-dir='scripts/network/systemd-wait-online'

mmopt-$(CONFIG_INSTALL_WIFI) += --hook-dir='scripts/network/wpasupplicant'
pkgs-$(CONFIG_INSTALL_WIFI) += wpasupplicant,wireless-regdb,iw,rfkill
pkgs-$(CONFIG_INSTALL_WIFI) += $(if $(findstring y,$(CONFIG_SOC_BCM)),firmware-brcm80211)
pkgs-$(CONFIG_INSTALL_WIFI) += $(if $(findstring y,$(CONFIG_SOC_BCM)),bluez-firmware)
pkgs-$(CONFIG_INSTALL_LTE) += unipi-lte,rfkill
pkgs-$(CONFIG_INSTALL_WIREGUARD) += wireguard-tools

ifneq ($(CONFIG_HOSTNAME),"")
export CONFIG_HOSTNAME
mmopt-y += --hook-dir=scripts/network/hostname
endif
