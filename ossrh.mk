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

## include ossrh config
## - OSSRH_GPG_KEY
## - OSSRH_GPG_PASSPHRASE
## - OSSRH_USERNAME
## - OSSRH_PASSWORD
-include $(HOME)/.config/objectos/ossrh-config.mk

## gpg command
GPGX = $(GPG)
GPGX += --armor
GPGX += --batch
GPGX += --default-key $(OSSRH_GPG_KEY)
GPGX += --detach-sign
GPGX += --passphrase $(OSSRH_GPG_PASSPHRASE)
GPGX += --pinentry-mode loopback
GPGX += --yes

## ossrh artifact
OSSRH_ARTIFACT := $(WORK)/$(ARTIFACT_ID)-$(VERSION)-bundle.jar

## ossrh jars
OSSRH_JARS := $(ARTIFACT)
OSSRH_JARS += $(POM_ARTIFACT)
OSSRH_JARS += $(SOURCE_ARTIFACT)
OSSRH_JARS += $(JAVADOC_ARTIFACT)

## ossrh sigs
OSSRH_SIGS := $(OSSRH_JARS:%=%.asc)

## ossrh jar command
OSSRH_JARX = $(JAR)
OSSRH_JARX += --create
OSSRH_JARX += --file $(OSSRH_ARTIFACT)
OSSRH_JARX += $(OSSRH_JARS:$(WORK)/%=-C $(WORK) %)
OSSRH_JARX += $(OSSRH_SIGS:$(WORK)/%=-C $(WORK) %)

## cookies
OSSRH_COOKIES := $(WORK)/ossrh-cookies.txt 

## ossrh login curl command
OSSRH_LOGIN_CURLX = $(CURL)
OSSRH_LOGIN_CURLX += --cookie-jar $(OSSRH_COOKIES)
OSSRH_LOGIN_CURLX += --output /dev/null
OSSRH_LOGIN_CURLX += --request GET
OSSRH_LOGIN_CURLX += --silent
OSSRH_LOGIN_CURLX += --url https://oss.sonatype.org/service/local/authentication/login
OSSRH_LOGIN_CURLX += --user $(OSSRH_USERNAME):$(OSSRH_PASSWORD)

## ossrh upload curl command
OSSRH_UPLOAD_CURLX = $(CURL)
OSSRH_UPLOAD_CURLX += --cookie $(OSSRH_COOKIES)
OSSRH_UPLOAD_CURLX += --header 'Content-Type: multipart/form-data'
OSSRH_UPLOAD_CURLX += --form file=@$(OSSRH_ARTIFACT)
OSSRH_UPLOAD_CURLX += --request POST
OSSRH_UPLOAD_CURLX += --url https://oss.sonatype.org/service/local/staging/bundle_upload

#
# ossrh target
#

.PHONY: ossrh-stage 
ossrh-stage: ossrh-bundle ossrh-login ossrh-upload

.PHONY: ossrh-bundle
ossrh-bundle: $(OSSRH_ARTIFACT)
	$(OSSRH_JARX)

.PHONY: ossrh-login
ossrh-login:
	@$(OSSRH_LOGIN_CURLX)

ossrh-upload:
	$(OSSRH_UPLOAD_CURLX)
	
$(OSSRH_ARTIFACT): $(OSSRH_SIGS)

%.asc: %
	@$(GPGX) $<
