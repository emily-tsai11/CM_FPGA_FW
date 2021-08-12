library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.std_logic_misc.all;

use work.axiRegPkg.all;
use work.axiRegPkg_d64.all;
use work.types.all;
use work.K_IO_Ctrl.all;


Library UNISIM;
use UNISIM.vcomponents.all;

entity top is
  port (
    -- clocks
    p_clk_100 : in std_logic;
    n_clk_100 : in std_logic;           -- 200 MHz system clock

    -- Zynq AXI Chip2Chip
    n_util_clk_chan0 : in std_logic;
    p_util_clk_chan0 : in std_logic;
    n_mgt_z2k        : in  std_logic_vector(1 downto 1);
    p_mgt_z2k        : in  std_logic_vector(1 downto 1);
    n_mgt_k2z        : out std_logic_vector(1 downto 1);
    p_mgt_k2z        : out std_logic_vector(1 downto 1)

--    k_fpga_i2c_scl   : inout std_logic;
--    k_fpga_i2c_sda   : inout std_logic

    --TCDS
    --p_clk0_chan0     : in std_logic; -- 200 MHz system clock
    --n_clk0_chan0     : in std_logic; 
    --p_clk1_chan0     : in std_logic; -- 312.195122 MHz synth clock
    --n_clk1_chan0     : in std_logic;
    --p_atca_tts_out   : out std_logic;
    --n_atca_tts_out   : out std_logic;
    --p_atca_ttc_in    : in  std_logic;
    --n_atca_ttc_in    : in  std_logic;

    
    -- tri-color LED
    --led_red : out std_logic;
    --led_green : out std_logic;
    --led_blue : out std_logic       -- assert to turn on
    -- utility bits to/from TM4C
    );    
end entity top;

architecture structure of top is

  
  signal clk_200_raw     : std_logic;
  signal clk_200         : std_logic;
  signal clk_50          : std_logic;
  signal reset           : std_logic;
  signal locked_clk200   : std_logic;

  signal led_blue_local  : slv_8_t;
  signal led_red_local   : slv_8_t;
  signal led_green_local : slv_8_t;

  constant localAXISlaves    : integer := 2;
  signal local_AXI_ReadMOSI  :  AXIReadMOSI_array_t(0 to localAXISlaves-1) := ( others => DefaultAXIReadMOSI);
  signal local_AXI_ReadMISO  :  AXIReadMISO_array_t(0 to localAXISlaves-1) := ( others => DefaultAXIReadMISO);
  signal local_AXI_WriteMOSI : AXIWriteMOSI_array_t(0 to localAXISlaves-1) := ( others => DefaultAXIWriteMOSI);
  signal local_AXI_WriteMISO : AXIWriteMISO_array_t(0 to localAXISlaves-1) := ( others => DefaultAXIWriteMISO);
  signal AXI_CLK             : std_logic;
  signal AXI_RST_N           : std_logic;
  signal AXI_RESET           : std_logic;

  signal ext_AXI_ReadMOSI  :  AXIReadMOSI_d64 := DefaultAXIReadMOSI_d64;
  signal ext_AXI_ReadMISO  :  AXIReadMISO_d64 := DefaultAXIReadMISO_d64;
  signal ext_AXI_WriteMOSI : AXIWriteMOSI_d64 := DefaultAXIWriteMOSI_d64;
  signal ext_AXI_WriteMISO : AXIWriteMISO_d64 := DefaultAXIWriteMISO_d64;

  

  signal C2CLink_aurora_do_cc                : STD_LOGIC;
  signal C2CLink_axi_c2c_config_error_out    : STD_LOGIC;
  signal C2CLink_axi_c2c_link_status_out     : STD_LOGIC;
  signal C2CLink_axi_c2c_multi_bit_error_out : STD_LOGIC;
  signal C2CLink_phy_gt_pll_lock             : STD_LOGIC;
  signal C2CLink_phy_hard_err                : STD_LOGIC;
  signal C2CLink_phy_lane_up                 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal C2CLink_phy_link_reset_out          : STD_LOGIC;
  signal C2CLink_phy_mmcm_not_locked_out     : STD_LOGIC;
  signal C2CLink_phy_soft_err                : STD_LOGIC;


  signal BRAM_write : std_logic;
  signal BRAM_addr  : std_logic_vector(9 downto 0);
  signal BRAM_WR_data : std_logic_vector(31 downto 0);
  signal BRAM_RD_data : std_logic_vector(31 downto 0);

--  signal AXI_BRAM_EN : std_logic;
--  signal AXI_BRAM_we : std_logic_vector(7 downto 0);
--  signal AXI_BRAM_addr :std_logic_vector(12 downto 0);
--  signal AXI_BRAM_DATA_IN : std_logic_vector(63 downto 0);
--  signal AXI_BRAM_DATA_OUT : std_logic_vector(63 downto 0);


  signal bram_rst_a    : std_logic;
  signal bram_clk_a    : std_logic;
  signal bram_en_a     : std_logic;
  signal bram_we_a     : std_logic_vector(7 downto 0);
  signal bram_addr_a   : std_logic_vector(8 downto 0);
  signal bram_wrdata_a : std_logic_vector(63 downto 0);
  signal bram_rddata_a : std_logic_vector(63 downto 0);


  constant family : string := "kintexuplus";
  constant axi_protocol : string := "AXI4";

  
  
begin  -- architecture structure

  --Clocking
  Local_Clocking_1: entity work.Local_Clocking
    port map (
      clk_200   => clk_200,
      clk_50    => clk_50,
      clk_axi   => AXI_CLK,
      reset     => '0',
      locked    => locked_clk200,
      clk_in1_p => p_clk_100,
      clk_in1_n => n_clk_100);


  

  c2csslave_wrapper_1: entity work.c2cslave_wrapper
    port map (
      AXI_CLK                             => AXI_CLK,
      AXI_RST_N(0)                        => AXI_RST_N,
      K_C2C_phy_Rx_rxn                  => n_mgt_z2k,
      K_C2C_phy_Rx_rxp                  => p_mgt_z2k,
      K_C2C_phy_Tx_txn                  => n_mgt_k2z,
      K_C2C_phy_Tx_txp                  => p_mgt_k2z,
      K_C2C_phy_refclk_clk_n            => n_util_clk_chan0,
      K_C2C_phy_refclk_clk_p            => p_util_clk_chan0,
      clk50Mhz                            => clk_50,
      K_IO_araddr                         => local_AXI_ReadMOSI(0).address,              
      K_IO_arprot                         => local_AXI_ReadMOSI(0).protection_type,      
      K_IO_arready                        => local_AXI_ReadMISO(0).ready_for_address,    
      K_IO_arvalid                        => local_AXI_ReadMOSI(0).address_valid,        
      K_IO_awaddr                         => local_AXI_WriteMOSI(0).address,             
      K_IO_awprot                         => local_AXI_WriteMOSI(0).protection_type,     
      K_IO_awready                        => local_AXI_WriteMISO(0).ready_for_address,   
      K_IO_awvalid                        => local_AXI_WriteMOSI(0).address_valid,       
      K_IO_bready                      => local_AXI_WriteMOSI(0).ready_for_response,  
      K_IO_bresp                          => local_AXI_WriteMISO(0).response,            
      K_IO_bvalid                      => local_AXI_WriteMISO(0).response_valid,      
      K_IO_rdata                          => local_AXI_ReadMISO(0).data,                 
      K_IO_rready                      => local_AXI_ReadMOSI(0).ready_for_data,       
      K_IO_rresp                          => local_AXI_ReadMISO(0).response,             
      K_IO_rvalid                      => local_AXI_ReadMISO(0).data_valid,           
      K_IO_wdata                          => local_AXI_WriteMOSI(0).data,                
      K_IO_wready                      => local_AXI_WriteMISO(0).ready_for_data,       
      K_IO_wstrb                          => local_AXI_WriteMOSI(0).data_write_strobe,   
      K_IO_wvalid                      => local_AXI_WriteMOSI(0).data_valid,          
      CM_K_INFO_araddr                    => local_AXI_ReadMOSI(1).address,              
      CM_K_INFO_arprot                    => local_AXI_ReadMOSI(1).protection_type,      
      CM_K_INFO_arready                => local_AXI_ReadMISO(1).ready_for_address,    
      CM_K_INFO_arvalid                => local_AXI_ReadMOSI(1).address_valid,        
      CM_K_INFO_awaddr                    => local_AXI_WriteMOSI(1).address,             
      CM_K_INFO_awprot                    => local_AXI_WriteMOSI(1).protection_type,     
      CM_K_INFO_awready                => local_AXI_WriteMISO(1).ready_for_address,   
      CM_K_INFO_awvalid                => local_AXI_WriteMOSI(1).address_valid,       
      CM_K_INFO_bready                 => local_AXI_WriteMOSI(1).ready_for_response,  
      CM_K_INFO_bresp                     => local_AXI_WriteMISO(1).response,            
      CM_K_INFO_bvalid                 => local_AXI_WriteMISO(1).response_valid,      
      CM_K_INFO_rdata                     => local_AXI_ReadMISO(1).data,                 
      CM_K_INFO_rready                 => local_AXI_ReadMOSI(1).ready_for_data,       
      CM_K_INFO_rresp                     => local_AXI_ReadMISO(1).response,             
      CM_K_INFO_rvalid                 => local_AXI_ReadMISO(1).data_valid,           
      CM_K_INFO_wdata                     => local_AXI_WriteMOSI(1).data,                
      CM_K_INFO_wready                 => local_AXI_WriteMISO(1).ready_for_data,       
      CM_K_INFO_wstrb                     => local_AXI_WriteMOSI(1).data_write_strobe,   
      CM_K_INFO_wvalid                 => local_AXI_WriteMOSI(1).data_valid,          


      KINTEX_IPBUS_araddr                 => ext_AXI_ReadMOSI.address,              
      KINTEX_IPBUS_arburst                => ext_AXI_ReadMOSI.burst_type,
      KINTEX_IPBUS_arcache                => ext_AXI_ReadMOSI.cache_type,
      KINTEX_IPBUS_arlen                  => ext_AXI_ReadMOSI.burst_length,
      KINTEX_IPBUS_arlock(0)              => ext_AXI_ReadMOSI.lock_type,
      KINTEX_IPBUS_arprot                 => ext_AXI_ReadMOSI.protection_type,      
      KINTEX_IPBUS_arqos                  => ext_AXI_ReadMOSI.qos,
      KINTEX_IPBUS_arready(0)             => ext_AXI_ReadMISO.ready_for_address,
      KINTEX_IPBUS_arregion               => ext_AXI_ReadMOSI.region,
      KINTEX_IPBUS_arsize                 => ext_AXI_ReadMOSI.burst_size,
      KINTEX_IPBUS_arvalid(0)             => ext_AXI_ReadMOSI.address_valid,        
      KINTEX_IPBUS_awaddr                 => ext_AXI_WriteMOSI.address,             
      KINTEX_IPBUS_awburst                => ext_AXI_WriteMOSI.burst_type,
      KINTEX_IPBUS_awcache                => ext_AXI_WriteMOSI.cache_type,
      KINTEX_IPBUS_awlen                  => ext_AXI_WriteMOSI.burst_length,
      KINTEX_IPBUS_awlock(0)              => ext_AXI_WriteMOSI.lock_type,
      KINTEX_IPBUS_awprot                 => ext_AXI_WriteMOSI.protection_type,
      KINTEX_IPBUS_awqos                  => ext_AXI_WriteMOSI.qos,
      KINTEX_IPBUS_awready(0)             => ext_AXI_WriteMISO.ready_for_address,   
      KINTEX_IPBUS_awregion               => ext_AXI_WriteMOSI.region,
      KINTEX_IPBUS_awsize                 => ext_AXI_WriteMOSI.burst_size,
      KINTEX_IPBUS_awvalid(0)             => ext_AXI_WriteMOSI.address_valid,       
      KINTEX_IPBUS_bready(0)              => ext_AXI_WriteMOSI.ready_for_response,  
      KINTEX_IPBUS_bresp                  => ext_AXI_WriteMISO.response,            
      KINTEX_IPBUS_bvalid(0)              => ext_AXI_WriteMISO.response_valid,      
      KINTEX_IPBUS_rdata                  => ext_AXI_ReadMISO.data,
      KINTEX_IPBUS_rlast(0)               => ext_AXI_ReadMISO.last,
      KINTEX_IPBUS_rready(0)              => ext_AXI_ReadMOSI.ready_for_data,       
      KINTEX_IPBUS_rresp                  => ext_AXI_ReadMISO.response,             
      KINTEX_IPBUS_rvalid(0)              => ext_AXI_ReadMISO.data_valid,           
      KINTEX_IPBUS_wdata                  => ext_AXI_WriteMOSI.data,
      KINTEX_IPBUS_wlast(0)               => ext_AXI_WriteMOSI.last,
      KINTEX_IPBUS_wready(0)              => ext_AXI_WriteMISO.ready_for_data,       
      KINTEX_IPBUS_wstrb                  => ext_AXI_WriteMOSI.data_write_strobe,   
      KINTEX_IPBUS_wvalid(0)              => ext_AXI_WriteMOSI.data_valid,          
      reset_n                             => locked_clk200,--reset,
      K_C2C_aurora_do_cc                => C2CLink_aurora_do_cc,               
      K_C2C_axi_c2c_config_error_out    => C2CLink_axi_c2c_config_error_out,   
      K_C2C_axi_c2c_link_status_out     => C2CLink_axi_c2c_link_status_out,    
      K_C2C_axi_c2c_multi_bit_error_out => C2CLink_axi_c2c_multi_bit_error_out,
      K_C2C_phy_gt_pll_lock             => C2CLink_phy_gt_pll_lock,            
      K_C2C_phy_hard_err                => C2CLink_phy_hard_err,               
      K_C2C_phy_lane_up                 => C2CLink_phy_lane_up,                
      K_C2C_phy_link_reset_out          => C2CLink_phy_link_reset_out,         
      K_C2C_phy_mmcm_not_locked_out     => C2CLink_phy_mmcm_not_locked_out,    
      K_C2C_phy_power_down              => '0',
      K_C2C_phy_soft_err                => C2CLink_phy_soft_err
);

  RGB_pwm_1: entity work.RGB_pwm
    generic map (
      CLKFREQ => 200000000,
      RGBFREQ => 1000)
    port map (
      clk        => clk_200,
      redcount   => led_red_local,
      greencount => led_green_local,
      bluecount  => led_blue_local,
      LEDred     => open,
      LEDgreen   => open,
      LEDblue    => open);

  K_IO_interface_1: entity work.K_IO_map
    port map (
      clk_axi         => AXI_CLK,
      reset_axi_n     => AXI_RST_N,
      slave_readMOSI  => local_AXI_readMOSI(0),
      slave_readMISO  => local_AXI_readMISO(0),
      slave_writeMOSI => local_AXI_writeMOSI(0),
      slave_writeMISO => local_AXI_writeMISO(0),
      Mon.C2C.CONFIG_ERR      => C2CLink_axi_c2c_config_error_out,
      Mon.C2C.DO_CC           => C2CLink_aurora_do_cc,
      Mon.C2C.GT_PLL_LOCK     => C2CLink_phy_gt_pll_lock,
      Mon.C2C.HARD_ERR        => C2CLink_phy_hard_err,
      Mon.C2C.LANE_UP         => C2CLink_phy_lane_up(0),
      Mon.C2C.LINK_RESET      => C2CLink_phy_link_reset_out,
      Mon.C2C.LINK_STATUS     => C2CLink_axi_c2c_link_status_out,
      Mon.C2C.MMCM_NOT_LOCKED => C2CLink_phy_mmcm_not_locked_out,
      Mon.C2C.MULTIBIT_ERR    => C2CLink_axi_c2c_multi_bit_error_out,
      Mon.C2C.SOFT_ERR        => C2CLink_phy_soft_err,
      Mon.CLK_200_LOCKED      => locked_clk200,
      Mon.BRAM.RD_DATA        => BRAM_RD_DATA,
      Ctrl.RGB.R              => led_red_local,
      Ctrl.RGB.G              => led_green_local,
      Ctrl.RGB.B              => led_blue_local,
      Ctrl.BRAM.WRITE         => BRAM_WRITE,
      Ctrl.BRAM.ADDR(9 downto 0)          => BRAM_ADDR,
      Ctrl.BRAM.ADDR(14 downto 10) => open,
      Ctrl.BRAM.WR_DATA       => BRAM_WR_DATA
      );

  CM_K_info_1: entity work.CM_K_info
    port map (
      clk_axi     => AXI_CLK,
      reset_axi_n => AXI_RST_N,
      readMOSI    => local_AXI_ReadMOSI(1),
      readMISO    => local_AXI_ReadMISO(1),
      writeMOSI   => local_AXI_WriteMOSI(1),
      writeMISO   => local_AXI_WriteMISO(1));


  AXI_RESET <= not AXI_RST_N;
  axi_bram_controller_1: entity work.axi_bram_controller
    generic map (
      USE_D64_PKG                   => 1,
      C_ADR_WIDTH                   => 32,
      C_DATA_WIDTH                  => 64,
--      C_FAMILY                      => "kintexuplus",
      C_FAMILY                      => family,
      C_MEMORY_DEPTH                => 4096,
      C_BRAM_ADDR_WIDTH             => 12,
      C_SINGLE_PORT_BRAM            => 1,
      C_S_AXI_ID_WIDTH              => 0,
--      C_S_AXI_PROTOCOL              => "AXI4",
      C_S_AXI_PROTOCOL              => axi_protocol,
      C_S_AXI_DATA_WIDTH            => 64)
    port map (
      s_axi_aclk    => AXI_CLK,
      s_axi_aresetn => AXI_RST_N,
      r_mosi_d64        => ext_AXI_ReadMOSI,
      r_miso_d64        => ext_AXI_ReadMISO,
      w_mosi_d64        => ext_AXI_WriteMOSI,
      w_miso_d64        => ext_AXI_WriteMISO,
      bram_rst_a    => bram_rst_a,
      bram_clk_a    => bram_clk_a,
      bram_en_a     => bram_en_a,
      bram_we_a     => bram_we_a,
      bram_addr_a(31 downto 11) => open,
      bram_addr_a(10 downto  2) => bram_addr_a,
      bram_addr_a( 1 downto  0) => open,
      bram_wrdata_a => bram_wrdata_a,
      bram_rddata_a => bram_rddata_a);


  asym_ram_tdp_1: entity work.asym_ram_tdp
    generic map (
      WIDTHA     => 32,
      SIZEA      => 1024,
      ADDRWIDTHA => 10,
      WIDTHB     => 64,
      SIZEB      => 512,
      ADDRWIDTHB => 9)
    port map (
      clkA  => AXI_CLK,
      clkB  => AXI_CLK,
      enA   => '1',
      enB   => bram_en_a,
      weA   => BRAM_WRITE,
      weB   => or_reduce(bram_we_a),
      addrA => BRAM_ADDR,
      addrB => bram_addr_a,
      diA   => BRAM_WR_DATA,
      diB   => bram_wrdata_a,
      doA   => open,
      doB   => bram_rddata_a);
  
end architecture structure;