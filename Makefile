SILENT= > /dev/null
SHELL := /usr/bin/env bash -eo pipefail -c

define PREPARE_ENV
	source ./.github/gen_env.sh;
endef

###############################################

pre-commit.install:
	@pre-commit install && \
		pre-commit install --hook-type commit-msg

###############################################

infra.init:
	@printf "InitDeploying infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh

infra.apply:
	@printf "Deploying infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh apply

infra.destroy:
	@printf "Destroy infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh destroy

infra.plan:
	@printf "Plan infrastructure...\n"
	${PREPARE_ENV} \
		./infra/tf.sh plan

###############################################

build:
	@printf "Build...\n"
	@pushd ./livecraft && \
		go build -o livecraft livecraft.go && \
		chmod +x livecraft && \
		popd

bin.test:
	@printf "Test...\n"
	@printf "Add permissions...\n"
	@chmod +x livecraft/livecraft
	@printf "Run tests...\n"
	@printf "Run plan...\n"
	@livecraft/livecraft infra/tf.sh plan
	@printf "Run apply...\n"
	@livecraft/livecraft infra/tf.sh apply
	@printf "Run destroy...\n"
	@livecraft/livecraft infra/tf.sh destroy

go.test :
	@printf "Test...\n"
	@pushd ./livecraft && \
		go test -v ./... && \
		popd

###############################################

mr.clean:
	@printf "Clean Environment...\n"
	@${PREPARE_ENV} \
		if [ $${STAGE} == "prod" ]; \
		then \
			echo "We don't clean PRODUCTION :)"; \
		else \
			./infra/tf.sh destroy && \
			rm -rf ./infra/terraform/.terraform && \
			rm -rf ./infra/terraform/terraform.tfstate* && \
			rm -rf ./infra/terraform/terraform.lock.hcl && \
			rm -rf ./infra/plan/out.plan; \
		fi \


###############################################

update-golang:
	@printf "Update Golang...\n"
	@go get -u ./... && go mod tidy
