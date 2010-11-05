#!/bin/bash

# Fichier où sont stockées les informations
SRCFILE=/tmp/conky_meteo.txt

LEVER=$(grep "Lever de soleil" $SRCFILE | sed 's/AM//g' | cut -d : -f 2,3 | sed 's/ //g;s/://g')
COUCHER=$(echo `grep "Coucher de soleil" $SRCFILE | cut -d : -f 2` + 12 | bc)$(grep "Coucher de soleil" $SRCFILE | sed 's/PM//g' | cut -d : -f 3)

# Traitement
RESULTAT=$(grep "$1" $SRCFILE | awk -F " : " '{print $2}')

# Transformation de la condition en lettre qui deviendra une icône
if echo "$1" | grep -i -q 'conditions aujourd'; then
    if echo "$RESULTAT" | egrep -i -q 'fog|mist'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='d' ; else
                RESULTAT='n'
        fi
    elif echo "$RESULTAT" | egrep -i -q 'storm|thunder'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='i' ; else
                RESULTAT='s'
        fi
    elif echo "$RESULTAT" | egrep -i -q 'shower|drizzle'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='g' ; else
                RESULTAT='q'
        fi
    elif echo "$RESULTAT" | grep -i -q 'partly cloudy'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='c' ; else
                RESULTAT='m'
        fi
    elif echo "$RESULTAT" | grep -i -q 'fair'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='b' ; else
                RESULTAT='l'
        fi
    elif echo "$RESULTAT" | grep -i -q 'sunny'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='C' ; else
                RESULTAT='K'
        fi
    elif echo "$RESULTAT" | grep -i -q 'cloud'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='d' ; else
                RESULTAT='n'
        fi
    elif echo "$RESULTAT" | grep -i -q 'snow'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='k' ; else
                RESULTAT='u'
        fi
    elif echo "$RESULTAT" | grep -i -q 'rain'; then
        if [[ `date +%k%M` -lt $COUCHER && `date +%k%M` -gt $LEVER ]] ; then
            RESULTAT='h' ; else
                RESULTAT='r'
        fi
    fi

# Transformation de la condition en lettre qui deviendra une icône
elif echo "$1" | grep -i -q 'conditions demain'; then

    RESULTAT=`echo $RESULTAT | sed 's/AM//g;s/PM//g;s/ //g;s|/| |g'`

    if echo "$RESULTAT" | egrep -i -q 'fog|mist'; then
        RESULTAT='='
    elif echo "$RESULTAT" | egrep -i -q 'storm|thunder'; then
        RESULTAT='i'
    elif echo "$RESULTAT" | egrep -i -q 'shower|drizzle'; then
        RESULTAT='g'
    elif echo "$RESULTAT" | grep -i -q 'partly cloudy'; then
        RESULTAT='c'
    elif echo "$RESULTAT" | grep -i -q 'fair'; then
        RESULTAT='b'
    elif echo "$RESULTAT" | grep -i -q 'sunny'; then
        RESULTAT='C'
    elif echo "$RESULTAT" | grep -i -q 'cloud'; then
        RESULTAT='d'
    elif echo "$RESULTAT" | grep -i -q 'snow'; then
        RESULTAT='k'
    elif echo "$RESULTAT" | grep -i -q 'rain'; then
        RESULTAT='h'
    fi

# Transformation des heures à l'américaine (5:50 AM) en heures à la française (5h50)
elif echo "$1" | grep -i -q 'soleil'; then
    RESULTAT=$(echo "$RESULTAT" | awk '{print $1}' | sed -e s/:/h/g)

    # Transformation des heures PM (9h38 PM) en heures françaises (21h38)
    if echo "$1" | egrep -i -q 'coucher'; then
        HEURES=$(echo "$RESULTAT" | awk -F "h" '{print $1}')
        MINUTES=$(echo "$RESULTAT" | awk -F "h" '{print $2}')
        HEURES=$(($HEURES + 12))
        RESULTAT="${HEURES}h${MINUTES}"
    fi

# Transformation des heures à l'américaine (5:50 AM) en heures à la française (5h50)
elif echo "$1" | grep -i -q 'MAJ'; then
    RESULTAT=$(echo "$RESULTAT" | awk '{print $1}' | sed -e s/:/h/g)

    # Transformation des heures PM (9h38 PM) en heures françaises (21h38)
    if [[ `date +%k` -ge 12 ]] ; then
        HEURES=$(echo "$RESULTAT" | awk -F "h" '{print $1}')
        MINUTES=$(echo "$RESULTAT" | awk -F "h" '{print $2}')
        HEURES=$(($HEURES + 12))
        RESULTAT="${HEURES}h${MINUTES}"
    fi
    if [[ `date +%k` -eq 0 ]] ; then
        MINUTES=$(echo "$RESULTAT" | awk -F "h" '{print $2}')
        HEURES=00
        RESULTAT="${HEURES}h${MINUTES}"
    fi

# Transformation de "Ville, Pays" en "Ville"
elif echo "$1" | grep -i -q 'ville'; then
    RESULTAT=$(echo "$RESULTAT" | awk -F "," '{print $1}')

# Transformation de "West" en "Ouest"
elif echo "$1" | grep -i -q 'vent'; then
    RESULTAT=$(echo "$RESULTAT" | sed 's/W/O/g')

# Transformation de la température en icone
elif echo "$1" | grep -i -q 'icone_temp'; then
    RESULTAT=$(echo "$RESULTAT" | sed 's/1[0-9]/y/g;s/[2-9][0-9]/z/g;s/[0-9]/y/g;s/*[0-9]*/x/g')

#Traduction du nom de la phase de la lune en fr.
elif echo "$1" | grep -i -q 'Lune_Texte'; then
    RESULTAT=$(echo "$RESULTAT" | sed 's/New/Nouvelle Lune/g;s/New Moon/Nouvelle Lune/g;s/Waxing Crescent/Premier Croissant/g;s/First Quarter/Premier Quartier/g;s/Waxing Gibbous/Gibbeuse Croissante/g;s/Full Moon/Pleine Lune/g;s/Full/Pleine Lune/g;s/Waning Gibbous/Gibbeuse Décroissante/g;s/Last Quarter/Dernier Quartier/g;s/Waning Crescent/Dernier Croissant/g')

# Transformation du numero de l'icone de la lune en lettre
elif echo "$1" | grep -i -q 'Lune_Icone'; then
    RESULTAT=$(echo "$RESULTAT" | sed 's/20/r/g;s/21/s/g;s/22/t/g;s/23/u/g;s/24/v/g;s/25/w/g;s/26/x/g;s/27/y/g;s/28/z/g;s/29/ /g;s/10/j/g;s/11/k/g;s/12/l/g;s/13/m/g;s/14/+/g;s/15/+/g;s/16/n/g;s/17/o/g;s/18/p/g;s/19/q/g;s/0/ /g;s/1/a/g;s/2/b/g;s/3/c/g;s/4/d/g;s/5/e/g;s/6/f/g;s/7/g/g;s/8/h/g;s/9/i/g')

fi

# Affichage du résultat
echo $RESULTAT
