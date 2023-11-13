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
# Provides the pom target:
#
# - generates a pom.xml suitable for deploying to a maven repository
# 
# Requirements:
#
# - you must provide the pom template $$(MODULE)/pom.xml.tmpl

define POM_TASK

## pom source
$(1)POM_SOURCE = $$($(1)MODULE)/pom.xml.tmpl

## pom file
$(1)POM_FILE = $$($(1)WORK)/$$($(1)JAR_NAME)-$$($(1)VERSION).pom

## pom external variables
# $(1)POM_VARIABLES = 

## ossrh pom sed command
$(1)POM_SEDX = $$(SED)
$(1)POM_SEDX += $$(foreach var,$$(POM_VARIABLES),--expression='s/@$$(var)@/$$($$(var))/g')
$(1)POM_SEDX += --expression='s/@COPYRIGHT_YEARS@/$$($(1)COPYRIGHT_YEARS)/g'
$(1)POM_SEDX += --expression='s/@ARTIFACT_ID@/$$($(1)ARTIFACT_ID)/g'
$(1)POM_SEDX += --expression='s/@GROUP_ID@/$$($(1)GROUP_ID)/g'
$(1)POM_SEDX += --expression='s/@VERSION@/$$($(1)VERSION)/g'
$(1)POM_SEDX += --expression='s/@DESCRIPTION@/$$($(1)DESCRIPTION)/g'
$(1)POM_SEDX += --expression='w $$($(1)POM_FILE)'
$(1)POM_SEDX += $$($(1)POM_SOURCE)

#
# Targets
#

$$($(1)POM_FILE): $$($(1)POM_SOURCE) Makefile
	$$($(1)POM_SEDX)

endef