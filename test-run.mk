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
# @name@ test execution options
#

## @name@ test runtime dependencies
# @prefix@TEST_RUNTIME_DEPS =

## @name@ test main class
ifndef @prefix@TEST_MAIN
@prefix@TEST_MAIN = $(@prefix@MODULE).RunTests
endif

## @name@ test runtime output path
@prefix@TEST_RUNTIME_OUTPUT = $(@prefix@WORK)/test-output

## @name@ test java command
@prefix@TEST_JAVAX = $(JAVA)
@prefix@TEST_JAVAX += --module-path $(call module-path,$(@prefix@TEST_RUNTIME_DEPS))
@prefix@TEST_JAVAX += --add-modules org.testng
@prefix@TEST_JAVAX += --add-reads $(@prefix@MODULE)=org.testng
ifdef @prefix@TEST_JAVAX_EXPORTS
@prefix@TEST_JAVAX += $(foreach pkg,$(@prefix@TEST_JAVAX_EXPORTS),--add-exports $(@prefix@MODULE)/$(pkg)=org.testng)
endif
ifeq ($(@prefix@ENABLE_PREVIEW),1)
@prefix@TEST_JAVAX += --enable-preview
endif
@prefix@TEST_JAVAX += --patch-module $(@prefix@MODULE)=$(@prefix@TEST_CLASS_OUTPUT)
@prefix@TEST_JAVAX += --module $(@prefix@MODULE)/$(@prefix@TEST_MAIN)
@prefix@TEST_JAVAX += $(@prefix@TEST_RUNTIME_OUTPUT)

## @name@ test execution marker
@prefix@TEST_RUN_MARKER = $(@prefix@TEST_RUNTIME_OUTPUT)/index.html

#
# @name@ test execution targets
#

$(@prefix@TEST_RUN_MARKER): $(@prefix@TEST_COMPILE_MARKER) 
	$(@prefix@TEST_JAVAX)
