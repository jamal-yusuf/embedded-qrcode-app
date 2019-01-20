#!/bin/bash
gpio mode 21 out;
gpio mode 29 out;
gpio mode 6 out;
gpio write 21 0;
gpio write 29 0;
gpio write 6 1;
while : ; do
  read token
  token=$(echo $token | cut -d':' -f2)
  email=$(curl -X GET https://www.googleapis.com/oauth2/v2/userinfo -H 'Authorization: Bearer '$token | jq -r .email)
  count=$(grep $email emails.txt | wc -l)

  if [ $count = 1 ]; then
    gpio write 21 1 ;
    gpio write 6 0 ;
    sleep 2 ;
    gpio write 21 0 ;
    gpio write 6 1 ;
    curl -H "Content-type:application/x-www-form-urlencoded" https://accounts.google.com/o/oauth2/revoke?token=$token
  else
    gpio write 29 1 ;
    sleep 2 ;
    gpio write 29 0 ;
  fi
done;
