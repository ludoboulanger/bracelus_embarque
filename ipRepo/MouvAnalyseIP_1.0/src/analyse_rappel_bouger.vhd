----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2021 06:34:55 AM
-- Design Name: 
-- Module Name: analyse_rappel_bouger - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity analyse_rappel_bouger is
    Port ( i_moyenne : in STD_LOGIC_VECTOR (1 downto 0);
           i_clk1Hz : in STD_LOGIC;
           o_rappel : out STD_LOGIC_VECTOR(7 downto 0));
end analyse_rappel_bouger;

architecture Behavioral of analyse_rappel_bouger is

component compteur_simple is
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;

component mef_rappel_bouger is
    Port ( i_clk : in STD_LOGIC;
           i_reset : STD_LOGIC;
           i_cpt_moy_0 : in STD_LOGIC_VECTOR (7 downto 0);
           i_cpt_strobe : in STD_LOGIC_VECTOR (7 downto 0);
           i_threshold : STD_LOGIC_VECTOR(7 downto 0);
           i_moyenne : in STD_LOGIC_VECTOR (1 downto 0);
           ----
           o_cpt_reset : out STD_LOGIC;
           o_strobe_rappel : out STD_LOGIC);
end component;

constant c_threshold : std_logic_vector(7 downto 0) := "00110010";
signal s_cpt_val : std_logic_vector(7 downto 0);
signal s_cpt_reset : std_logic;
signal s_moyenne_0 : std_logic_vector(7 downto 0);
signal s_rappel : std_logic;

begin

    inst_cpt : compteur_simple
        port map (
            clk => i_clk1Hz,
            i_en => '1',
            reset => s_cpt_reset,
            o_val_cpt => s_cpt_val
        );
        
     mef : mef_rappel_bouger
        port map (
            i_clk => i_clk1Hz,
            i_reset => '0',
            i_cpt_moy_0 => s_moyenne_0,
            i_cpt_strobe => s_cpt_val,
            i_threshold => c_threshold,
            i_moyenne => i_moyenne,
           ----
           o_cpt_reset => s_cpt_reset,
           o_strobe_rappel => s_rappel
        );
        
     verifie_moyenne : process (i_clk1Hz, s_cpt_reset) is
     begin
        if s_cpt_reset = '1' then
            s_moyenne_0 <= (others => '0');
        elsif rising_edge(i_clk1Hz) then
            if i_moyenne = "00" then 
                s_moyenne_0 <= s_moyenne_0 + 1;
            end if;
        end if;     
     end process;
     
     o_rappel <= "11111111" when s_rappel = '1' else "00000000";

end Behavioral;
