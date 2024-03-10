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

## compile-time dependencies
# COMPILE_DEPS := 

## compile-time module-path
ifdef COMPILE_DEPS
COMPILE_MODULE_PATH := $(call module-path,$(COMPILE_DEPS))
endif

## javac --release option
ifndef JAVA_RELEASE
JAVA_RELEASE := 21
endif

## module version
ifndef VERSION
VERSION := 1.0.0-SNAPSHOT
endif

## javac command
JAVACX := $(JAVAC)
JAVACX += -d $(CLASS_OUTPUT)
JAVACX += -Xlint:none
JAVACX += -Xpkginfo:always
ifdef COMPILE_MODULE_PATH
JAVACX += --module-path $(COMPILE_MODULE_PATH)
endif
JAVACX += --module-version $(VERSION)
JAVACX += --release $(JAVA_RELEASE)
JAVACX += --source-path $(MAIN)
JAVACX += $(SOURCES)

## compilation marker
COMPILE_MARKER = $(WORK)/compile-marker

#
# compilation targets
#

.PHONY: compile
compile: $(COMPILE_MARKER)

.PHONY: compile@clean
compile@clean:
	rm -f $(COMPILE_MARKER)

$(COMPILE_MARKER): $(SOURCES)
	$(JAVACX)
	touch $@
