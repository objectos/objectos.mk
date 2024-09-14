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
# Generates the Carbon stylesheet
#

## requirements
ifndef JAVA
$(error The required variable JAVA was not defined: please include java-core.mk)
endif

ifndef CLASS_OUTPUT
$(error The required variable CLASS_OUTPUT was not defined: please include java-compile.mk)
endif

## carbon output file
ifndef CARBON
$(error The required variable CARBON was not defined: output file name)
endif

## carbon way
ifndef CARBON_WAY
$(error The required variable CARBON_WAY was not defined: Objectos Way coordinates)
endif

## carbon resolution files
CARBON_RESOLUTION_FILES := $(call to-resolution-files,$(CARBON_WAY))

## dev module-path
CARBON_MODULE_PATH := $(WORK)/carbon-module-path

## carbon java command
CARBON_JAVAX := $(JAVA)
CARBON_JAVAX += --module-path @$(CARBON_MODULE_PATH)
CARBON_JAVAX += --module objectos.way/objectos.way.Carbon
CARBON_JAVAX += --class-output $(CLASS_OUTPUT)
CARBON_JAVAX += --output-file $(CARBON)

.PHONY: carbon
carbon: $(CARBON_MODULE_PATH) $(CARBON)
	$(CSS_JAVAX)

.PHONY: carbon@clean
carbon@clean:
	rm -f $(CARBON_MODULE_PATH) $(CARBON)

.PHONY: re-carbon
re-carbon: carbon@clean carbon

$(CARBON_MODULE_PATH): $(COMPILE_MARKER) $(CARBON_RESOLUTION_FILES)
	cat $(CARBON_RESOLUTION_FILES) > $@.tmp
	cat $@.tmp | paste --delimiter='$(MODULE_PATH_SEPARATOR)' --serial > $@

$(CARBON):
	$(CARBON_JAVAX)