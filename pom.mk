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
# Provides the pom target
#
# - generates a pom.xml suitable for deploying to a maven repository 
#

## ossrh pom source
POM_SOURCE := pom-template.xml

## ossrh pom file
POM_ARTIFACT := $(WORK)/pom.xml

## ossrh pom sed command
POM_SEDX := $(SED)
POM_SEDX += --expression=s/%%ARTIFACT_ID%%/$(ARTIFACT_ID)/g
POM_SEDX += --expression=s/%%GROUP_ID%%/$(GROUP_ID)/g
POM_SEDX += --expression=s/%%VERSION%%/$(VERSION)/g
POM_SEDX += --expression='w $(POM_ARTIFACT)'
POM_SEDX += $(POM_SOURCE)

#
# Targets
#

.PHONY: pom
pom: $(POM_ARTIFACT)

$(POM_ARTIFACT): $(POM_SOURCE) Makefile
	$(POM_SEDX)
