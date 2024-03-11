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
# $(1) = module name
# $(2) = dst gav
# $(3) = src gav
# $(4) = deps

define module-info

## tmp JAR file name
$(1)TMP := $$(WORK)/$(1).jar

## final JAR file name
$(1)JAR_FILE := $$(call gav-to-local,$(2))

## final resolution file
$(1)RESOLUTION_FILE := $$(call gav-to-resolution-file,$(2))

## module-info.java
$(1)MODULE_INFO := modules/$(1)/module-info.java

## src resolution file
$(1)SRC_RESOLUTION_FILE := $$(call gav-to-resolution-file,$(3))

## module path (if necessary)
ifneq ($(4),)

## deps resolution files
$(1)DEPS_RESOLUTIONS := $$(call to-resolution-files,$(4))

## deps module path
$(1)MODULE_PATH := $$(WORK)/$(1)-module-path

endif

## src jar file
$(1)SRC_JAR_FILE := $$(call gav-to-local,$(3))

## the jdeps command
$(1)JDEPSX  = $$(JDEPS)
ifdef $(1)MODULE_PATH
$(1)JDEPSX += --module-path $$(file < $$($(1)MODULE_PATH))
endif
ifeq ($$($(1)_IGNORE_MISSING_DEPS),1)
$(1)JDEPSX += --ignore-missing-deps
endif
$(1)JDEPSX += --generate-module-info modules
$(1)JDEPSX += $$($(1)SRC_JAR_FILE)

## javac output directory
$(1)CLASS_OUTPUT := $$(WORK)/$(1)

## the javac command
$(1)JAVACX  = $$(JAVAC)
$(1)JAVACX += -d $$($(1)CLASS_OUTPUT)
ifdef $(1)MODULE_PATH
$(1)JAVACX += --module-path @$$($(1)MODULE_PATH)
endif
$(1)JAVACX += --patch-module $(1)=$$@
$(1)JAVACX += $$($(1)MODULE_INFO)

#
# foo
#

.PHONY: $(1)
$(1): $$($(1)RESOLUTION_FILE)

#
# foo@clean
#

.PHONY: $(1)@clean
$(1)@clean:
	rm -f $$($(1)JAR_FILE) $$($(1)RESOLUTION_FILE) $$($(1)TMP) $$($(1)MODULE_PATH)

$$($(1)MODULE_PATH): $$($(1)DEPS_RESOLUTIONS)
	cat $$^ | sort -u > $$@.tmp
	cat $$@.tmp | paste --delimiter='$(MODULE_PATH_SEPARATOR)' --serial > $$@

#
# Generates the module-info.java file
#

$$($(1)MODULE_INFO): $$($(1)MODULE_PATH)
	$$($(1)JDEPSX)

#
# Patches JAR file
#

$$($(1)TMP): $$($(1)SRC_RESOLUTION_FILE) $$($(1)MODULE_INFO)
	cp $$($(1)SRC_JAR_FILE) $$@
	rm -rf $$($(1)CLASS_OUTPUT)
	$$($(1)JAVACX)
	$(JAR) --update --file=$$@ -C $$($(1)CLASS_OUTPUT) .
	$(JAR) --describe-module --file=$$@

$$($(1)JAR_FILE): $$($(1)TMP)
	@mkdir --parents $$(@D)
	cp $$< $$@

$$($(1)RESOLUTION_FILE): $$($(1)JAR_FILE)
	@mkdir --parents $$(@D)
	echo "$$<" > $$@
ifdef $(1)DEPS_RESOLUTIONS
	cat $$($(1)DEPS_RESOLUTIONS) >> $$@
endif
	
endef
