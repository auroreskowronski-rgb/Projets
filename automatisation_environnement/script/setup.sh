#!/bin/bash
#permet de stopper le script si un sous-script ou un tube (pipe) échoue
set -e
set -o pipefail

#Si le scrit n'est pas exécuté en sudo il s'arrete
if [ "$EUID" -ne 0 ]; then
    echo "Erreur : Ce script doit être exécuté avec sudo (en tant que root)." >&2
    exit 1
fi

# Vous pouvez modifier la liste des paquets à avoir ici
DESIRED=(git curl wget zsh vim)
#Definition de l'username de la vm et l'adresse e-mail etna
USER_NAME=$SUDO_USER
USER_MAIL=$USER_NAME@etna-alternance.net

echo $USER_NAME
echo $USER_MAIL


#Branche avec laquelle git push 
BRANCH=main
#Editeur par défaut du git
EDIT=vim

THEME=bira

ALIAS="# Mes alias personnalisés
alias c=\"clear\"
alias ..=\"cd ..\"
alias ll=\"ls -alF --color=auto\""

mkdir -p ./logs
chmod 777 ./logs
touch ./logs/logs.txt
# Mettre à jour les sources
./sous_script/update.sh | tee ./logs/logs.txt

# Définition des paquets à installer
./sous_script/installed.sh "${DESIRED[@]}" | tee -a ./logs/logs.txt

# Installer les paquets manquant
./sous_script/installer.sh | tee -a ./logs/logs.txt

# Configurer le git
./sous_script/git_config.sh $USER_NAME  $USER_MAIL $BRANCH $EDIT | tee -a ./logs/logs.txt

# Configurer la clé ssh
./sous_script/ssh.sh $USER_NAME $USER_MAIL | tee -a ./logs/logs.txt

# Configurer vim
./sous_script/vim.sh $USER_NAME | tee -a ./logs/logs.txt

# Installer oh_my_zsh et des pluging et configurer un theme et des alias personalisé
./sous_script/oh_my_zsh.sh $USER_NAME $THEME "$ALIAS" | tee -a ./logs/logs.txt

echo "MERCI D'AVOIR UTILISER MON SCRIPT ! :) "
echo Aurore

