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
