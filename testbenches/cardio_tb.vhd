----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2021 03:59:44 PM
-- Design Name: 
-- Module Name: Ctrl_AD1_tb - Behavioral
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

entity cardio_tb is
--  Port ( );
end cardio_tb;

architecture Behavioral of cardio_tb is


    component Analyse_cardio is
    Port ( i_echantillon : in std_logic_vector(11 downto 0);
           i_bclk : in STD_LOGIC;
           i_strobe : in STD_LOGIC;
           o_cpt : out std_logic_vector(7 downto 0));
    end component; 

component Synchro_Horloges is
generic (const_CLK_syst_MHz: integer := 100); 
    Port ( 
           clkm         : in STD_LOGIC;      -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
           o_S_5MHz     : out  STD_LOGIC;    -- source horloge divisee   (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
           o_clk_5MHz   : out  STD_LOGIC;    -- horlgoe via bufg
           o_S_100Hz    : out  STD_LOGIC;    -- source horloge 100 Hz : out  STD_LOGIC;   -- (100  Hz approx:  99,952 Hz) 
           o_stb_100Hz  : out  STD_LOGIC;    -- strobe durée 1/clk_5mHz aligne sur front 100Hz
           o_stb_1Hz    : out STD_LOGIC;
           o_S_1Hz      : out  STD_LOGIC     -- Signal temoin 1 Hz
     );                    
end component;

type in_array is array (integer range 0 to 499) of std_logic_vector(11 downto 0);
constant mem_valeurs_tests : in_array := (
x"042",
x"0AA",
x"1BF",
x"34A",
x"4F8",
x"664",
x"6F1",
x"601",
x"3C3",
x"0DC",
x"E3F",
x"D03",
x"D62",
x"ED1",
x"08A",
x"18E",
x"179",
x"0BB",
x"FD6",
x"F51",
x"F6D",
x"FD7",
x"037",
x"064",
x"049",
x"011",
x"FED",
x"FE0",
x"FE7",
x"FF4",
x"FF8",
x"FF4",
x"FEE",
x"FEB",
x"FEA",
x"FEC",
x"FEF",
x"FF1",
x"FF2",
x"FF4",
x"FF6",
x"FF7",
x"FF8",
x"FF9",
x"FF9",
x"FF9",
x"FF9",
x"FFA",
x"FFA",
x"FFA",
x"FFB",
x"FFD",
x"FFE",
x"000",
x"001",
x"004",
x"006",
x"009",
x"00B",
x"00D",
x"00E",
x"012",
x"02B",
x"07C",
x"128",
x"255",
x"3F6",
x"5A1",
x"6D2",
x"6DF",
x"563",
x"2D2",
x"FE4",
x"DA7",
x"D0B",
x"DDA",
x"F7D",
x"10C",
x"1A0",
x"13B",
x"05C",
x"F87",
x"F3D",
x"F81",
x"FEF",
x"042",
x"056",
x"02D",
x"FFD",
x"FE5",
x"FE5",
x"FF4",
x"001",
x"004",
x"001",
x"FFE",
x"FFC",
x"FFC",
x"FFE",
x"FFF",
x"FFF",
x"FFF",
x"000",
x"000",
x"000",
x"000",
x"000",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"000",
x"000",
x"000",
x"000",
x"000",
x"001",
x"002",
x"002",
x"002",
x"002",
x"00A",
x"032",
x"09F",
x"177",
x"2D7",
x"48A",
x"61C",
x"6F8",
x"676",
x"484",
x"1B9",
x"EEB",
x"D38",
x"D31",
x"E62",
x"01C",
x"165",
x"190",
x"0EF",
x"003",
x"F53",
x"F46",
x"FA3",
x"00B",
x"04A",
x"042",
x"010",
x"FE7",
x"FD8",
x"FDF",
x"FF0",
x"FFC",
x"FFD",
x"FFA",
x"FF7",
x"FF7",
x"FF8",
x"FFB",
x"FFB",
x"FFB",
x"FFB",
x"FFA",
x"FF9",
x"FF7",
x"FF6",
x"FF5",
x"FF3",
x"FF2",
x"FF2",
x"FF2",
x"FF2",
x"FF3",
x"FF5",
x"FF7",
x"FF9",
x"FFB",
x"FFD",
x"FFF",
x"000",
x"001",
x"002",
x"001",
x"003",
x"012",
x"04E",
x"0DD",
x"1E3",
x"36D",
x"520",
x"682",
x"6F0",
x"5D9",
x"384",
x"097",
x"E0E",
x"CF8",
x"D73",
x"EEF",
x"09D",
x"183",
x"155",
x"08B",
x"FA7",
x"F2F",
x"F56",
x"FC4",
x"024",
x"04E",
x"033",
x"000",
x"FE4",
x"FDF",
x"FED",
x"FFE",
x"004",
x"003",
x"000",
x"FFD",
x"FFD",
x"FFF",
x"000",
x"000",
x"000",
x"000",
x"001",
x"001",
x"001",
x"001",
x"001",
x"000",
x"000",
x"000",
x"000",
x"FFF",
x"FFF",
x"FFE",
x"FFD",
x"FFD",
x"FFC",
x"FFB",
x"FFA",
x"FFA",
x"FF9",
x"FF8",
x"FF7",
x"FFA",
x"015",
x"06B",
x"122",
x"25D",
x"405",
x"5AC",
x"6CC",
x"6B7",
x"51C",
x"27C",
x"F94",
x"D78",
x"D04",
x"DEF",
x"F9C",
x"11D",
x"197",
x"122",
x"03F",
x"F73",
x"F3A",
x"F87",
x"FF6",
x"045",
x"053",
x"027",
x"FF9",
x"FE4",
x"FE6",
x"FF5",
x"001",
x"002",
x"FFE",
x"FF9",
x"FF6",
x"FF5",
x"FF5",
x"FF5",
x"FF4",
x"FF3",
x"FF2",
x"FF1",
x"FF1",
x"FF0",
x"FF0",
x"FF0",
x"FF1",
x"FF1",
x"FF2",
x"FF2",
x"FF3",
x"FF4",
x"FF5",
x"FF6",
x"FF7",
x"FF7",
x"FF8",
x"FF9",
x"FFA",
x"FFA",
x"FF9",
x"FFB",
x"003",
x"030",
x"0A6",
x"189",
x"2F6",
x"4AB",
x"634",
x"6F7",
x"650",
x"444",
x"16D",
x"EAD",
x"D21",
x"D3D",
x"E83",
x"03D",
x"16F",
x"182",
x"0D5",
x"FEB",
x"F48",
x"F49",
x"FAD",
x"014",
x"04F",
x"043",
x"010",
x"FEB",
x"FDF",
x"FE7",
x"FF8",
x"001",
x"000",
x"FFB",
x"FF7",
x"FF5",
x"FF6",
x"FF6",
x"FF6",
x"FF5",
x"FF5",
x"FF5",
x"FF5",
x"FF6",
x"FF7",
x"FF8",
x"FFA",
x"FFC",
x"FFE",
x"000",
x"001",
x"003",
x"005",
x"007",
x"008",
x"00A",
x"00A",
x"00B",
x"00B",
x"00B",
x"00A",
x"009",
x"00A",
x"01C",
x"05E",
x"0F6",
x"209",
x"39C",
x"54E",
x"6A1",
x"6F0",
x"5B6",
x"34B",
x"05B",
x"DEA",
x"CFD",
x"D95",
x"F1F",
x"0C5",
x"18E",
x"14C",
x"078",
x"F98",
x"F2E",
x"F60",
x"FCE",
x"028",
x"04A",
x"029",
x"FF7",
x"FDB",
x"FD7",
x"FE5",
x"FF6",
x"FFC",
x"FFA",
x"FF7",
x"FF6",
x"FF7",
x"FFB",
x"FFD",
x"FFF",
x"000",
x"001",
x"002",
x"002",
x"002",
x"001",
x"000",
x"FFE",
x"FFC",
x"FFA",
x"FF8",
x"FF5",
x"FF4",
x"FF2",
x"FF1",
x"FF1",
x"FF1",
x"FF2",
x"FF3",
x"FF4",
x"FF6",
x"FF6",
x"FF8",
x"FFE",
x"01E",
x"07D",
x"13F",
x"287",
x"434",
x"5D5",
x"6DE",
x"6A4",
x"4EA",
x"239",
x"F57",
x"D5C",
x"D0D",
x"E12",
x"FC5",
x"136",
x"194",
x"110",
x"029",
x"F67",
x"F3E",
x"F93",
x"000",
x"04C",
x"054",
x"027",
x"FFB",
x"FE9",
x"FED",
x"FFD",
x"008",
x"009",
x"004",
x"000",
x"FFC",
x"FFB",
x"FFB",
x"FFA",
x"FF9",
x"FF7",
x"FF6",
x"FF5",
x"FF4",
x"FF3",
x"FF2",
x"FF2",
x"FF1",
x"FF1",
x"FF1",
x"FF0",
x"FF0",
x"FF0",
x"FF0",
x"FF0",
x"FF0",
x"FEF",
x"FEF",
x"FEF",
x"FEF",
x"FEF",
x"FEF",
x"FEF"
);

     signal adc_clk : std_logic := '0';
     constant adc_clk_period : time := 50 ns;
     
     signal clk_100Hz : std_logic := '0';
     constant clk_100Hz_period : time := 10 ms;
     
     signal sim_sys_clock : std_logic := '0';
     constant sim_sys_clk_period : time := 8 ns;
     
     
     
     -- Generation du strobe pour commencer a echantillonner
     signal adc_strobe : std_logic := '0';
     signal last_strobe : std_logic := '0';
     signal prev_pulse : std_logic := '0';
     signal curr_pulse : std_logic := '0';
     signal strobe_100Hz : std_logic := '0';
     
     signal sim_data_echantillon: std_logic_vector(11 downto 0);
     signal sim_data_out: std_logic_vector(7 downto 0);
     signal sim_data_ready: std_logic;
     
     signal table_valeurs_adr : integer range 0 to 499 :=0;
     

begin
    
    -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;
       
    
    syncro : Synchro_Horloges
    port map (
        clkm => sim_sys_clock,
        o_S_5MHz => open,
        o_clk_5MHz => adc_clk,
        o_S_100Hz => open,
        o_stb_100Hz => adc_strobe,
        o_S_1Hz => open
   );

    
    inst_analy_cardio: Analyse_cardio
    port map(
    i_echantillon => sim_data_echantillon,
    i_bclk => adc_clk,
    i_strobe => adc_strobe,
    o_cpt => sim_data_out
    );

    

      -- test bench
   tb : PROCESS(adc_strobe)
   variable table_valeurs_adr_var : integer range 0 to 499;
    begin
        if(adc_strobe = '1' and last_strobe ='0') then
            sim_data_echantillon <= mem_valeurs_tests(table_valeurs_adr);
            table_valeurs_adr <= table_valeurs_adr + 1;
		      if(table_valeurs_adr = 499) then
			     table_valeurs_adr <= 0;
		      end if;
		 end if;
		 last_strobe <= adc_strobe;
      END PROCESS;


end Behavioral;