
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
entity calcul_moyenne is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_echantillon_pret : in std_logic;
    i_ech     : in   std_logic_vector (7 downto 0);
    o_param   : out  std_logic_vector (7 downto 0)                                     
    );
end calcul_moyenne;

----------------------------------------------------------------------------------

architecture Behavioral of calcul_moyenne is

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    signal d_y : signed (15 downto 0);
    signal d_last_y : signed (15 downto 0);
    signal d_mul_y : signed (21 downto 0);
    signal d_ech : signed (7 downto 0);
    signal d_ech_sqrt : signed (15 downto 0);
    signal d_param_15b_vec : std_logic_vector (15 downto 0);
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
        elsif(rising_edge(i_bclk)) then
            if i_echantillon_pret = '1' then
                d_y <= d_ech_sqrt + d_last_y;
                d_last_y <= d_mul_y(21)&d_mul_y(19 downto 5);
                d_mul_y <= d_y * "011111";
            end if;
        end if;
    end process;

    
    d_param_15b_vec <= std_logic_vector(d_y);
    o_param <= d_param_15b_vec(15 downto 8);

end Behavioral;
