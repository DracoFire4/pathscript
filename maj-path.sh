#!/bin/bash
# Ajout des variables
verrou="/tmp/$(basename "$0")_verrou.lock"
date=$(date +"%Y%m%d_%H%M%S")
# Couleurs (:
ROUGE='\033[0;31m'
BLANC='\033[0;37m'
VERT='\033[0;32m'

# Vérifie si c'est la première fois que le script à été exécuté, si oui donne les instructions
if [ ! -e "$verrou" ]; 
then
# Message d'introduction à l'utilisation du script
    echo -e "\n\n\nCe script $(basename "$0") à pour intention d'ajouter un chemin à la variable d'environnement PATH.\nLors de son éxécution, ce script génère un fichier de sauvegarde du .bashrc dans le répertoire $HOME.\n"
    echo -e "Ceci est apparement la première fois que ce script est exécuté, voici donc son utilisation :\n\nSi le script est exécuté avec un argument, une entrée valide serait un chemin absolu existant vers un répertoire ou un fichier, example: ${VERT}/var/www/html${BLANC}.\nSi aucun argument n'est fourni, le script utilisera le chemin courant."
    echo -e "${ROUGE}Ces messages ne s'affichent qu'à la première exécution, pour utiliser ce script, éxécuter le une deuxième fois.${BLANC}"
# Créer le fichier qui est responsable de vérifier si c'est la première exécution du script
    touch "$verrou"


# Vérifie le nombre d'argument en entré et si le chemin donné en argument est valide
# [[ "$(readlink -f "$1")" == "$1" ]] pas vus en classe, permet d'assurer que le chemin passé en argument n'est pas relatif
elif [ $# -eq 1 ] && [ -d "$1" ] || [ -f "$1" ] && [[ "$(readlink -f "$1")" == "$1" ]]; 
then
# Vérifie si la variable existe déja
    if ! grep -qF "export PATH=\"\$PATH:$1\"" "$HOME/.bashrc";
    then
# Copie le fichier .bashrc avant la modification
        echo "Création d'un fichier de sauvegarde de la configuration bash"
        cp "$HOME/.bashrc" "$HOME/.bashrc_$date"
# Ajoute la variable au .bashrc et au shell en cour d'utilisation (pas envie de redémarer mon shell pour que le nouveau chemin dans PATH fonctionne)
        echo 'export PATH="$PATH:'"$1"'"' >> $HOME/.bashrc
        export PATH="$PATH:$1"
        echo "Mise à jour de la variable PATH terminée avec succès."
        exit 0

else
    echo "Le chemin $1 est déjà présent dans PATH."
    exit 1
fi

# Si aucun argument n'est fourni
elif [ $# -eq 0 ];
then
# Vérifie si la variable existe déja
    if ! grep -qF "export PATH=\"\$PATH:$PWD\"" "$HOME/.bashrc";
    then
# Copie le fichier .bashrc avant la modification
        echo "Création d'un fichier de sauvegarde de la configuration bash"
        cp "$HOME/.bashrc" "$HOME/.bashrc_$date"
# Ajoute la variable au .bashrc et au shell en cour d'utilisation (pas envie de redémarer mon shell pour que le nouveau chemin dans PATH fonctionne)
        echo 'export PATH="$PATH:'"$PWD"'"' >> $HOME/.bashrc
        export PATH="$PATH:$PWD"
        echo "Mise à jour de la variable PATH terminée avec succès."
        exit 0

else
    echo "Le chemin $PWD est déjà présent dans PATH."
    exit 1
fi

else
    echo "Variable(s) en entré erroné!"
    exit 1
fi