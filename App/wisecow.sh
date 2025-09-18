#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
	read line
	echo $line
}

handleRequest() {
    # 1) Process the request
	get_api
	mod=`fortune`
	body="<pre>$(cowsay "$mod")</pre>"
    length=$(echo -n "$body" | wc -c)

    {
        printf 'HTTP/1.1 200 OK\r\n'
        printf 'Content-Type: text/html\r\n'
        printf 'Content-Length: %s\r\n' "$length"
        printf '\r\n'
        printf '%s' "$body"
    } > $RSPFILE

}

prerequisites() {
	command -v cowsay >/dev/null 2>&1 &&
	command -v fortune >/dev/null 2>&1 || 
		{ 
			echo "Install prerequisites."
		
		}
}

main() {
	prerequisites
	echo "Wisdom served on port=$SRVPORT..."

	while [ 1 ]; do
		cat $RSPFILE | nc -lN $SRVPORT | handleRequest
		sleep 0.01
	done
}

main
