
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;

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
    signal reg_last_vals : std_logic_vector(63 downto 0) := (others => '0');
    signal reg_add : unsigned(10 downto 0) := (others => '0');
    signal reg_div : unsigned(10 downto 0) := (others => '0');

---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 

    process(i_bclk, i_reset)
    begin
        if i_reset = '1' then
            reg_last_vals <= (others => '0');
        elsif(rising_edge(i_bclk)) then
            if i_echantillon_pret = '1' then
                reg_last_vals <= reg_last_vals(55 downto 0) & i_ech;
            end if;
        end if;
    end process;

    reg_add <= unsigned("000"&reg_last_vals(63 downto 56)) + 
                                           unsigned("000"&reg_last_vals(55 downto 48)) + 
                                           unsigned("000"&reg_last_vals(47 downto 40)) + 
                                           unsigned("000"&reg_last_vals(39 downto 32)) +
                                           unsigned("000"&reg_last_vals(31 downto 24)) +
                                           unsigned("000"&reg_last_vals(23 downto 16)) +
                                           unsigned("000"&reg_last_vals(15 downto 8)) +
                                           unsigned("000"&reg_last_vals(7 downto 0));

    reg_div <= shr(reg_add,"11");
    o_param <= std_logic_vector(reg_div(7 downto 0));

end Behavioral;
