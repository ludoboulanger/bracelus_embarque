----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/31/2021 11:13:53 AM
-- Design Name: 
-- Module Name: mef_calcul_param_1 - Behavioral
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

entity mef_analyse_1 is
    Port ( i_clk : in std_logic;
           i_enable : in std_logic;
           i_echantillon : in std_logic_vector(11 downto 0);
           i_reset : in STD_LOGIC;
           o_reset : out STD_LOGIC;
           o_variation: out std_logic_vector(11 downto 0));
end mef_analyse_1;

architecture Behavioral of mef_analyse_1 is

    type type_mealy is (Strobe, Attente, Gain1, Perte, Gain2);
    signal etat_courant,nouvel_etat : type_mealy;
    
    signal s_derniere_echantillon : std_logic_vector(11 downto 0) := (others => '0');
    signal enable : std_logic;

begin

    sync : process(i_reset, i_clk) is
    begin
        if i_reset = '1' then
            etat_courant <= Attente;
        elsif rising_edge(i_clk) then
            if i_enable = '1' then
                etat_courant <= nouvel_etat;
            end if;
        end if;
    end process;
    
    combinat : process(etat_courant, i_echantillon)
    begin
        case etat_courant is
            when Attente =>
                
            when Gain1   =>
            when Perte   =>
            when Gain2   =>
            when Strobe  =>
           end case;
    end process;
    
end Behavioral;
