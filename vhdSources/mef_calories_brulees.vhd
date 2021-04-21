----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 01:00:16 PM
-- Design Name: 
-- Module Name: mef_calories_brulees - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mef_calories_brulees is
    Port ( i_clk : in STD_LOGIC;
           i_cpt_val : in STD_LOGIC_VECTOR(7 downto 0);
           i_reset : in STD_LOGIC;
           o_cpt_rst : out STD_LOGIC;
           o_cpt_en : out STD_LOGIC;
           o_output_cal_strobe : out STD_LOGIC
          );
end mef_calories_brulees;

architecture Behavioral of mef_calories_brulees is

    type type_etat is (HOLD, RESET, COMPTE, OUTPUT);
    signal s_etat_courant : type_etat := RESET;
    signal s_prochain_etat : type_etat := RESET;

begin

    clock_sync : process(i_clk, i_reset)
    begin
        if (i_reset = '1') then
            s_etat_courant <= RESET;
        elsif(rising_edge(i_clk)) then
            s_etat_courant <= s_prochain_etat;
        end if;
    end process;
    
    
    state_management : process(s_etat_courant)
    begin
        case s_etat_courant is
            when RESET =>
                s_prochain_etat <= COMPTE;
            when COMPTE =>
                if (i_cpt_val = "00111100") then
                    s_prochain_etat <= OUTPUT;
                else 
                    s_prochain_etat <= s_etat_courant;
                end if;
            when OUTPUT =>
                s_prochain_etat <= RESET;
            when others => s_prochain_etat <= RESET;
       end case;
    end process;
    
    
    
    output_process : process(s_etat_courant)
    begin
        case s_etat_courant is
            when RESET =>
                o_cpt_rst <= '1';
                o_cpt_en <= '0';
                o_output_cal_strobe <= '0';
            when COMPTE =>
                o_cpt_rst <= '0';
                o_cpt_en <= '1';
                o_output_cal_strobe <= '0';
            when OUTPUT =>
                o_cpt_rst <= '0';
                o_cpt_en <= '0';
                o_output_cal_strobe <= '1';
            when others => 
                o_cpt_rst <= '1';
                o_cpt_en <= '0';
                o_output_cal_strobe <= '0';
       end case;
    end process;

end Behavioral;
