

mmopt-$(CONFIG_NOPASSWD) += --customize-hook='passwd  --root "$$1" --delete root'

ifneq ($(CONFIG_NOPASSWD),y)
export PASSWD_FILE=$(subst ",,$(CONFIG_PASSWD_FILE))
check-$(CONFIG_PASSWD) += scripts/users/password/check.sh
mmopt-$(CONFIG_PASSWD) += --customize-hook='upload "$(PASSWD_FILE)" /tmp/.mmpasswd'
mmopt-$(CONFIG_PASSWD) += --customize-hook='echo root:$$(cat "$$1/tmp/.mmpasswd") | /sbin/chpasswd -R "$$1" -e'
endif
