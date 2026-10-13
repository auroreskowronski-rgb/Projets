#!/bin/bash


# Mettre à jour les sources
echo "Verification des mise à jour des paquets"
apt update >/dev/null 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo "La mise à jour de la liste des mise à jour est effectué."
else
    echo "La mise à jour de la liste des mise à jour a echoué"

fi

apt upgrade -y >/dev/null 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo "La mise à jour des paquets est effectué."
else
    echo "La mise à jour des paquets a echoué."
fi