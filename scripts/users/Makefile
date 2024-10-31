

export ROOTKEY_FILE=$(subst ",,$(CONFIG_ROOTKEY_FILE))
check-$(CONFIG_ROOTKEY) += scripts/users/check-ssh.sh
pkgs-$(CONFIG_ROOTKEY) += openssh-server
mmopt-$(CONFIG_ROOTKEY) += --customize-hook='mkdir -m700 -p "$$1/root/.ssh"'
mmopt-$(CONFIG_ROOTKEY) += --customize-hook='upload "$(ROOTKEY_FILE)" /root/.ssh/authorized_keys'

include scripts/users/password/Makefile

ifneq ($(CONFIG_UNIPI_USERNAME),"")
export UNIPI_USERNAME=$(subst ",,$(CONFIG_UNIPI_USERNAME))
export UNIPI_PASSWD=$(subst ",,$(CONFIG_UNIPI_PASSWD))
export UNIPI_PASSWD_TEXT=$(subst ",,$(CONFIG_UNIPI_PASSWD_TEXT))
mmopt-$(CONFIG_UNIPI_USER) += --customize-hook=scripts/users/unipi-user/customize

export UNIPI_ROOTKEY_FILE=$(subst ",,$(CONFIG_UNIPI_ROOTKEY_FILE))
check-$(CONFIG_UNIPI_ROOTKEY) += scripts/users/unipi-user/check-ssh.sh
pkgs-$(CONFIG_UNIPI_ROOTKEY) += openssh-server
mmopt-$(CONFIG_UNIPI_ROOTKEY) += --customize-hook='mkdir -m700 -p "$$1/home/$(UNIPI_USERNAME)/.ssh"'
mmopt-$(CONFIG_UNIPI_ROOTKEY) += --customize-hook='upload "$(UNIPI_ROOTKEY_FILE)" /home/$(UNIPI_USERNAME)/.ssh/authorized_keys'
mmopt-$(CONFIG_UNIPI_ROOTKEY) += --customize-hook='chroot "$$1" chown -R $(UNIPI_USERNAME) /home/$(UNIPI_USERNAME)/.ssh'
endif
