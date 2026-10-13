#!/bin/bash
# Configurer la clé ssh
USER_NAME=$1
USER_MAIL=$2

echo "Vérification de la clé SSH auprès de l'ETNA..."

# "-i" pour pouvoir indiquer l'adresse exact, afin de contourner le sudo; "-o StrictHostKeyChecking=accept-new pour repondre oui à la premiere connexion"
REPONSE=$(ssh -i "/home/$USER_NAME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new -T git@rendu-git.etna-alternance.net 2>&1)


# -i pour rendre insensible a la casse et -E pour pouvoir utiliser "|" comme un OU
if echo "$REPONSE" | grep -qiE "(Welcome to GitLab|successfully authenticated)"; then

    echo "La clé SSH est déjà configurée."
else 
    echo "La clé n'est pas configurée"
    if [ -f "/home/$USER_NAME/.ssh/id_ed25519.pub" ]; then
        echo "La clé publique existe déjà, copiez-la et ajoutez-la à votre profil :" 
        cat "/home/$USER_NAME/.ssh/id_ed25519.pub"
    
    
    else
        #Bloc de génération de la clé ssh
        echo "Génération de la clé ssh"
        mkdir -p "/home/$USER_NAME/.ssh"
        ssh-keygen -t ed25519 -C "$USER_MAIL" -f "/home/$USER_NAME/.ssh/id_ed25519" -N "" > /dev/null 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo "La clé SSH est générée ! Copiez la clé publique et ajoutez-la à votre profil : "
            cat "/home/$USER_NAME/.ssh/id_ed25519.pub"
        else 
            echo "Problème lors de la génération de la clé SSH" 
        fi 
    
    fi

    # Le dossier et la clé ont été généré en sudo , il faut retablir le proprietaire et les permissions
    chown -R "$USER_NAME:$USER_NAME" "/home/$USER_NAME/.ssh"
    chmod 700 "/home/$USER_NAME/.ssh"
    chmod 600 "/home/$USER_NAME/.ssh/id_ed25519"
    
    
    if [ -z "$SSH_AUTH_SOCK" ]; then
        #Permet de lancer l'agent ssh.
        eval "$(ssh-agent -s)" > /dev/null 2>/dev/null 
        if [[ $? -eq 0 ]]; then 
            echo "Agent SSH démarré"
        else 
        echo " Erreur lors du demarrage de l'agent SSH" 
        fi 
    fi
   
    #Ajoute la clà l'agent SSH.
    ssh-add "/home/$USER_NAME/.ssh/id_ed25519" > /dev/null 2>/dev/null  
    if [[ $? -eq 0 ]]; then 
        echo "La clé SSH est ajoutée à l'agent SSH" 
    else 
        echo "Erreur lors de l'ajout de la clé SSH à l'agent SSH" 
    fi 
fi

rm -f logs/cle_public.txt && touch logs/cle_public.txt && chmod 666 logs/cle_public.txt
cat "/home/$USER_NAME/.ssh/id_ed25519.pub" > logs/cle_public.txt 2>/dev/null