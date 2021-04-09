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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity analyse_rappel_bouger is
    Port ( i_moyenne : in STD_LOGIC_VECTOR (1 downto 0);
           i_strobe1Hz : in STD_LOGIC;
           i_bclk : in STD_LOGIC;
           o_rappel : out STD_LOGIC_VECTOR (7 downto 0));
end analyse_rappel_bouger;

architecture Behavioral of analyse_rappel_bouger is

begin


end Behavioral;
