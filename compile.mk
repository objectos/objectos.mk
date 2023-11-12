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
# compilation options
#

define COMPILE

## source directory
$(1)MAIN = $$($(1)MODULE)/main

## source files
$(1)SOURCES = $$(shell find $${$(1)MAIN} -type f -name '*.java' -print)

## source files modified since last compilation
$(1)DIRTY :=

## work dir
$(1)WORK = $$($(1)MODULE)/work

## class output path
$(1)CLASS_OUTPUT = $$($(1)WORK)/main

## compiled classes
$(1)CLASSES = $$($(1)SOURCES:$$($(1)MAIN)/%.java=$$($(1)CLASS_OUTPUT)/%.class)

## compile-time dependencies
# $(1)COMPILE_DEPS = 

## compile-time module-path
$(1)COMPILE_MODULE_PATH = $$(call module-path,$$($(1)COMPILE_DEPS))
 
## javac command
$(1)JAVACX = $$(JAVAC)
$(1)JAVACX += -d $$($(1)CLASS_OUTPUT)
$(1)JAVACX += -g
$(1)JAVACX += -Xlint:all
$(1)JAVACX += -Xpkginfo:always
ifeq ($$($(1)ENABLE_PREVIEW),1)
$(1)JAVACX += --enable-preview
endif
ifneq ($$($(1)COMPILE_MODULE_PATH),)
$(1)JAVACX += --module-path $$($(1)COMPILE_MODULE_PATH)
endif
$(1)JAVACX += --module-version $$($(1)VERSION)
$(1)JAVACX += --release $$($(1)JAVA_RELEASE)
$(1)JAVACX += $$($(1)DIRTY)

## resources
# $(1)RESOURCES =

## compilation marker
$(1)COMPILE_MARKER = $$($(1)WORK)/compile-marker

#
# compilation targets
#

$$($(1)COMPILE_MARKER): $$($(1)COMPILE_DEPS) $$($(1)CLASSES) $$($(1)RESOURCES)
	if [ -n "$$($(1)DIRTY)" ]; then \
		$$($(1)JAVACX); \
	fi
	touch $$@

$$($(1)CLASSES): $$($(1)CLASS_OUTPUT)/%.class: $$($(1)MAIN)/%.java
	$$(eval $(1)DIRTY += $$$$<)

endef