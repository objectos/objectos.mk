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
# Eclipse targets
#

#
# eclipse-classpath
#

## Eclipse classpath file
ECLIPSE_CLASSPATH := .classpath

## Eclipse classpath template
define ECLIPSE_CLASSPATH_TMPL
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
	<classpathentry kind="src" output="work/main" path="main"/>
	<classpathentry kind="src" output="work/test" path="test">
		<attributes>
			<attribute name="test" value="true"/>
		</attributes>
	</classpathentry>
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-21">
		<attributes>
			<attribute name="module" value="true"/>
		</attributes>
	</classpathentry>
$(1)	<classpathentry kind="output" path="eclipse-bin"/>
</classpath>
endef

## Eclipse classpath entry template
define ECLIPSE_CLASSPATH_ENTRY
	<classpathentry kind="lib" path="$(1)"/>

endef

## Eclipse classpath deps
#ECLIPSE_CLASSPATH_DEPS :=

## Eclipse classpath libraries
ECLIPSE_CLASSPATH_LIBS := $(foreach dep,$(ECLIPSE_CLASSPATH_DEPS),$(file < $(dep)))

## Eclipse classpath entries
ECLIPSE_CLASSPATH_ENTRIES := $(foreach lib,$(sort $(ECLIPSE_CLASSPATH_LIBS)),$(call ECLIPSE_CLASSPATH_ENTRY,$(lib)))

.PHONY: eclipse-classpath
eclipse-classpath:
	$(file > $(ECLIPSE_CLASSPATH),$(call ECLIPSE_CLASSPATH_TMPL,$(ECLIPSE_CLASSPATH_ENTRIES)))
