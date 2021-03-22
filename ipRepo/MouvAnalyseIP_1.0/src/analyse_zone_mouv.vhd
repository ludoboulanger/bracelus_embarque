
---------------------------------------------------------------------------------------------
--    calcul_param_2.vhd   (temporaire)
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Université de Sherbrooke - Département de GEGI
--
--    Version         : 5.0
--    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS
--    Date            : 16 janvier 2020, 4 mai 2020
--    Auteur(s)       : 
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : vivado 2019.1 64 bits
--
---------------------------------------------------------------------------------------------
--    Description (sur une carte Zybo)
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
-- À FAIRE: 
-- Voir le guide de la problématique
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
entity analyse_zone_mouv is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_echantillon_pret : in std_logic;
    i_ech     : in   std_logic_vector (11 downto 0);
    o_param   : out  std_logic_vector (11 downto 0)                                     
    );
end analyse_zone_mouv;

----------------------------------------------------------------------------------

architecture Behavioral of analyse_zone_mouv is

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    signal d_y : signed (23 downto 0);
    signal d_last_y : signed (23 downto 0);
    signal d_mul_y : signed (29 downto 0);
    signal d_ech : signed (11 downto 0);
    signal d_ech_sqrt : signed (23 downto 0);
    signal d_param_23b_vec : std_logic_vector (23 downto 0);
    constant facteur_oubli : std_logic_vector(5 downto 0) := "011111";

---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 
    d_ech <= signed(i_ech);
    d_ech_sqrt <= shift_right(d_ech*d_ech,5);

    process(i_bclk, i_reset)
    begin
        if i_reset = '1' then
            d_last_y <= (others => '0');
            d_mul_y <= (others => '0');
            d_y <= (others => '0');
        elsif(rising_edge(i_bclk) and i_echantillon_pret = '1') then
            d_y <= d_ech_sqrt + d_last_y;
            d_last_y <= d_mul_y(29)&d_mul_y(27 downto 5);
            d_mul_y <= d_y * "011111";
        end if;
    end process;    

    
    d_param_23b_vec <= std_logic_vector(d_y);
    o_param <= d_param_23b_vec(23 downto 12);

end Behavioral;
