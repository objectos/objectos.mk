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
# - you must provide the pom template $(MODULE)/pom.xml.tmpl

## @name@ pom source
@prefix@POM_SOURCE = $(@prefix@MODULE)/pom.xml.tmpl

## @name@ pom file
@prefix@POM_FILE = $(@prefix@WORK)/pom.xml

## @name@ pom external variables
# @prefix@POM_VARIABLES = 

## @name@ ossrh pom sed command
@prefix@POM_SEDX = $(SED)
@prefix@POM_SEDX += $(foreach var,$(POM_VARIABLES),--expression='s/@$(var)@/$($(var))/g')
@prefix@POM_SEDX += --expression='s/@COPYRIGHT_YEARS@/$(@prefix@COPYRIGHT_YEARS)/g'
@prefix@POM_SEDX += --expression='s/@ARTIFACT_ID@/$(@prefix@ARTIFACT_ID)/g'
@prefix@POM_SEDX += --expression='s/@GROUP_ID@/$(@prefix@GROUP_ID)/g'
@prefix@POM_SEDX += --expression='s/@VERSION@/$(@prefix@VERSION)/g'
@prefix@POM_SEDX += --expression='w $(@prefix@POM_FILE)'
@prefix@POM_SEDX += $(@prefix@POM_SOURCE)

#
# Targets
#

$(@prefix@POM_FILE): $(@prefix@POM_SOURCE) Makefile
	$(@prefix@POM_SEDX)
