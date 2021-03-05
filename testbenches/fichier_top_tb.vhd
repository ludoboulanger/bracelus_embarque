----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2021 02:14:23 PM
-- Design Name: 
-- Module Name: fichier_top_tb - Behavioral
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

entity fichier_top_tb is
--  Port ( );
end fichier_top_tb;

architecture Behavioral of fichier_top_tb is

component Top is
port (
    sys_clock       : in std_logic;
    o_leds          : out std_logic_vector ( 3 downto 0 );
    i_sw            : in std_logic_vector ( 3 downto 0 );
    i_btn           : in std_logic_vector ( 3 downto 0 );
    o_ledtemoin_b   : out std_logic;
    
    ---- DAC
    o_DAC_NCS : out std_logic;
    o_DAC_D0 : out std_logic;
    o_DAC_D1 : out std_logic;
    o_DAC_CLK : out std_logic;
    
    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JD
    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
    -- Pmod_AD1 - port_JC haut
    o_ADC_NCS       : out std_logic;  
    i_ADC_D0        : in std_logic;
    i_ADC_D1        : in std_logic;
    o_ADC_CLK       : out std_logic

);
end component;

    signal sim_sys_clock : std_logic := '0';
    signal sim_sys_clk_period : time := 20 ns;
    
    --DAC
    signal dac_ncs : std_logic;
    signal dac_d0 : std_logic;
    signal dac_clk : std_logic;
    
    --ADC
    signal adc_ncs : std_logic;
    signal adc_d0 : std_logic;
    signal adc_d1 : std_logic;
    signal adc_clk : std_logic;
    
    --PMOD

begin

    entity_top : Top
        port map (
            sys_clock       => sim_sys_clock,
            o_leds          => open,
            i_sw            => "0000",
            i_btn           => "0000",
            o_ledtemoin_b   => open,
            
            ---- DAC
            o_DAC_NCS => dac_ncs,
            o_DAC_D0 => dac_d0,
            o_DAC_D1 => open,
            o_DAC_CLK => dac_clk,
            
            Pmod_8LD        => open,  -- port JD
            Pmod_OLED       => open,  -- port_JE
            
            -- Pmod_AD1 - port_JC haut
            o_ADC_NCS       => adc_ncs,
            i_ADC_D0        => dac_d0,
            i_ADC_D1        => adc_d1,
            o_ADC_CLK       => adc_clk
        );            

-- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;


end Behavioral;
