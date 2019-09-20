#! /usr/bin/env bash
shopt -s extglob

url_components=()

function parse_url() {
  IFS='/' read -r -a url_components <<< $1
}

function parse_request() {
  read -u 0 request
  method=$(echo "$request" | cut -d ' ' -f 1)
  url=$(echo "$request" | cut -d ' ' -f 2)
  echo "$url"
}

parse_url $(parse_request)

url_matcher="${url_components[@]}"

case $url_matcher in
  *home*)
    data="Hello!"
    ;;
  *name*)
    data="Your name is ${url_components[-1]}"
    ;;
  *)
    data="it's something else, $url_matcher"
    ;;
esac

response="<html>$data</html>"
content_length=$(( $(echo $response | wc -c) - 1))

printf "HTTP/1.1 200 OK\r\n"
printf "Server: ucspi\r\n"
printf "Content-Type: text/html; charset=UTF-8\r\n"
printf "Content-Length: $content_length\r\n"
printf "\r\n"
printf "$response"
