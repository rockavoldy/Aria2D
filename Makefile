BUILD_DIR = ./dist
SCRIPT_DIR = ./script

build: 
	@$(SCRIPT_DIR)/build.sh

clean:
	rm -rf $(BUILD_DIR)
