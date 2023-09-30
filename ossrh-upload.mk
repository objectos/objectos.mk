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

## @name@ ossrh cookies
@prefix@OSSRH_COOKIES = $(@prefix@WORK)/ossrh-cookies.txt 

## @name@ ossrh login curl command
@prefix@OSSRH_LOGIN_CURLX = $(CURL)
@prefix@OSSRH_LOGIN_CURLX += --cookie-jar $(@prefix@OSSRH_COOKIES)
@prefix@OSSRH_LOGIN_CURLX += --output /dev/null
@prefix@OSSRH_LOGIN_CURLX += --request GET
@prefix@OSSRH_LOGIN_CURLX += --silent
@prefix@OSSRH_LOGIN_CURLX += --url https://oss.sonatype.org/service/local/authentication/login
@prefix@OSSRH_LOGIN_CURLX += --user $(OSSRH_USERNAME):$(OSSRH_PASSWORD)

## @name@ ossrh response json
@prefix@OSSRH_UPLOAD_JSON = $(@prefix@WORK)/ossrh-upload.json

## @name@ ossrh upload curl command
@prefix@OSSRH_UPLOAD_CURLX = $(CURL)
@prefix@OSSRH_UPLOAD_CURLX += --cookie $(@prefix@OSSRH_COOKIES)
@prefix@OSSRH_UPLOAD_CURLX += --header 'Content-Type: multipart/form-data'
@prefix@OSSRH_UPLOAD_CURLX += --form file=@$(@prefix@OSSRH_BUNDLE)
@prefix@OSSRH_UPLOAD_CURLX += --output $(@prefix@OSSRH_UPLOAD_JSON)
@prefix@OSSRH_UPLOAD_CURLX += --request POST
@prefix@OSSRH_UPLOAD_CURLX += --url https://oss.sonatype.org/service/local/staging/bundle_upload

## @name@ ossrh repository id sed parsing
@prefix@OSSRH_SEDX = $(SED)
@prefix@OSSRH_SEDX += --regexp-extended
@prefix@OSSRH_SEDX += --silent
@prefix@OSSRH_SEDX += 's/^.*repositories\/(.*)".*/\1/p'
@prefix@OSSRH_SEDX += $(@prefix@OSSRH_UPLOAD_JSON)

## @name@ repository id
@prefix@OSSRH_REPOSITORY_ID = $(shell $(@prefix@OSSRH_SEDX))

## @name@ ossrh release curl command
@prefix@OSSRH_RELEASE_CURLX = $(CURL)
@prefix@OSSRH_RELEASE_CURLX += --cookie $(@prefix@OSSRH_COOKIES)
@prefix@OSSRH_RELEASE_CURLX += --data '{"data":{"autoDropAfterRelease":true,"description":"","stagedRepositoryIds":["$(@prefix@OSSRH_REPOSITORY_ID)"]}}'
@prefix@OSSRH_RELEASE_CURLX += --header 'Content-Type: application/json'
@prefix@OSSRH_RELEASE_CURLX += --request POST
@prefix@OSSRH_RELEASE_CURLX += --url https://oss.sonatype.org/service/local/staging/bulk/promote

## @name@ ossrh marker
@prefix@OSSRH_MARKER = $(@prefix@WORK)/ossrh-marker

#
# @name@ ossrh targets
#

@prefix@OSSRH_MARKER: $(@prefix@OSSRH_UPLOAD_JSON)
	@for i in 1 2 3; do \
	  echo "Waiting before release..."; \
	  sleep 45; \
	  echo "Trying to release $(@prefix@OSSRH_REPOSITORY_ID)"; \
	  $(@prefix@OSSRH_RELEASE_CURLX); \
	  if [ $$? -eq 0 ]; then \
	    exit 0; \
	  fi \
	done
	touch $@

$(@prefix@OSSRH_UPLOAD_JSON): $(@prefix@OSSRH_BUNDLE)
	@$(@prefix@OSSRH_LOGIN_CURLX)
	$(@prefix@OSSRH_UPLOAD_CURLX)
