## Expose local tcp port to internet using ssh port forwarding 

This utility exposes your device local tcp port to internet via an intermediate server ( with public ip address ). This is acheived by ssh tunning and port forwarding. 
  
## Source Code
  
	1. Clone this repo
	2. cd src

## Usage:

##### Example 1

	$./expose_port.sh 

		Enter local port number to expose to the world   : 22
	 	Enter remote server [ ip address / domain name ] : test.domain.com
		Enter remote server username                     : root
		Enter remote server password                     : xxxxxxxx



		#########################################################################################


		 Local Port ( 22 ) successfully exposed to the world!!


		 You can access tcp port ( 22 ) on this device using [ IP/DNS : test.domain.com ] [ PORT : 10000 ]


		#########################################################################################


##### Example 2

	$./expose_port.sh <local_port> <username>@<remote_server_ip/dns>

	<local_port> 			: Local port to expose to internet
	<remote_server_ip/dns>	: Server with public ip address 

	$./expose_port.sh 22 test@domain123.com

	
