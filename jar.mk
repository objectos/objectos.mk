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
# @name@ jar options
#

## @name@ license 'artifact'
@prefix@LICENSE = $(@prefix@CLASS_OUTPUT)/META-INF/LICENSE

## @name@ jar file path
@prefix@JAR_FILE = $(@prefix@WORK)/$(@prefix@JAR_NAME)-$(@prefix@VERSION).jar

## @name@ jar command
@prefix@JARX = $(JAR)
@prefix@JARX += --create
@prefix@JARX += --file $(@prefix@JAR_FILE)
@prefix@JARX += --module-version $(@prefix@VERSION)
@prefix@JARX += -C $(@prefix@CLASS_OUTPUT)
@prefix@JARX += .

#
# @name@ jar targets
#

$(@prefix@JAR_FILE): $(@prefix@COMPILE_MARKER) $(@prefix@LICENSE)
	$(@prefix@JARX)

$(@prefix@LICENSE): LICENSE
	mkdir --parents $(@D)
	cp LICENSE $(@D)
