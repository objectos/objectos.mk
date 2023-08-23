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
# test options
#

## test base dir
TEST := test

## test source path
TEST_SOURCE_PATH := $(TEST)

## test source files 
TEST_SOURCES := $(shell find ${TEST_SOURCE_PATH} -type f -name '*.java' -print)

## test source files modified since last compilation
TEST_MODIFIED_SOURCES :=

## test class output path
TEST_CLASS_OUTPUT := $(WORK)/test-classes

## test compiled classes
TEST_CLASSES := $(TEST_SOURCES:$(TEST_SOURCE_PATH)/%.java=$(TEST_CLASS_OUTPUT)/%.class)

## test compile-time dependencies
TEST_COMPILE_DEPS := $(call dependency,org.testng,testng,7.7.1)

## test compile-time class path
TEST_COMPILE_CLASS_PATH := $(call class-path,$(TEST_COMPILE_DEPS)) 

## test javac command
TEST_JAVACX = $(JAVAC)
TEST_JAVACX += -d $(TEST_CLASS_OUTPUT)
TEST_JAVACX += --class-path $(CLASS_OUTPUT)$(CLASS_PATH_SEPARATOR)$(TEST_COMPILE_CLASS_PATH)
TEST_JAVACX += $(TEST_MODIFIED_SOURCES)

## test runtime dependencies
TEST_RUNTIME_DEPS := $(TEST_COMPILE_DEPS)
TEST_RUNTIME_DEPS += $(call dependency,com.beust,jcommander,1.82)
TEST_RUNTIME_DEPS += $(call dependency,org.slf4j,slf4j-api,1.7.36)
TEST_RUNTIME_DEPS += $(call dependency,org.slf4j,slf4j-nop,1.7.36)

## test runtime module-path
TEST_RUNTIME_MODULE_PATH := $(call module-path,$(TEST_RUNTIME_DEPS))

## test java command
TEST_JAVAX = $(JAVA)
TEST_JAVAX += --module-path $(CLASS_OUTPUT)$(MODULE_PATH_SEPARATOR)$(TEST_RUNTIME_MODULE_PATH)
TEST_JAVAX += --add-modules org.testng
TEST_JAVAX += --add-reads $(MODULE)=org.testng
TEST_JAVAX += --patch-module $(MODULE)=$(TEST_CLASS_OUTPUT)
TEST_JAVAX += --module $(MODULE)/$(TESTING_MAIN)

#
# test target
#
.PHONY: test test-compile test-compile-deps test-classes test-runtime-deps
test: test-compile test-runtime-deps 
	$(TEST_JAVAX)

test-compile: compile test-compile-deps test-classes
	if [ -n "$(TEST_MODIFIED_SOURCES)" ]; then \
		$(TEST_JAVACX); \
	fi

test-compile-deps: $(TEST_COMPILE_DEPS)

test-classes: $(TEST_CLASSES)

$(TEST_CLASSES): $(TEST_CLASS_OUTPUT)/%.class: $(TEST_SOURCE_PATH)/%.java
	$(eval TEST_MODIFIED_SOURCES += $$<)

test-runtime-deps: $(TEST_RUNTIME_DEPS)
