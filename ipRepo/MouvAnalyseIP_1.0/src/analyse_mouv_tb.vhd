----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2021 01:02:12 PM
-- Design Name: 
-- Module Name: analyse_mouv_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity analyse_mouv_tb is
--  Port ( );
end analyse_mouv_tb;

architecture Behavioral of analyse_mouv_tb is

component analyse_zone_mouv is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_ech     : in   std_logic_vector (11 downto 0);
    o_param   : out  std_logic_vector (11 downto 0)                                     
    );
end component;

signal sim_sys_clock : std_logic;
constant sim_sys_clk_period : time := 20 ns;

--constant nbEchantillonMemoireMouv : integer := 24;
constant nbEchantillonMemoireMouv : integer := 402;
type tableau_mouv is array (integer range 0 to nbEchantillonMemoireMouv - 1) of std_logic_vector(11 downto 0);


constant mem_forme_signal_mouv : tableau_mouv := (
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
    x"1E9",
    
    ---- LOW
    x"1F8",
x"1FC",
x"1FF",
x"1FD",
x"1F8",
x"1FE",
x"1FE",
x"1FB",
x"1F7",
x"1FC",
x"1FD",
x"1FA",
x"1DD",
x"1DD",
x"28B",
x"161",
x"1A5",
x"179",
x"0ED",
x"015",
x"1FC",
x"178",
x"065",
x"0F4",
x"17C",
x"029",
x"0E1",
x"187",
x"0F5",
x"077",
x"01F",
x"FA3",
x"1DA",
x"0A7",
x"13B",
x"160",
x"090",
x"016",
x"018",
x"1AA",
x"06B",
x"FF7",
x"0C1",
x"1F0",
x"034",
x"025",
x"049",
x"0B9",
x"0BC",
x"09D",
x"0DC",
x"155",
x"092",
x"FF3",
x"074",
x"10B",
x"148",
x"06C",
x"10D",
x"130",
x"051",
x"04C",
x"19C",
x"02F",
x"0F2",
x"18F",
x"0EE",
x"095",
x"11F",
x"10E",
x"0A1",
x"0ED",
x"0F8",
x"0DA",
x"0FF",
x"0B8",
x"102",
x"07E",
x"050",
x"0EE",
x"105",
x"01F",
x"07D",
x"0D4",
x"0CB",
x"065",
x"07B",
x"170",
x"088",
x"09C",
x"07F",
x"176",
x"119",
x"050",
x"093",
x"16B",
x"039",
x"06F",
x"070",
x"082",
x"109",
x"072",
x"05C",
x"0F9",
x"0EF",
x"06A",
x"067",
x"0E6",
x"0A6",
x"0AA",
x"109",
x"0CE",
x"04E",
x"0D9",
x"0D0",
x"09B",
x"072",
x"11E",
x"068",
x"09B",
x"0B4",
x"168",
x"09F",
x"005",
x"0B5",
x"113",
x"0D3",
x"0C3",
x"15C",
x"0B3",
x"036",
x"012",
x"1D2",
x"011",
x"087",
x"061",
x"0F3",
x"022",
x"03B",
x"02D",
x"0E9",
x"07E",
x"089",
x"15F",
x"063",
x"00D",
x"FE6",
x"043",
x"0D4",
x"02F",
x"0AB",
x"025",
x"03B",
x"060",
x"0C2",
x"0BF",
x"066",
x"0F7",
x"04F",
x"01F",
x"046",
x"031",
x"021",
x"076",
x"040",
x"0A9",
x"04C",
x"085",
x"072",
x"1B2",
x"02A",
x"0C6",
x"176",
x"031",
x"003",
x"0ED",
x"1A8",
x"07E",
x"101",
x"01D",
x"018",
x"110",
x"052",
x"01E",
x"0A1",
x"03F",
x"FB3",
x"1CC",
x"143",
x"112",
x"0C8",
x"09E",
x"044",
x"025",
x"0E6",
x"087",
x"070",
x"094",
x"095",
x"048",
x"030"

);

signal i_reset : std_logic :='0';

    signal d_compteur_echantillonMemoireMouv : unsigned(7 downto 0) := (others => '0');
    signal d_compteur_echantillonMemoireCardio : unsigned(7 downto 0) := (others => '0');
    signal d_echantillonMemoireMouv : std_logic_vector(15 downto 0) := (others => '0');
    signal d_echantillonMemoireCardio : std_logic_vector(15 downto 0) := (others => '0');
    signal q_iteration : unsigned(2 downto 0) := (others => '0');
    signal q_collecte : std_logic := '0';
    signal q_prec_collecte : std_logic;
    signal q_strobe_collecte : std_logic;
    
    signal sim_moy: std_logic_vector(11 downto 0);
    
begin


    inst_analyse: analyse_zone_mouv
    Port map (
    i_bclk    => sim_sys_clock,
    i_reset   => i_reset,
    i_en      => '1',
    i_ech     => d_echantillonMemoireMouv,
    o_param   => sim_moy                         
    );

    
    -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;
       


    lireEchantillonMouv : process (i_reset, sim_sys_clock)
        begin
           if(i_reset = '1') then 
              d_compteur_echantillonMemoireMouv <= x"00";
              d_echantillonMemoireMouv <= x"0000";
              q_iteration <= (others => '0');
           else
              if rising_edge(sim_sys_clock) then
                     d_echantillonMemoireMouv <= "0000"&mem_forme_signal_mouv(to_integer(d_compteur_echantillonMemoireMouv));
                        if (d_compteur_echantillonMemoireMouv = mem_forme_signal_mouv'length-1) then
                            d_compteur_echantillonMemoireMouv <= x"00";
                            q_iteration <= q_iteration + 1;
                        else
                            d_compteur_echantillonMemoireMouv <= d_compteur_echantillonMemoireMouv + 1;
                        end if;
                        end if;
             end if;
        end process;  



end Behavioral;
