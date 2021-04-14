----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2021 02:53:42 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

component Ctrl_AD1 is
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
    i_DO0                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC         
    i_DO1                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC         
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
    o_echantillon_mouv          : out   std_logic_vector (11 downto 0); -- valeur de l'échantillon reçu
    o_echantillon_cardio        : out   std_logic_vector (11 downto 0)-- valeur de l'échantillon reçu
);
end component;

    component Ctrl_DAC is
        Port (
            clk_DAC : in std_logic;
            i_reset : in std_logic;
            i_strobe_collecte : in std_logic;
            ----
            o_DAC_tsync : out std_logic;
            o_DAC_data : out std_logic
         );
    end component;
    
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := 100); 
        Port ( 
               clkm         : in STD_LOGIC;      -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
               o_S_5MHz     : out  STD_LOGIC;    -- source horloge divisee   (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
               o_clk_5MHz   : out  STD_LOGIC;    -- horlgoe via bufg
               o_S_100Hz    : out  STD_LOGIC;    -- source horloge 100 Hz : out  STD_LOGIC;   -- (100  Hz approx:  99,952 Hz) 
               o_stb_100Hz  : out  STD_LOGIC;    -- strobe durée 1/clk_5mHz aligne sur front 100Hz
               o_S_1Hz      : out  STD_LOGIC     -- Signal temoin 1 Hz
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

     signal sim_reset : std_logic := '0';
     
     -- COMPTEUR
     signal cpt_val : std_logic_vector(3 downto 0) := (others => '0');
     signal cpt_en : std_logic := '0';
     signal cpt_reset : std_logic := '1';

     -- CLOCKS
     signal adc_clk : std_logic := '0';
     constant adc_clk_period : time := 200 ns;
     
     signal sim_sys_clock : std_logic := '0';
     constant sim_sys_clk_period : time := 20 ns;
     
     signal strobe_1Hz : std_logic := '0';
     signal strobe_100Hz : std_logic := '0';
     
     --ADC
     signal sim_adc_strobe : std_logic := '0';
     signal rentre_donnee : std_logic := '0';
     signal i_dat_ADC : std_logic;
     signal index_data : unsigned(7 downto 0) := (others => '0');
     signal ADC_ncs : std_logic := '1';

     signal ech_pret_strobe : std_logic;
     signal o_ech : std_logic_vector(11 downto 0);
     
     signal q_adc_lire : std_logic := '0';
     signal q_prec_adc_lire : std_logic := '0';
     
     
     --DAC
     signal reset : std_logic := '0';
     signal sim_tsync : std_logic := '1';
     signal dac_bit : std_logic := '0';
     
    

begin

    -- Compteur pour le delai
    compteur_delai : compteur_nbits
    port map (
        clk => adc_clk,
        i_en => cpt_en,
        reset => cpt_reset,
        o_val_cpt => cpt_val
    );

    -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;
    
    controleur_ADC : Ctrl_AD1
    port map (
        reset => sim_reset,
        clk_ADC => adc_clk,
        i_DO1 => i_dat_ADC,     
        i_DO2 => i_dat_ADC,     
        o_ADC_nCS => ADC_ncs,
        i_ADC_Strobe => sim_adc_strobe, -- A changer si on veut que ca fonctionne fr
        o_echantillon_pret_strobe => ech_pret_strobe,
        o_echantillon => o_ech
    );
   
   controleur_DAC : Ctrl_DAC 
        port map (
            clk_DAC => adc_clk,
            i_reset => sim_reset,
            i_strobe_collecte => strobe_100Hz,
            ----
            o_DAC_tsync => sim_tsync,
            o_DAC_data => dac_bit
        );
        
    syncro : Synchro_Horloges
        port map (
            clkm => sim_sys_clock,
            o_S_5MHz => open,
            o_clk_5MHz => adc_clk,
            o_S_100Hz => open,
            o_stb_100Hz => strobe_100Hz,
            o_S_1Hz => open
       );
       
     process (adc_clk)
     begin
        if (falling_edge(adc_clk)) then -- Change Donnees au falling edge pour mimiquer le vrai comportement
            i_dat_ADC <= dac_bit;
        end if;
     end process;
        
   process (adc_clk, strobe_100Hz, cpt_val)
   begin
        if cpt_val = "0001" then
            cpt_en <= '0';
            cpt_reset <= '1';
            q_adc_lire <= '1';
        elsif strobe_100Hz = '1' then
            cpt_reset <= '0';
            cpt_en <= '1';
            q_adc_lire <= '0';
        end if;
   end process;
            

    process (adc_clk, q_adc_lire) is
    begin
        if (rising_edge(adc_clk)) then
            q_prec_adc_lire <= q_adc_lire;
        end if;
    end process;
    
    process (q_prec_adc_lire, q_adc_lire) is
    begin
        sim_adc_strobe <= q_adc_lire and not(q_prec_adc_lire);
    end process;   
end Behavioral;
