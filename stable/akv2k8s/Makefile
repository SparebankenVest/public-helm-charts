CUR_DIR = $(shell pwd)
TAG=

.PHONY: gen-docs
gen-docs:
	# -s = sort order -> file or alphanum
	docker run --rm --volume "$(CUR_DIR):/helm-docs" jnorwood/helm-docs:latest -s file

.PHONY: check-tag
check-tag:
ifndef TAG
	$(error TAG is undefined)
endif

.PHONY: tag-chart
tag-chart: check-tag
	git tag -a akv2k8s-$(TAG) -m "akv2k8s chart version $(TAG)"
	git push --tags
