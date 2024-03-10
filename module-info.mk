#
# Copyright (C) 2024 Objectos Software LTDA.
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
# module-info task
#
# requires:
# - tools.mk
# - resolver.mk
#
# $(1) = module name

define module-info

## add this module to the ALL variable
ALL += $(1)

## GAV for this module
$(1)GAV := $(2)

## JAR file name
$(1)JAR := $$(WORK)/$(1).jar

## javac output directory
$(1)CLASS_OUTPUT := $$(WORK)/$(1)

## module path (if necessary)
ifneq ($(3),)
$(1)MODULE_PATH := $$(call module-path,$$(foreach dep,$(3),$$(WORK)/$$(dep).jar))
endif

## the jdeps command
$(1)JDEPSX := $$(JDEPS)
ifdef $(1)MODULE_PATH
$(1)JDEPSX += --module-path $$($(1)MODULE_PATH)
endif
ifeq ($$(IGNORE_MISSING_DEPS),1)
$(1)JDEPSX += --ignore-missing-deps
endif
$(1)JDEPSX += --generate-module-info modules
$(1)JDEPSX += $$(call gav-to-local,$$($(1)GAV))

## the javac command
$(1)JAVACX  = $$(JAVAC)
$(1)JAVACX += -d $$($(1)CLASS_OUTPUT)
ifdef $(1)MODULE_PATH
$(1)JAVACX += --module-path $$($(1)MODULE_PATH)
endif
$(1)JAVACX += --patch-module $(1)=$$@
$(1)JAVACX += $$^

#
# Targets
#

.PHONY: $(1)
$(1): $$($(1)JAR)

#
# foo@clean
#

.PHONY: $(1)@clean
$(1)@clean:
	rm -f $$($(1)JAR)

#
# Generates the module-info.java file
#

($1)INFO_REQS := $$(foreach dep,$(3),$$(WORK)/$(dep).jar) 

modules/$(1)/module-info.java: $$(RESOLUTION_DIR)/$$($(1)GAV) $$($(1)INFO_REQS)
	$$($(1)JDEPSX)

#
# Patches JAR file
#

$$($(1)JAR): modules/$(1)/module-info.java $(4)
	cp $$(call gav-to-local,$$($(1)GAV)) $$@
	rm -rf $$($(1)CLASS_OUTPUT)
	$$($(1)JAVACX)
	jar --update --file=$$@ -C $$($(1)CLASS_OUTPUT) .
	jar --describe-module --file=$$@
	
.PHONY: $(1)@install
$(1)@install: $(1)
	@mkdir --parents $$(LOCAL_REPO_PATH)/objectos.factoring.libs/
	cp $$($(1)JAR) $$(LOCAL_REPO_PATH)/objectos.factoring.libs/

endef
