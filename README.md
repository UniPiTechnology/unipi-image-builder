# Unipi Image Builder

Simple, configurable tool to build Debian images. The tool is basically frontend to [mmdebstrap - multi-mirror Debian chroot creator](https://gitlab.mister-muffin.de/josch/mmdebstrap)

Frontend is based on Kconfig language and Makefiles and is used it like building Linux kernel

``` 
    make bookworm-patron_defconfig
    make menuconfig
    make
```

## Requirements
- mmdebstrap
- apt
- make
- fakeroot
- kconfig-frontends-nox
- python3-jinja2
- j2
- pigz, zip
- fusefat



## Makefile options

mmopt-y          - list of hooks to run
mmpre-y          - list of hooks to run before mmopt-y hooks
mmpost-y         - list of hooks to run after mmopt-y hooks
sources-y        - list of directories with apt source definition
pkgs-y           - list of packages to install
local-pkgs-y     - list of local file packages to install
local-uploads-y
components-y     - list of apt components to install (main, test ...)


