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

## include release config
## - GH_TOKEN
-include $(HOME)/.config/objectos/release-config.mk

## GitHub API
GH_API := https://api.github.com/repos/objectos/$(ARTIFACT_ID)

## GitHub milestone title
GH_MILESTONE_TITLE := v$(VERSION)
GH_TAG := $(GH_MILESTONE_TITLE)

## GitHub milestones curl command
GH_MILESTONE_CURLX := $(CURL)
GH_MILESTONE_CURLX += '$(GH_API)/milestones'

## GitHub milestone number parsing
GH_MILESTONE_JQX := $(JQ)
GH_MILESTONE_JQX += '.[] | select(.title == "$(GH_MILESTONE_TITLE)") | .number'

## GitHub milestone ID
GH_MILESTONE_ID = $(shell $(GH_MILESTONE_CURLX) | $(GH_MILESTONE_JQX))

## Issues from GitHub
GH_ISSUES_JSON := $(WORK)/github-issues.json

## GitHub issues curl command
GH_ISSUES_CURLX = $(CURL)
GH_ISSUES_CURLX += '$(GH_API)/issues?milestone=$(GH_MILESTONE_ID)&per_page=100&state=all'
GH_ISSUES_CURLX += >
GH_ISSUES_CURLX += $(GH_ISSUES_JSON)

##
GH_RELEASE_BODY := $(WORK)/github-release.md

## Filter and format issues
GH_ISSUES_JQX = $(JQ)
GH_ISSUES_JQX += --arg LABEL "$(LABEL)"
GH_ISSUES_JQX += --raw-output
GH_ISSUES_JQX += 'sort_by(.number) | [.[] | {number: .number, title: .title, label: .labels[] | select(.name) | .name}] | .[] | select(.label == $$LABEL) | "- \(.title) \#\(.number)"'
GH_ISSUES_JQX += $(GH_ISSUES_JSON)

gh_issues = $(let LABEL,$1,$(GH_ISSUES_JQX))

##
GH_RELEASE_JSON := $(WORK)/github-release.json

##
GH_RELEASE_JQX = $(JQ)
GH_RELEASE_JQX += --raw-input
GH_RELEASE_JQX += --slurp
GH_RELEASE_JQX += '. as $$body | {"tag_name":"$(GH_TAG)","name":"Release $(GH_TAG)","body":$$body,"draft":true,"prerelease":false,"generate_release_notes":false}'
GH_RELEASE_JQX += $(GH_RELEASE_BODY)

## 
GH_RELEASE_CURLX := $(CURL)
GH_RELEASE_CURLX += --data-binary "@$(GH_RELEASE_JSON)"
GH_RELEASE_CURLX += --header "Accept: application/vnd.github+json"
GH_RELEASE_CURLX += --header "Authorization: Bearer $(GH_TOKEN)"
GH_RELEASE_CURLX += --header "X-GitHub-Api-Version: 2022-11-28"
GH_RELEASE_CURLX += --location
GH_RELEASE_CURLX += --request POST
GH_RELEASE_CURLX +=  $(GH_API)/releases
#
# Targets
#

.PHONY: release
release: $(GH_RELEASE_JSON)
	@$(GH_RELEASE_CURLX)

$(GH_ISSUES_JSON):
	$(GH_ISSUES_CURLX)
	
$(GH_RELEASE_BODY): $(GH_ISSUES_JSON)
	echo '## Enhancements' > $(GH_RELEASE_BODY)
	echo '' >> $(GH_RELEASE_BODY)
	$(call gh_issues,enhancement) >> $(GH_RELEASE_BODY) 
	echo '' >> $(GH_RELEASE_BODY)
	echo '## Bug Fixes' >> $(GH_RELEASE_BODY)
	echo '' >> $(GH_RELEASE_BODY)
	$(call gh_issues,bug) >> $(GH_RELEASE_BODY) 
	echo '' >> $(GH_RELEASE_BODY)
	echo '## Documentation' >> $(GH_RELEASE_BODY)
	echo '' >> $(GH_RELEASE_BODY)
	$(call gh_issues,documentation) >> $(GH_RELEASE_BODY) 

$(GH_RELEASE_JSON): $(GH_RELEASE_BODY)
	$(GH_RELEASE_JQX) > $(GH_RELEASE_JSON) 

.PHONY: milestone
milestone:
	echo $(GH_MILESTONE_ID)