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
# $(1) = prefix
# $(2) = final dep
# $(3) = deps

define merge-jars

## final jar file location
$(1)JAR := $$(call gav-to-local,$(2))

## final resolution file
$(1)RESOLUTION_FILE := $$(call gav-to-resolution-file,$(2))

## tmp dir
$(1)TMP := $$(WORK)/$(1)

## tmp resolution file
$(1)RESOLUTION_TMP := $$(WORK)/$(1)-resolution-file 

## local jars
$(1)LOCALS := $$(call deps-to-local,$(3))

## resolution files
$(1)RESOLUTION_FILES := $$(call to-resolution-files,$(3))

## cleanup
ifdef $(1)JAR_EXCLUDES
$(1)JAR_RM := rm -r $$(foreach f,$$($(1)JAR_EXCLUDES),$$($(1)TMP)/$$(f))
endif

#
# targets
#

.PHONY: $(1)
$(1): $$($(1)RESOLUTION_FILE) 

.PHONY: $(1)@clean
$(1)@clean:
	rm -rf $$($(1)RESOLUTION_FILE) $$($(1)RESOLUTION_TMP) $$($(1)JAR) $$($(1)TMP)
	
.PHONY: re-$(1)
re-$(1): $(1)@clean $(1)

$$($(1)TMP):
	for f in $$($(1)LOCALS); do \
		unzip -o $$$${f} -d $$@; \
	done

$$($(1)JAR): $$($(1)TMP)
ifdef $(1)JAR_RM
	$$($(1)JAR_RM)
endif
	$$(JAR) --create --file=$$@ -C $$($(1)TMP) .

$$($(1)RESOLUTION_TMP): $$($(1)RESOLUTION_FILES) $$($(1)JAR)
	echo $$($(1)JAR) > $$@
	for f in $$($(1)RESOLUTION_FILES); do \
		tail --lines=+2 $$$${f} >> $$@; \
	done

$$($(1)RESOLUTION_FILE): $$($(1)RESOLUTION_TMP)
	@mkdir --parents $$(@D)
	cp $$< $$@

endef
