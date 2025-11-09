# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CLOCK_FREQ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "T_MIN_EW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "T_MIN_NS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "T_PED" -parent ${Page_0}
  ipgui::add_param $IPINST -name "T_YELLOW" -parent ${Page_0}


}

proc update_PARAM_VALUE.CLOCK_FREQ { PARAM_VALUE.CLOCK_FREQ } {
	# Procedure called to update CLOCK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_FREQ { PARAM_VALUE.CLOCK_FREQ } {
	# Procedure called to validate CLOCK_FREQ
	return true
}

proc update_PARAM_VALUE.T_MIN_EW { PARAM_VALUE.T_MIN_EW } {
	# Procedure called to update T_MIN_EW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T_MIN_EW { PARAM_VALUE.T_MIN_EW } {
	# Procedure called to validate T_MIN_EW
	return true
}

proc update_PARAM_VALUE.T_MIN_NS { PARAM_VALUE.T_MIN_NS } {
	# Procedure called to update T_MIN_NS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T_MIN_NS { PARAM_VALUE.T_MIN_NS } {
	# Procedure called to validate T_MIN_NS
	return true
}

proc update_PARAM_VALUE.T_PED { PARAM_VALUE.T_PED } {
	# Procedure called to update T_PED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T_PED { PARAM_VALUE.T_PED } {
	# Procedure called to validate T_PED
	return true
}

proc update_PARAM_VALUE.T_YELLOW { PARAM_VALUE.T_YELLOW } {
	# Procedure called to update T_YELLOW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.T_YELLOW { PARAM_VALUE.T_YELLOW } {
	# Procedure called to validate T_YELLOW
	return true
}


proc update_MODELPARAM_VALUE.CLOCK_FREQ { MODELPARAM_VALUE.CLOCK_FREQ PARAM_VALUE.CLOCK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_FREQ}] ${MODELPARAM_VALUE.CLOCK_FREQ}
}

proc update_MODELPARAM_VALUE.T_MIN_NS { MODELPARAM_VALUE.T_MIN_NS PARAM_VALUE.T_MIN_NS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T_MIN_NS}] ${MODELPARAM_VALUE.T_MIN_NS}
}

proc update_MODELPARAM_VALUE.T_MIN_EW { MODELPARAM_VALUE.T_MIN_EW PARAM_VALUE.T_MIN_EW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T_MIN_EW}] ${MODELPARAM_VALUE.T_MIN_EW}
}

proc update_MODELPARAM_VALUE.T_YELLOW { MODELPARAM_VALUE.T_YELLOW PARAM_VALUE.T_YELLOW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T_YELLOW}] ${MODELPARAM_VALUE.T_YELLOW}
}

proc update_MODELPARAM_VALUE.T_PED { MODELPARAM_VALUE.T_PED PARAM_VALUE.T_PED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.T_PED}] ${MODELPARAM_VALUE.T_PED}
}

