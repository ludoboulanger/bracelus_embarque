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
        i_signal_select : in std_logic_vector(2 downto 0);
        ----
        o_DAC_tsync : out std_logic;
        o_DAC_data0 : out std_logic;
        o_DAC_data1 : out std_logic
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

--constant nbEchantillonMemoireMouv : integer := 24;
constant nbEchantillonMemoireMouv : integer := 201;
type tableau_mouv is array (integer range 0 to nbEchantillonMemoireMouv - 1) of std_logic_vector(11 downto 0);
constant mem_forme_signal_mouv_high : tableau_mouv := (
x"990",
x"69C",
x"98F",
x"990",
x"80B",
x"828",
x"9B5",
x"384",
x"781",
x"990",
x"5DC",
x"98F",
x"990",
x"86F",
x"98F",
x"CBA",
x"38F",
x"98F",
x"A8E",
x"98F",
x"727",
x"F6E",
x"C43",
x"045",
x"F2D",
x"D94",
x"052",
x"FFB",
x"236",
x"041",
x"DF4",
x"BD0",
x"D5D",
x"3E0",
x"98F",
x"990",
x"717",
x"98F",
x"990",
x"766",
x"98F",
x"990",
x"98F",
x"98F",
x"AF7",
x"98F",
x"98F",
x"C3A",
x"990",
x"003",
x"235",
x"541",
x"990",
x"98F",
x"98F",
x"B63",
x"B3D",
x"990",
x"98F",
x"98F",
x"A90",
x"990",
x"990",
x"98F",
x"2D3",
x"261",
x"98F",
x"990",
x"98F",
x"435",
x"11D",
x"8B0",
x"990",
x"809",
x"137",
x"20E",
x"98F",
x"990",
x"3B2",
x"1BE",
x"39A",
x"85C",
x"990",
x"98F",
x"763",
x"FBD",
x"430",
x"990",
x"964",
x"98F",
x"CCB",
x"5D5",
x"990",
x"98F",
x"627",
x"001",
x"3B1",
x"990",
x"98F",
x"73A",
x"044",
x"17D",
x"ABA",
x"7B5",
x"98F",
x"990",
x"137",
x"023",
x"31D",
x"98F",
x"990",
x"98F",
x"44E",
x"162",
x"98F",
x"990",
x"98F",
x"7D8",
x"10A",
x"0B0",
x"C70",
x"68D",
x"98F",
x"A3A",
x"3E4",
x"C38",
x"851",
x"7E8",
x"990",
x"189",
x"E2B",
x"54C",
x"98F",
x"990",
x"24A",
x"FDC",
x"3F9",
x"98F",
x"990",
x"348",
x"F10",
x"2AC",
x"98F",
x"990",
x"98F",
x"20F",
x"25D",
x"98F",
x"990",
x"98F",
x"203",
x"12F",
x"250",
x"C64",
x"98F",
x"36D",
x"226",
x"01E",
x"D93",
x"98F",
x"565",
x"990",
x"FC9",
x"2DC",
x"33D",
x"98F",
x"990",
x"92B",
x"36F",
x"161",
x"98F",
x"990",
x"98F",
x"5B4",
x"F6F",
x"195",
x"E96",
x"507",
x"98F",
x"990",
x"47F",
x"22C",
x"1A5",
x"98F",
x"A33",
x"98F",
x"23D",
x"3A2",
x"98F",
x"9AA",
x"98F",
x"5F9",
x"990",
x"3A5",
x"19E",
x"52F",
x"98F",
x"990",
x"98F",
x"20E",
x"379"

);

constant mem_forme_signal_mouv_low : tableau_mouv := (
x"3F1",
x"3F8",
x"3FE",
x"3FB",
x"3F0",
x"3FC",
x"3FD",
x"3F7",
x"3EE",
x"3F8",
x"3FA",
x"3F4",
x"3BB",
x"3BB",
x"517",
x"2C2",
x"34A",
x"2F3",
x"1DB",
x"02A",
x"3F8",
x"2F0",
x"0CB",
x"1E9",
x"2F9",
x"053",
x"1C3",
x"30F",
x"1EA",
x"0EF",
x"03F",
x"F45",
x"3B4",
x"14F",
x"277",
x"2C0",
x"120",
x"02D",
x"031",
x"355",
x"0D7",
x"FED",
x"183",
x"3E1",
x"068",
x"04A",
x"093",
x"173",
x"178",
x"13A",
x"1B8",
x"2AA",
x"124",
x"FE6",
x"0E8",
x"217",
x"291",
x"0D9",
x"21A",
x"261",
x"0A2",
x"099",
x"339",
x"05F",
x"1E4",
x"31F",
x"1DC",
x"12B",
x"23E",
x"21C",
x"143",
x"1DB",
x"1F1",
x"1B4",
x"1FE",
x"171",
x"204",
x"0FD",
x"0A1",
x"1DD",
x"20B",
x"03F",
x"0FA",
x"1A8",
x"196",
x"0CA",
x"0F7",
x"2E0",
x"111",
x"138",
x"0FE",
x"2ED",
x"232",
x"0A1",
x"126",
x"2D7",
x"072",
x"0DE",
x"0E0",
x"105",
x"213",
x"0E4",
x"0B9",
x"1F2",
x"1DF",
x"0D5",
x"0CE",
x"1CD",
x"14D",
x"154",
x"213",
x"19D",
x"09D",
x"1B3",
x"1A0",
x"137",
x"0E4",
x"23C",
x"0D1",
x"137",
x"168",
x"2D0",
x"13F",
x"00B",
x"16B",
x"226",
x"1A6",
x"186",
x"2B9",
x"166",
x"06C",
x"025",
x"3A4",
x"022",
x"10E",
x"0C2",
x"1E6",
x"045",
x"077",
x"05A",
x"1D3",
x"0FD",
x"112",
x"2BE",
x"0C6",
x"01B",
x"FCC",
x"086",
x"1A9",
x"05E",
x"157",
x"04B",
x"076",
x"0C1",
x"184",
x"17F",
x"0CC",
x"1EE",
x"09F",
x"03F",
x"08D",
x"062",
x"043",
x"0ED",
x"081",
x"152",
x"099",
x"10B",
x"0E5",
x"365",
x"054",
x"18C",
x"2ED",
x"062",
x"007",
x"1DA",
x"350",
x"0FC",
x"202",
x"03A",
x"030",
x"221",
x"0A5",
x"03C",
x"142",
x"07E",
x"F65",
x"399",
x"287",
x"224",
x"191",
x"13C",
x"088",
x"04B",
x"1CD",
x"10F",
x"0E1",
x"129",
x"12B",
x"091",
x"060"
);

constant mem_forme_signal_sed : tableau_mouv := (others => x"000");


--constant nbEchantillonMemoireCardio : integer := 24;
constant nbEchantillonMemoireCardio : integer := 500;
type tableau_cardio is array (integer range 0 to nbEchantillonMemoireCardio - 1) of std_logic_vector(11 downto 0);
--constant mem_forme_signal_cardio : tableau_cardio := (
--    x"400",
--    x"258",
--    x"113",
--    x"046",
--    x"001",
--    x"046",
--    x"113",
--    x"258",
--    x"400",
--    x"5EE",
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
--    x"5EE"
--);
constant mem_forme_signal_cardio_mort : tableau_cardio := (others => x"000");
--    constant c_NbIteration : unsigned(3 downto 0) := "1000";
constant mem_forme_signal_cardio_100 : tableau_cardio := (
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

constant mem_forme_signal_cardio_60 : tableau_cardio := (
x"040",
x"06A",
x"0DF",
x"193",
x"27A",
x"380",
x"48F",
x"591",
x"668",
x"6E9",
x"6E9",
x"646",
x"517",
x"384",
x"1B4",
x"FE2",
x"E53",
x"D4F",
x"CFB",
x"D3D",
x"DF2",
x"EF5",
x"00B",
x"0F7",
x"17D",
x"18E",
x"14A",
x"0CF",
x"03C",
x"FB3",
x"F54",
x"F39",
x"F58",
x"F98",
x"FE0",
x"01F",
x"04D",
x"061",
x"058",
x"03D",
x"01D",
x"005",
x"FF8",
x"FF3",
x"FF7",
x"FFF",
x"008",
x"010",
x"013",
x"012",
x"00E",
x"00A",
x"007",
x"004",
x"002",
x"002",
x"002",
x"002",
x"002",
x"001",
x"001",
x"001",
x"000",
x"000",
x"000",
x"000",
x"000",
x"001",
x"001",
x"001",
x"001",
x"002",
x"002",
x"002",
x"003",
x"003",
x"003",
x"003",
x"004",
x"004",
x"004",
x"005",
x"005",
x"005",
x"006",
x"006",
x"007",
x"007",
x"007",
x"008",
x"008",
x"008",
x"009",
x"009",
x"009",
x"008",
x"007",
x"008",
x"00A",
x"016",
x"033",
x"06A",
x"0C5",
x"14B",
x"208",
x"2F9",
x"406",
x"513",
x"603",
x"6B0",
x"6EF",
x"696",
x"5A4",
x"43C",
x"285",
x"0AC",
x"EF7",
x"DAA",
x"D07",
x"D08",
x"D8D",
x"E72",
x"F88",
x"08F",
x"14A",
x"18D",
x"16B",
x"104",
x"075",
x"FE1",
x"F67",
x"F27",
x"F2C",
x"F5D",
x"FA3",
x"FE7",
x"01D",
x"03E",
x"041",
x"02D",
x"00F",
x"FF4",
x"FE2",
x"FDB",
x"FDC",
x"FE4",
x"FF0",
x"FFB",
x"001",
x"004",
x"003",
x"001",
x"000",
x"000",
x"000",
x"000",
x"002",
x"004",
x"006",
x"008",
x"009",
x"009",
x"00A",
x"00A",
x"00A",
x"009",
x"009",
x"008",
x"007",
x"006",
x"005",
x"005",
x"004",
x"004",
x"004",
x"005",
x"006",
x"007",
x"008",
x"009",
x"00A",
x"00C",
x"00D",
x"00E",
x"00F",
x"00F",
x"010",
x"010",
x"010",
x"00F",
x"00F",
x"00E",
x"00E",
x"00D",
x"00C",
x"00A",
x"008",
x"007",
x"008",
x"00E",
x"021",
x"04B",
x"094",
x"105",
x"1A8",
x"283",
x"388",
x"49A",
x"59E",
x"671",
x"6E9",
x"6DD",
x"62F",
x"4FA",
x"362",
x"190",
x"FC1",
x"E38",
x"D3E",
x"CF5",
x"D3F",
x"DFA",
x"EFF",
x"015",
x"0FC",
x"17A",
x"185",
x"13C",
x"0BE",
x"029",
x"FA1",
x"F44",
x"F2C",
x"F4D",
x"F8D",
x"FD5",
x"012",
x"03E",
x"050",
x"044",
x"028",
x"008",
x"FF2",
x"FE5",
x"FE1",
x"FE5",
x"FEE",
x"FF9",
x"000",
x"003",
x"002",
x"000",
x"FFD",
x"FFA",
x"FF8",
x"FF7",
x"FF7",
x"FF8",
x"FF9",
x"FFA",
x"FFB",
x"FFC",
x"FFC",
x"FFD",
x"FFE",
x"FFE",
x"FFF",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"000",
x"FFF",
x"FFF",
x"FFE",
x"FFE",
x"FFD",
x"FFD",
x"FFD",
x"FFD",
x"FFD",
x"FFD",
x"FFD",
x"FFE",
x"FFE",
x"FFE",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFE",
x"FFF",
x"002",
x"00F",
x"02E",
x"068",
x"0C7",
x"152",
x"214",
x"309",
x"41A",
x"528",
x"618",
x"6C1",
x"6FA",
x"699",
x"59F",
x"431",
x"276",
x"09C",
x"EEA",
x"DA6",
x"D0B",
x"D15",
x"D9F",
x"E88",
x"F9F",
x"0A4",
x"15A",
x"198",
x"173",
x"10B",
x"07E",
x"FEE",
x"F78",
x"F3F",
x"F49",
x"F7D",
x"FC3",
x"005",
x"039",
x"056",
x"055",
x"03C",
x"01A",
x"FFC",
x"FE8",
x"FDE",
x"FDD",
x"FE3",
x"FED",
x"FF7",
x"FFD",
x"FFF",
x"FFE",
x"FFD",
x"FFB",
x"FFA",
x"FFB",
x"FFC",
x"FFE",
x"000",
x"000",
x"002",
x"003",
x"003",
x"003",
x"004",
x"004",
x"003",
x"003",
x"002",
x"001",
x"000",
x"000",
x"FFF",
x"FFD",
x"FFC",
x"FFC",
x"FFB",
x"FFB",
x"FFB",
x"FFC",
x"FFD",
x"FFE",
x"FFF",
x"000",
x"000",
x"001",
x"002",
x"002",
x"003",
x"002",
x"002",
x"002",
x"001",
x"001",
x"000",
x"000",
x"FFF",
x"FFD",
x"FFD",
x"FFE",
x"005",
x"01A",
x"047",
x"093",
x"108",
x"1AF",
x"28E",
x"395",
x"4A8",
x"5AA",
x"679",
x"6EC",
x"6D7",
x"620",
x"4E4",
x"348",
x"176",
x"FA9",
x"E28",
x"D3A",
x"CFC",
x"D4E",
x"E10",
x"F1A",
x"02F",
x"112",
x"189",
x"18F",
x"142",
x"0C2",
x"02E",
x"FA7",
x"F4D",
x"F39",
x"F5C",
x"F9D",
x"FE4",
x"01F",
x"04A",
x"059",
x"04C",
x"02F",
x"00F",
x"FF9",
x"FEC",
x"FE8",
x"FED",
x"FF6",
x"000",
x"007",
x"009",
x"007",
x"003",
x"000",
x"FFC",
x"FF9",
x"FF6",
x"FF5",
x"FF5",
x"FF4",
x"FF4",
x"FF3",
x"FF3",
x"FF3",
x"FF2",
x"FF2",
x"FF2",
x"FF2",
x"FF3",
x"FF3",
x"FF3",
x"FF3",
x"FF4",
x"FF4",
x"FF4",
x"FF5",
x"FF5",
x"FF6",
x"FF7",
x"FF7",
x"FF8",
x"FF9",
x"FF9",
x"FFA",
x"FFB",
x"FFB",
x"FFC",
x"FFD",
x"FFD",
x"FFE",
x"FFE",
x"FFE",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF",
x"FFF"
);


constant mem_forme_signal_cardio_80 : tableau_cardio := (
x"033",
x"06F",
x"114",
x"20D",
x"33F",
x"485",
x"5B8",
x"6A0",
x"6F3",
x"669",
x"50D",
x"321",
x"0ED",
x"EE0",
x"D74",
x"D00",
x"D62",
x"E60",
x"FAC",
x"0DB",
x"185",
x"18B",
x"11F",
x"076",
x"FCA",
x"F50",
x"F38",
x"F6B",
x"FBE",
x"00A",
x"041",
x"052",
x"03C",
x"015",
x"FF6",
x"FE4",
x"FE0",
x"FE8",
x"FF5",
x"000",
x"005",
x"005",
x"003",
x"000",
x"FFF",
x"FFF",
x"FFF",
x"000",
x"000",
x"000",
x"000",
x"000",
x"FFF",
x"FFE",
x"FFD",
x"FFC",
x"FFA",
x"FF9",
x"FF8",
x"FF8",
x"FF7",
x"FF7",
x"FF8",
x"FF9",
x"FFA",
x"FFC",
x"FFD",
x"FFF",
x"000",
x"002",
x"004",
x"005",
x"006",
x"007",
x"008",
x"008",
x"009",
x"009",
x"009",
x"008",
x"007",
x"008",
x"00E",
x"029",
x"065",
x"0D4",
x"184",
x"284",
x"3BF",
x"507",
x"627",
x"6DF",
x"6E4",
x"603",
x"46A",
x"259",
x"024",
x"E44",
x"D2F",
x"D11",
x"DB3",
x"ED8",
x"025",
x"12F",
x"197",
x"16B",
x"0E1",
x"02E",
x"F8D",
x"F35",
x"F3D",
x"F80",
x"FD5",
x"01B",
x"047",
x"04A",
x"02D",
x"008",
x"FF0",
x"FE6",
x"FE8",
x"FF4",
x"002",
x"00C",
x"00F",
x"00E",
x"00A",
x"007",
x"004",
x"003",
x"003",
x"003",
x"002",
x"002",
x"001",
x"000",
x"000",
x"FFF",
x"FFF",
x"FFE",
x"FFE",
x"FFD",
x"FFD",
x"FFC",
x"FFC",
x"FFC",
x"FFB",
x"FFB",
x"FFB",
x"FFB",
x"FFC",
x"FFC",
x"FFD",
x"FFD",
x"FFE",
x"FFF",
x"000",
x"001",
x"002",
x"003",
x"003",
x"004",
x"004",
x"003",
x"002",
x"004",
x"00F",
x"034",
x"080",
x"104",
x"1D0",
x"2EB",
x"430",
x"56F",
x"672",
x"6F0",
x"6A1",
x"575",
x"3A8",
x"17F",
x"F5C",
x"DB8",
x"D03",
x"D33",
x"E0E",
x"F4F",
x"090",
x"166",
x"193",
x"13F",
x"0A1",
x"FF0",
x"F64",
x"F32",
x"F56",
x"FA5",
x"FF7",
x"035",
x"051",
x"044",
x"020",
x"FFD",
x"FE8",
x"FE1",
x"FE6",
x"FF2",
x"FFE",
x"004",
x"005",
x"002",
x"000",
x"FFE",
x"FFD",
x"FFD",
x"FFE",
x"000",
x"000",
x"000",
x"000",
x"001",
x"001",
x"002",
x"002",
x"002",
x"001",
x"001",
x"000",
x"000",
x"FFF",
x"FFE",
x"FFE",
x"FFD",
x"FFC",
x"FFC",
x"FFC",
x"FFD",
x"FFD",
x"FFE",
x"000",
x"000",
x"002",
x"003",
x"004",
x"005",
x"006",
x"006",
x"005",
x"005",
x"005",
x"008",
x"01C",
x"04D",
x"0AD",
x"14A",
x"235",
x"366",
x"4AF",
x"5E0",
x"6BA",
x"6F6",
x"651",
x"4E2",
x"2EA",
x"0B3",
x"EB1",
x"D5C",
x"D01",
x"D77",
x"E81",
x"FCF",
x"0F5",
x"18C",
x"184",
x"10F",
x"063",
x"FB9",
x"F49",
x"F3B",
x"F74",
x"FC8",
x"013",
x"047",
x"053",
x"03B",
x"014",
x"FF6",
x"FE6",
x"FE4",
x"FED",
x"FFB",
x"006",
x"00B",
x"00A",
x"008",
x"006",
x"004",
x"004",
x"005",
x"007",
x"008",
x"008",
x"009",
x"009",
x"008",
x"008",
x"008",
x"008",
x"007",
x"007",
x"006",
x"006",
x"005",
x"005",
x"004",
x"003",
x"002",
x"002",
x"001",
x"000",
x"000",
x"000",
x"000",
x"FFF",
x"FFF",
x"FFE",
x"FFE",
x"FFD",
x"FFD",
x"FFD",
x"FFC",
x"FFB",
x"FFB",
x"FFC",
x"003",
x"021",
x"063",
x"0D9",
x"192",
x"29B",
x"3DB",
x"522",
x"63C",
x"6E4",
x"6D2",
x"5DC",
x"432",
x"219",
x"FE9",
x"E17",
x"D1E",
x"D18",
x"DCC",
x"EFB",
x"047",
x"145",
x"19D",
x"166",
x"0D7",
x"025",
x"F8B",
x"F3E",
x"F4F",
x"F97",
x"FEA",
x"02E",
x"054",
x"050",
x"02F",
x"008",
x"FF0",
x"FE4",
x"FE6",
x"FF1",
x"FFE",
x"005",
x"007",
x"005",
x"002",
x"000",
x"FFF",
x"FFF",
x"000",
x"000",
x"001",
x"002",
x"002",
x"003",
x"003",
x"004",
x"005",
x"006",
x"006",
x"007",
x"007",
x"008",
x"008",
x"008",
x"008",
x"008",
x"007",
x"007",
x"006",
x"005",
x"004",
x"004",
x"003",
x"002",
x"002",
x"002",
x"002",
x"002",
x"003",
x"004",
x"004",
x"004",
x"006",
x"00A",
x"01A",
x"044",
x"099",
x"127",
x"1FE",
x"322",
x"46B",
x"5A8",
x"6A1",
x"70D",
x"6A6",
x"565",
x"38A",
x"159",
x"F3C",
x"DAC",
x"D10",
x"D53",
x"E3B",
x"F7F",
x"0B9",
x"17C",
x"197",
x"138",
x"094",
x"FE3",
x"F5D",
x"F34",
x"F5E",
x"FAE",
x"FFD",
x"037",
x"04E",
x"03D",
x"018",
x"FF6",
x"FE2",
x"FDD",
x"FE3",
x"FF0",
x"FFD",
x"003",
x"003",
x"001",
x"000",
x"FFE",
x"FFE",
x"FFF",
x"000",
x"001",
x"001",
x"002",
x"002",
x"002",
x"002",
x"002",
x"003",
x"003",
x"003",
x"003",
x"004",
x"004",
x"005",
x"005",
x"006",
x"007",
x"008",
x"008",
x"008",
x"009",
x"008",
x"008",
x"007",
x"005",
x"004",
x"001",
x"000",
x"FFE",
x"FFC",
x"FFA",
x"FF9",
x"FF8",
x"FF8"
);

    signal d_compteur_echantillonMemoireMouv : unsigned(7 downto 0) := (others => '0');
    signal d_compteur_echantillonMemoireCardio : unsigned(11 downto 0) := (others => '0');
    signal d_echantillonMemoireMouv : std_logic_vector(15 downto 0) := (others => '0');
    signal d_echantillonMemoireCardio : std_logic_vector(15 downto 0) := (others => '0');
    
    signal cpt_val : std_logic_vector(3 downto 0) := "0000";
    
    signal dac_t_sync : std_logic := '1';
    signal dac_t_sync_prec : std_logic := '0';
    signal reset_cpt : std_logic := '0';
    signal dac_echantillon : std_logic;
    signal done_ech : std_logic := '0';
    
    signal load_reg : std_logic := '0';
    signal en_reg : std_logic := '0';
    signal out_reg_mouv : std_logic := '0';
    signal out_reg_cardio : std_logic := '0';
    
    signal mem_forme_signal_mouv : tableau_mouv := mem_forme_signal_mouv_high;
    signal mem_forme_signal_cardio : tableau_cardio := mem_forme_signal_cardio_100;

begin

  reg_16b_mouv : registre_16b
    port map (
        i_clk => clk_DAC,
        i_reset => '0',
        i_en => en_reg,
        i_load => load_reg,
        i_dat_load => d_echantillonMemoireMouv,
        o_dat => out_reg_mouv
    );
    reg_16b_cardio : registre_16b
    port map (
        i_clk => clk_DAC,
        i_reset => '0',
        i_en => en_reg,
        i_load => load_reg,
        i_dat_load => d_echantillonMemoireCardio,
        o_dat => out_reg_cardio
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
    
        mem_forme_signal_mouv <= mem_forme_signal_sed when i_signal_select = "001" else
                           mem_forme_signal_mouv_low when i_signal_select = "010" else
                           mem_forme_signal_mouv_high;
                           
        mem_forme_signal_cardio <= mem_forme_signal_cardio_60 when i_signal_select = "001" else
                           mem_forme_signal_cardio_80 when i_signal_select = "010" else
                           mem_forme_signal_cardio_mort when i_signal_select = "100" else
                           mem_forme_signal_cardio_100;

        lireEchantillonMouv : process (i_reset, clk_DAC)
        begin
           if(i_reset = '1') then 
              d_compteur_echantillonMemoireMouv <= x"00";
              d_echantillonMemoireMouv <= x"0000";
           else
              if rising_edge(clk_DAC) then
                 if (i_strobe_collecte = '1') then
                     d_echantillonMemoireMouv <= "0000"&mem_forme_signal_mouv(to_integer(d_compteur_echantillonMemoireMouv));
                        if (d_compteur_echantillonMemoireMouv = mem_forme_signal_mouv'length-1) then
                            d_compteur_echantillonMemoireMouv <= x"00";
                        else
                            d_compteur_echantillonMemoireMouv <= d_compteur_echantillonMemoireMouv + 1;
                        end if;
                 end if;
             end if;
           end if;
        end process;    
        
        lireEchantillonCardio : process (i_reset, clk_DAC)
        begin
           if(i_reset = '1') then 
              d_compteur_echantillonMemoireCardio <= x"000";
              d_echantillonMemoireCardio <= x"0000";
           else
              if rising_edge(clk_DAC) then
                 if (i_strobe_collecte = '1') then
                     d_echantillonMemoireCardio <= "0000"&mem_forme_signal_cardio(to_integer(d_compteur_echantillonMemoireCardio));
                        if (d_compteur_echantillonMemoireCardio = mem_forme_signal_cardio'length-1) then
                            d_compteur_echantillonMemoireCardio <= x"000";
                        else
                            d_compteur_echantillonMemoireCardio <= d_compteur_echantillonMemoireCardio + 1;
                        end if;
                 end if;
             end if;
           end if;
        end process;   
        
        
   o_DAC_data0 <= out_reg_mouv;
   o_DAC_data1 <= out_reg_cardio;
   o_DAC_tsync <= dac_t_sync;

end Behavioral;
