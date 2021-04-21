----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 04:12:41 PM
-- Design Name: 
-- Module Name: pico_tb - Behavioral
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

entity pico_tb is
--  Port ( );
end pico_tb;

architecture Behavioral of pico_tb is

    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := 100); 
        Port ( 
               clkm         : in STD_LOGIC;      -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
               o_S_5MHz     : out  STD_LOGIC;    -- source horloge divisee   (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
               o_clk_5MHz   : out  STD_LOGIC;    -- horlgoe via bufg
               o_clk_1Hz    : out  STD_LOGIC;    -- horlgoe via bufg
               o_S_100Hz    : out  STD_LOGIC;    -- source horloge 100 Hz : out  STD_LOGIC;   -- (100  Hz approx:  99,952 Hz) 
               o_stb_100Hz  : out  STD_LOGIC;    -- strobe durée 1/clk_5mHz aligne sur front 100Hz
               o_stb_1Hz    : out STD_LOGIC;
               o_S_1Hz      : out  STD_LOGIC     -- Signal temoin 1 Hz
         );                    
    end component;
    
    component Pblaze_uCtrler is
      port (
        clk                     : in std_logic;
        i_ADC_echantillon       : in std_logic_vector (11 downto 0); 
        i_ADC_echantillon_pret  : in std_logic;
        i_reset                 : in std_logic;
        o_urgence               : out std_logic;
        o_cpt_val               : out std_logic_vector(7 downto 0)
      );
    end component;
    
    component compteur_nbits is
    generic (nbits : integer := 4);
       port ( clk             : in    std_logic; 
              i_en            : in    std_logic; 
              reset           : in    std_logic; 
              o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
              );
    end component;
    
    component mef_ctrl_pico is
        Port (
               i_clk                  : in STD_LOGIC;
               i_adc_pret_strobe      : in STD_LOGIC;
               i_cpt_val              : in STD_LOGIC_VECTOR(3 downto 0);
               i_reset                : in STD_LOGIC;
               ---------
               o_pico_pret_ech        : out STD_LOGIC;
               o_cpt_en               : out STD_LOGIC;
               o_cpt_rst              : out STD_LOGIC
               );
    end component;
    
    constant nbEchantillonMemoireCardio : integer := 500;
    type tableau_cardio is array (integer range 0 to nbEchantillonMemoireCardio - 1) of std_logic_vector(11 downto 0);
    constant mem_forme_signal_cardio_mort : tableau_cardio := (others => x"000");


     signal adc_clk : std_logic := '0';
     constant adc_clk_period : time := 200 ns;
     
     signal clk_100Hz : std_logic := '0';
     constant clk_100Hz_period : time := 10 ms;
     
     signal sim_sys_clock : std_logic := '0';
     constant sim_sys_clk_period : time := 20 ns;
     
     
     signal rentre_donnee : std_logic := '0';
     signal sim_reset : std_logic;
     signal i_dat : std_logic_vector(11 downto 0);
     signal index_data : unsigned(7 downto 0) := (others => '0');
     signal ADC_ncs : std_logic := '1';

     signal ech_pret_strobe : std_logic;
     signal o_ech : std_logic_vector(11 downto 0);
     
     
     -- Generation du strobe pour commencer a echantillonner
     signal adc_strobe : std_logic := '0';
     signal prev_pulse : std_logic := '0';
     signal curr_pulse : std_logic := '0';
     signal strobe_100Hz : std_logic := '0';
     
     signal s_clk_1Hz : std_logic := '0';
     signal s_stb_1Hz : std_logic := '0';
     
     signal s_urgence_cardiaque : std_logic;
     signal s_reset : std_logic := '0';
     signal s_pico_ech_pret : std_logic;
     signal s_cpt_val         : std_logic_vector(3 downto 0);
     signal s_cpt_en          : std_logic;
     signal s_cpt_rst         : std_logic;

begin

    -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;
       
       
    mef_pico : mef_ctrl_pico
    port map (
        i_clk                       => adc_clk,
        i_adc_pret_strobe           => adc_strobe,
        i_cpt_val                   => s_cpt_val,
        i_reset                     => s_reset,
        ---- ----
        o_pico_pret_ech             => s_pico_ech_pret,
        o_cpt_en                    => s_cpt_en,
        o_cpt_rst                   => s_cpt_rst
    );
    
    cpt_pico : compteur_nbits
    port map (
        clk             => adc_clk,
        i_en            => s_cpt_en,
        reset           => s_cpt_rst,
        o_val_cpt       => s_cpt_val
    );
    


    Picoblaze : Pblaze_uCtrler
    port map(
          clk                       => adc_clk,          
          i_ADC_echantillon         => i_dat,
          i_ADC_echantillon_pret    => s_pico_ech_pret,
          i_reset                   => s_reset, 
          o_urgence                 => s_urgence_cardiaque,
          o_cpt_val                 => open                   -- Ce port sert a visualiser le code assembleur sur le 8LD
    );
    
    syncro : Synchro_Horloges
    port map (
        clkm => sim_sys_clock,
        o_S_5MHz => open,
        o_clk_5MHz => adc_clk,
        o_clk_1Hz    => s_clk_1Hz,
        o_S_100Hz => open,
        o_stb_100Hz => adc_strobe,
        o_stb_1Hz => s_stb_1Hz,
        o_S_1Hz => open
   );
   
   
    sim_entree_adc : process (sim_reset, adc_clk)
    begin
       if(sim_reset = '1') then 
          index_data <= x"00";
          i_dat <= x"000";
       else
          if(adc_clk'event and adc_clk = '1') and adc_strobe = '1' then
             i_dat <= mem_forme_signal_cardio_mort(to_integer(index_data));
             if (index_data = mem_forme_signal_cardio_mort'length-1) then
               index_data <= x"00";
             else
               index_data <= index_data + 1;
             end if;
          end if;
       end if;
    end process;
    
    
      tb : PROCESS
         BEGIN
           
            WAIT; -- will wait forever
         END PROCESS;



end Behavioral;
