#
# Copyright (C) 2023-2024 Objectos Software LTDA.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# java compilation options
#

## source directory
MAIN = main

## source files
SOURCES = $(shell find ${MAIN} -type f -name '*.java' -print)

## class output path
CLASS_OUTPUT = $(WORK)/main

## compile dependencies
# COMPILE_DEPS := 

ifdef COMPILE_DEPS
## compile resolution files
COMPILE_RESOLUTION_FILES := $(call to-resolution-files,$(COMPILE_DEPS))

## compile module-path (or class-path)
COMPILE_PATH := $(WORK)/compile-path
endif

## common javac options
JAVACX := $(JAVAC)
JAVACX += -d $(CLASS_OUTPUT)
JAVACX += -Xlint:none
JAVACX += -Xpkginfo:always

ifeq ($(COMPILE_MODE),class-path)

ifdef COMPILE_PATH
## path delimiter
COMPILE_PATH_DELIMITER := $(CLASS_PATH_SEPARATOR)

## class-path
JAVACX += --class-path @$(COMPILE_PATH)
endif

else

ifdef COMPILE_PATH
## path delimiter
COMPILE_PATH_DELIMITER := $(MODULE_PATH_SEPARATOR)

## module-path
JAVACX += --module-path @$(COMPILE_PATH)
endif

## module version
ifndef VERSION
VERSION := 1.0.0-SNAPSHOT
endif
JAVACX += --module-version $(VERSION)

endif

## javac --release option
ifndef JAVA_RELEASE
JAVA_RELEASE := 21
endif

## common javac trailing options
JAVACX += --release $(JAVA_RELEASE)
JAVACX += --source-path $(MAIN)
JAVACX += $(SOURCES)

## compilation marker
COMPILE_MARKER = $(WORK)/compile-marker

## compilation requirements
COMPILE_REQS :=
ifdef COMPILE_RESOLUTION_FILES
COMPILE_REQS += $(COMPILE_PATH)
endif
COMPILE_REQS += $(SOURCES)

#
# compilation targets
#

.PHONY: compile
compile: $(COMPILE_MARKER)

.PHONY: compile@clean
compile@clean:
	rm -f $(COMPILE_MARKER) $(COMPILE_PATH)

.PHONY: re-compile
re-compile: compile@clean compile

$(COMPILE_PATH): $(COMPILE_RESOLUTION_FILES)
	$(call uniq-resolution-files,$(COMPILE_RESOLUTION_FILES)) > $@.tmp
	cat $@.tmp | paste --delimiter='$(COMPILE_PATH_DELIMITER)' --serial > $@

$(COMPILE_MARKER): $(COMPILE_REQS)
	$(JAVACX)
	touch $@
