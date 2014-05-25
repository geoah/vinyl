NPM_BIN := node_modules/.bin

TEST_DIR = test/lib/*.coffee

test: npm-dep
	${NPM_BIN}/mocha --compilers coffee:coffee-script/register ${TEST_DIR}

npm-dep:
	test `which npm` || echo 'You need npm to do npm install... makes sense?'

.SILENT:
.PHONY: build watch remove-js publish test npm-dep coffee-dep test-cov
