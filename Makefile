NPM_EXECUTABLE_HOME := node_modules/.bin
PATH := ${NPM_EXECUTABLE_HOME}:${PATH}

TEST_DIR = ./spec

test: npm-dep
	jasmine-node --coffee --color --verbose ${TEST_DIR}

npm-dep:
	test `which npm` || echo 'You need npm to do npm install... makes sense?'

.SILENT:
.PHONY: build watch remove-js publish test npm-dep coffee-dep test-cov
