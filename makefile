C_FILES = $(shell find src/$(GAME_NAME) -type f -name "*.c" ! -name "*.ase.c")
H_FILES = $(shell find src/$(GAME_NAME) -type f -name "*.h" ! -name "*.ase.h")

ASEPRITE_FILES = $(shell find src/$(GAME_NAME) -type f -name "*.ase")
ASEPRITE_C_FILES = $(ASEPRITE_FILES:src/$(GAME_NAME)/%.ase=src/$(GAME_NAME)/%.ase.c)
ASEPRITE_H_FILES = $(ASEPRITE_FILES:src/$(GAME_NAME)/%.ase=src/$(GAME_NAME)/%.ase.h)

SUBMODULE_C_FILES = $(shell find submodules -type f -name "*.c")
SUBMODULE_H_FILES = $(shell find submodules -type f -name "*.h")
SUBMODULE_FILES = $(SUBMODULE_C_FILES) $(SUBMODULE_H_FILES)

CONFIGURATION_FILES = makefile package-lock.json

all: dist/$(GAME_NAME).wasm

.SUFFIXES:

.PRECIOUS: $(ASEPRITE_H_FILES)

src/$(GAME_NAME)/%.ase.c src/$(GAME_NAME)/%.ase.h: src/$(GAME_NAME)/%.ase $(CONFIGURATION_FILES) $(SUBMODULE_FILES)
	npx neomura-c-tool-aseprite \
		--aseprite-file $< \
		--neomura-header-file submodules/neomura/c-library/neomura.h \
		--neomura-sprites-header-file submodules/neomura/c-library-sprites/sprites.h \
		--refresh-rate 60 \
		--output $<

tmp/$(GAME_NAME)/%.ll: src/$(GAME_NAME)/%.c $(CONFIGURATION_FILES) $(H_FILES) $(SUBMODULE_FILES) $(ASEPRITE_H_FILES)
	mkdir -p $(dir $@)
	clang-10 --target=wasm32 -emit-llvm -c -S -o $@ $<

tmp/$(GAME_NAME)/%.o: tmp/$(GAME_NAME)/%.ll
	mkdir -p $(dir $@)
	llc-10 -march=wasm32 -filetype=obj $< -o $@

dist/$(GAME_NAME).wasm: $(C_FILES:src/$(GAME_NAME)/%.c=tmp/$(GAME_NAME)/%.o) $(ASEPRITE_C_FILES:src/$(GAME_NAME)/%.c=tmp/$(GAME_NAME)/%.o)
	mkdir -p $(dir $@)
	wasm-ld-10 --no-entry --export-dynamic -o $@ $^
	wasm-opt -Oz $@ -o $@

clean:
	rm -rf dist/$(GAME_NAME).wasm src/$(GAME_NAME)/*.ase.c src/$(GAME_NAME)/*.ase.h tmp/$(GAME_NAME)
