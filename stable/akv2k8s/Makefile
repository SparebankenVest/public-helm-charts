CUR_DIR = $(shell pwd)

.PHONY: gen-docs
gen-docs:
	docker run --rm --volume "$(CUR_DIR):/helm-docs" jnorwood/helm-docs:latest -s file
