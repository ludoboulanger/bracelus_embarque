----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 12:50:34 PM
-- Design Name: 
-- Module Name: calories_brulees - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calories_brulees is
    Port (
           i_clk_1Hz : in STD_LOGIC;
           i_ech_pret_strobe : in STD_LOGIC;
           i_strobe1Hz : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_analyse_cardio : in STD_LOGIC_VECTOR(7 downto 0);
           --- ----
           o_cal_brulee : out STD_LOGIC_VECTOR(31 downto 0)
           );
end calories_brulees;    

architecture Behavioral of calories_brulees is

    component mef_calories_brulees is
    Port ( i_clk : in STD_LOGIC;
           i_cpt_val : in STD_LOGIC_VECTOR(7 downto 0);
           i_reset : in STD_LOGIC;
           o_cpt_rst : out STD_LOGIC;
           o_cpt_en : out STD_LOGIC;
           o_output_cal_strobe : out STD_LOGIC
          );
    end component;
    
    component compteur_nbits is
    generic (nbits : integer := 8);
       port ( clk             : in    std_logic; 
              i_en            : in    std_logic; 
              reset           : in    std_logic; 
              o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
              );
    end component;

    signal s_compte_cal_basse_courrant : STD_LOGIC_VECTOR(23 downto 0);
    signal s_compte_cal_moderee_courrant : STD_LOGIC_VECTOR(23 downto 0);
    signal s_compte_cal_intense_courrant : STD_LOGIC_VECTOR(23 downto 0);
    
    signal s_compte_cal_brulee_total : STD_LOGIC_VECTOR(47 downto 0);
    
    signal s_cpt_en : STD_LOGIC := '0';
    signal s_cpt_reset : STD_LOGIC := '0';
    signal s_cpt_val : STD_LOGIC_VECTOR(7 downto 0);
    signal s_output_calories_strobe : STD_LOGIC;

begin

    cpt : compteur_nbits
    port map (
        clk => i_clk_1Hz,
        i_en => '1',
        reset => s_cpt_reset,
        o_val_cpt => s_cpt_val
    );
    
    mef : mef_calories_brulees
    port map (
        i_clk => i_clk_1Hz,
        i_cpt_val => s_cpt_val,
        i_reset => i_reset,
        o_cpt_rst => s_cpt_reset,
        o_cpt_en => s_cpt_en,
        o_output_cal_strobe => s_output_calories_strobe
    );

    compte_cal : process(i_clk_1Hz, s_cpt_reset)
    begin
        if (s_cpt_reset = '1') then
            s_compte_cal_intense_courrant <= (others => '0');
            s_compte_cal_moderee_courrant <= (others => '0');
            s_compte_cal_basse_courrant <= (others => '0');
        elsif (rising_edge(i_clk_1Hz)) then
            if (i_analyse_cardio < x"3E") then
                s_compte_cal_intense_courrant <= s_compte_cal_intense_courrant + 1;
            elsif (i_analyse_cardio < x"53") then
                s_compte_cal_moderee_courrant <= s_compte_cal_moderee_courrant + 1;
            elsif (i_analyse_cardio < x"64") then
                s_compte_cal_basse_courrant <= s_compte_cal_basse_courrant + 1;
            end if;
        end if;
  
    end process;

    process (i_clk_1Hz)
    begin
        if (rising_edge(i_clk_1Hz)) then
            if (s_output_calories_strobe = '1') then
                s_compte_cal_brulee_total <= s_compte_cal_brulee_total + 
                                             s_compte_cal_basse_courrant + 
                                             s_compte_cal_moderee_courrant +
                                             s_compte_cal_moderee_courrant +
                                             s_compte_cal_intense_courrant +
                                             s_compte_cal_intense_courrant +
                                             s_compte_cal_intense_courrant;
            else 
                s_compte_cal_brulee_total <= s_compte_cal_brulee_total;
            end if;
        end if;
    end process;
    
    o_cal_brulee <= s_compte_cal_brulee_total(31 downto 0);
end Behavioral;
