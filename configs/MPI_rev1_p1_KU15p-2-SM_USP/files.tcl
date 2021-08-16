set bd_path proj/

array set bd_files [list {c2cSlave} {src/c2cBD/createC2CSlaveInterconnect.tcl} \
			]

set vhdl_files "\
     configs/MPI_rev1_p1_KU15p-2-SM_USP/src/top.vhd \
     src/misc/pass_time_domain.vhd \
     src/misc/pacd.vhd \
     src/misc/types.vhd \
     src/misc/capture_CDC.vhd \
     src/misc/counter.vhd \
     src/misc/counter_clock.vhd \
     src/misc/asym_dualport_ram.vhd \
     src/misc/Xilinx/rams_sp_wf.vhd \
     regmap_helper/axiReg/axiRegWidthPkg_32.vhd \
     regmap_helper/axiReg/axiRegPkg_d64.vhd \
     regmap_helper/axiReg/axiRegPkg.vhd \
     regmap_helper/axiReg/axiReg.vhd \
     configs/MPI_rev1_p1_KU15p-2-SM_USP/autogen/CM_IO/K_IO_PKG.vhd \
     configs/MPI_rev1_p1_KU15p-2-SM_USP/autogen/CM_IO/K_IO_map.vhd \
     regmap_helper/axiReg/axiRegBlocking.vhd \
     regmap_helper/axiReg/bramPortPkg.vhd \   
     src/misc/RGB_PWM.vhd \
     src/misc/LED_PWM.vhd \
     src/CM_FW_info/CM_K_info.vhd \
     configs/MPI_rev1_p1_KU15p-2-SM_USP/autogen/CM_FW_info/CM_K_INFO_PKG.vhd \
     configs/MPI_rev1_p1_KU15p-2-SM_USP/autogen/CM_FW_info/CM_K_INFO_map.vhd \
     src/misc/axi_bram_ctrl_v4_1_rfs.vhd \
     src/misc/axi_bram_controller.vhd \
     src/MEM_TEST/Mem_test.vhd \
     src/MEM_TEST/MEM_TEST_map.vhd \
     src/MEM_TEST/MEM_TEST_PKG.vhd \
     "
set xdc_files "\
    configs/MPI_rev1_p1_KU15p-2-SM_USP/src/top_pins.xdc \
    configs/MPI_rev1_p1_KU15p-2-SM_USP/src/top_timing.xdc	\
    "	    

set xci_files "\
    	      configs/MPI_rev1_p1_KU15p-2-SM_USP/cores/Local_Clocking/Local_Clocking.xci \
	      cores/AXI_BRAM/AXI_BRAM.xci \
    	      "

