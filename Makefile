HTML_TMP_DIR=tmp

all: open

.PHONY : all open jdhp publish clean init

# OPEN IN WEB BROWSER #########################################################

# Inspired by https://git.kernel.org/cgit/git/git.git/tree/config.mak.uname
# See also http://stackoverflow.com/questions/3466166/

# If uname not available then UNAME_S is set to 'unknown' 
UNAME_S := $(shell sh -c 'uname -s 2>/dev/null || echo unknown')

open: $(SUBDIRS)
# Linux ###############################
# See: http://askubuntu.com/questions/8252/
ifeq ($(UNAME_S),Linux)
	@xdg-open index.html
endif

# MacOSX ##############################
ifeq ($(UNAME_S),Darwin)
	@open -a firefox index.html
	#open -a Google\ Chrome index.html
endif

# Windows #############################
ifneq (,$(findstring CYGWIN,$(UNAME_S)))
	@#start chrome  index.html
	@start firefox  index.html
endif
ifneq (,$(findstring MINGW32,$(UNAME_S)))
	@#start chrome  index.html
	@start firefox  index.html
endif
ifneq (,$(findstring MSYS,$(UNAME_S)))
	@#start chrome  index.html
	@start firefox  index.html
endif

## JDHP #######################################################################

publish: jdhp

jdhp:index.html
	
	########
	# HTML #
	########
	
	# JDHP_WEBAPPS_URI is a shell environment variable that contains the
	# destination URI of the HTML files.
	@if test -z $$JDHP_WEBAPPS_URI ; then exit 1 ; fi

	# Copy HTML
	@rm -rf $(HTML_TMP_DIR)/
	@mkdir $(HTML_TMP_DIR)/
	cp -v index.html $(HTML_TMP_DIR)/
	cp -v README.rst $(HTML_TMP_DIR)/

	# Upload the HTML files
	rsync -r -v -e ssh $(HTML_TMP_DIR)/ ${JDHP_WEBAPPS_URI}/timetable/

## CLEAN ######################################################################

clean:
	@echo "Remove generated files"
	@rm -rf $(HTML_TMP_DIR)/

init: clean

