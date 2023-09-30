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
# @name@ GitHub release
#

## @name@ GitHub API
ifndef @prefix@GH_API
@prefix@GH_API = https://api.github.com/repos/objectos/$(@prefix@ARTIFACT_ID)
endif

## @name@ GitHub milestone title
@prefix@GH_MILESTONE_TITLE = v$(@prefix@VERSION)

## @name@ GitHub milestones curl command
@prefix@GH_MILESTONE_CURLX = $(CURL)
@prefix@GH_MILESTONE_CURLX += '$(@prefix@GH_API)/milestones'

## @name@ GitHub milestone number parsing
@prefix@GH_MILESTONE_JQX = $(JQ)
@prefix@GH_MILESTONE_JQX += '.[] | select(.title == "$(@prefix@GH_MILESTONE_TITLE)") | .number'

## @name@ GitHub milestone ID
@prefix@GH_MILESTONE_ID = $(shell $(@prefix@GH_MILESTONE_CURLX) | $(@prefix@GH_MILESTONE_JQX))

## @name@ Issues from GitHub
@prefix@GH_ISSUES_JSON = $(@prefix@WORK)/gh-issues.json

## @name@ GitHub issues curl command
@prefix@GH_ISSUES_CURLX = $(CURL)
@prefix@GH_ISSUES_CURLX += '$(@prefix@GH_API)/issues?milestone=$(@prefix@GH_MILESTONE_ID)&per_page=100&state=all'
@prefix@GH_ISSUES_CURLX += >
@prefix@GH_ISSUES_CURLX += $(@prefix@GH_ISSUES_JSON)

##
@prefix@GH_RELEASE_BODY = $(@prefix@WORK)/gh-release.md

## @name@ Filter and format issues
@prefix@GH_ISSUES_JQX = $(JQ)
@prefix@GH_ISSUES_JQX += --arg LABEL "$(LABEL)"
@prefix@GH_ISSUES_JQX += --raw-output
@prefix@GH_ISSUES_JQX += 'sort_by(.number) | [.[] | {number: .number, title: .title, label: .labels[] | select(.name) | .name}] | .[] | select(.label == $$LABEL) | "- \(.title) \#\(.number)"'
@prefix@GH_ISSUES_JQX += $(@prefix@GH_ISSUES_JSON)

@prefix@gh_issues = $(let LABEL,$1,$(@prefix@GH_ISSUES_JQX))

##
@prefix@GH_RELEASE_JSON := $(@prefix@WORK)/gh-release.json

## @name@ git tag name to be generated
@prefix@GH_TAG := $(@prefix@GH_MILESTONE_TITLE)

##
@prefix@GH_RELEASE_JQX = $(JQ)
@prefix@GH_RELEASE_JQX += --raw-input
@prefix@GH_RELEASE_JQX += --slurp
@prefix@GH_RELEASE_JQX += '. as $$body | {"tag_name":"$(@prefix@GH_TAG)","name":"Release $(@prefix@GH_TAG)","body":$$body,"draft":true,"prerelease":false,"generate_release_notes":false}'
@prefix@GH_RELEASE_JQX += $(@prefix@GH_RELEASE_BODY)

## 
@prefix@GH_RELEASE_CURLX = $(CURL)
@prefix@GH_RELEASE_CURLX += --data-binary "@$(@prefix@GH_RELEASE_JSON)"
@prefix@GH_RELEASE_CURLX += --header "Accept: application/vnd.github+json"
@prefix@GH_RELEASE_CURLX += --header "Authorization: Bearer $(GH_TOKEN)"
@prefix@GH_RELEASE_CURLX += --header "X-GitHub-Api-Version: 2022-11-28"
@prefix@GH_RELEASE_CURLX += --location
@prefix@GH_RELEASE_CURLX += --request POST
@prefix@GH_RELEASE_CURLX +=  $(@prefix@GH_API)/releases

##
@prefix@GH_RELEASE_MARKER = $(@prefix@WORK)/gh-release-marker 

#
# @name@ GitHub release targets
#

$(@prefix@GH_RELEASE_MARKER): $(@prefix@GH_RELEASE_JSON)
	@$(@prefix@GH_RELEASE_CURLX)
	touch $@

$(@prefix@GH_RELEASE_JSON): $(@prefix@GH_RELEASE_BODY)
	$(@prefix@GH_RELEASE_JQX) > $(@prefix@GH_RELEASE_JSON) 

$(@prefix@GH_ISSUES_JSON):
	$(@prefix@GH_ISSUES_CURLX)

$(@prefix@GH_RELEASE_BODY): $(@prefix@GH_ISSUES_JSON)
	echo '## New features' > $(@prefix@GH_RELEASE_BODY)
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	$(call @prefix@gh_issues,t:feature) >> $(@prefix@GH_RELEASE_BODY) 
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	echo '## Enhancements' >> $(@prefix@GH_RELEASE_BODY)
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	$(call @prefix@gh_issues,t:enhancement) >> $(@prefix@GH_RELEASE_BODY) 
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	echo '## Bug Fixes' >> $(@prefix@GH_RELEASE_BODY)
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	$(call @prefix@gh_issues,t:bug) >> $(@prefix@GH_RELEASE_BODY) 
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	echo '## Documentation' >> $(@prefix@GH_RELEASE_BODY)
	echo '' >> $(@prefix@GH_RELEASE_BODY)
	$(call @prefix@gh_issues,t:documentation) >> $(@prefix@GH_RELEASE_BODY) 
