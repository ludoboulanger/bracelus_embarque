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

entity Ctrl_AD1_tb is
--  Port ( );
end Ctrl_AD1_tb;

architecture Behavioral of Ctrl_AD1_tb is

component Ctrl_AD1 is
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
    i_DO                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC         
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
    o_echantillon               : out   std_logic_vector (11 downto 0)  -- valeur de l'échantillon reçu
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
           o_stb_1Hz    : out STD_LOGIC;
           o_S_1Hz      : out  STD_LOGIC     -- Signal temoin 1 Hz
     );                    
end component;

type in_array is array (integer range 0 to 31) of std_logic;
constant in_data_no_error : in_array := (
'0',
'0',
'0',
'0',
'0', -- Cycle 1
'1',
'0',
'1',
'0',
'1',
'0',
'1',
'0',
'1',
'0',
'1',
'0',
'0',
'0',
'0',
'0',
'1', -- Cycle 2
'1',
'1',
'1',
'1',
'1',
'1',
'1',
'1',
'1',
'1'
);

     signal adc_clk : std_logic := '0';
     constant adc_clk_period : time := 200 ns;
     
     signal clk_100Hz : std_logic := '0';
     constant clk_100Hz_period : time := 10 ms;
     
     signal sim_sys_clock : std_logic := '0';
     constant sim_sys_clk_period : time := 20 ns;
     
     
     signal rentre_donnee : std_logic := '0';
     signal sim_reset : std_logic;
     signal i_dat : std_logic;
     signal index_data : unsigned(7 downto 0) := (others => '0');
     signal ADC_ncs : std_logic := '1';

     signal ech_pret_strobe : std_logic;
     signal o_ech : std_logic_vector(11 downto 0);
     
     
     -- Generation du strobe pour commencer a echantillonner
     signal adc_strobe : std_logic := '0';
     signal prev_pulse : std_logic := '0';
     signal curr_pulse : std_logic := '0';
     signal strobe_100Hz : std_logic := '0';
     

begin
    
    -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;
    
    controleur : Ctrl_AD1
    port map (
        reset => sim_reset,
        clk_ADC => adc_clk,
        i_DO => i_dat,     
        o_ADC_nCS => ADC_ncs,
        i_ADC_Strobe => adc_strobe,
        o_echantillon_pret_strobe => ech_pret_strobe,
        o_echantillon => o_ech
    );
    
    syncro : Synchro_Horloges
    port map (
        clkm => sim_sys_clock,
        o_S_5MHz => open,
        o_clk_5MHz => adc_clk,
        o_S_100Hz => open,
        o_stb_100Hz => adc_strobe,
        o_S_1Hz => open
   );
        


    sim_entree_adc : process (sim_reset, adc_clk)
    begin
       if(sim_reset = '1') then 
          index_data <= x"00";
          i_dat <= '0';
       else
          if(adc_clk'event and adc_clk = '0') and ADC_ncs = '0' then
             i_dat <= in_data_no_error(to_integer(index_data));
             if (index_data = in_data_no_error'length-1) then
               index_data <= x"00";
             else
               rentre_donnee <= '0';
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