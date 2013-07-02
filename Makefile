
all: buildroot

#               --- buildroot ---

dl/buildroot-2013.05.tar.bz2:
	( cd dl ; \
	wget http://buildroot.uclibc.org/downloads/buildroot-2013.05.tar.bz2 )

buildroot-2013.05: | dl/buildroot-2013.05.tar.bz2
	tar -xf dl/buildroot-2013.05.tar.bz2

buildroot-2013.05/.config: buildroot-2013.05 buildroot.config
	cp buildroot.config $@

buildroot: buildroot-2013.05/.config
	make -C buildroot-2013.05
