
all: buildroot reveng fmk-build

#               --- buildroot ---

dl/buildroot-2013.05.tar.bz2:
	( cd dl ; \
	wget http://buildroot.uclibc.org/downloads/buildroot-2013.05.tar.bz2 )
	[ "$$(md5sum dl/buildroot-2013.05.tar.bz2)" ==  "881219ff40e966ef431c717cddbc464f  dl/buildroot-2013.05.tar.bz2" ]

buildroot-2013.05: dl/buildroot-2013.05.tar.bz2
	tar -xf $|

buildroot-2013.05/.config: buildroot.config | buildroot-2013.05
	cp buildroot.config $@

buildroot-2013.05/.built: buildroot-2013.05/.config
	make -C buildroot-2013.05
	touch $@

.PHONY+=buildroot
buildroot: buildroot-2013.05/.built

buildroot-dirclean:
	rm -rf buildroot-2013.05/

#               --- reveng ---

dl/reveng-1.1.2.tar.xz:
	( cd dl ; \
	wget http://downloads.sourceforge.net/project/reveng/1.1.2/reveng-1.1.2.tar.xz )
	[ "$$(md5sum dl/reveng-1.1.2.tar.xz)" ==  "a2a6d1fd09d5666ba7270bccef79c4fa  dl/reveng-1.1.2.tar.xz" ]

reveng-1.1.2: | dl/reveng-1.1.2.tar.xz
	tar -xf $|
	(cd $@ ; \
	patch ) < reveng-x86_64.patch

reveng-1.1.2/reveng: | reveng-1.1.2
	make -C $|

.PHONY+=reveng
reveng: reveng-1.1.2/reveng

reveng-dirclean:
	-rm -rf reveng-1.1.2

#               --- firmware modification kit ---

.PHONY+=fmk-prereqs
fmk/.prereqs:
	dpkg -l zlib1g-dev > /dev/null
	dpkg -l liblzma-dev > /dev/null
	touch $@

dl/fmk_099.tar.gz:
	( cd dl ;\
	wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz )
	[ "$$(md5sum dl/reveng-1.1.2.tar.xz)" ==  "a2a6d1fd09d5666ba7270bccef79c4fa  dl/reveng-1.1.2.tar.xz" ]

fmk:
	tar -xf dl/fmk_099.tar.gz

fmk/.built: | fmk fmk/.prereqs
	(cd fmk/src ; \
	./configure )
	make -C fmk/src
	touch $@

.PHONY+=fmk-build
fmk-build: fmk/.built


#               --- general ---
.PHONY+=dir-clean
dir-clean: reveng-dirclean buildroot-dirclean fmk-dirclean

#               --- prerequisites ---

.PHONY+=prereqs
prereqs: fmk-prereqs


