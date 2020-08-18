ps -ef | grep "ssh -f -N" | grep -v "grep" | awk '{print $2}' | xargs -I{} kill -9 {}
