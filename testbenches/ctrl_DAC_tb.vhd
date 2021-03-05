----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2021 11:23:50 AM
-- Design Name: 
-- Module Name: ctrl_DAC_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl_DAC_tb is
--  Port ( );
end ctrl_DAC_tb;

architecture Behavioral of ctrl_DAC_tb is

component Ctrl_DAC is
    Port (
        clk_DAC : in std_logic;
        i_reset : in std_logic;
        ----
        o_DAC_tsync : out std_logic;
        o_DAC_data : out std_logic
     );
end component;

component Synchro_Horloges is
generic (const_CLK_syst_MHz: integer := 100); 
    Port ( 
           clkm         : in STD_LOGIC;      -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
           o_S_5MHz     : out  STD_LOGIC;    -- source horloge divisee   (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
           o_clk_5MHz   : out  STD_LOGIC;    -- horlgoe via bufg
           o_S_100Hz    : out  STD_LOGIC;    -- source horloge 100 Hz : out  STD_LOGIC;   -- (100  Hz approx:  99,952 Hz) 
           o_stb_100Hz  : out  STD_LOGIC;    -- strobe durée 1/clk_5mHz aligne sur front 100Hz
           o_S_1Hz      : out  STD_LOGIC     -- Signal temoin 1 Hz
     );                    
end component;

    signal clk_DAC : std_logic := '0';
    constant clk_DAC_period : time := 200 ns;
         
    signal sim_sys_clock : std_logic := '0';
    constant sim_sys_clk_period : time := 20 ns;
    
    signal reset : std_logic := '0';
    signal sim_tsync : std_logic := '1';
    signal dac_bit : std_logic := '0';
    

begin

    -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;


    syncro : Synchro_Horloges
        port map (
            clkm => sim_sys_clock,
            o_S_5MHz => open,
            o_clk_5MHz => clk_DAC,
            o_S_100Hz => open,
            o_stb_100Hz => open,
            o_stb_1Hz => open,
            o_S_1Hz => open
       );
       
   controleur : Ctrl_DAC 
        port map (
            clk_DAC => clk_DAC,
            i_reset => reset,
            ----
            o_DAC_tsync => sim_tsync,
            o_DAC_data => dac_bit
        );

end Behavioral;
