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


constant nbEchantillonMemoireCardio : integer := 24;
--constant nbEchantillonMemoire : integer := 201;
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
constant mem_forme_signal_cardio : tableau_cardio := (others => x"000");
    constant c_NbIteration : unsigned(3 downto 0) := "1000";

    signal d_compteur_echantillonMemoireMouv : unsigned(7 downto 0) := (others => '0');
    signal d_compteur_echantillonMemoireCardio : unsigned(7 downto 0) := (others => '0');
    signal d_echantillonMemoireMouv : std_logic_vector(15 downto 0) := (others => '0');
    signal d_echantillonMemoireCardio : std_logic_vector(15 downto 0) := (others => '0');
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
    signal out_reg_mouv : std_logic := '0';
    signal out_reg_cardio : std_logic := '0';
    
    signal mem_forme_signal_mouv : tableau_mouv := mem_forme_signal_mouv_high;

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

        lireEchantillonMouv : process (i_reset, clk_DAC)
        begin
           if(i_reset = '1') then 
              d_compteur_echantillonMemoireMouv <= x"00";
              d_echantillonMemoireMouv <= x"0000";
              q_iteration <= (others => '0');
           else
              if rising_edge(clk_DAC) then
                 if (i_strobe_collecte = '1') then
                     d_echantillonMemoireMouv <= "0000"&mem_forme_signal_mouv(to_integer(d_compteur_echantillonMemoireMouv));
                     q_collecte <= '1';
                        if (d_compteur_echantillonMemoireMouv = mem_forme_signal_mouv'length-1) then
                            d_compteur_echantillonMemoireMouv <= x"00";
                            q_iteration <= q_iteration + 1;
                        else
                            d_compteur_echantillonMemoireMouv <= d_compteur_echantillonMemoireMouv + 1;
                        end if;
                 else
                    q_collecte <= '0';
                 end if;
             end if;
           end if;
        end process;    
        
        lireEchantillonCardio : process (i_reset, clk_DAC)
        begin
           if(i_reset = '1') then 
              d_compteur_echantillonMemoireCardio <= x"00";
              d_echantillonMemoireCardio <= x"0000";
              q_iteration <= (others => '0');
           else
              if rising_edge(clk_DAC) then
                 if (i_strobe_collecte = '1') then
                     d_echantillonMemoireCardio <= "0000"&mem_forme_signal_cardio(to_integer(d_compteur_echantillonMemoireCardio));
                     q_collecte <= '1';
                        if (d_compteur_echantillonMemoireCardio = mem_forme_signal_cardio'length-1) then
                            d_compteur_echantillonMemoireCardio <= x"00";
                            q_iteration <= q_iteration + 1;
                        else
                            d_compteur_echantillonMemoireCardio <= d_compteur_echantillonMemoireCardio + 1;
                        end if;
                 else
                    q_collecte <= '0';
                 end if;
             end if;
           end if;
        end process;   
        
        
   o_DAC_data0 <= out_reg_mouv;
   o_DAC_data1 <= out_reg_cardio;
   o_DAC_tsync <= dac_t_sync;

end Behavioral;
