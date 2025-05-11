.PHONY: build docs

build:
	dub build --compiler ldc2 --debug debug

docs:
	rm -rf docs/api
	cd docs && dub run adrdox -- ../source -o api --genSearchIndex
	cp docs/style.css docs/api/
