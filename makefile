C_FILES = $(shell find src/$(GAME_NAME) -type f -name "*.c")
H_FILES = $(shell find src/$(GAME_NAME) -type f -name "*.h")

SUBMODULE_C_FILES = $(shell find submodules -type f -name "*.c")
SUBMODULE_H_FILES = $(shell find submodules -type f -name "*.h")
SUBMODULE_FILES = $(SUBMODULE_C_FILES) $(SUBMODULE_H_FILES)

CONFIGURATION_FILES = makefile package.json

all: dist/$(GAME_NAME).wasm

tmp/$(GAME_NAME)/%.ll: src/$(GAME_NAME)/%.c $(CONFIGURATION_FILES) $(H_FILES) $(SUBMODULE_FILES)
	mkdir -p $(dir $@)
	clang-10 --target=wasm32 -emit-llvm -c -S -o $@ $<

tmp/$(GAME_NAME)/%.o: tmp/$(GAME_NAME)/%.ll
	mkdir -p $(dir $@)
	llc-10 -march=wasm32 -filetype=obj $< -o $@

dist/$(GAME_NAME).wasm: $(C_FILES:src/$(GAME_NAME)/%.c=tmp/$(GAME_NAME)/%.o)
	mkdir -p $(dir $@)
	wasm-ld-10 --no-entry --export-dynamic -o $@ $^
	wasm-opt -Oz $@ -o $@

clean:
	rm -rf dist/$(GAME_NAME).wasm tmp/$(GAME_NAME)
