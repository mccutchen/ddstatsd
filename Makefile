BIN_NAME    ?= ddstatsd
BUILD_DIR   ?= build
BUILD_FLAGS ?= -ldflags="-s -w"
DIST_DIR    ?= dist

$(BUILD_DIR)/$(BIN_NAME): main.go
	mkdir -p $(BUILD_DIR)
	go build $(BUILD_FLAGS) -o $(BUILD_DIR)/$(BIN_NAME) main.go

dist: $(BUILD_DIR)/$(BIN_NAME)
	mkdir -p $(DIST_DIR)
	ls -lah $(BUILD_DIR)
	sudo chown 0:0 $(BUILD_DIR)/$(BIN_NAME)
	tar -C $(BUILD_DIR) -czvf $(DIST_DIR)/$(BIN_NAME).tar.gz $(BIN_NAME)

test: main.go main_test.go
	go test -v -race ./...

clean:
	rm -fr $(BUILD_DIR) $(DIST_DIR)
.PHONY: clean
