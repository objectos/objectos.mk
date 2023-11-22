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
# Objectos MK
#

GROUP_ID := br.com.objectos
ARTIFACT_ID := objectos.mk
VERSION := 0.2.0-SNAPSHOT

## resolver dir
RESOLVER = resolver

## resolver pom
RESOLVER_POM = $(RESOLVER)/pom.xml

## deps file
RESOLVER_DEPS = $(RESOLVER)/src/dep-tree

include tools.mk

## mvn command
MVNX := $(MVN)
MVNX += --file $(RESOLVER_POM)

# Delete the default suffixes
.SUFFIXES:

#
# Default target
#

.PHONY: all
all: resolver test

.PHONY: clean
clean:
	$(MVNX) clean

.PHONY: resolver
resolver: $(RESOLVER_DEPS)

$(RESOLVER_DEPS): $(RESOLVER_POM)
	$(MVNX) test

.PHONY: test
test:
	$(MVNX) test
