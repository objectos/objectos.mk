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

LIBRARY_HEAD := library-head.mk

LIBRARY_BODY := common-tools.mk
LIBRARY_BODY += common-deps.mk
LIBRARY_BODY += common-jar.mk
LIBRARY_BODY += common-test.mk
LIBRARY_BODY += common-install.mk
LIBRARY_BODY += common-source-jar.mk
LIBRARY_BODY += common-javadoc.mk
LIBRARY_BODY += common-pom.mk
LIBRARY_BODY += common-ossrh.mk
LIBRARY_BODY += common-release.mk

LIBRARY_ARTIFACT := library.mk 

.PHONY: all
all: clean library

.PHONY: clean
clean:
	rm $(LIBRARY_ARTIFACT)

.PHONY: library
library: $(LIBRARY_ARTIFACT)

$(LIBRARY_ARTIFACT): $(LIBRARY_HEAD) $(LIBRARY_BODY)
	 echo $(LIBRARY_BODY) | xargs tail -n +16 --quiet | cat $(LIBRARY_HEAD) - > $(LIBRARY_ARTIFACT)