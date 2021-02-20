CUR_DIR = $(shell pwd)

.PHONY: gen-docs
gen-docs:
	# -s = sort order -> file or alphanum
	docker run --rm --volume "$(CUR_DIR):/helm-docs" jnorwood/helm-docs:latest -s file
