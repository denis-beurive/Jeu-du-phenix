MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
GIT_RSA      :=  $(HOME)/.ssh/ssh_github



push:
	$(MAKEFILE_DIR)/git.sh -i $(GIT_RSA) push -u origin master 
