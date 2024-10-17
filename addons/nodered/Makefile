sources-$(CONFIG_NODE_SOURCE) += addons/nodered/node-source
pkgs-$(CONFIG_NODE_RED) += wget,curl,gnupg,g++,make,nodejs
mmopt-$(CONFIG_NODE_RED) += --customize-hook=addons/nodered/customize

node_proj=$(if $(filter $(CONFIG_SOC_BCM)$(CONFIG_IMX),y),project.tar,project-g1.tar)
mmopt-$(CONFIG_NODE_PROJECT) += --customize-hook="tar-in addons/nodered/node-project/$(node_proj) /home/unipi/"
mmopt-$(CONFIG_NODE_PROJECT) += --customize-hook=addons/nodered/node-project/customize

ifeq ($(CONFIG_GATE),y)
pkgs-$(CONFIG_NODE_PROJECT) += nginx
mmopt-$(CONFIG_NODE_PROJECT) += --customize-hook="upload addons/nodered/node-project/nginx.node /etc/nginx/sites-available/node-red"
mmopt-$(CONFIG_NODE_PROJECT) += --customize-hook=addons/nodered/node-project/customize-nginx
endif
