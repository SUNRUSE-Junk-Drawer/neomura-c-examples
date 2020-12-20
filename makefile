SRC_C = $(shell find src -type f -name "*.c")
SRC_H = $(shell find src -type f -name "*.h")
SUBMODULES_C = $(shell find submodules -type f -name "*.c")
SUBMODULES_H = $(shell find submodules -type f -name "*.h")
EXAMPLE_NAMES = $(shell find src/* -type d -prune -printf "%f\n")

all: $(EXAMPLE_NAMES:%=dist/%.wasm)

tmp/%.ll: %.c makefile $(SRC_H) $(SUBMODULES_C) $(SUBMODULES_H)
	mkdir -p $(dir $@)
	clang-10 --target=wasm32 -emit-llvm -c -S -o $@ $<

tmp/%.o: tmp/%.ll
	mkdir -p $(dir $@)
	llc-10 -march=wasm32 -filetype=obj $< -o $@

# I do not believe it is possible to only link wasm files with changed .c files
# here.
dist/%.wasm: $(SRC_C:%.c=tmp/%.o)
	mkdir -p $(dir $@)
	wasm-ld-10 --no-entry --export-dynamic -o $@ $(patsubst %.c,tmp/%.o,$(filter src/$(basename $(notdir $@))%.c, $(SRC_C)))
	wasm-opt -Oz $@ -o $@

clean:
	rm -rf dist tmp
