#!/bin/bash
# Permet de stopper le script si un sous-script ou un tube (pipe) échoue
set -e
set -o pipefail

# Definit le répertoire de logs en fonction de ceux déja présent
LOGS_NUMBER=1
while [ -r "./logs$LOGS_NUMBER" ]; do
    LOGS_NUMBER=$((LOGS_NUMBER + 1))
done
LOGS_DIRECTORY="./logs$LOGS_NUMBER"


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

mkdir -p $LOGS_DIRECTORY
chmod 744 $LOGS_DIRECTORY
touch $LOGS_DIRECTORY/logs.txt
# Mettre à jour les sources
./sous_script/update.sh | tee $LOGS_DIRECTORY/logs.txt

# Définition des paquets à installer
./sous_script/installed.sh "${DESIRED[@]}" | tee -a ./$LOGS_DIRECTORY/logs.txt

# Installer les paquets manquant
./sous_script/installer.sh | tee -a $LOGS_DIRECTORY/logs.txt

# Configurer le git
./sous_script/git_config.sh $USER_NAME  $USER_MAIL $BRANCH $EDIT | tee -a $LOGS_DIRECTORY/logs.txt

# Configurer la clé ssh
./sous_script/ssh.sh $USER_NAME $USER_MAIL | tee -a $LOGS_DIRECTORY/logs.txt

# Configurer vim
./sous_script/vim.sh $USER_NAME | tee -a $LOGS_DIRECTORY/logs.txt

# Installer oh_my_zsh et des pluging et configurer un theme et des alias personalisé
./sous_script/oh_my_zsh.sh $USER_NAME $THEME "$ALIAS" | tee -a $LOGS_DIRECTORY/logs.txt

echo "MERCI D'AVOIR UTILISER MON SCRIPT ! :) "
echo Aurore

