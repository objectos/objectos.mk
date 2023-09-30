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

## @name@ gpg command
@prefix@GPGX = $(GPG)
@prefix@GPGX += --armor
@prefix@GPGX += --batch
@prefix@GPGX += --default-key $(OSSRH_GPG_KEY)
@prefix@GPGX += --detach-sign
@prefix@GPGX += --passphrase $(OSSRH_GPG_PASSPHRASE)
@prefix@GPGX += --pinentry-mode loopback
@prefix@GPGX += --yes

## @name@ ossrh bundle jar file
@prefix@OSSRH_BUNDLE = $(@prefix@WORK)/$(@prefix@ARTIFACT_ID)-$(@prefix@VERSION)-bundle.jar

## @name@ ossrh bundle contents
@prefix@OSSRH_CONTENTS = $(@prefix@POM_FILE)
@prefix@OSSRH_CONTENTS += $(@prefix@JAR_FILE)
@prefix@OSSRH_CONTENTS += $(@prefix@SOURCE_JAR_FILE)
@prefix@OSSRH_CONTENTS += $(@prefix@JAVADOC_JAR_FILE)

## @name@ ossrh sigs
@prefix@OSSRH_SIGS = $(@prefix@OSSRH_CONTENTS:%=%.asc)

## @name@ ossrh bundle jar command
@prefix@OSSRH_JARX = $(JAR)
@prefix@OSSRH_JARX += --create
@prefix@OSSRH_JARX += --file $(@prefix@OSSRH_BUNDLE)
@prefix@OSSRH_JARX += $(@prefix@OSSRH_CONTENTS:$(@prefix@WORK)/%=-C $(@prefix@WORK) %)
@prefix@OSSRH_JARX += $(@prefix@OSSRH_SIGS:$(@prefix@WORK)/%=-C $(@prefix@WORK) %)

#
# @name@ ossrh bundle targets
#

$(@prefix@OSSRH_BUNDLE): $(@prefix@OSSRH_SIGS)
	$(@prefix@OSSRH_JARX)

%.asc: %
	@$(@prefix@GPGX) $<
