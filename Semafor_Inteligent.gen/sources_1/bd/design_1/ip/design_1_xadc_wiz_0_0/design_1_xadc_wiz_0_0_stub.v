// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Sun Nov  9 15:03:46 2025
// Host        : LAPTOP-RD189EMT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/UTCN/AN_3/Semestru1/SSC/Proiect/Semafor_Inteligent/Semafor_Inteligent.gen/sources_1/bd/design_1/ip/design_1_xadc_wiz_0_0/design_1_xadc_wiz_0_0_stub.v
// Design      : design_1_xadc_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CORE_GENERATION_INFO = "design_1_xadc_wiz_0_0,xadc_wiz_v3_3_11,{component_name=design_1_xadc_wiz_0_0,enable_axi=true,enable_axi4stream=true,dclk_frequency=100,enable_busy=true,enable_convst=false,enable_convstclk=false,enable_dclk=true,enable_drp=false,enable_eoc=true,enable_eos=true,enable_vbram_alaram=false,enable_vccddro_alaram=true,enable_Vccint_Alaram=true,enable_Vccaux_alaram=true,enable_vccpaux_alaram=true,enable_vccpint_alaram=true,ot_alaram=true,user_temp_alaram=true,timing_mode=continuous,channel_averaging=None,sequencer_mode=on,startup_channel_selection=contineous_sequence}" *) 
module design_1_xadc_wiz_0_0(s_axi_aclk, s_axi_aresetn, s_axi_awaddr, 
  s_axi_awvalid, s_axi_awready, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, s_axi_wready, 
  s_axi_bresp, s_axi_bvalid, s_axi_bready, s_axi_araddr, s_axi_arvalid, s_axi_arready, 
  s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready, ip2intc_irpt, s_axis_aclk, 
  m_axis_tdata, m_axis_tvalid, m_axis_tid, m_axis_tready, vauxp6, vauxn6, vauxp7, vauxn7, vauxp14, 
  vauxn14, vauxp15, vauxn15, channel_out, busy_out, eoc_out, eos_out, ot_out, vccddro_alarm_out, 
  vccpaux_alarm_out, vccpint_alarm_out, vccaux_alarm_out, vccint_alarm_out, 
  user_temp_alarm_out, alarm_out, vp_in, vn_in)
/* synthesis syn_black_box black_box_pad_pin="s_axi_aresetn,s_axi_awaddr[10:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[10:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,ip2intc_irpt,m_axis_tdata[15:0],m_axis_tvalid,m_axis_tid[4:0],m_axis_tready,vauxp6,vauxn6,vauxp7,vauxn7,vauxp14,vauxn14,vauxp15,vauxn15,channel_out[4:0],busy_out,eoc_out,eos_out,ot_out,vccddro_alarm_out,vccpaux_alarm_out,vccpint_alarm_out,vccaux_alarm_out,vccint_alarm_out,user_temp_alarm_out,alarm_out,vp_in,vn_in" */
/* synthesis syn_force_seq_prim="s_axi_aclk" */
/* synthesis syn_force_seq_prim="s_axis_aclk" */;
  input s_axi_aclk /* synthesis syn_isclock = 1 */;
  input s_axi_aresetn;
  input [10:0]s_axi_awaddr;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wvalid;
  output s_axi_wready;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [10:0]s_axi_araddr;
  input s_axi_arvalid;
  output s_axi_arready;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rvalid;
  input s_axi_rready;
  output ip2intc_irpt;
  input s_axis_aclk /* synthesis syn_isclock = 1 */;
  output [15:0]m_axis_tdata;
  output m_axis_tvalid;
  output [4:0]m_axis_tid;
  input m_axis_tready;
  input vauxp6;
  input vauxn6;
  input vauxp7;
  input vauxn7;
  input vauxp14;
  input vauxn14;
  input vauxp15;
  input vauxn15;
  output [4:0]channel_out;
  output busy_out;
  output eoc_out;
  output eos_out;
  output ot_out;
  output vccddro_alarm_out;
  output vccpaux_alarm_out;
  output vccpint_alarm_out;
  output vccaux_alarm_out;
  output vccint_alarm_out;
  output user_temp_alarm_out;
  output alarm_out;
  input vp_in;
  input vn_in;
endmodule
