# 
# Pour lancer : 
# Ouvrir "Xilinx Software Command Line Tool 2020.2" (XSCT)
# Lancer le script avec la commande suivante: 
#		source D:/ZYBO/Work-2020.2/Ateliers/Atelier3-Git/scripts/vitisProj.tcl

# Set the reference directory for source file relative paths (by default the value is script directory path)
# ==> Pointe vers le répertoire dans lequel on a mis les scripts TCL
set origin_dir "."

# nom du projet
set app_name bracelus_vitis

# spécifier le répertoire où placer le projet
set workspace C:/Users/ludov/bracelus_test/bracelus_embarque/work/bracelus_vitis

# Paths pour les fichiers sources c/c++/h
set sourcePath C:/Users/ludov/bracelus_test/bracelus_embarque/vitisProj/src

# Path pour le fichier .xsa
set hw C:/Users/ludov/bracelus_test/bracelus_embarque/work/bracelus_vhdl/Top.xsa

# Créer le workspace
file delete -force $workspace
setws $workspace
cd $workspace

# Créer le projet. La plateform va être créée automatiquement par XSCT
app create -name $app_name -hw $hw -os {freertos10_xilinx} -proc {ps7_cortexa9_0} -template {Empty Application} 

# Importation des fichiers sources
importsources -name $app_name -path $sourcePath -soft-link
#importsources -name $app_name -path $sourcePath/lscript.ld -linker-script

# Compiler le projet
app build -name $app_name