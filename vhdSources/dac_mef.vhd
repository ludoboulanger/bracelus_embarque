----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2021 03:14:10 PM
-- Design Name: 
-- Module Name: dac_mef - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dac_mef is
    Port (
        clk_DAC : in std_logic;
        i_reset : in std_logic;
        strobe_collecte : in std_logic;
        i_cpt_val : in std_logic_vector(3 downto 0);
        ----
        o_t_sync : out std_logic;
        o_rst_cpt : out std_logic;
        o_done : out std_logic;  
        o_en_reg : out std_logic;
        o_load_reg : out std_logic 
     );
end dac_mef;

architecture Behavioral of dac_mef is

    type state_type is (HOLD, LOAD, SYNC, SEND, DONE);
    
    signal curr_state, next_state : state_type;
    
    signal internal_t_sync : std_logic := '1';
    signal internal_cpt_rst : std_logic := '1';
    signal internal_o_done : std_logic := '0';
    signal internal_load_reg : std_logic := '0';
    signal internal_en_reg : std_logic := '0';
begin

    clock : process(clk_DAC, i_reset) is
    begin
        if(i_reset = '1') then
            curr_state <= HOLD;
        elsif rising_edge(clk_DAC) then
            curr_state <= next_state;
        end if;
    end process;
    
    
    state_change : process (i_cpt_val, curr_state, strobe_collecte) is
    begin
        case curr_state is
            when HOLD => 
                if strobe_collecte = '1' then
                    next_state <= LOAD;
                else
                    next_state <= HOLD;
                end if;
            when LOAD => next_state <= SYNC;
            when SYNC =>
                if i_cpt_val = "0011" then 
                    next_state <= SEND;
                else
                    next_state <= SYNC;
                end if;
            when SEND => 
                if i_cpt_val = "1111" then 
                    next_state <= DONE;
                else
                    next_state <= SEND;
                end if;
            when DONE => next_state <= HOLD;
            when others => next_state <= HOLD;
        end case;
    end process;
    
    output_change: process (curr_state) is
    begin
        case curr_state is
            when HOLD =>
                internal_t_sync <= '1';
                internal_cpt_rst <= '1';
                internal_o_done <= '0';
                internal_en_reg <= '0';
                internal_load_reg <= '0';
            when LOAD =>
                internal_t_sync <= '1';
                internal_cpt_rst <= '1';
                internal_o_done <= '0';
                internal_en_reg <= '0';
                internal_load_reg <= '1';
            when SYNC =>
                internal_t_sync <= '0';
                internal_cpt_rst <= '0';
                internal_o_done <= '0';
                internal_en_reg <= '1';
                internal_load_reg <= '0';
            when SEND =>
                internal_t_sync <= '0';
                internal_cpt_rst <= '0';
                internal_o_done <= '0';
                internal_en_reg <= '1';
                internal_load_reg <= '0';
            when DONE =>
                internal_t_sync <= '1';
                internal_cpt_rst <= '1';
                internal_o_done <= '1';
                internal_en_reg <= '0';
                internal_load_reg <= '0';
            when others =>
                internal_t_sync <= '1';
                internal_cpt_rst <= '1';
                internal_o_done <= '0';
                internal_en_reg <= '0';
                internal_load_reg <= '0';    
        end case;
    end process;
    
    o_t_sync <= internal_t_sync;
    o_rst_cpt <= internal_cpt_rst;
    o_done <= internal_o_done;
    o_en_reg <= internal_en_reg;
    o_load_reg <= internal_load_reg;
    
end Behavioral;
