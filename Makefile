# ex : shiftwidth=2 tabstop=2 softtabstop=2 :
SHELL  = /bin/sh
EXE		 = bin/highlow
PKG    = github.com/nfisher/highlow
SRC    = $(wildcard src/github.com/nfisher/highlow/*.go)
TEST   = $(wildcard src/github.com/nfisher/highlow/*_test.go)
GOPATH = $(CURDIR)
export GOPATH

.PHONY: all
all: $(SRC) $(EXE) 

.PHONY: prep
prep:
	mkdir -p src/$(PKG)

.PHONY: clean
clean:
	rm -rf $(EXE)

.PHONY: format
format: $(SRC)
	go fmt $(PKG)

.PHONY: cov
cov:
	go test -coverprofile $(TEST) $(PKG)

.PHONY: test
test:
	go test $(PKG)

.PHONY: run
run: $(EXE)
	$(EXE) 2000 "http://echo.maxymiser.qa/v5/?t="

$(EXE): $(SRC) format test
	go install $(PKG)

