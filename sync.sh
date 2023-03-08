#!/bin/bash

if [ "$*" = "" ] ; then echo "Es wurde kein Argument angegeben" ; exit 1; fi

{ while IFS=';' read  u1
  do
        { echo "$u1" | egrep "^#" ; } > /dev/null && continue
         NOW=`date +%Y-%m-%d-%H-%M-%S`
         echo syncing user "$u1"

imapsync --host1 127.0.0.1 --user1 "$u1"@domain.de \
--authuser1 user --passfile1 /etc/user.secret \
--host2 192.168.240.250 --authuser2 eximport@domain.de --password2 password --user2 "$u1" --ssl1 --ssl2 --nosyncacl \
--idatefromheader --allowsizemismatch --skipsize --noauthmd5 --subscribe --nofoldersizes --buffersize 8192000 \
--maxsize 100000000 \
--regextrans2 's/^Sent(.*)/Gesendete Elemente$1/' \
--regextrans2 's/^Gesendete Objekte(.*)/Gesendete Elemente$1/' \
--regextrans2 's/^Trash(.*)/Gel&APY-schte Elemente$1/' \
--regextrans2 's/^Papierkorb/Gel&APY-schte Elemente$1/' \
--regextrans2 's/^Drafts(.*)/Entw&APw-rfe$1/'  \
--regextrans2 's/^Spam(.*)/Junk-E-Mail$1/' \
--exclude 'confirmed-ham|confirmed-spam|Ham|Aufgaben' \
--authmech1 PLAIN --authmech2 PLAIN > /root/LOG/${u1}.log 2> /root/LOG/${u1}.error.log
done ; } < $1
