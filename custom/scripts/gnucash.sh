#! /bin/sh -e
ssh-askpass | encfs -S ~/Dropbox/gnucash ~/gnucash
/usr/bin/gnucash ~/gnucash/myFinances
fusermount -u ~/gnucash
