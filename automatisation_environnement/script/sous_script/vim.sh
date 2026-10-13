#!/bin/bash
USER_NAME=$1
VIMRC="/home/$USER_NAME/.vimrc"

#Crée le fichier .vimrc s'il n'existe pas encore modifie seulement son horodatage si il existe déja
touch "$VIMRC"

#Vérifie de l'absence de "set number" et l'ajoute si c'est le cas
if ! grep -q "set number" "$VIMRC"; then
    echo "set number" >> "$VIMRC"
    echo "\"set number\" a été ajouté à $VIMRC"
else
    echo "\"set number\" est déjà présent."
fi

#Vérifie de l'absence et ajout de 'set mouse=a'
if ! grep -q "set mouse=a" "$VIMRC"; then
    echo "set mouse=a" >> "$VIMRC"
    echo "\"set mouse=a a été ajouté à $VIMRC"
else
    echo "\"set mouse=a\" est déjà présent."
fi
