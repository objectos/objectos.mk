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
# @name@ test compilation options
#

## @name@ test source directory
@prefix@TEST = $(@prefix@MODULE)/test

## @name@ test source files 
@prefix@TEST_SOURCES = $(shell find ${@prefix@TEST} -type f -name '*.java' -print)

## @name@ test source files modified since last compilation
@prefix@TEST_DIRTY :=

## @name@ test class output path
@prefix@TEST_CLASS_OUTPUT = $(@prefix@WORK)/test

## @name@ test compiled classes
@prefix@TEST_CLASSES = $(@prefix@TEST_SOURCES:$(@prefix@TEST)/%.java=$(@prefix@TEST_CLASS_OUTPUT)/%.class)

## @name@ test compile-time dependencies
# @prefix@TEST_COMPILE_DEPS =

## @name@ test javac command
@prefix@TEST_JAVACX = $(JAVAC)
@prefix@TEST_JAVACX += -d $(@prefix@TEST_CLASS_OUTPUT)
@prefix@TEST_JAVACX += -g
@prefix@TEST_JAVACX += -Xlint:all
@prefix@TEST_JAVACX += --class-path $(call class-path,$(@prefix@TEST_COMPILE_DEPS))
ifeq ($(@prefix@ENABLE_PREVIEW),1)
@prefix@TEST_JAVACX += --enable-preview
endif
@prefix@TEST_JAVACX += --release $(@prefix@JAVA_RELEASE)
@prefix@TEST_JAVACX += $(@prefix@TEST_DIRTY)

## @name@ test compilation marker
@prefix@TEST_COMPILE_MARKER = $(@prefix@WORK)/test-compile-marker

#
# @name@ test compilation targets
#

$(@prefix@TEST_COMPILE_MARKER): $(@prefix@TEST_COMPILE_DEPS) $(@prefix@TEST_CLASSES) 
	if [ -n "$(@prefix@TEST_DIRTY)" ]; then \
		$(@prefix@TEST_JAVACX); \
	fi
	touch $(@prefix@TEST_COMPILE_MARKER); \

$(@prefix@TEST_CLASSES): $(@prefix@TEST_CLASS_OUTPUT)/%.class: $(@prefix@TEST)/%.java
	$(eval @prefix@TEST_DIRTY += $$<)
