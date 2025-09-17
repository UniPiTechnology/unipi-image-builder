

export ROOT_KEY_FILE=$(subst ",,$(CONFIG_ROOT_KEY_FILE))
check-$(CONFIG_ROOT_KEY) += scripts/users/check-ssh.sh
pkgs-$(CONFIG_ROOT_KEY) += openssh-server
mmopt-$(CONFIG_ROOT_KEY) += --customize-hook='mkdir -m700 -p "$$1/root/.ssh"'
mmopt-$(CONFIG_ROOT_KEY) += --customize-hook='upload "$(ROOT_KEY_FILE)" /root/.ssh/authorized_keys'

include scripts/users/password/Makefile

ifneq ($(CONFIG_SUDO_USERNAME),"")
export SUDO_USERNAME=$(subst ",,$(CONFIG_SUDO_USERNAME))
export SUDO_PASSWD=$(subst ",,$(CONFIG_SUDO_PASSWD))
export SUDO_PASSWD_TEXT=$(subst ",,$(CONFIG_SUDO_PASSWD_TEXT))
mmopt-$(CONFIG_SUDO_USER) += --customize-hook=scripts/users/sudo-user/customize

export SUDO_KEY_FILE=$(subst ",,$(CONFIG_SUDO_KEY_FILE))
check-$(CONFIG_SUDO_KEY) += scripts/users/sudo-user/check-ssh.sh
pkgs-$(CONFIG_SUDO_KEY) += openssh-server
mmopt-$(CONFIG_SUDO_KEY) += --customize-hook='mkdir -m700 -p "$$1/home/$(SUDO_USERNAME)/.ssh"'
mmopt-$(CONFIG_SUDO_KEY) += --customize-hook='upload "$(SUDO_KEY_FILE)" /home/$(SUDO_USERNAME)/.ssh/authorized_keys'
mmopt-$(CONFIG_SUDO_KEY) += --customize-hook='chroot "$$1" chown -R $(SUDO_USERNAME) /home/$(SUDO_USERNAME)/.ssh'
endif
