BUILD_DIR = ./dist
SCRIPT_DIR = ./script

build: 
	@$(SCRIPT_DIR)/build.sh

selfsign:
	@$(SCRIPT_DIR)/build-new.sh

clean:
	rm -rf $(BUILD_DIR)
