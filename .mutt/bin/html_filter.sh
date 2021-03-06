#!/bin/sh
# filter which runs w3m using socksify (from the dante package) 
# to prevent any phoning home by rendered emails
export SOCKS_SERVER="127.0.0.1:1"
charset="${1:-UTF-8}"
exec setsid socksify w3m \
	-T text/html \
	-cols $(tput cols) \
	-dump \
	-graph \
	-I "${charset}" \
	-o display_image=false \
	-o display_link_number=true
