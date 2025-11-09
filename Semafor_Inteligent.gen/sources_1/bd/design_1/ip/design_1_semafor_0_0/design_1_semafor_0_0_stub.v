// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sun Nov  9 15:03:31 2025
// Host        : LAPTOP-RD189EMT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/UTCN/AN_3/Semestru1/SSC/Proiect/Semafor_Inteligent/Semafor_Inteligent.gen/sources_1/bd/design_1/ip/design_1_semafor_0_0/design_1_semafor_0_0_stub.v
// Design      : design_1_semafor_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "design_1_semafor_0_0,semafor,{}" *) (* CORE_GENERATION_INFO = "design_1_semafor_0_0,semafor,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=semafor,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,CLOCK_FREQ=100000000,T_MIN_NS=10,T_MIN_EW=10,T_YELLOW=3,T_PED=10}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "module_ref" *) (* X_CORE_INFO = "semafor,Vivado 2024.2" *) 
module design_1_semafor_0_0(clk, rst, btn, sw, green_ns_i, green_ew_i, led_out)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,btn[3:0],sw[3:0],green_ns_i[3:0],green_ew_i[3:0],led_out[3:0]" */;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input rst;
  input [3:0]btn;
  input [3:0]sw;
  input [3:0]green_ns_i;
  input [3:0]green_ew_i;
  output [3:0]led_out;
endmodule
