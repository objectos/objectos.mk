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
# javadoc task
#

define JAVADOC_TASK

## javadoc output path
$(1)JAVADOC_OUTPUT = $$($(1)WORK)/javadoc

## javadoc marker
$(1)JAVADOC_MARKER = $$($(1)JAVADOC_OUTPUT)/index.html

## javadoc command
$(1)JAVADOCX = $$(JAVADOC)
$(1)JAVADOCX += -d $$($(1)JAVADOC_OUTPUT)
ifeq ($$($(1)ENABLE_PREVIEW),1)
$(1)JAVADOCX += --enable-preview
endif
$(1)JAVADOCX += --module $$($(1)MODULE)
ifneq ($$($(1)COMPILE_MODULE_PATH),)
$(1)JAVADOCX += --module-path $$($(1)COMPILE_MODULE_PATH)
endif
$(1)JAVADOCX += --module-source-path "./*/main"
$(1)JAVADOCX += --release $$($(1)JAVA_RELEASE)
$(1)JAVADOCX += --show-module-contents api
$(1)JAVADOCX += --show-packages exported
ifdef $(1)JAVADOC_SNIPPET_PATH
$(1)JAVADOCX += --snippet-path $$($$($(1)JAVADOC_SNIPPET_PATH))
endif 
$(1)JAVADOCX += -bottom 'Copyright &\#169; $$($(1)COPYRIGHT_YEARS) <a href="https://www.objectos.com.br/">Objectos Software LTDA</a>. All rights reserved.'
$(1)JAVADOCX += -charset 'UTF-8'
$(1)JAVADOCX += -docencoding 'UTF-8'
$(1)JAVADOCX += -doctitle '$$($(1)GROUP_ID):$$($(1)ARTIFACT_ID) $$($(1)VERSION) API'
$(1)JAVADOCX += -encoding 'UTF-8'
$(1)JAVADOCX += -use
$(1)JAVADOCX += -version
$(1)JAVADOCX += -windowtitle '$$($(1)GROUP_ID):$$($(1)ARTIFACT_ID) $$($(1)VERSION) API'

## javadoc jar file
$(1)JAVADOC_JAR_FILE = $$($(1)WORK)/$$($(1)ARTIFACT_ID)-$$($(1)VERSION)-javadoc.jar

## javadoc jar command
$(1)JAVADOC_JARX = $$(JAR)
$(1)JAVADOC_JARX += --create
$(1)JAVADOC_JARX += --file $$($(1)JAVADOC_JAR_FILE)
$(1)JAVADOC_JARX += -C $$($(1)JAVADOC_OUTPUT)
$(1)JAVADOC_JARX += .

#
# javadoc targets
#

$$($(1)JAVADOC_JAR_FILE): $$($(1)JAVADOC_MARKER)
	$$($(1)JAVADOC_JARX)

$$($(1)JAVADOC_MARKER): $$($(1)SOURCES)
	$$($(1)JAVADOCX)

endef
