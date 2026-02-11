CC = gcc
CXX = g++ # needed for the CCompact.cpp in wrapper
CFLAGS = -m64 -fPIC -O3 -ffast-math -msse -DNDEBUG -Wall
CXXFLAGS = -m64 -fPIC -O3 -ffast-math -msse -DNDEBUG -Wall -std=c++11
LDFLAGS = -m64 -shared -static-libstdc++ -static-libgcc

# Folders
WRAPPER_DIR = wrapper/include
BUILD_DIR = build


INCLUDES = -I$(WRAPPER_DIR)
WRAPPER_CXX_SOURCES = $(WRAPPER_DIR)/GarrysMod/Lua/CCompat.cpp # cpp file in GarrysMod/Lua

##### Module Registration #####
MODULES = example
###############################

define module_binary
gmsv_$(1)_linux64.dll
endef

.PHONY: all
all: $(BUILD_DIR) $(foreach mod,$(MODULES),$(BUILD_DIR)/$(call module_binary,$(mod)))

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/gmsv_%_linux64.dll: %/src/*.c $(WRAPPER_CXX_SOURCES)
	@echo "Compiling module: $*"
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(WRAPPER_CXX_SOURCES) -o $(BUILD_DIR)/$*_ccompat.o
	$(CC) $(CFLAGS) $(INCLUDES) -c $*/src/main.c -o $(BUILD_DIR)/$*_main.o
	$(CXX) $(LDFLAGS) -o $@ $(BUILD_DIR)/$*_ccompat.o $(BUILD_DIR)/$*_main.o
	@echo "[ OK ] Compiled: $@"

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.dll
	@echo "[ OK ] Build folder cleaned!"