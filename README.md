## Expose Port 

This utility is used to expose local tcp port to the INTERNET.

The utility uses ssh port forwarding under the hood. 

## Source Code
  
	1. Clone this repo
	2. cd src

## Usage:


##### SYNTAX

	$./expose_port <local_tcp_port> <username>@<remote_server_ip/dns> 
    
    <local_tcp_port>        : Local TCP port to expose to the INTERNET
	<remote_server_ip/dns>	: Server with public ip address and ssh access 
    <username>              : Server username 

##### Example 1

	$./expose_port

    Enter local port to expose                 : 22
    Enter jump server IP ADDRESS / DOMAIN NAME : test.domain.com
    Enter remote server username               : root
    Enter remote server ssh port               : 22

    Remote Host Details                        : remote_user@test.domain.com:22
    Enter remote server password               : 


    ####################################################################

    You can access port ( 22 ) of this device using the following details, 

    USER NAME ( optional )     :  local_user
    DOMAIN NAME                :  test.domain.com
    PORT                       :  10001 

    ####################################################################


##### Example 2
	
	$./expose_port 80 remote_user@test.domain.com

    ####################################################################

    You can access port ( 22 ) of this device using the following details, 

    USER NAME ( optional )     :  local_user
    DOMAIN NAME                :  test.domain.com
    PORT                       :  10001 

    ####################################################################

##### Example 3 -> Run utility in background ( -bg )
	
	$./expose_port 80 remote_user@test.domain.com -bg

    ####################################################################

    You can access port ( 22 ) of this device using the following details, 

    USER NAME ( optional )     :  local_user
    DOMAIN NAME                :  test.domain.com
    PORT                       :  10001 

    ####################################################################


    -bg: This option is used to run the utility in background 

##### Caution!!:
   
    Remember to disble the exposed port after completing your work using "unexpose_port" utility.

#### Terminate Debugger

	This command terminates remote_debugger and all opened tcp ports

	$./unexpose_port <local port>

#### Client Prerequisite 

##### Install sshpass [ Ubuntu ]

	$sudo apt-get install sshpass

##### Install sshpass [ Mac ]

	$brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

#### Server Prerequisite [ test.domain.com ]
    
    Login to remote server in our case 'test.domain.com' ( This code is tested only on ubuntu server ). 

    $git clone <this repo>
    $cd server_setup
    $./enable_ssh_port_forwarding.sh
    
    #This command enable port forwarding in remote server (test.domain.com). 
    "expose_port" utility can be used only after running "enable_ssh_port_forwarding.sh" on jump server. 

#### Tested Systems:

	- Linux 
	- Mac
