REPORTER = list

test:
		@NODE_ENV=test ./node_modules/.bin/mocha -u bdd --timeout 5s --reporter $(REPORTER) --compilers coffee:coffee-script/register --require coffee-script

test-cov: lib-cov
		@HPUB_COV=1 $(MAKE) test REPORTER=html-cov > test/coverage.html

lib-cov:
		@rm -fr ./$@
		@jscoverage --no-highlight lib $@

clean:
		rm -f test/coverage.html
		rm -fr lib-cov

.PHONY: test test-cov lib-cov clean
