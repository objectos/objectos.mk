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
# @name@ javadoc options
#

## @name@ javadoc output path
@prefix@JAVADOC_OUTPUT = $(@prefix@WORK)/javadoc

## @name@ javadoc marker
@prefix@JAVADOC_MARKER = $(@prefix@JAVADOC_OUTPUT)/index.html

## @name@ javadoc command
@prefix@JAVADOCX = $(JAVADOC)
@prefix@JAVADOCX += -d $(@prefix@JAVADOC_OUTPUT)
ifeq ($(@prefix@ENABLE_PREVIEW),1)
@prefix@JAVADOCX += --enable-preview
endif
@prefix@JAVADOCX += --module $(@prefix@MODULE)
ifneq ($(@prefix@COMPILE_MODULE_PATH),)
@prefix@JAVADOCX += --module-path $(@prefix@COMPILE_MODULE_PATH)
endif
@prefix@JAVADOCX += --module-source-path "./*/main"
@prefix@JAVADOCX += --release $(@prefix@JAVA_RELEASE)
@prefix@JAVADOCX += --show-module-contents api
@prefix@JAVADOCX += --show-packages exported
ifdef @prefix@JAVADOC_SNIPPET_PATH
@prefix@JAVADOCX += --snippet-path $($(@prefix@JAVADOC_SNIPPET_PATH))
endif 
@prefix@JAVADOCX += -bottom 'Copyright &\#169; $(@prefix@COPYRIGHT_YEARS) <a href="https://www.objectos.com.br/">Objectos Software LTDA</a>. All rights reserved.'
@prefix@JAVADOCX += -charset 'UTF-8'
@prefix@JAVADOCX += -docencoding 'UTF-8'
@prefix@JAVADOCX += -doctitle '$(@prefix@GROUP_ID):$(@prefix@ARTIFACT_ID) $(@prefix@VERSION) API'
@prefix@JAVADOCX += -encoding 'UTF-8'
@prefix@JAVADOCX += -use
@prefix@JAVADOCX += -version
@prefix@JAVADOCX += -windowtitle '$(@prefix@GROUP_ID):$(@prefix@ARTIFACT_ID) $(@prefix@VERSION) API'

## @name@ javadoc jar file
@prefix@JAVADOC_JAR_FILE = $(@prefix@WORK)/$(@prefix@ARTIFACT_ID)-$(@prefix@VERSION)-javadoc.jar

## @name@ javadoc jar command
@prefix@JAVADOC_JARX = $(JAR)
@prefix@JAVADOC_JARX += --create
@prefix@JAVADOC_JARX += --file $(@prefix@JAVADOC_JAR_FILE)
@prefix@JAVADOC_JARX += -C $(@prefix@JAVADOC_OUTPUT)
@prefix@JAVADOC_JARX += .

#
# @name@ javadoc targets
#

$(@prefix@JAVADOC_JAR_FILE): $(@prefix@JAVADOC_MARKER)
	$(@prefix@JAVADOC_JARX)

$(@prefix@JAVADOC_MARKER): $(@prefix@SOURCES)
	$(@prefix@JAVADOCX)
