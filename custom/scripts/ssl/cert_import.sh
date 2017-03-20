#!/bin/sh
# How to import a certificate in Chrome for linux
# http://stuffivelearned.org/doku.php?id=apps:chrome:sscert_import
# Just run that as your normal user to import the certificate for your domain like so:
#    $ cert_import.sh my.domain.com
# If you are using a different port than the standard SSL port 443, you can add that as a second argument:
#    $ cert_import.sh my.domain.com 4430

 
usage() {
    ex="${1:-0}"
    echo "Usage: $0 <host> [<port>]"
    echo "\n\tPort will be set to 443 by default"
    exit $ex
}
 
host="$1"
if [ -z $host ] ; then
    usage 1
fi
port="${2:-443}"
ssl=/usr/bin/openssl
cu=/usr/bin/certutil
tmp="$(tempfile)"
 
trap 'rm $tmp' 1 2 3 15
 
echo |
    openssl s_client -connect $host:$port 2>&1 |
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $tmp
certutil -d sql:$HOME/.pki/nssdb -A -t CP,,C -n "$host" -i $tmp
rm $tmp
