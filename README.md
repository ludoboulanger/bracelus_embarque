# BracelUS 

Ce répertoire contient les fichiers source nécessaire à la compilation et la regénérationd es projets Vivado et Vitis pour BracelUS. Seuls les fichiers sources sont inclu afin de garder le contrôle de version possible. Les scripts `tcl`rendent cela possible.

Des scripts `tcl`sont inclu dans le répertoire `script`

# Génération des projets

Afin de recompiler et générer les projets, il faut générer celui de Vivado en **premier**. Les étapes sont les suivantes:

## Vivado

1. Ouvrir Vivado
2. Dans la ligne de commande au bas de la fenêtre d'acceuil, naviguer vers le répertoire scripts
3. Exécuter la commande `source ./bracelus_vhdl.tcl`
4. Une fois le projet compilé, Écrire le bitstream et exporter ce dernier.

## Vitis

### Projet principal
1. Ouvrir le CLI `Xilinx Software Command Line tool`
2. Naviguer vers le répertoire `scripts`
3. Change les paths dnas le fichiers `.tcl` pour qu'ils concordent avec votre organisation de fichiers
4. Exécuter la commande `source vitis.tcl`
5. Le projet Vitis sera alors compilé

### Tests
Un projet Vitis de test peut être créer afin de valider le bon fonctionnement des IPs en vhdl. Aafin de créer ce projet:
1. Ouvrir le CLI `Xilinx Software Command Line tool`
2. Naviguer vers le répertoire `scripts`
3. 3. Change les paths dnas le fichiers `.tcl` pour qu'ils concordent avec votre organisation de fichiers
4. Exécuter la commande `source vitisTest.tcl`
6. Le projet Vitis sera alors compilé
7. Le main contient les tests à faire avec le IP, il est possible d'en rajouter. Faire attention à sélectionner le bon régistre de lecture. Ce dernier peux être localiser dans le fichier `.h` de l'IP en question
