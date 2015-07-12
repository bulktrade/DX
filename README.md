# DX
Deacix Framework

The allrounder framework with useful sets of tools and libraries written in Java, JavaScript, Bash and more. 

# Makefile 

Start docker container stack as daemon and print logs:

	make rundl

Print all commands

	make help
	
	#
    # General targets
    #
    
    usage: make [target]
    
    docker:
      run......................Run container stack
      rund.....................Run container stack as daemon
      rundl....................Print logs
      stop.....................Stop container stack
      kill.....................Kill container stack
      destroy..................Destroy container stack
    
    base:
      help.....................Show this help

Example Makefile to use with multiple docker stacks in a project:

	BASE_PATH=`pwd`
    YML=$(BASE_PATH)/docker/stacks/main/docker-compose.yml
    ECO_YML=$(BASE_PATH)/docker/stacks/eco/docker-compose.yml
    
    include DX/Makefile
    
    eco:
    	$(eval YML=$(ECO_YML))
    	@echo -n "Set ECO Stack: "
    	@echo -e "$(OK_STRING)"

Links
-----
    
- [Inspired By Doma Project](https://github.com/schmunk42/doma)
