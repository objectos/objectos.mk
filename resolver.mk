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
# Dependencies related options & functions
#

## local repository path
LOCAL_REPO_PATH := $(HOME)/.cache/objectos/repo

## remote repository URL
REMOTE_REPO_URL := https://repo.maven.apache.org/maven2

## remote repository curl
REMOTE_REPO_CURLX = $(CURL)
REMOTE_REPO_CURLX += --create-dirs

## gets the dependency from the remote repository
$(LOCAL_REPO_PATH)/%.jar:	
	$(REMOTE_REPO_CURLX) --output $@ $(@:$(LOCAL_REPO_PATH)/%.jar=$(REMOTE_REPO_URL)/%.jar)

## to-deps function

word-colon = $(word $2, $(subst :, , $1))

mk-path = $(LOCAL_REPO_PATH)/$(subst $(dot),$(solidus),$(1))/$(2)/$(3)/$(2)-$(3)

to-path = $(call mk-path,$(call word-colon,$(1),1),$(call word-colon,$(1),2),$(call word-colon,$(1),3))

to-jars = $(foreach dep,$(1),$(call to-path, $(dep)).jar)

to-deps = $(foreach dep,$(1),$(call to-path, $(dep)).deps)

## resolver path
ifndef RESOLVER_PATH
RESOLVER_PATH = .
endif

## Resolver.java path
RESOLVER_JAVA = $(RESOLVER_PATH)/Resolver.java

## Resolver.java deps
RESOLVER_DEPS  = commons-codec:commons-codec:1.16.0
RESOLVER_DEPS += org.apache.commons:commons-lang3:3.12.0
RESOLVER_DEPS += org.apache.httpcomponents:httpclient:4.5.14
RESOLVER_DEPS += org.apache.httpcomponents:httpcore:4.4.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-api:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-connector-basic:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-impl:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-named-locks:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-spi:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-supplier:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-transport-file:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-transport-http:1.9.16
RESOLVER_DEPS += org.apache.maven.resolver:maven-resolver-util:1.9.16
RESOLVER_DEPS += org.apache.maven:maven-artifact:3.9.4
RESOLVER_DEPS += org.apache.maven:maven-builder-support:3.9.4
RESOLVER_DEPS += org.apache.maven:maven-model-builder:3.9.4
RESOLVER_DEPS += org.apache.maven:maven-model:3.9.4
RESOLVER_DEPS += org.apache.maven:maven-repository-metadata:3.9.4
RESOLVER_DEPS += org.apache.maven:maven-resolver-provider:3.9.4
RESOLVER_DEPS += org.codehaus.plexus:plexus-interpolation:1.26
RESOLVER_DEPS += org.codehaus.plexus:plexus-utils:3.5.1
RESOLVER_DEPS += org.slf4j:jcl-over-slf4j:1.7.36
RESOLVER_DEPS += org.slf4j:slf4j-api:1.7.36
RESOLVER_DEPS += org.slf4j:slf4j-nop:1.7.36

## Resolver.java jars
RESOLVER_DEPS_JARS = $(call to-jars,$(RESOLVER_DEPS))

## resolve java command
RESOLVEX  = $(JAVA)
RESOLVEX += --class-path $(call class-path,$(RESOLVER_DEPS_JARS))
RESOLVEX += $(RESOLVER_JAVA)
RESOLVEX += --local-repo $(LOCAL_REPO_PATH)

## dependency function
## 
## syntax:
## $(call dependency,[GROUP_ID],[ARTIFACT_ID],[VERSION])
dot := .
solidus := /

dependency = $(LOCAL_REPO_PATH)/$(subst $(dot),$(solidus),$(1))/$(2)/$(3)/$(2)-$(3).jar

## class-path function
##
## syntax:
## $(call class-path,[list of deps])
ifeq ($(OS),Windows_NT)
CLASS_PATH_SEPARATOR := ;
else
CLASS_PATH_SEPARATOR := :
endif
empty :=
space := $(empty) $(empty)

class-path = $(subst $(space),$(CLASS_PATH_SEPARATOR),$(1))

## module-path function
##
## syntax:
## $(call module-path,[list of deps])
MODULE_PATH_SEPARATOR := :

mk-module-path = $(subst $(space),$(MODULE_PATH_SEPARATOR),$(1))

module-path = $(call mk-module-path,$(shell $(RESOLVEX) $(DEPS)))
