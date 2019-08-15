# Only used if 'make clone' is called
SCIRIUS_GIT_REPO := git@github.com:potrik98/scirius
SCIRIUS_GIT_BRANCH := develop

# Directory the git repo is cloned to, or scirius
# is expected to be.
SCIRIUS_DIR := scirius

# This json file is loaded into the datebase when 
# it is first initialized
INITIAL_DB_JSON := scirius.json

# Local settings file to copy into $(SCIRIUS_DIR) 
# on init and on each update.
LOCAL_SETTINGS_PATH := local_settings.py

ENTR_CMD := entr

.PHONY: all help clone init start

help:
	@ echo "Commands:"
	@ echo "clone       Clone scirius source from github"
	@ echo "start       Start scirius while watching for changes"
	@ echo "init        Setup install dependencies, build static for scirius"

all: clone init start

clone: $(SCIRIUS_DIR)

$(SCIRIUS_DIR):
	git clone $(SCIRIUS_GIT_REPO) $(SCIRIUS_DIR)
	(cd $(SCIRIUS_DIR) && git checkout $(SCIRIUS_GIT_BRANCH))

start:
	@ # Watching local_settings.py too in case it changes.
	cp $(LOCAL_SETTINGS_PATH) $(SCIRIUS_DIR)
	(echo $(LOCAL_SETTINGS_PATH) | $(ENTR_CMR) cp $(LOCAL_SETTINGS_PATH) $(SCIRIUS_DIR) &)
	cd $(SCIRIUS_DIR) && while true; do find . -name '*.py' | $(ENTR_CMD) -c $(MAKE) start; done

init: $(SCIRIUS_DIR)
	cp $(LOCAL_SETTINGS_PATH) $(SCIRIUS_DIR)
	cp Makefile_scirius $(SCIRIUS_DIR)/Makefile
	mkdir -p $(SCIRIUS_DIR)/files
	cp $(INITIAL_DB_JSON) $(SCIRIUS_DIR)/files/scirius.json
	(cd $(SCIRIUS_DIR) && $(MAKE) install-deps static hunt django)
