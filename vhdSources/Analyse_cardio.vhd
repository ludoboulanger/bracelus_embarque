----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 02:21:29 PM
-- Design Name: 
-- Module Name: Analyse_cardio - Behavioral
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

entity Analyse_cardio is
    Port ( i_echantillon : in std_logic_vector(11 downto 0);
           i_bclk : in STD_LOGIC;
           i_strobe : in STD_LOGIC;
           o_cpt : out std_logic_vector(7 downto 0));
end Analyse_cardio;

architecture Behavioral of Analyse_cardio is

component mef_bpm is
    Port (i_echantillon : in STD_LOGIC_VECTOR (11 downto 0);
           i_clk : in STD_LOGIC;
           i_strobe : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_echantillon_pret : out STD_LOGIC;
           o_cpt : out STD_LOGIC_VECTOR (7 downto 0)                                 
    );
    end component;
    
    component calcul_moyenne is
    Port (
        i_bclk    : in   std_logic;   -- bit clock
        i_reset   : in   std_logic;
        i_en      : in   std_logic;   -- un echantillon present
        i_echantillon_pret : in std_logic;
        i_ech     : in   std_logic_vector (7 downto 0);
        o_param   : out  std_logic_vector (7 downto 0)                                     
    );
    end component;

	signal s_cpt_val : STD_LOGIC_VECTOR (7 downto 0);
	signal s_moyenne : STD_LOGIC_VECTOR (7 downto 0);
	signal s_cpt_pret : STD_LOGIC;

begin
	-- Add user logic here
	inst_mef_bpm: mef_bpm
	port map( i_clk  => i_bclk,    
	          i_reset  => '0',
	          i_strobe => i_strobe,
              i_echantillon => i_echantillon,
              o_echantillon_pret => s_cpt_pret,
              o_cpt => o_cpt
             );
             
    inst_moy: calcul_moyenne 
    Port map(
        i_bclk    => i_bclk,
        i_reset   => '0',
        i_en      => '1',
        i_echantillon_pret => s_cpt_pret,
        i_ech    => s_cpt_val,
        o_param  => s_moyenne                                   
    );
    
    --o_cpt <= s_moyenne;
end Behavioral;
