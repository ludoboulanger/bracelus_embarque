

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "MouvAnalyseIP" "NUM_INSTANCES" "DEVICE_ID"  "C_MouvAnalyseIP_BASEADDR" "C_MouvAnalyseIP_HIGHADDR"
}
