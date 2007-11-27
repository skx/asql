#
#  Makefile for 'asql'.
#
# Steve
# -- 
#

stubb:
	@echo "Valid targets are"
	@echo " "
	@echo " clean   - Remove temporary files"
	@echo " diff    - See differences from the remote repository"
	@echo " install - Install the scripts into /etc"
	@echo " update  - Update from the repository"
	@echo " "


clean:
	-find . -name '*~' -delete
	-find . -name 'build-stamp' -delete


diff:
	hg diff 2>/dev/null

install:
	mkdir -p ${PREFIX}/usr/bin/
	cp bin/asql ${PREFIX}/usr/bin/asql
	chmod 755 ${PREFIX}/usr/bin/asql

test:
	prove --shuffle t/

test-verbose:
	prove --verbose --shuffle t/

update:
	hg pull --update 2>/dev/null
