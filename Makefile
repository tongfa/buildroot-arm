
SHELL=/bin/bash
all: buildroot reveng fmk-build /usr/local/bin/binwalk

#FMK prerequisites
PREREQS=zlib1g-dev liblzma-dev

#??
PREREQS+=libncurses5-dev

#binwalk 
PREREQS+=libqt4-opengl python-opengl python-qt4 python-numpy python-scipy python-pip

CHECK_PREREQ = if ! (dpkg -l $(1) | grep '^ii' > /dev/null) then \
        STATUS=1; \
        MISSING_PACKAGES="$${MISSING_PACKAGES} $(1)"; \
        fi
.check-prereqs:
	mkdir -p dl
	declare -a MISSING_PACKAGES; \
	for PREREQ in $(PREREQS) ; do \
          $(call CHECK_PREREQ,$$PREREQ); \
        done; \
        if [ "$${MISSING_PACKAGES}" ] ; then \
          echo ; \
          echo run this command to install system prerequisites: ; \
          echo sudo apt-get install $${MISSING_PACKAGES} ; \
          echo ; \
        fi ; \
        exit $$STATUS
	touch $@

#               --- buildroot ---

dl/buildroot-2013.05.tar.bz2: | .check-prereqs
	( cd dl && \
	wget http://buildroot.uclibc.org/downloads/buildroot-2013.05.tar.bz2 )
	[ "$$(md5sum dl/buildroot-2013.05.tar.bz2)" ==  "881219ff40e966ef431c717cddbc464f  dl/buildroot-2013.05.tar.bz2" ]

buildroot-2013.05: dl/buildroot-2013.05.tar.bz2
	tar -xf $^

buildroot-2013.05/.config: config.buildroot | buildroot-2013.05
	cp config.buildroot $@

buildroot-2013.05/.built: buildroot-2013.05/.config
	make -C buildroot-2013.05
	touch $@

.PHONY+=buildroot
buildroot: buildroot-2013.05/.built

buildroot-dirclean:
	rm -rf buildroot-2013.05/

#               --- reveng ---

dl/reveng-1.1.2.tar.xz: | .check-prereqs
	( cd dl && \
	wget http://downloads.sourceforge.net/project/reveng/1.1.2/reveng-1.1.2.tar.xz )
	[ "$$(md5sum dl/reveng-1.1.2.tar.xz)" =  "a2a6d1fd09d5666ba7270bccef79c4fa  dl/reveng-1.1.2.tar.xz" ]

reveng-1.1.2: | dl/reveng-1.1.2.tar.xz
	tar -xf $|
	if [ "$$(uname -m)" = x86_64 ] ; then (cd $@ ; \
	patch ) < reveng-x86_64.patch ; fi

reveng-1.1.2/reveng: | reveng-1.1.2
	make -C $|

.PHONY+=reveng
reveng: reveng-1.1.2/reveng

reveng-dirclean:
	-rm -rf reveng-1.1.2

#               --- firmware modification kit ---

dl/fmk_099.tar.gz: | .check-prereqs
	( cd dl && \
	wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz )
	[ "$$(md5sum dl/fmk_099.tar.gz)" =  "91bd2cb3803880368af369d07271b5b9  dl/fmk_099.tar.gz" ]

fmk: dl/fmk_099.tar.gz
	tar -xf dl/fmk_099.tar.gz

fmk/.built: | fmk
	(cd fmk/src ; \
	./configure )
	make -C fmk/src
	touch $@

.PHONY+=fmk-build
fmk-build: fmk/.built

#               --- binwalk ---
binwalk: .binwalk-prereqs
	git clone https://github.com/devttys0/binwalk.git
/usr/local/bin/binwalk: binwalk
	(cd binwalk; sudo python setup.py install)
	patch -p2 < binwalk-upgrade.patch

#               --- general ---
.PHONY+=dir-clean
dir-clean: reveng-dirclean buildroot-dirclean fmk-dirclean

#               --- prerequisites ---

.PHONY+=prereqs
prereqs: fmk-prereqs


