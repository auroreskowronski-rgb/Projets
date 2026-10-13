#!/bin/bash
# Installer les paquets manquant
LIST1=logs/a_installer.txt
LIST3=logs/installé.txt
#Reitialisation de $LIST3
rm -f $LIST3 && touch $LIST3 && chmod 666 $LIST3
echo "Liste des paquets installé :" > $LIST3

#Installe chaque paquets dans la liste des paquet à installer
for PAQUET in $(tail -n +2  $LIST1) ; do
    echo "Installation de \"$PAQUET\" en cours... Veuillez patienter"
    apt  install -y -q  $PAQUET >/dev/null 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "Le paquet \"$PAQUET\" a été installé."
        echo $PAQUET >> $LIST3
    else
        echo "Erreur dans l'installation de \"$PAQUET\""
        
    fi

done