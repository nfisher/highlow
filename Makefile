# ex : shiftwidth=2 tabstop=2 softtabstop=2 :
SHELL  = /bin/sh
PROJECT = github.com/nfisher/highlow
EXE  = $(GOPATH)/bin/highlow
SRC  = $(wildcard *.go)
TEST = $(wildcard *_test.go)

.PHONY: all
all: $(SRC) $(EXE) 

.PHONY: clean
clean:
	go clean -i ./...

.PHONY: format
format: $(SRC)
	go fmt ./...

.PHONY: cov
cov:
	go test -coverprofile $(TEST) $(PROJECT)

.PHONY: test
test:
	go test $(PROJECT)

.PHONY: run
run: $(EXE)
	$(EXE) 2000 "http://echo.maxymiser.qa/v5/?t="

$(EXE): test
	go install $(PROJECT)

