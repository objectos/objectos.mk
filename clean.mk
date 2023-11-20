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
# clean task
#

define CLEAN_TASK

## work dir
$(1)WORK = $$($(1)MODULE)/work

## targets

.PHONY: $(2)clean
$(2)clean:
ifneq ($$($(1)WORK),)
	rm -rf $$($(1)WORK)/*
else
	@echo "Cannot clean: $(1)WORK was not defined!"
endif
	
endef