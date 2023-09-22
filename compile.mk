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
# @name@ compilation options
#

## @name@ source directory
@prefix@MAIN = $(@prefix@MODULE)/main

## @name@ source files
@prefix@SOURCES = $(shell find ${@prefix@MAIN} -type f -name '*.java' -print)

## @name@ source files modified since last compilation
@prefix@DIRTY :=

## @name@ work dir
@prefix@WORK = $(@prefix@MODULE)/work

## @name@ class output path
@prefix@CLASS_OUTPUT = $(@prefix@WORK)/main

## @name@ compiled classes
@prefix@CLASSES = $(@prefix@SOURCES:$(@prefix@MAIN)/%.java=$(@prefix@CLASS_OUTPUT)/%.class)

## @name@ compile-time dependencies
# @prefix@COMPILE_DEPS = 

## @name@ compile-time module-path
@prefix@COMPILE_MODULE_PATH = $(call module-path,$(@prefix@COMPILE_DEPS))
 
## @name@ javac command
@prefix@JAVACX = $(JAVAC)
@prefix@JAVACX += -d $(@prefix@CLASS_OUTPUT)
@prefix@JAVACX += -g
@prefix@JAVACX += -Xlint:all
@prefix@JAVACX += -Xpkginfo:always
ifeq ($(@prefix@ENABLE_PREVIEW),1)
@prefix@JAVACX += --enable-preview
endif
ifneq ($(@prefix@COMPILE_MODULE_PATH),)
@prefix@JAVACX += --module-path $(@prefix@COMPILE_MODULE_PATH)
endif
@prefix@JAVACX += --module-version $(@prefix@VERSION)
@prefix@JAVACX += --release $(@prefix@JAVA_RELEASE)
@prefix@JAVACX += $(@prefix@DIRTY)

## @name@ compilation marker
@prefix@COMPILE_MARKER = $(@prefix@WORK)/compile-marker

#
# @name@ compilation targets
#

$(@prefix@COMPILE_MARKER): $(@prefix@COMPILE_DEPS) $(@prefix@CLASSES)
	if [ -n "$(@prefix@DIRTY)" ]; then \
		$(@prefix@JAVACX); \
		touch $(@prefix@COMPILE_MARKER); \
	fi

$(@prefix@CLASSES): $(@prefix@CLASS_OUTPUT)/%.class: $(@prefix@MAIN)/%.java
	$(eval @prefix@DIRTY += $$<)
