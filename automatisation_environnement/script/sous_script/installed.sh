#!/bin/bash
# Définition des paquets à installer


DESIRED=("$@")
LIST1=logs/a_installer.txt
LIST2=logs/déja_installé.txt

#Reinitialisation de $LIST1 et $LIST2
rm -f $LIST1 && touch $LIST1 && chmod 666 $LIST1
rm -f $LIST2 && touch $LIST2 && chmod 666 $LIST2
echo "Liste des paquets à installer :" > $LIST1
echo "Liste des paquets déja installé :" > $LIST2

#Verifie si chaque paquet est installé et si il ne l'est pas l'installe et ecris dans les $LIST
for CMD in "${DESIRED[@]}" ; do 
    if command -v "$CMD" >/dev/null 2>&1; then
        echo "Le paquet \"$CMD\" est déja installé"
        echo $CMD >> $LIST2

    else
        echo "Le paquet \"$CMD\" n'est pas installé"
        echo $CMD >> $LIST1
    fi
done