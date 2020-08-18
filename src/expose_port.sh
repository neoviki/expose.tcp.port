LOCAL_PORT=""
REMOTE_IP=""
REMOTE_UNAME=""
REMOTE_PASS=""

while [ 1 ]
do
    read -p " Enter local port number to expose to the world   : " LOCAL_PORT    </dev/tty
    if [[ ! -z $LOCAL_PORT ]]; then
        break
    fi
done

while [ 1 ]
do
    read -p " Enter remote server [ ip address / domain name ] : " REMOTE_IP     </dev/tty
    if [[ ! -z $REMOTE_IP ]]; then
        break
    fi
done

while [ 1 ]
do
    read -p " Enter remote server username                     : " REMOTE_UNAME  </dev/tty
    if [[ ! -z $REMOTE_UNAME ]]; then
        break
    fi
done

while [ 1 ]
do
    read -sp " Enter remote server password                     : " REMOTE_PASS
    if [[ ! -z $REMOTE_PASS ]]; then
        break
    fi
done



#echo    " Enter remote server password                     : " 
echo 
echo 
#Users in the internet can use this port along with $REMOTE_IP to communicate with THIS machine
INCOMING_PORT=10000
PORT_CHECK_LIMIT=10006

ERROR_LOG="/tmp/expose_port_error.log"

while [ $INCOMING_PORT -lt $PORT_CHECK_LIMIT ]
do
    #printf "."
    rm $ERROR_LOG
    
    if [ -f "$ERROR_LOG" ]; then
        echo
        echo
        echo "[ error  ] Unable to access file ( $ERROR_LOG ) - permission error"
        echo "[ error  ] Manually remove file ( $ERROR_LOG ) and try again"
        exit 1
    fi

    touch $ERROR_LOG
    #Change "-p 22" to appropriate ssh port if the remote server isn't configured with default ssh port
    sshpass -p $REMOTE_PASS  ssh -f -N  -R $INCOMING_PORT:localhost:$LOCAL_PORT -p 22 $REMOTE_UNAME@$REMOTE_IP 2> $ERROR_LOG
    
    #Check Command Exit Status
    if [ $? -ne 0 ]; then
        echo
        echo
        echo "[ status ] Execution Error : "
        echo
        printf "\t( execution failure ) ssh -f -N  -R $INCOMING_PORT:localhost:$LOCAL_PORT -p 22 $REMOTE_UNAME@$REMOTE_IP 2> $ERROR_LOG"
        echo
        echo
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
echo " You can access tcp port ( $LOCAL_PORT ) on this device using [ IP :$REMOTE_IP ] [ PORT : $INCOMING_PORT ]"
echo ""
echo ""
echo "#########################################################################################"
echo ""
echo ""
