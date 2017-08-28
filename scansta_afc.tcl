#
# Copyright (ↄ) 2017 by Piotr Miedzik <P.Miedzik@gsi.de>
#

proc scansta_enable_target {target {probes_file ""}} {

close_hw_target 
catch {
 open_hw_target -jtag_mode true ${target}
}
run_state_hw_jtag RESET
run_state_hw_jtag IDLE
catch {
  scan_ir_hw_jtag  8 -tdi 00 -tdo FF -mask FF
}
catch {
  scan_ir_hw_jtag  8 -tdi A0 -tdo 01 -mask FF
}
catch {
	scan_ir_hw_jtag  8 -tdi A5 -tdo 51 -mask FF
}
catch {
	scan_dr_hw_jtag  8 -tdi 5A -tdo B4 -mask FF
}
catch {
	scan_ir_hw_jtag  8 -tdi C3 -tdo D1 -mask FF
}
catch {
	scan_dr_hw_jtag  8 -tdi 5A -tdo 00 -mask FF
}
close_hw_target ${target}
close_hw_target ${target}

open_hw_target ${target}

if {[string compare "" ${probes_file}] != 0} {
set my_hw_device [lindex [get_hw_devices -of_objects [current_hw_target]] 0]
set_property PROBES.FILE ${probes_file} ${my_hw_device}

catch {
refresh_hw_device ${my_hw_device}
}

puts {display_hw_ila_data [ get_hw_ila_data hw_ila_data_1 -of_objects [get_hw_ilas -of_objects [get_hw_devices xc7a200t_0] -filter {CELL_NAME=~"U_CTL/GEN_ILA_CTL.U_ila_root2wb/U_ILA_wishbone"}]]}

}

}



proc scansta_enable_all {} {
foreach target [get_hw_targets] {
  scansta_enable_target ${target}
}

}

#create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev  [lindex [get_cfgmem_parts {n25q128-3.3v-spi-x1_x2_x4}] 0]
