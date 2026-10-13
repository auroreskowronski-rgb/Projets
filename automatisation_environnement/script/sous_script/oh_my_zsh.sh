#!/bin/bash
USER_NAME=$1
USER_HOME="/home/$USER_NAME"
THEME=$2
ALIAS=$3


#Verifie la présence de .oh-my-zsh et le télécharge et l'install si il n'est pas présent
if [ -d "$USER_HOME/.oh-my-zsh" ] ; then
    echo "'oh-my-zsh' est déja installé pour $USER_NAME."
else
    echo "'oh-my-zsh' n'etait pas déjà installé" 
    #Installe oh-my-zhs en tant que $USER_NAME dans $USER_HOME; en mode non interactif et sans changer le shell à la fin
    sudo -u "$USER_NAME" HOME="$USER_HOME" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --skip-chsh    
    echo "'oh-my-zsh' a été installé." 
fi

#Defini le chemin du dossier custom pour ne pas avoir à le repeter
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"

#Verifie l'absence de zsh-autosuggestions et l'installe si il est absent
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    if ! grep -q "^plugins=(.*zsh-autosuggestions.*)" "$USER_HOME/.zshrc"  ; then
        # Ajoute zsh-autosuggestions et a la liste des pluging de .zshrc
        sudo -u "$USER_NAME" sed -i '/^plugins=(/ s/)/ zsh-autosuggestions)/' "$USER_HOME/.zshrc"
    fi
fi

#Verifie l'absence de zsh-syntax-hightlighting et l'installe si il est absent
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    if ! grep -q "^plugins=(.*zsh-syntax-highlighting.*)" "$USER_HOME/.zshrc" ; then
        # Ajoute zsh-syntax-highlighting et a la liste des pluging de .zshrc -i sers a moddifier le fichier sur place
        sudo -u "$USER_NAME" sed -i '/^plugins=(/ s/)/ zsh-syntax-highlighting)/' "$USER_HOME/.zshrc"
    fi
fi





#Verifie si le bon theme est deja configuré et le configure si ce n'est pas le cas
if [ -f "$USER_HOME/.zshrc" ]; then
    if  grep -q "^ZSH_THEME=['\"]$THEME['\"]" "$USER_HOME/.zshrc"; then
        echo "Le  theme \"$THEME\" est déja configurer dans le .zshrc de $USER_NAME"
    else
        sudo -u "$USER_NAME" sed -i "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$THEME\"/g" "$USER_HOME/.zshrc"
        echo "Thème configuré sur '$THEME' dans le .zshrc de $USER_NAME."
    fi
fi


# Ecrit les alias personalisées dans le fichier de config si ce n'est pas déja present
if [ -f "$USER_HOME/.zshrc" ] && [ -n "$ALIAS" ]; then
    #Cherche " "#Mes alias personalisés" -F sert à traiter le texte brut
    if grep -qF "# Mes alias personnalisés" "$USER_HOME/.zshrc"; then
        echo "Les alias personnalisés sont déjà configurés dans le .zshrc de $USER_NAME."
    else
        #Ecrit les alias dans le fichier
        echo -e "\n$ALIAS" | sudo -u "$USER_NAME" tee -a "$USER_HOME/.zshrc" >/dev/null
        echo "Alias personnalisés ajoutés avec succès dans le .zshrc de $USER_NAME."
    fi
fi

#Definit le chemin de zsh et change le shell par défaut avec usermod -s sans demander de mot de passe
ZSH_PATH=$(which zsh)
if [ -n "$ZSH_PATH" ]; then
    usermod -s "$ZSH_PATH" "$USER_NAME" >/dev/null 2>/dev/null
    echo "Le shell par défaut de $USER_NAME a été modifié vers Zsh."
else
    echo "Erreur : Zsh n'est pas installé sur le système. Impossible de changer le shell." >&2
fi

