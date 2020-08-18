: '
	Utility to Expose Local Device Port to Internet
	
	Author	: 	Viki ( a ) Vignesh Natarajan
			:	vikiworks.io
'

LOCAL_PORT=""
REMOTE_IP=""
REMOTE_UNAME=""
REMOTE_PASS=""
REMOTE_SSH_PORT=""
REMOTE_DETAILS=""

#Single Line Usage:
#./expose_port.sh <local_port_to_expose> <username>@<remote_ip> <remote_ssh_port>
#./expose_port.sh 22 testuser@2.3.4.5 

if [ $# -lt 2 ]; then 
	echo
	echo
	echo " Press ( ctrl + c ) to exit application "
	echo
	echo
	while [ 1 ]
	do
		if [[ ! -z $LOCAL_PORT ]]; then
	        break
	    fi
	    read -p " Enter local port number to expose to the world   : " LOCAL_PORT    </dev/tty
	done


	while [ 1 ]
	do
    	if [[ ! -z $REMOTE_IP ]]; then
        	break
    	fi
    	read -p " Enter remote server [ ip address / domain name ] : " REMOTE_IP     </dev/tty
	done

	while [ 1 ]
	do
    	if [[ ! -z $REMOTE_UNAME ]]; then
        	break
    	fi
    	read -p " Enter remote server username                     : " REMOTE_UNAME  </dev/tty
	done

else
	
	if [ ! -z "$1" ]; then
    	LOCAL_PORT=$1
	fi

	if [ ! -z "$2" ]; then
    	REMOTE_DETAILS=$2
	fi
	
	if [ ! -z "$3" ]; then
    	REMOTE_SSH_PORT=$3
	else
		REMOTE_SSH_PORT=22
	fi
	echo
	echo " Local Port 					  : $LOCAL_PORT"
	echo " Remote Host Details 				  : $REMOTE_DETAILS -p $REMOTE_SSH_PORT"
fi

if [ -z "$REMOTE_SSH_PORT" ]; then
	REMOTE_SSH_PORT=22
fi

while [ 1 ]
do
	if [[ ! -z $REMOTE_PASS ]]; then
		break
	fi
	read -sp " Enter remote server password                     : " REMOTE_PASS
done

echo 
echo 

#Users in the internet can use this port along with $REMOTE_IP to communicate with THIS machine
INCOMING_PORT=10000
PORT_CHECK_LIMIT=10006

ERROR_LOG="/tmp/expose_port_error.log"

while [ $INCOMING_PORT -lt $PORT_CHECK_LIMIT ]
do
    #printf "."
    rm $ERROR_LOG 2> /dev/null
    
    if [ -f "$ERROR_LOG" ]; then
        echo
        echo
        echo "[ error  ] Unable to access file ( $ERROR_LOG ) - permission error"
        echo "[ error  ] Manually remove file ( $ERROR_LOG ) and try again"
        exit 1
    fi

    touch $ERROR_LOG
   
	if [[ ! -z $REMOTE_DETAILS ]]; then 
		sshpass -p $REMOTE_PASS  ssh -f -N  -R $INCOMING_PORT:localhost:$LOCAL_PORT -p $REMOTE_SSH_PORT $REMOTE_DETAILS 2> $ERROR_LOG
	else
		sshpass -p $REMOTE_PASS  ssh -f -N  -R $INCOMING_PORT:localhost:$LOCAL_PORT -p $REMOTE_SSH_PORT $REMOTE_UNAME@$REMOTE_IP 2> $ERROR_LOG
    fi

    #Check Command Exit Status
    if [ $? -ne 0 ]; then
        echo
        echo
        echo "[ status ] Execution Error : "
        echo
        printf "\t( execution failure ) ssh -f -N  -R $INCOMING_PORT:localhost:$LOCAL_PORT -p 22 $REMOTE_UNAME@$REMOTE_IP 2> $ERROR_LOG"
        echo
        echo
    	rm $ERROR_LOG 2> /dev/null
        exit 1
    fi  

    sleep 1

    #Check Port Expose Status  
    if [ -f "$ERROR_LOG" ]; then
        #The above commane will throw "Warning error if the port is already used by other servers"
        grep -i "warning" $ERROR_LOG | grep "$INCOMING_PORT" > /dev/null

        if [ $? -eq 0 ]; then
            printf "."
            #echo
            #echo
            #echo "Unable to expose local port ($LOCAL_PORT) with remote port ($INCOMING_PORT)"
        else
            break
        fi

    fi


    INCOMING_PORT=$[$INCOMING_PORT+1]
    sleep 2
done

echo ""
echo ""
echo "#########################################################################################"
echo ""
echo ""
echo " Local Port ( $LOCAL_PORT ) successfully exposed to the world!!"
echo ""
echo ""
echo " You can access tcp port ( $LOCAL_PORT ) on this device using [ IP/DNS : $REMOTE_IP ] [ PORT : $INCOMING_PORT ]"
echo ""
echo ""
echo "#########################################################################################"
echo ""
echo ""

rm $ERROR_LOG 2> /dev/null
