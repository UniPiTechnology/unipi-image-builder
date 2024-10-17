# Unipi Image Builder

Simple, configurable tool to build Debian images. The tool is basically frontend to mmdebstrap
- multi-mirror Debian chroot creator.

Frontend is based on Kconfig language and Makefiles and you can use it like building Linux kernel

``` 
    make bookworm-patron_defconfig
    make menuconfig
    make
```

