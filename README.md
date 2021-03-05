# BracelUS 

Ce répertoire contient les fichiers source nécessaire à la compilation et la regénérationd es projets Vivado et Vitis pour BracelUS. Seuls les fichiers sources sont inclu afin de garder le contrôle de version possible.

Des scripts `tcl`sont inclu dans le répertoire `script`

# Génération des projets

Afin de recompiler et générer les projets, il faut générer celui de Vivado en **premier**. Les étapes sont les suivantes:

## Vivado

1. Ouvrir Vivado
2. Dans la ligne de commande au bas de la fenêtre d'acceuil, naviguer vers le répertoire scripts
3. Exécuter la commande `source ./bracelus_vhdl.tcl`
4. Une fois le projet compilé, Écrire le bitstream et exporter ce dernier.

## Vitis

1. Ouvrir le CLI `Xilinx Software Command Line tool`
2. Naviguer vers le répertoire `scripts`
3. Exécuter la commande `source vitisProj.tcl`
4. Le projet Vitis sera alors compilé