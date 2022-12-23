# Copyright (C) Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

include hack/commons.mk

# ====================================
# D E V E L O P M E N T
# ====================================

##@ Development

.PHONY: clean
clean: ## Cleanup
	@echo -e "$(OK_COLOR)[$(BANNER)] Cleanup$(NO_COLOR)"
	@rm -fr vendor

.PHONY: check
check: check-inspec ## Check requirements

.PHONY: init
init: ## Initialize environment
	@poetry install

.PHONY: validate
validate: ## Execute git-hooks
	@pre-commit run -a


# ====================================
# I N S P E C
# ====================================

##@ Inspec

.PHONY: inspec-init
inspec-init: ## Initialize
	@echo -e "$(OK_COLOR)Install requirements$(NO_COLOR)"
	@gem install inspec inspec-bin bundler

.PHONY: inspec-deps
inspec-deps: ## Install requirements
	@echo -e "$(OK_COLOR)Install requirements$(NO_COLOR)"
	@PATH=${HOME}/.gem/ruby/3.0.0/bin/:${PATH} bundle config set path vendor/bundle --local \
		&& PATH=${HOME}/.gem/ruby/3.0.0/bin/:${PATH} bundle install
