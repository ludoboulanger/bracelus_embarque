----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 02:24:41 PM
-- Design Name: 
-- Module Name: mef_bpm - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mef_bpm is
    Port ( i_echantillon : in STD_LOGIC_VECTOR (11 downto 0);
           i_clk : in STD_LOGIC;
           i_strobe : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           o_echantillon_pret : out STD_LOGIC;
           o_cpt : out STD_LOGIC_VECTOR (7 downto 0));
end mef_bpm;

architecture Behavioral of mef_bpm is

--	Components
component compteur_nbits_strobe 
generic (nbits : integer := 8);
port (    clk             : in    std_logic; 
          i_strobe        : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
);
end component;
--	Constantes

--	Signals
type mef_etat is (Sous_Seuil,Sommet,Compter,Reset);
signal etat_courant, nouvelle_etat : mef_etat;

signal reset_compt : std_logic := '0';
signal val_compt : std_logic_vector (7 downto 0);
signal last_val_compt : std_logic_vector (7 downto 0) := (others => '0');
signal last_strobe: std_logic := '0';
signal dif: signed(11 downto 0);

constant seuil : signed(11 downto 0):= "001111101000";

--	Registers

-- Attributes

begin

    compteur : compteur_nbits_strobe
    port map (
        clk => i_clk,
        i_strobe => i_strobe,
        i_en  => '1',
        reset   => reset_compt,
        o_val_cpt  => val_compt
    );


-- Assignation du prochain �tat

Assignation : process(i_clk,i_reset)
begin
    if(i_reset = '1') then
        etat_courant <= Sous_Seuil;
    elsif (rising_edge(i_clk)) then
        if(i_strobe = '1') then
            etat_courant <= nouvelle_etat;
        end if;
        
        if(etat_courant = Compter) then
            last_val_compt <= val_compt;
        end if;
    end if;
end process;


-- Calcul du prochain �tat

    Next_state : process(etat_courant, i_echantillon)
    begin
        case etat_courant is
            when Sous_Seuil =>
                if(signed(i_echantillon) > seuil) then
                    nouvelle_etat <= Sommet;
                else
                    nouvelle_etat <= Sous_Seuil;
                end if;
                
                
            when Sommet =>
                if(signed(i_echantillon) < seuil) then
                    nouvelle_etat <= Compter;
                else
                    nouvelle_etat <= Sommet;
                end if;
                
            when Compter => 
                nouvelle_etat <= Reset;
                
           when Reset => 
                nouvelle_etat <= Sous_seuil;
        end case;
    end process;
    
    process (etat_courant)
    begin
        case etat_courant is
            when Sous_Seuil => 
                o_echantillon_pret <='0';
                reset_compt <= '0';
                
            when Sommet =>
                reset_compt <= '0';
                o_echantillon_pret <='0';
                
            when Compter => 
                --last_val_compt <= val_compt;
                o_echantillon_pret <='1';
                reset_compt <= '0';
                
            when Reset =>
                o_echantillon_pret <='0';
                reset_compt <= '1';
        end case;
    end process;
    
    o_cpt <= val_compt when (etat_courant =  Compter) else last_val_compt;
end Behavioral;
