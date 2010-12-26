-include Makefile.local

FILENAME       := AILibDirection

shell          ?= /bin/sh
HG             ?= hg

REPO_REVISION  ?= $(shell $(HG) id -n | cut -d+ -f1)
BUNDLE_NAME    := $(FILENAME)-$(REPO_REVISION)
VER_FILE       := $(BUNDLE_NAME)/version.nut
TAR_FILENAME   := $(BUNDLE_NAME).tar

_E             := @echo
_V             := @

all: bundle_tar

bundle_tar:
	$(_E) "[TAR]"
	$(_V) $(shell $(HG) archive -X glob:.* -X path:Makefile $(BUNDLE_NAME))
	$(_V) sed -i '20,25d' $(VER_FILE)
	$(_V) echo "revision  <- $(REPO_REVISION)" >> $(VER_FILE)
	$(_V) tar -cf $(TAR_FILENAME) $(BUNDLE_NAME)

clean:
	$(_E) "[Clean]"
	$(_V) -rm -r -f $(BUNDLE_NAME)
	$(_V) -rm -r -f $(TAR_FILENAME)

test:
	$(_E) "HG:                           $(HG)"
	$(_E) "Revision:                     $(REPO_REVISION)"
	$(_E) "Build folder:                 $(BUNDLE_NAME)"
	$(_E) "Version file:                 $(VER_FILE)"
	$(_E) "Bundle filenames       tar:   $(TAR_FILENAME)"

help:
	$(_E) ""
	$(_E) "$(FILENAME) version $(REPO_REVISION) Makefile"
	$(_E) "Usage : make [option]"
	$(_E) ""
	$(_E) "options:"
	$(_E) "  all           bundle the files (default)"
	$(_E) "  clean         remove the files generated during bundling"
	$(_E) "  bundle_tar    create bundle $(TAR_FILENAME)"
	$(_E) "  test          test to check the value of environment"
	$(_E) ""

.PHONY: all test clean help

