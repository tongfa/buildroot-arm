OLD BRANCH

# Buildroot for generic arm

This project is a superset of a 2013 version of buildroot.  It also
includes some other packages useful for embedded systems, specifically
installing firmware onto small footprint systems.

Includes:
- 2013 version of buildroot
- reveng for exploding existing manufacturer firmware
- fmk also for explosing existing manufacturer firmware

## build

I've created a Makefile which under ideally conditions will test for
required dependencies and bark if any are missing.  Please install any
missing dependencies the makefile notices.  Assuming you have all the
dependencies, the build procedure is simple:

```cd buildroot-arm;  #presumably where you downloaded this project
make
```

Now wait about three hours.

This completed successfully on a Debian 8 system.  Believe I've also
had success on an Ubuntu version, probably around 12 or 14.

Once you have a this built, it's up to you to decide what to do with
it.  As an axample, you can checkout my vent project which uses this
toolchain to build a simple tunneling program and then uses the
fmk/reveng software to install it into a factory firmware image from
an IP cam manufacturer.
