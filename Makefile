NPM_BIN := node_modules/.bin

TEST_DIR = ./spec

test: npm-dep
	${NPM_BIN}/jasmine-node --coffee --color --verbose ${TEST_DIR}

npm-dep:
	test `which npm` || echo 'You need npm to do npm install... makes sense?'

.SILENT:
.PHONY: build watch remove-js publish test npm-dep coffee-dep test-cov
