
--// file: ibert_ultrascale_gty_0.v
--//////////////////////////////////////////////////////////////////////////////
--//   ____  ____ 
--//  /   /\/   /
--// /___/  \  /    Vendor: Xilinx
--// \   \   \/     Version : 2012.3
--//  \   \         Application : IBERT Ultrascale 
--//  /   /         Filename : example_ibert_ultrascale_gty_0
--// /___/   /\     
--// \   \  /  \ 
--//  \___\/\___\
--//
--//
--// Module example_ibert_ultrascale_gty_0
--// Generated by Xilinx IBERT_Ultrascale 
--//////////////////////////////////////////////////////////////////////////////
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;
library UNISIM;
use UNISIM.vcomponents.all;


entity ibert_ultrascale_gty_r is
  generic
  (
    C_NUM_GTY_QUADS                   : integer              := 13;
    C_GTY_REFCLKS_USED                     : integer              :=6
    );
  port
    (
      gty_refclk0p_i  : in std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
      gty_refclk0n_i  : in std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
--      gty_refclk1p_i  : in std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
--      gty_refclk1n_i  : in std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
     -- gty_sysclk_i      : in std_logic;
      --gty_sysclkp_i : in std_logic;
      --gty_sysclkn_i : in std_logic;
      gty_rxn_i       : in std_logic_vector(4*C_NUM_GTY_QUADS-1 downto 0);
      gty_rxp_i       : in std_logic_vector(4*C_NUM_GTY_QUADS-1 downto 0);
      gty_txn_o       : out std_logic_vector(4*C_NUM_GTY_QUADS-1 downto 0);
      gty_txp_o       : out std_logic_vector(4*C_NUM_GTY_QUADS-1 downto 0)
      );
end entity ibert_ultrascale_gty_r;

architecture proc of ibert_ultrascale_gty_r is
--  //
--  // Ibert refclk internal signals
--  //
  
   signal  gty_qrefclk0_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qrefclk1_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qnorthrefclk0_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qnorthrefclk1_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);        	
   signal  gty_qsouthrefclk0_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qsouthrefclk1_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qrefclk00_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qrefclk10_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qrefclk01_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qrefclk11_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);  
   signal  gty_qnorthrefclk00_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qnorthrefclk10_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qnorthrefclk01_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qnorthrefclk11_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);  
   signal  gty_qsouthrefclk00_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qsouthrefclk10_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qsouthrefclk01_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0);
   signal  gty_qsouthrefclk11_i :std_logic_vector(C_NUM_GTY_QUADS-1 downto 0); 
   signal  gty_refclk0_i :std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
   signal  gty_refclk1_i :std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
   signal  gty_odiv2_0_i :std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
   signal  gty_odiv2_1_i :std_logic_vector(C_GTY_REFCLKS_USED-1 downto 0);
   signal                           gty_sysclk_i: std_logic;
begin

  
  --
  -- Sysclock IBUFDS instantiation
  --
  --u_ibufgds : IBUFGDS
  --  generic map (
  --    DIFF_TERM => true
  --  ) port map (
  --    I => gty_sysclkp_i,
  --    IB => gty_sysclkn_i,
  --    O => gty_sysclk_i
  --    );

  u_gty_sysclk_internal : BUFG_GT
    port map (
      I => gty_odiv2_0_i(4),
      O => gty_sysclk_i,
      CE => '1',
      CEMASK => '0',
      CLR => '0',
      CLRMASK => '0',
      DIV => "000"
      );

     
  --
  -- Refclk IBUFDS instantiations
  --


  u_buf_q2_clk0 :IBUFDS_GTE4
    port map(
      O => gty_refclk0_i(0),
      ODIV2 => gty_odiv2_0_i(0),
      CEB => '0',
      I => gty_refclk0p_i(0),
      IB => gty_refclk0n_i(0)
      );

  
  u_buf_q4_clk0 :IBUFDS_GTE4 
     port map(
       O => gty_refclk0_i(1),
       ODIV2 => gty_odiv2_0_i(1),
       CEB => '0',
       I => gty_refclk0p_i(1),
       IB => gty_refclk0n_i(1)
      );

   --u_buf_q2_clk1 :IBUFDS_GTE4
   --  port map(
   --    O => gty_refclk1_i(0),
   --    ODIV2 => gty_odiv2_1_i(0),
   --    CEB => '0',
   --    I => gty_refclk1p_i(0),
   --    IB => gty_refclk1n_i(0)
   --    );

   u_buf_q6_clk0 :IBUFDS_GTE4
     port map(
       O => gty_refclk0_i(2),
       ODIV2 => gty_odiv2_0_i(2),
       CEB => '0',
       I => gty_refclk0p_i(2),
       IB => gty_refclk0n_i(2)
       );

   u_buf_q9_clk0 :IBUFDS_GTE4
     port map(
       O => gty_refclk0_i(3),
       ODIV2 => gty_odiv2_0_i(3),
       CEB => '0',
       I => gty_refclk0p_i(3),
       IB => gty_refclk0n_i(3)
       );
  

   u_buf_q10_clk0 :IBUFDS_GTE4
     port map(
       O => gty_refclk0_i(4),
       ODIV2 => gty_odiv2_0_i(4),
       CEB => '0',
       I => gty_refclk0p_i(4),
       IB => gty_refclk0n_i(4)
       );

  u_buf_q13_clk0 :IBUFDS_GTE4
    port map(
      O => gty_refclk0_i(5),
      ODIV2 => gty_odiv2_0_i(5),
      CEB => '0',
      I => gty_refclk0p_i(5),
      IB => gty_refclk0n_i(5)
      );
  
  
  --
  -- Refclk connection from each IBUFDS to respective quads depending on the source selected in gui
  --
--  gty_qrefclk0_i(0) <= gty_refclk0_i(0);
--  gty_qrefclk1_i(0) <= '0'; --gty_refclk1_i(0);
--  gty_qnorthrefclk0_i(0) <= '0';
--  gty_qnorthrefclk1_i(0) <= '0';
--  gty_qsouthrefclk0_i(0) <= '0';
--  gty_qsouthrefclk1_i(0) <= '0';
----GTYE4_COMMON clock connection
--  gty_qrefclk00_i(0) <= gty_refclk0_i(0);
--  gty_qrefclk10_i(0) <= '0'; --gty_refclk1_i(0);
--  gty_qrefclk01_i(0) <= '0';
--  gty_qrefclk11_i(0) <= '0';  
--  gty_qnorthrefclk00_i(0) <= '0';
--  gty_qnorthrefclk10_i(0) <= '0';
--  gty_qnorthrefclk01_i(0) <= '0';
--  gty_qnorthrefclk11_i(0) <= '0';  
--  gty_qsouthrefclk00_i(0) <= '0';
--  gty_qsouthrefclk10_i(0) <= '0';  
--  gty_qsouthrefclk01_i(0) <= '0';
--  gty_qsouthrefclk11_i(0) <= '0';
--
--

  gty_qrefclk0_i(0) <= '0';
  gty_qrefclk1_i(0) <= '0';
  gty_qnorthrefclk0_i(0) <= '0';
  gty_qnorthrefclk1_i(0) <= '0';
  gty_qsouthrefclk0_i(0) <= gty_refclk0_i(0);
  gty_qsouthrefclk1_i(0) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(0) <= '0';
  gty_qrefclk10_i(0) <= '0';
  gty_qrefclk01_i(0) <= '0';
  gty_qrefclk11_i(0) <= '0';
  gty_qnorthrefclk00_i(0) <= '0';
  gty_qnorthrefclk10_i(0) <= '0';
  gty_qnorthrefclk01_i(0) <= '0';
  gty_qnorthrefclk11_i(0) <= '0';
  gty_qsouthrefclk00_i(0) <= gty_refclk0_i(0);
  gty_qsouthrefclk10_i(0) <= '0';
  gty_qsouthrefclk01_i(0) <= '0';
  gty_qsouthrefclk11_i(0) <= '0';
  

  gty_qrefclk0_i(1) <= gty_refclk0_i(0);
  gty_qrefclk1_i(1) <= '0'; --gty_refclk1_i(0);
  gty_qnorthrefclk0_i(1) <= '0';
  gty_qnorthrefclk1_i(1) <= '0';
  gty_qsouthrefclk0_i(1) <= '0';
  gty_qsouthrefclk1_i(1) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(1) <= gty_refclk0_i(0);
  gty_qrefclk10_i(1) <= '0'; --gty_refclk1_i(0);
  gty_qrefclk01_i(1) <= '0';
  gty_qrefclk11_i(1) <= '0';
  gty_qnorthrefclk00_i(1) <= '0';
  gty_qnorthrefclk10_i(1) <= '0';
  gty_qnorthrefclk01_i(1) <= '0';
  gty_qnorthrefclk11_i(1) <= '0';
  gty_qsouthrefclk00_i(1) <= '0';
  gty_qsouthrefclk10_i(1) <= '0';
  gty_qsouthrefclk01_i(1) <= '0';
  gty_qsouthrefclk11_i(1) <= '0';
  

  gty_qrefclk0_i(2) <= '0';
  gty_qrefclk1_i(2) <= '0';
  gty_qnorthrefclk0_i(2) <= gty_refclk0_i(0);
  gty_qnorthrefclk1_i(2) <= '0';
  gty_qsouthrefclk0_i(2) <= '0';
  gty_qsouthrefclk1_i(2) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(2) <= '0';
  gty_qrefclk10_i(2) <= '0';
  gty_qrefclk01_i(2) <= '0';
  gty_qrefclk11_i(2) <= '0';
  gty_qnorthrefclk00_i(2) <= gty_refclk0_i(0);
  gty_qnorthrefclk10_i(2) <= '0';
  gty_qnorthrefclk01_i(2) <= '0';
  gty_qnorthrefclk11_i(2) <= '0';
  gty_qsouthrefclk00_i(2) <= '0';
  gty_qsouthrefclk10_i(2) <= '0';
  gty_qsouthrefclk01_i(2) <= '0';
  gty_qsouthrefclk11_i(2) <= '0';
  

  gty_qrefclk0_i(3) <= '0';
  gty_qrefclk1_i(3) <= '0'; 
  gty_qnorthrefclk0_i(3) <= '0';
  gty_qnorthrefclk1_i(3) <= '0';
  gty_qsouthrefclk0_i(3) <= gty_refclk0_i(1);
  gty_qsouthrefclk1_i(3) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(3) <= '0';
  gty_qrefclk10_i(3) <= '0';
  gty_qrefclk01_i(3) <= '0';
  gty_qrefclk11_i(3) <= '0';
  gty_qnorthrefclk00_i(3) <= '0';
  gty_qnorthrefclk10_i(3) <= '0';
  gty_qnorthrefclk01_i(3) <= '0';
  gty_qnorthrefclk11_i(3) <= '0';
  gty_qsouthrefclk00_i(3) <= gty_refclk0_i(1);
  gty_qsouthrefclk10_i(3) <= '0';
  gty_qsouthrefclk01_i(3) <= '0';
  gty_qsouthrefclk11_i(3) <= '0';
  
  gty_qrefclk0_i(4) <= gty_refclk0_i(1);
  gty_qrefclk1_i(4) <= '0';
  gty_qnorthrefclk0_i(4) <= '0';
  gty_qnorthrefclk1_i(4) <= '0';
  gty_qsouthrefclk0_i(4) <= '0';
  gty_qsouthrefclk1_i(4) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(4) <= gty_refclk0_i(1);
  gty_qrefclk10_i(4) <= '0';
  gty_qrefclk01_i(4) <= '0';
  gty_qrefclk11_i(4) <= '0';
  gty_qnorthrefclk00_i(4) <= '0';
  gty_qnorthrefclk10_i(4) <= '0';
  gty_qnorthrefclk01_i(4) <= '0';
  gty_qnorthrefclk11_i(4) <= '0';
  gty_qsouthrefclk00_i(4) <= '0';
  gty_qsouthrefclk10_i(4) <= '0';
  gty_qsouthrefclk01_i(4) <= '0';
  gty_qsouthrefclk11_i(4) <= '0';
  

  gty_qrefclk0_i(5) <= '0';
  gty_qrefclk1_i(5) <= '0';
  gty_qnorthrefclk0_i(5) <= gty_refclk0_i(1);
  gty_qnorthrefclk1_i(5) <= '0';
  gty_qsouthrefclk0_i(5) <= '0';
  gty_qsouthrefclk1_i(5) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(5) <= '0';
  gty_qrefclk10_i(5) <= '0'; --gty_refclk1_i(0);
  gty_qrefclk01_i(5) <= '0';
  gty_qrefclk11_i(5) <= '0';
  gty_qnorthrefclk00_i(5) <= gty_refclk0_i(1);
  gty_qnorthrefclk10_i(5) <= '0';
  gty_qnorthrefclk01_i(5) <= '0';
  gty_qnorthrefclk11_i(5) <= '0';
  gty_qsouthrefclk00_i(5) <= '0';
  gty_qsouthrefclk10_i(5) <= '0';
  gty_qsouthrefclk01_i(5) <= '0';
  gty_qsouthrefclk11_i(5) <= '0';
  

  gty_qrefclk0_i(6) <= '0';
  gty_qrefclk1_i(6) <= '0';
  gty_qnorthrefclk0_i(6) <= '0';
  gty_qnorthrefclk1_i(6) <= '0';
  gty_qsouthrefclk0_i(6) <= gty_refclk0_i(2);
  gty_qsouthrefclk1_i(6) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(6) <= '0';
  gty_qrefclk10_i(6) <= '0';
  gty_qrefclk01_i(6) <= '0';
  gty_qrefclk11_i(6) <= '0';
  gty_qnorthrefclk00_i(6) <= '0';
  gty_qnorthrefclk10_i(6) <= '0';
  gty_qnorthrefclk01_i(6) <= '0';
  gty_qnorthrefclk11_i(6) <= '0';
  gty_qsouthrefclk00_i(6) <= gty_refclk0_i(2);
  gty_qsouthrefclk10_i(6) <= '0';
  gty_qsouthrefclk01_i(6) <= '0';
  gty_qsouthrefclk11_i(6) <= '0';
  
  gty_qrefclk0_i(7) <= gty_refclk0_i(2);
  gty_qrefclk1_i(7) <= '0';
  gty_qnorthrefclk0_i(7) <= '0';
  gty_qnorthrefclk1_i(7) <= '0';
  gty_qsouthrefclk0_i(7) <= '0';
  gty_qsouthrefclk1_i(7) <= '0';
--GTYE4_COMMON clock connection
  gty_qrefclk00_i(7) <= gty_refclk0_i(2);
  gty_qrefclk10_i(7) <= '0';
  gty_qrefclk01_i(7) <= '0';
  gty_qrefclk11_i(7) <= '0';
  gty_qnorthrefclk00_i(7) <= '0';
  gty_qnorthrefclk10_i(7) <= '0';
  gty_qnorthrefclk01_i(7) <= '0';
  gty_qnorthrefclk11_i(7) <= '0';
  gty_qsouthrefclk00_i(7) <= '0';
  gty_qsouthrefclk10_i(7) <= '0';
  gty_qsouthrefclk01_i(7) <= '0';
  gty_qsouthrefclk11_i(7) <= '0';
 
  gty_qrefclk0_i(8) <= gty_refclk0_i(3);
  gty_qrefclk1_i(8) <= '0'; --gty_refclk1_i(1);
  gty_qnorthrefclk0_i(8) <= '0';
  gty_qnorthrefclk1_i(8) <= '0';
  gty_qsouthrefclk0_i(8) <= '0';
  gty_qsouthrefclk1_i(8) <= '0';
--GTYE4_COMMON clock connection
  gty_qrefclk00_i(8) <= gty_refclk0_i(3);
  gty_qrefclk10_i(8) <= '0'; --gty_refclk1_i(1);
  gty_qrefclk01_i(8) <= '0';
  gty_qrefclk11_i(8) <= '0';  
  gty_qnorthrefclk00_i(8) <= '0';
  gty_qnorthrefclk10_i(8) <= '0';
  gty_qnorthrefclk01_i(8) <= '0';
  gty_qnorthrefclk11_i(8) <= '0';  
  gty_qsouthrefclk00_i(8) <= '0';
  gty_qsouthrefclk10_i(8) <= '0';  
  gty_qsouthrefclk01_i(8) <= '0';
  gty_qsouthrefclk11_i(8) <= '0'; 
 

  gty_qrefclk0_i(9) <= gty_refclk0_i(4);
  gty_qrefclk1_i(9) <= '0';
  gty_qnorthrefclk0_i(9) <= '0';
  gty_qnorthrefclk1_i(9) <= '0';
  gty_qsouthrefclk0_i(9) <= '0';
  gty_qsouthrefclk1_i(9) <= '0';
--GTYE4_COMMON clock connection
  gty_qrefclk00_i(9) <= gty_refclk0_i(4);
  gty_qrefclk10_i(9) <= '0';
  gty_qrefclk01_i(9) <= '0';
  gty_qrefclk11_i(9) <= '0';
  gty_qnorthrefclk00_i(9) <= '0';
  gty_qnorthrefclk10_i(9) <= '0';
  gty_qnorthrefclk01_i(9) <= '0';
  gty_qnorthrefclk11_i(9) <= '0';
  gty_qsouthrefclk00_i(9) <= '0';
  gty_qsouthrefclk10_i(9) <= '0';
  gty_qsouthrefclk01_i(9) <= '0';
  gty_qsouthrefclk11_i(9) <= '0';
 
 
   gty_qrefclk0_i(10) <= '0';
  gty_qrefclk1_i(10) <= '0';
  gty_qnorthrefclk0_i(10) <= '0';
  gty_qnorthrefclk1_i(10) <= '0';
  gty_qsouthrefclk0_i(10) <= gty_refclk0_i(5);
  gty_qsouthrefclk1_i(10) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(10) <= '0';
  gty_qrefclk10_i(10) <= '0';
  gty_qrefclk01_i(10) <= '0';
  gty_qrefclk11_i(10) <= '0';
  gty_qnorthrefclk00_i(10) <= '0';
  gty_qnorthrefclk10_i(10) <= '0';
  gty_qnorthrefclk01_i(10) <= '0';
  gty_qnorthrefclk11_i(10) <= '0';
  gty_qsouthrefclk00_i(10) <= gty_refclk0_i(5);
  gty_qsouthrefclk10_i(10) <= '0';
  gty_qsouthrefclk01_i(10) <= '0';
  gty_qsouthrefclk11_i(10) <= '0';
  

  gty_qrefclk0_i(11) <= gty_refclk0_i(5);
  gty_qrefclk1_i(11) <= '0'; --gty_refclk1_i(11);
  gty_qnorthrefclk0_i(11) <= '0';
  gty_qnorthrefclk1_i(11) <= '0';
  gty_qsouthrefclk0_i(11) <= '0';
  gty_qsouthrefclk1_i(11) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(11) <= gty_refclk0_i(5);
  gty_qrefclk10_i(11) <= '0'; --gty_refclk1_i(11);
  gty_qrefclk01_i(11) <= '0';
  gty_qrefclk11_i(11) <= '0';
  gty_qnorthrefclk00_i(11) <= '0';
  gty_qnorthrefclk10_i(11) <= '0';
  gty_qnorthrefclk01_i(11) <= '0';
  gty_qnorthrefclk11_i(11) <= '0';
  gty_qsouthrefclk00_i(11) <= '0';
  gty_qsouthrefclk10_i(11) <= '0';
  gty_qsouthrefclk01_i(11) <= '0';
  gty_qsouthrefclk11_i(11) <= '0';
  

  gty_qrefclk0_i(12) <= '0';
  gty_qrefclk1_i(12) <= '0';
  gty_qnorthrefclk0_i(12) <= gty_refclk0_i(5);
  gty_qnorthrefclk1_i(12) <= '0';
  gty_qsouthrefclk0_i(12) <= '0';
  gty_qsouthrefclk1_i(12) <= '0';
  --GTYE4_COMMON clock connection
  gty_qrefclk00_i(12) <= '0';
  gty_qrefclk10_i(12) <= '0';
  gty_qrefclk01_i(12) <= '0';
  gty_qrefclk11_i(12) <= '0';
  gty_qnorthrefclk00_i(12) <= gty_refclk0_i(5);
  gty_qnorthrefclk10_i(12) <= '0';
  gty_qnorthrefclk01_i(12) <= '0';
  gty_qnorthrefclk11_i(12) <= '0';
  gty_qsouthrefclk00_i(12) <= '0';
  gty_qsouthrefclk10_i(12) <= '0';
  gty_qsouthrefclk01_i(12) <= '0';
  gty_qsouthrefclk11_i(12) <= '0';
  --
  -- IBERT core instantiation
  --
  u_ibert_gty_core_1 : entity work.ibert_ultrascale_gty_core_r
    port map (
      txn_o => gty_txn_o,
      txp_o => gty_txp_o,
      rxn_i => gty_rxn_i,
      rxp_i => gty_rxp_i,
      clk => gty_sysclk_i,
      gtrefclk0_i => gty_qrefclk0_i,
      gtrefclk1_i => gty_qrefclk1_i,
      gtnorthrefclk0_i => gty_qnorthrefclk0_i,
      gtnorthrefclk1_i => gty_qnorthrefclk1_i,
      gtsouthrefclk0_i => gty_qsouthrefclk0_i,
      gtsouthrefclk1_i => gty_qsouthrefclk1_i,
      gtrefclk00_i => gty_qrefclk00_i,
      gtrefclk10_i => gty_qrefclk10_i,
      gtrefclk01_i => gty_qrefclk01_i,
      gtrefclk11_i => gty_qrefclk11_i,
      gtnorthrefclk00_i => gty_qnorthrefclk00_i,
      gtnorthrefclk10_i => gty_qnorthrefclk10_i,
      gtnorthrefclk01_i => gty_qnorthrefclk01_i,
      gtnorthrefclk11_i => gty_qnorthrefclk11_i,
      gtsouthrefclk00_i => gty_qsouthrefclk00_i,
      gtsouthrefclk10_i => gty_qsouthrefclk10_i,
      gtsouthrefclk01_i => gty_qsouthrefclk01_i,
      gtsouthrefclk11_i => gty_qsouthrefclk11_i
    );

end proc;
