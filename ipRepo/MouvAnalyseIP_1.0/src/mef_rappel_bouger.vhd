----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2021 06:56:38 AM
-- Design Name: 
-- Module Name: mef_rappel_bouger - Behavioral
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

entity mef_rappel_bouger is
    Port ( i_clk : in STD_LOGIC;
           i_reset : STD_LOGIC;
           i_cpt_moy_0 : in STD_LOGIC_VECTOR (7 downto 0);
           i_cpt_strobe : in STD_LOGIC_VECTOR (7 downto 0);
           i_threshold : STD_LOGIC_VECTOR(7 downto 0);
           i_moyenne : in STD_LOGIC_VECTOR (1 downto 0);
           ----
           o_strobe_rappel : out STD_LOGIC;
           o_cpt_reset : out STD_LOGIC);
end mef_rappel_bouger;

architecture Behavioral of mef_rappel_bouger is

type type_etat is (
    COMPTE, 
    BILAN, 
    RAPPEL1,
    RAPPEL2, 
    RAPPEL3, 
    RAPPEL4, 
    RAPPEL5,
    RESET
    );
signal s_etat_courant, s_prochain_etat : type_etat;

begin

    process (i_clk, i_reset)
    begin
        if i_reset = '1' then
            s_etat_courant <= COMPTE;
        elsif rising_edge(i_clk) then
            s_etat_courant <= s_prochain_etat;
        end if;
    end process;
    
    process ( i_cpt_moy_0, i_cpt_strobe, i_moyenne )
    begin
        case (s_etat_courant) is
            when COMPTE =>
                if i_cpt_strobe = "00011110" then -- pour 30 --"00111100" then pour 60
                    s_prochain_etat <= BILAN;
                else 
                    s_prochain_etat <= s_etat_courant;
                end if;
            when BILAN =>
                if i_cpt_moy_0 > i_threshold then
                    s_prochain_etat <= RAPPEL1;
                else 
                    s_prochain_etat <= RESET;
                end if;
            when RAPPEL1 =>
                s_prochain_etat <= RAPPEL2;
            when RAPPEL2 =>
                s_prochain_etat <= RAPPEL3;
            when RAPPEL3 =>
                s_prochain_etat <= RAPPEL4;
            when RAPPEL4 =>
                s_prochain_etat <= RAPPEL5;
            when RAPPEL5 =>
                s_prochain_etat <= COMPTE; 
            when RESET =>
                s_prochain_etat <= COMPTE;
            when others =>
                s_prochain_etat <= COMPTE;
        end case;
    end process;

    o_strobe_rappel <= '1' when s_etat_courant = RAPPEL1 or
                                s_etat_courant = RAPPEL2 or
                                s_etat_courant = RAPPEL3 or
                                s_etat_courant = RAPPEL4 or
                                s_etat_courant = RAPPEL5
                            else '0';
    
    o_cpt_reset <= '1' when s_etat_courant = RESET or 
                            s_etat_courant = RAPPEL1 
                       else '0';
    
end Behavioral;
