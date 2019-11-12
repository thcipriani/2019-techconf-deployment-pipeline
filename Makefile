deploy: build
	rsync -avz --no-perms --exclude=".git/**" . people1001.eqiad.wmnet:public_html/pipeline-techconf/.

build: fetch
	pandoc --standalone -f markdown -t revealjs --slide-level=2 README.md -V theme=solarized -o index.html

fetch:
	curl -SLo README.md https://etherpad.tylercipriani.com/p/2019pipeline/export/txt

serve:
	python -mSimpleHTTPServer

.PHONY: build fetch deploy serve
