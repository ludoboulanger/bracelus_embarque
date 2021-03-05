----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2021 11:28:55 AM
-- Design Name: 
-- Module Name: Ctrl_DAC - Behavioral
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

entity Ctrl_DAC is
    Port (
        clk_DAC : in std_logic;
        i_reset : in std_logic;
        i_strobe_collecte : in std_logic;
        ----
        o_DAC_tsync : out std_logic;
        o_DAC_data : out std_logic
     );
end Ctrl_DAC;

architecture Behavioral of Ctrl_DAC is

component compteur_nbits is
generic (nbits : integer := 4);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;

component dac_mef is
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
end component;

component registre_16b is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_load : in STD_LOGIC;
           i_dat_load : in STD_LOGIC_VECTOR (15 downto 0);
           o_dat : out STD_LOGIC);
end component;

-- constant nbEchantillonMemoire : integer := 24;
constant nbEchantillonMemoire : integer := 201;
type tableau is array (integer range 0 to nbEchantillonMemoire - 1) of std_logic_vector(11 downto 0);
--constant mem_forme_signal : tableau := (
--    x"800", --800
--    x"A11",
--    x"BFF",
--    x"DA7",
--    x"EEC",
--    x"FB9",
--    x"FFF",
--    x"FB9",
--    x"EEC",
--    x"DA7",
--    x"BFF",
--    x"A11",
--    x"800",
--    x"5EE",
--    x"400",
--    x"258",
--    x"113",
--    x"046",
--    x"001",
--    x"046",
--    x"113",
--    x"258",
--    x"400",
--    x"5EE"
--);

constant mem_forme_signal : tableau := (
    x"800",
    x"50C",
    x"7FF",
    x"800",
    x"67B",
    x"698",
    x"825",
    x"1F4",
    x"5F1",
    x"800",
    x"44C",
    x"7FF",
    x"800",
    x"6DF",
    x"7FF",
    x"B2A",
    x"1FF",
    x"7FF",
    x"8FE",
    x"7FF",
    x"597",
    x"DDE",
    x"AB3",
    x"EB6",
    x"D9D",
    x"C04",
    x"EC2",
    x"E6B",
    x"0A6",
    x"EB1",
    x"C64",
    x"A40",
    x"BCD",
    x"250",
    x"7FF",
    x"800",
    x"587",
    x"7FF",
    x"800",
    x"5D6",
    x"7FF",
    x"800",
    x"7FF",
    x"7FF",
    x"967",
    x"7FF",
    x"7FF",
    x"AAA",
    x"800",
    x"E74",
    x"0A5",
    x"3B1",
    x"800",
    x"7FF",
    x"7FF",
    x"9D3",
    x"9AD",
    x"800",
    x"7FF",
    x"7FF",
    x"900",
    x"800",
    x"800",
    x"7FF",
    x"143",
    x"0D1",
    x"7FF",
    x"800",
    x"7FF",
    x"2A5",
    x"F8E",
    x"720",
    x"800",
    x"679",
    x"FA8",
    x"07E",
    x"7FF",
    x"800",
    x"222",
    x"02E",
    x"20A",
    x"6CC",
    x"800",
    x"7FF",
    x"5D3",
    x"E2D",
    x"2A0",
    x"800",
    x"7D4",
    x"7FF",
    x"B3B",
    x"445",
    x"800",
    x"7FF",
    x"497",
    x"E72",
    x"221",
    x"800",
    x"7FF",
    x"5AA",
    x"EB5",
    x"FED",
    x"92A",
    x"625",
    x"7FF",
    x"800",
    x"FA8",
    x"E94",
    x"18D",
    x"7FF",
    x"800",
    x"7FF",
    x"2BE",
    x"FD3",
    x"7FF",
    x"800",
    x"7FF",
    x"648",
    x"F7B",
    x"F20",
    x"AE0",
    x"4FD",
    x"7FF",
    x"8AA",
    x"254",
    x"AA8",
    x"6C1",
    x"658",
    x"800",
    x"FFA",
    x"C9B",
    x"3BC",
    x"7FF",
    x"800",
    x"0BA",
    x"E4C",
    x"269",
    x"7FF",
    x"800",
    x"1B8",
    x"D80",
    x"11C",
    x"7FF",
    x"800",
    x"7FF",
    x"07F",
    x"0CD",
    x"7FF",
    x"800",
    x"7FF",
    x"073",
    x"FA0",
    x"0C0",
    x"AD4",
    x"7FF",
    x"1DD",
    x"096",
    x"E8F",
    x"C03",
    x"7FF",
    x"3D5",
    x"800",
    x"E39",
    x"14C",
    x"1AD",
    x"7FF",
    x"800",
    x"79B",
    x"1DF",
    x"FD2",
    x"7FF",
    x"800",
    x"7FF",
    x"424",
    x"DDF",
    x"005",
    x"D06",
    x"377",
    x"7FF",
    x"800",
    x"2EF",
    x"09C",
    x"015",
    x"7FF",
    x"8A3",
    x"7FF",
    x"0AD",
    x"212",
    x"7FF",
    x"81A",
    x"7FF",
    x"469",
    x"800",
    x"215",
    x"00E",
    x"39F",
    x"7FF",
    x"800",
    x"7FF",
    x"07E",
    x"1E9"
);

    constant c_NbIteration : unsigned(3 downto 0) := "1000";

    signal d_compteur_echantillonMemoire : unsigned(7 downto 0) := (others => '0');
    signal d_echantillonMemoire : std_logic_vector(15 downto 0) := (others => '0');
    signal q_iteration : unsigned(2 downto 0) := (others => '0');
    signal q_collecte : std_logic := '0';
    signal q_prec_collecte : std_logic;
    signal q_strobe_collecte : std_logic;
    
    signal cpt_val : std_logic_vector(3 downto 0) := "0000";
    
    signal dac_t_sync : std_logic := '1';
    signal dac_t_sync_prec : std_logic := '0';
    signal reset_cpt : std_logic := '0';
    signal dac_echantillon : std_logic;
    signal done_ech : std_logic := '0';
    
    signal load_reg : std_logic := '0';
    signal en_reg : std_logic := '0';
    signal out_reg : std_logic := '0';

begin

  reg_16b : registre_16b
    port map (
        i_clk => clk_DAC,
        i_reset => '0',
        i_en => en_reg,
        i_load => load_reg,
        i_dat_load => d_echantillonMemoire,
        o_dat => out_reg
    );

    compteur : compteur_nbits
    port map (
        clk => clk_DAC,
        i_en => '1',
        reset => reset_cpt,
        o_val_cpt => cpt_val
    );
    
    mef : dac_mef
    port map (
        clk_DAC => clk_DAC,
        i_reset => i_reset,
        strobe_collecte => i_strobe_collecte,
        i_cpt_val => cpt_val,
        ----
        o_t_sync => dac_t_sync,
        o_rst_cpt => reset_cpt,
        o_done => done_ech,
        o_en_reg => en_reg,
        o_load_reg => load_reg
    );

    lireEchantillon : process (i_reset, clk_DAC)
        begin
           if(i_reset = '1') then 
              d_compteur_echantillonMemoire <= x"00";
              d_echantillonMemoire <= x"0000";
              q_iteration <= (others => '0');
           else
              if rising_edge(clk_DAC) then
                 if (i_strobe_collecte = '1') then
                     d_echantillonMemoire <= "0000"&mem_forme_signal(to_integer(d_compteur_echantillonMemoire));
                     q_collecte <= '1';
                        if (d_compteur_echantillonMemoire = mem_forme_signal'length-1) then
                            d_compteur_echantillonMemoire <= x"00";
                            q_iteration <= q_iteration + 1;
                        else
                            d_compteur_echantillonMemoire <= d_compteur_echantillonMemoire + 1;
                        end if;
                 else
                    q_collecte <= '0';
                 end if;
             end if;
           end if;
        end process;    
        
        
   o_DAC_data <= out_reg;
   o_DAC_tsync <= dac_t_sync;

end Behavioral;
