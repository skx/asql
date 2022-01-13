#
#  Makefile for 'asql'.
#
# Steve
# --
#


#
#  Only used to build distribution tarballs.
#
DIST_PREFIX = ${TMP}
VERSION     = 1.7
BASE        = asql


.PHONY: test

stubb:
	@echo "Valid targets are"
	@echo " "
	@echo " clean    - Remove temporary files"
	@echo " commands - Make our command reference."
	@echo " install  - Install the scripts into /etc"
	@echo " release  - Build a tarball"
	@echo " "

clean:
	-find . -name '*~' -delete
	-find . -name 'build-stamp' -delete
	-rm bin/*.bak

commands:
	perl ./bin/make-cmds ./bin/asql > ./COMMANDS

install:
	mkdir -p ${PREFIX}/usr/bin/
	cp bin/asql ${PREFIX}/usr/bin/asql
	chmod 755 ${PREFIX}/usr/bin/asql


release: clean commands
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	rm -f $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz
	cp -R . $(DIST_PREFIX)/$(BASE)-$(VERSION)
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)/debian
	perl -pi -e "s/UNRELEASED/$(VERSION)/g" $(DIST_PREFIX)/$(BASE)-$(VERSION)/bin/asql
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)/.hg*
	cd $(DIST_PREFIX) && tar -cvf $(DIST_PREFIX)/$(BASE)-$(VERSION).tar $(BASE)-$(VERSION)/
	gzip $(DIST_PREFIX)/$(BASE)-$(VERSION).tar
	mv $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz .
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	gpg --armour --detach-sign $(BASE)-$(VERSION).tar.gz
	echo $(VERSION) > .version

check: test

test:
	prove --shuffle t/

test-verbose:
	prove --verbose --shuffle t/
