#!/bin/bash
# Configurer le git
USER_NAME=$1
USER_MAIL=$2
BRANCH=$3
EDIT=$4
#Tout les chemins sont precisés à partir du root car le script est en sudo


#Verifie la presence du .gitconfig
if [ -f "/home/$USER_NAME/.gitconfig" ]; then
    echo "Configuration déjà presente  :"

    cat /home/$USER_NAME/.gitconfig
    #sudo -u permet de se faire passer pour l'utilisateur
    sudo -u "$USER_NAME" git config --global --list | grep -E "=(($USER_NAME)|($USER_MAIL)|($BRANCH)|($EDIT))$" >/dev/null 2>/dev/null
    if [[ $? -ne 0 ]]; then 
        sudo -u "$USER_NAME" git config --global user.name "$USER_NAME"
        sudo -u "$USER_NAME" git config --global user.email "$USER_MAIL"

        sudo -u "$USER_NAME" git config --global init.defaultBranch "$BRANCH"

        sudo -u "$USER_NAME" git config --global core.editor "$EDIT"
    
    else
        echo "La configuration est déja la bonne."
    fi
else
    echo "Le fichier .gitconfig n'existe pas."
    echo "Configuration du git..." 
    sudo -u "$USER_NAME" git config --global user.name "$USER_NAME"
    sudo -u "$USER_NAME" git config --global user.email "$USER_MAIL"
    sudo -u "$USER_NAME" git config --global init.defaultBranch "$BRANCH"
    sudo -u "$USER_NAME" git config --global core.editor "$EDIT"
    echo " .gitconfig est créé et la configuration est : "
    cat /home/$USER_NAME/.gitconfig
fi
