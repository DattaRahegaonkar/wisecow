#!/usr/bin/env bash

SRVPORT=4499

prerequisites() {
	command -v cowsay >/dev/null 2>&1 &&
	command -v fortune >/dev/null 2>&1 || 
		{ 
			echo "Install prerequisites."
			exit 1
		}
}

handle_request() {
    while read line; do
        if [[ "$line" == $'\r' ]] || [[ -z "$line" ]]; then
            break
        fi
    done
    
    local fortune_text=$(fortune)
    local cowsay_output=$(cowsay "$fortune_text")
    
    printf "HTTP/1.1 200 OK\r\n"
    printf "Content-Type: text/html\r\n"
    printf "Content-Length: %d\r\n" $((${#cowsay_output} + 46))
    printf "Connection: close\r\n"
    printf "\r\n"
    printf "<html><body><pre>%s</pre></body></html>" "$cowsay_output"
}

main() {
	prerequisites
	echo "Wisdom served on port=$SRVPORT..."

	while true; do
		handle_request | nc -l -p $SRVPORT
		sleep 0.01
	done
}

main
