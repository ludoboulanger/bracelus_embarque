---------------------------------------------------------------------------------------------
-- circuit compteur_nbits.vhd.vhd
---------------------------------------------------------------------------------------------
-- Université de Sherbrooke - Département de GEGI
-- Version         : 1.0
-- Nomenclature    : 0.8 GRAMS
-- Date            : 14 mai 2019
-- Auteur(s)       : Daniel Dalle
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--
-- Outils          : vivado 2018.2
---------------------------------------------------------------------------------------------
-- Description:
-- Compteur a avec nombre de bits en parametre generic
---------------------------------------------------------------------------------------------
-- À faire :
-- 
-- 
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

entity compteur_nbits_strobe is
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_strobe        : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end compteur_nbits_strobe;

architecture BEHAVIORAL of compteur_nbits_strobe is               
-- compteur simple

signal last_strobe: std_logic := '0';
signal  d_val_cpt: std_logic_vector (nbits-1 downto 0) := (others => '0');

BEGIN

compteur_proc : process (clk, reset)
   begin
      
      if (rising_edge(clk) AND i_en = '1') then
            if ( reset = '1') then
            d_val_cpt <= (others =>'0');
          elsif(i_strobe = '1' AND last_strobe = '0') then
            d_val_cpt <= d_val_cpt + 1;
          end if;
          last_strobe <= i_strobe;
      end if;
   end process;
-- sortie
  o_val_cpt <= d_val_cpt;
  
 END Behavioral;
  
