#!/bin/bash

# Répertoire de ce script et du XSLT
RUNDIR=~/.scripts
# Emplacement du XSLT
XSLT=$RUNDIR/meteo.xslt
# Fichier de destination des informations
DESTFILE=/tmp/conky_meteo.txt
# Emplacement de xsltproc
XSLTCMD=/usr/bin/xsltproc

# Traitement
URL="http://xml.weather.com/weather/local/$1?cc=*&unit=m&dayf=2"
w3m -dump $URL | $XSLTCMD $XSLT - > $DESTFILE
#curl -s "http://iohelix.net/moon/moonlite.php?z=+2" | egrep age | cut -c10-14 >> $DESTFILE
