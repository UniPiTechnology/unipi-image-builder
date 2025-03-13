

mmopt-$(CONFIG_NOPASSWD) += --customize-hook='passwd  --root "$$1" --delete root'

ifneq ($(CONFIG_NOPASSWD),y)
export ROOT_PASSWD=$(subst ",,$(CONFIG_ROOT_PASSWD))
export ROOT_PASSWD_TEXT=$(subst ",,$(CONFIG_ROOT_PASSWD_TEXT))
mmopt-$(CONFIG_ROOT_PASSWD) += --customize-hook=scripts/users/password/customize.sh
endif
