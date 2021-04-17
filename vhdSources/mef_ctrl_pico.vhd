----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2021 08:25:40 AM
-- Design Name: 
-- Module Name: mef_ctrl_pico - Behavioral
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

entity mef_ctrl_pico is
    Port (
           i_clk                  : in STD_LOGIC;
           i_adc_pret_strobe      : in STD_LOGIC;
           i_cpt_val              : in STD_LOGIC_VECTOR(3 downto 0);
           i_reset                : in STD_LOGIC;
           ---------
           o_pico_pret_ech        : out STD_LOGIC;
           o_cpt_en               : out STD_LOGIC;
           o_cpt_rst              : out STD_LOGIC
           );
end mef_ctrl_pico;

architecture Behavioral of mef_ctrl_pico is

    signal s_cpt_en : std_logic := '0';
    signal s_cpt_rst : std_logic := '0';
    signal s_pico_pret : std_logic := '0';
    
    type type_etat is (INIT, PRET, RESET);
    
    signal s_etat_courant : type_etat := RESET;
    signal s_etat_prochain : type_etat := RESET;

begin


    mem_etat : process(i_reset, i_clk) 
    begin
        if i_reset = '1' then
            s_etat_courant <= INIT;
        elsif rising_edge(i_clk) then
            s_etat_courant <= s_etat_prochain;
        end if;
    end process;
    
    
    proch_etat : process (i_adc_pret_strobe, i_cpt_val)
    begin
        case s_etat_courant is
            when INIT =>
                if (i_adc_pret_strobe = '1') then
                    s_etat_prochain <= PRET;
                else 
                    s_etat_prochain <= s_etat_courant;
                end if;
                
            when PRET =>
                if i_cpt_val = "1000" then
                    s_etat_prochain <= RESET;
                else
                    s_etat_prochain <= s_etat_courant;
                end if;
            when RESET =>
                s_etat_prochain <= INIT;
            when others =>
                s_etat_prochain <= INIT;  
        end case;
    end process;
    
    
    outputs : process(s_etat_courant)
    begin
        case s_etat_courant is
            when INIT =>
                s_cpt_en <= '0';
                s_cpt_rst <= '0';
                s_pico_pret <= '0';
            when PRET =>
                s_cpt_en <= '1';
                s_cpt_rst <= '0';
                s_pico_pret <= '1';
            when RESET =>
                s_cpt_en <= '0';
                s_cpt_rst <= '1';
                s_pico_pret <= '0';
        end case;
    
    end process;

   o_pico_pret_ech <= s_pico_pret;
   o_cpt_en <= s_cpt_en;
   o_cpt_rst <= s_cpt_rst;
   
end Behavioral;
