#
# Copyright (C) 2023 Objectos Software LTDA.
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
# main artifact options
#

## main base dir
MAIN := main

## main source path
SOURCE_PATH := $(MAIN)

## main source files
SOURCES := $(shell find ${SOURCE_PATH} -type f -name '*.java' -print)

## main source files modified since last compilation
MODIFIED_SOURCES :=

## main class output path
CLASS_OUTPUT := $(WORK)/classes

## main compiled classes
CLASSES := $(SOURCES:$(SOURCE_PATH)/%.java=$(CLASS_OUTPUT)/%.class)

## main compile-time dependencies
# COMPILE_DEPS = 

## main compile-time module-path
COMPILE_MODULE_PATH = $(call module-path,$(COMPILE_DEPS))
 
## main javac command
JAVACX = $(JAVAC)
JAVACX += -d $(CLASS_OUTPUT)
ifneq ($(COMPILE_MODULE_PATH),)
JAVACX += --module-path $(COMPILE_MODULE_PATH)
endif
JAVACX += --module-version $(VERSION)
JAVACX += $(MODIFIED_SOURCES)

## main generated artifact
ARTIFACT := $(WORK)/$(ARTIFACT_ID)-$(VERSION).jar

## main jar command
JARX = $(JAR)
JARX += --create
JARX += --file $(ARTIFACT)
JARX += --module-version $(VERSION)
JARX += -C $(CLASS_OUTPUT)
JARX += .

#
# jar target
#
.PHONY: jar
jar: $(ARTIFACT)

$(ARTIFACT): $(COMPILE_DEPS) $(CLASSES)
	if [ -n "$(MODIFIED_SOURCES)" ]; then \
		$(JAVACX); \
	fi
	$(JARX)

$(CLASSES): $(CLASS_OUTPUT)/%.class: $(SOURCE_PATH)/%.java
	$(eval MODIFIED_SOURCES += $$<)
