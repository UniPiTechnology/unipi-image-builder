sources-$(CONFIG_UNIPI_SOURCE) += unipi/unipi-source
export OEMZULU=$(CONFIG_OEMZULU)
export PRODUCT=$(CONFIG_PRODUCT)

UNIPI_MODBUS = $(if findstring(y,$(CONFIG_DEBIAN_SUITE_OLDSTABLE)$(CONFIG_DEBIAN_SUITE_OLDOLDSTABLE)),unipi-modbus-tools,unipi-modbus)

pkgs-$(CONFIG_UNIPI_ESSENTIAL) += unipi-u-boot,unipi-kernel,kmod,udev
pkgs-$(CONFIG_UNIPI_ESSENTIAL) += $(if $(findstring y,$(CONFIG_SOC_BCM)),raspi-firmware)$(if $(findstring y,$(CONFIG_SOC_IMX)),firmware-misc-nonfree)
#mmopt-$(CONFIG_UNIPI_ESSENTIAL) += $(if $(findstring y,$(CONFIG_SOC_BCM)),--essential-hook='mkdir -p "$$1"/etc/bootcmd.d; touch "$$1"/etc/bootcmd.d/Makefile')

pkgs-$(CONFIG_UNIPI_RECOMMENDED) += unipi-os-configurator,unipi-os-configurator-data,unipi-altboot,unipi-kernel-modules
pkgs-$(CONFIG_UNIPI_RECOMMENDED) += $(UNIPI_MODBUS),ca-certificates,mbpoll,minicom
pkgs-$(CONFIG_UNIPI_RECOMMENDED) += unipi-flash-diag,unipi-firmware-tools,unipi-firmware6

mmopt-$(CONFIG_UNIPI_LOCALES) += --customize-hook='unipi/locales/customize'

mmopt-$(CONFIG_UNIPI_REGENERATE_SSH) += --customize-hook='upload unipi/regenerate-ssh-keys/regenerate_ssh_host_keys.service /etc/systemd/system/regenerate_ssh_host_keys.service'
mmopt-$(CONFIG_UNIPI_REGENERATE_SSH) += --customize-hook='upload unipi/regenerate-ssh-keys/check-mac /etc/ssh/check-mac'
mmopt-$(CONFIG_UNIPI_REGENERATE_SSH) += --customize-hook='unipi/regenerate-ssh-keys/customize'

mmopt-$(CONFIG_UNIPI_UPDATE_REGDB) += --customize-hook='unipi/update-regdb/customize'

mmopt-$(CONFIG_UNIPI_DISABLE_JOURNAL) += --customize-hook='unipi/disable-persistent-journal/customize'

pkgs-$(CONFIG_UNIPI_HAVEGED) += haveged
mmopt-$(CONFIG_UNIPI_HAVEGED) += --customize-hook='unipi/haveged/customize'

export IMAGE_NAME
export IMAGE_VERSION
mmopt-$(CONFIG_UNIPI_IMAGE_VERSION) += --customize-hook='unipi/image-version/customize'

export CONFIG_SOC_BCM
mmopt-$(CONFIG_UNIPI_FSTAB) += --hook-dir=unipi/fstab
mmopt-$(CONFIG_UNIPI_GETTY) += --hook-dir=unipi/getty-on-fb
mmopt-$(CONFIG_UNIPI_FWUPDATE) += --hook-dir=unipi/fwupdate-force

pkgs-$(CONFIG_UNIPI_EVOK) += evok,evok-unipi-data,evok-web,owserver
