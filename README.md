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

Links
-----
    
- [Inspired By Doma Project](https://github.com/schmunk42/doma)
