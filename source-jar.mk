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
# @name@ source-jar options
#

## @name@ source-jar file
@prefix@SOURCE_JAR_FILE = $(@prefix@WORK)/$(@prefix@JAR_NAME)-$(@prefix@VERSION)-sources.jar

## @name@ source-jar command
@prefix@SOURCE_JARX = $(JAR)
@prefix@SOURCE_JARX += --create
@prefix@SOURCE_JARX += --file $(@prefix@SOURCE_JAR_FILE)
@prefix@SOURCE_JARX += -C $(@prefix@MAIN)
@prefix@SOURCE_JARX += .

#
# @name@ source-jar targets
#

$(@prefix@SOURCE_JAR_FILE): $(@prefix@SOURCES)
	$(@prefix@SOURCE_JARX)
	