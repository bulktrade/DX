SHELL = bash

# Reset
Color_Off=\033[0m# Text Reset

# Regular Colors
Black=\033[0;30m# Black
Red=\033[0;31m# Red
Green=\033[0;32m# Green
Yellow=\033[0;33m# Yellow
Blue=\033[0;34m# Blue
Purple=\033[0;35m# Purple
Cyan=\033[0;36m# Cyan
White=\033[0;37m# White

# Bold
BBlack=\033[1;30m# Black
BRed=\033[1;31m# Red
BGreen=\033[1;32m# Green
BYellow=\033[1;33m# Yellow
BBlue=\033[1;34m# Blue
BPurple=\033[1;35m# Purple
BCyan=\033[1;36m# Cyan
BWhite=\033[1;37m# White

# Underline
UBlack=\033[4;30m# Black
URed=\033[4;31m# Red
UGreen=\033[4;32m# Green
UYellow=\033[4;33m# Yellow
UBlue=\033[4;34m# Blue
UPurple=\033[4;35m# Purple
UCyan=\033[4;36m# Cyan
UWhite=\033[4;37m# White

# Background
On_Black=\033[40m# Black
On_Red=\033[41m# Red
On_Green=\033[42m# Green
On_Yellow=\033[43m# Yellow
On_Blue=\033[44m# Blue
On_Purple=\033[45m# Purple
On_Cyan=\033[46m# Cyan
On_White=\033[47m# White

# High Intensity
IBlack=\033[0;90m# Black
IRed=\033[0;91m# Red
IGreen=\033[0;92m# Green
IYellow=\033[0;93m# Yellow
IBlue=\033[0;94m# Blue
IPurple=\033[0;95m# Purple
ICyan=\033[0;96m# Cyan
IWhite=\033[0;97m# White

# Bold High Intensity
BIBlack=\033[1;90m# Black
BIRed=\033[1;91m# Red
BIGreen=\033[1;92m# Green
BIYellow=\033[1;93m# Yellow
BIBlue=\033[1;94m# Blue
BIPurple=\033[1;95m# Purple
BICyan=\033[1;96m# Cyan
BIWhite=\033[1;97m# White

# High Intensity backgrounds
On_IBlack=\033[0;100m# Black
On_IRed=\033[0;101m# Red
On_IGreen=\033[0;102m# Green
On_IYellow=\033[0;103m# Yellow
On_IBlue=\033[0;104m# Blue
On_IPurple=\033[0;105m# Purple
On_ICyan=\033[0;106m# Cyan
On_IWhite=\033[0;107m# White

NO_COLOR=$(Color_Off)
OK_COLOR=$(Green)
ERROR_COLOR=$(Red)
WARN_COLOR=$(Blue)

PAD="--------------------------------------------------"

OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[INFO]$(NO_COLOR)

VERBOSE ?= false
YML ?= docker-compose.yml
PROJECT_NAME ?=
PROJECT_FLAG = `if [ ! -z $(PROJECT_NAME) ]; then echo -n "-p $(PROJECT_NAME) "; fi`

HELP_FUN = \
		%help; \
		while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([\w-]+)\s*:.*\#\#(?:@([\w-]+))?\s(.*)$$/ }; \
		print "\nusage: make [target]\n\n"; \
	for (keys %help) { \
		print "$$_:\n"; \
		for (@{$$help{$$_}}) { \
			$$sep = "." x (25 - length $$_->[0]); \
			print "  $$_->[0]$$sep$$_->[1]\n"; \
		} \
		print "\n"; }

.PHONY: default help

default: help

help:				##@base Show this help
	#
	# General targets
	#
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

.PHONY: start
start:				##@docker Start container stack
	@echo -n "Start container stack:"
	@if $(VERBOSE); \
    	then \
    		docker-compose $(PROJECT_FLAG)-f $(YML) start; \
    	else \
    		docker-compose $(PROJECT_FLAG)-f $(YML) start 1>/dev/null 2> temp.log || touch temp.errors; \
    	fi;
	@if test -e temp.errors; then echo -e "$(ERROR_STRING)" && cat temp.log; elif test -s temp.log; then echo -e "$(WARN_STRING)" && cat temp.log; else echo -e "$(OK_STRING)"; fi; rm -f temp.errors temp.log

.PHONY: run
run: destroy				##@docker Run container stack
	@echo -n "Run container stack:"
	@if $(VERBOSE); \
    	then \
    		docker-compose $(PROJECT_FLAG)-f $(YML) up; \
    	else \
    		docker-compose $(PROJECT_FLAG)-f $(YML) up 1>/dev/null 2> temp.log || touch temp.errors; \
    	fi;
	@if test -e temp.errors; then echo -e "$(ERROR_STRING)" && cat temp.log; elif test -s temp.log; then echo -e "$(WARN_STRING)" && cat temp.log; else echo -e "$(OK_STRING)"; fi; rm -f temp.errors temp.log

.PHONY: rund
rund: destroy				##@docker Run container stack as daemon
	@echo -n "Run container stack as daemon: "
	@if $(VERBOSE); \
    	then \
    		docker-compose $(PROJECT_FLAG)-f $(YML) up -d; \
    	else \
    		docker-compose $(PROJECT_FLAG)-f $(YML) up -d 1>/dev/null 2> temp.log || touch temp.errors; \
    	fi;
	@if test -e temp.errors; then echo -e "$(ERROR_STRING)" && cat temp.log; elif test -s temp.log; then echo -e "$(WARN_STRING)" && cat temp.log; else echo -e "$(OK_STRING)"; fi; rm -f temp.errors temp.log

.PHONY: rundl
rundl: rund logs				##@docker Run container stack as daemon and show logs

.PHONY: stop
stop:				##@docker Stop container stack
	@echo -n "Stop container stack: "
	@if $(VERBOSE); \
        then \
            docker-compose $(PROJECT_FLAG)-f $(YML) stop; \
        else \
            docker-compose $(PROJECT_FLAG)-f $(YML) stop 1>/dev/null 2> temp.log || touch temp.errors; \
        fi;
	@if test -e temp.errors; then echo -e "$(ERROR_STRING)" && cat temp.log; elif test -s temp.log; then echo -e "$(WARN_STRING)" && cat temp.log; else echo -e "$(OK_STRING)"; fi; rm -f temp.errors temp.log

.PHONY: kill
kill:				##@docker Kill container stack
	@echo -n "Kill container stack: "
	@if $(VERBOSE); \
	    then \
	        docker-compose $(PROJECT_FLAG)-f $(YML) kill; \
	    else \
	        docker-compose $(PROJECT_FLAG)-f $(YML) kill 1>/dev/null 2> temp.log || touch temp.errors; \
	    fi;
	@if test -e temp.errors; then echo -e "$(ERROR_STRING)" && cat temp.log; elif test -s temp.log; then echo -e "$(WARN_STRING)" && cat temp.log; else echo -e "$(OK_STRING)"; fi; rm -f temp.errors temp.log

.PHONY: destroy
destroy: kill				##@docker Destroy container stack
	@echo -n "Remove container stack: "
	@if $(VERBOSE); \
	    then \
	        docker-compose $(PROJECT_FLAG)-f $(YML) rm -v -f; \
	    else \
	        docker-compose $(PROJECT_FLAG)-f $(YML) rm -v -f 1>/dev/null 2> temp.log || touch temp.errors; \
	    fi;
	@if test -e temp.errors; then echo -e "$(ERROR_STRING)" && cat temp.log; elif test -s temp.log; then echo -e "$(WARN_STRING)" && cat temp.log; else echo -e "$(OK_STRING)"; fi; rm -f temp.errors temp.log

.PHONY: ps
ps:				##@docker List containers
	@echo "List containers: "
	@docker-compose $(PROJECT_FLAG)-f $(YML) ps

.PHONY: watch
watch:				##@docker Watch container list
	@echo "Watch container list: "
	@watch docker-compose $(PROJECT_FLAG)-f $(YML) ps

.PHONY: top
top:				##@docker Top View for the docker container stack ("Ctrl-a Cctrl-\" to close all windows or "Ctrl-a k" to kill focused window)
	@echo "List containers: "
	@docker-compose $(PROJECT_FLAG)-f $(YML) ps | grep 2 | awk '{print $$1}' 1>.top

	@echo -e "term xterm-256color\nhardstatus off\nhardstatus alwayslastline\nstartup_message off\nvbell off\naltscreen on\nwindowlist string \"%4n %h%=%f\"\nsessionname dockertop" > .screen

	@TOP_LINES_COUNTER=0 && \
	while read line; \
	do \
		if [ ! $$TOP_LINES_COUNTER -eq 0 ]; then \
				echo -e "split\nfocus down" >> .screen; \
		fi; \
		echo "screen -t $$line $$TOP_LINES_COUNTER docker exec -it $$line sh -c 'export TERM=xterm && top'" >> .screen; \
		((TOP_LINES_COUNTER = TOP_LINES_COUNTER + 1)); \
	done < .top
	@rm .top
	@screen -c .screen && rm .screen

.PHONY: logs
logs:				##@docker Show logs
	@echo "Print logs: "
	@docker-compose $(PROJECT_FLAG)-f $(YML) logs $(LOGS_OPTS)

.PHONY: verbose
verbose:				##@docker Verbose output
	@$(eval VERBOSE=true)
