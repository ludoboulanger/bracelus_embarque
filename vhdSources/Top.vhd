----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 G�nie informatique - H21
-- Larissa Njejimana
-- v.3 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Top is
port (
    sys_clock       : in std_logic;
    o_leds          : out std_logic_vector ( 3 downto 0 );
    i_sw            : in std_logic_vector ( 3 downto 0 );
    i_btn           : in std_logic_vector ( 3 downto 0 );
    o_ledtemoin_b   : out std_logic;
    
    ---- DAC
    o_DAC_NCS : out std_logic;
    o_DAC_D0 : out std_logic;
    o_DAC_D1 : out std_logic;
    o_DAC_CLK : out std_logic;
    
    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JD
    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
    -- Pmod_AD1 - port_JC haut
    o_ADC_NCS       : out std_logic;  
    i_ADC_D0        : in std_logic;
    i_ADC_D1        : in std_logic;
    o_ADC_CLK       : out std_logic;
    
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC
);
end Top;

architecture Behavioral of Top is

    constant freq_sys_MHz: integer := 125;  -- MHz
    
    component design_1_wrapper is
    port (
            DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    Pmod_8LD_pin10_io : inout STD_LOGIC;
    Pmod_8LD_pin1_io : inout STD_LOGIC;
    Pmod_8LD_pin2_io : inout STD_LOGIC;
    Pmod_8LD_pin3_io : inout STD_LOGIC;
    Pmod_8LD_pin4_io : inout STD_LOGIC;
    Pmod_8LD_pin7_io : inout STD_LOGIC;
    Pmod_8LD_pin8_io : inout STD_LOGIC;
    Pmod_8LD_pin9_io : inout STD_LOGIC;
    Pmod_OLED_pin10_io : inout STD_LOGIC;
    Pmod_OLED_pin1_io : inout STD_LOGIC;
    Pmod_OLED_pin2_io : inout STD_LOGIC;
    Pmod_OLED_pin3_io : inout STD_LOGIC;
    Pmod_OLED_pin4_io : inout STD_LOGIC;
    Pmod_OLED_pin7_io : inout STD_LOGIC;
    Pmod_OLED_pin8_io : inout STD_LOGIC;
    Pmod_OLED_pin9_io : inout STD_LOGIC;
    i_adc_strobe : in STD_LOGIC;
    i_analyse_cardio : in STD_LOGIC_VECTOR ( 7 downto 0 );
    i_bclk : in STD_LOGIC;
    i_clk1Hz : in STD_LOGIC;
    i_data_mouvement : in STD_LOGIC_VECTOR ( 11 downto 0 );
    i_sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    i_urgence_0 : in STD_LOGIC;
    o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    o_mouv_analyse0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    o_mouv_analyse1 : out STD_LOGIC_VECTOR ( 31 downto 0 )
    );
    end component;
    
        component kcpsm6 is
          generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                          interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
                   scratch_pad_memory_size : integer := 64);
          port (                   address : out std_logic_vector(11 downto 0);
                               instruction : in std_logic_vector(17 downto 0);
                               bram_enable : out std_logic;
                                   in_port : in std_logic_vector(7 downto 0);
                                  out_port : out std_logic_vector(7 downto 0);
                                   port_id : out std_logic_vector(7 downto 0);
                              write_strobe : out std_logic;
                            k_write_strobe : out std_logic;
                               read_strobe : out std_logic;
                                 interrupt : in std_logic;
                             interrupt_ack : out std_logic;
                                     sleep : in std_logic;
                                     reset : in std_logic;
                                       clk : in std_logic);
      end component;
  
        component myProgram                             
        generic(             
                             C_FAMILY : string := "S6"; 
                    C_RAM_SIZE_KWORDS : integer := 1;
                 C_JTAG_LOADER_ENABLE : integer := 0);
        Port (      
                    address : in std_logic_vector(11 downto 0);
                instruction : out std_logic_vector(17 downto 0);
                     enable : in std_logic;
                        rdl : out std_logic;                    
                        clk : in std_logic);
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

    component Ctrl_AD1 is
    port ( 
        reset                       : in    std_logic;  
        
        clk_ADC                     : in    std_logic;                      -- Horloge fourni � l'ADC
        i_DO0                       : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC           
        i_DO1                       : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC           
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- synchronisation: d�clencheur de la s�quence d'�chantillonnage  
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une r�ception compl�te d'un �chantillon  
        o_echantillon_mouv          : out   std_logic_vector (11 downto 0); -- valeur de l'�chantillon re�u
        o_echantillon_cardio        : out   std_logic_vector (11 downto 0)  -- valeur de l'�chantillon re�u
    );
    end  component;
    
    component Ctrl_DAC is
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
    end component;
   
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entr�e  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_CLK_1Hz   : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz
        o_stb_1Hz   : out std_logic;
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component;

    component compteur_nbits is
    generic (nbits : integer := 10); -- 10 bits ici pour compter jusqua 600
       port ( clk             : in    std_logic; 
              i_en            : in    std_logic; 
              reset           : in    std_logic; 
              o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
              );
    end component; 
    
    component Analyse_cardio is
    Port ( i_echantillon : in std_logic_vector(11 downto 0);
           i_bclk : in STD_LOGIC;
           i_strobe : in STD_LOGIC;
           o_cpt : out std_logic_vector(7 downto 0));
    end component; 
    
    signal clk_5MHz                     : std_logic;
     signal clk_1Hz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    
    signal reset                        : std_logic; 
    
    signal o_echantillon_pret_strobe    : std_logic;
    signal d_echantillon_mouv           : std_logic_vector (11 downto 0);
    signal d_echantillon_cardio         : std_logic_vector (11 downto 0);
    
    
    -- COMPTEUR
     signal cpt_val : std_logic_vector(9 downto 0) := (others => '0'); -- Changer a 10 pour avoir 600 coup de clock entre les strobes
     signal cpt_en : std_logic := '0';
     signal cpt_reset : std_logic := '1';
     
     --ADC
     signal adc_strobe : std_logic := '0';
     signal ADC_ncs : std_logic := '1';
     
     signal q_adc_lire : std_logic := '0';
     signal q_prec_adc_lire : std_logic := '0';
     
     
     -- CLK
     signal source_clk_5MHz : std_logic := '0';
     signal strobe_1_Hz : std_logic := '0';
     
     -- DAC
     signal out_DAC_bit : std_logic;
     
     -- PICOBLAZE --
    signal         address : std_logic_vector(11 downto 0);
    signal     instruction : std_logic_vector(17 downto 0);
    signal     bram_enable : std_logic;
    signal         in_port : std_logic_vector(7 downto 0);
    signal        out_port : std_logic_vector(7 downto 0);
    signal         port_id : std_logic_vector(7 downto 0);
    signal    write_strobe : std_logic;
    signal  k_write_strobe : std_logic;
    signal     read_strobe : std_logic;
    signal       interrupt : std_logic;
    signal   interrupt_ack : std_logic;
    signal    kcpsm6_sleep : std_logic;
    signal    kcpsm6_reset : std_logic;
    
    signal q_leds          : std_logic_vector ( 3 downto 0 ) := (others => '1');
    signal q_Pmod_8LD      : std_logic_vector ( 7 downto 0 ) := (others => '1');
    signal s_urgence_cardiaque : std_logic;
    signal s_analyse_cardio : std_logic_vector(7 downto 0);
    
    signal s_cpt_pico_en : std_logic := '0';
    signal s_cpt_pico_rst : std_logic := '0';
    signal s_cpt_pico_val : std_logic_vector(3 downto 0);
    signal s_adc_ech_pret : std_logic := '0';
    
    
    
    
     

begin
    reset    <= i_btn(0);
    
    cpt_10_bits : compteur_nbits
    port map (
        clk => clk_5MHz,
        i_en => cpt_en,
        reset => cpt_reset,
        o_val_cpt => cpt_val
    );
    
    process (clk_5MHz, d_strobe_100Hz, cpt_val) -- OUBLI PAS DE CHANGER POUR 1Hz, 100Hz juste pour simule
    begin
        if rising_edge(clk_5MHz) then
            if cpt_val = "1001011000" then -- 1001011000
                cpt_en <= '0';
                cpt_reset <= '1';
                q_adc_lire <= '1';
            elsif d_strobe_100Hz = '1' then  -- OUBLI PAS DE CHANGER POUR 1Hz, 100Hz juste pour simule
                cpt_reset <= '0';
                cpt_en <= '1';
                q_adc_lire <= '0';
            end if;
        end if;
   end process;
            

    process (clk_5MHz, q_adc_lire) is
    begin
        if (rising_edge(clk_5MHz)) then
            q_prec_adc_lire <= q_adc_lire;
        end if;
    end process;
    
    process (q_prec_adc_lire, q_adc_lire) is
    begin
        adc_strobe <= q_adc_lire and not(q_prec_adc_lire);
    end process; 
        
     
    Controleur_ADC :  Ctrl_AD1 
    port map(
        reset                       => reset,
        
        clk_ADC                     => clk_5MHz,                    -- pour horloge externe de l'ADC 
        i_DO0                       => i_ADC_D0,               -- bit de donn�es provenant de l'ADC (via um mux)       
        i_DO1                       => i_ADC_D1,               -- bit de donn�es provenant de l'ADC (via um mux)       
        o_ADC_nCS                   => o_ADC_NCS,                   -- chip select pour le convertisseur (ADC )
        
        i_ADC_Strobe                => adc_strobe,              -- synchronisation: d�clencheur de la s�quence d'�chantillonnage 
        o_echantillon_pret_strobe   => o_echantillon_pret_strobe,   -- strobe indicateur d'une r�ception compl�te d'un �chantillon 
        o_echantillon_mouv          => d_echantillon_mouv,          -- valeur de l'�chantillon re�u (12 bits)
        o_echantillon_cardio        => d_echantillon_cardio         -- valeur de l'�chantillon re�u (12 bits)
    );
    
    Controleur_DAC : Ctrl_DAC
    port map (
        clk_DAC                     => clk_5MHz,
        i_reset                     => reset,
        i_strobe_collecte           => d_strobe_100Hz, -- Oubli pas de rechanger pour 1Hz
        i_signal_select             => i_sw(2 downto 0),
        o_DAC_tsync                 => o_DAC_NCS,
        o_DAC_data0                  => o_DAC_D0, -- out_DAC_bit
        o_DAC_data1                  => o_DAC_D1 -- out_DAC_bit
    );

      
   Synchronisation : Synchro_Horloges
    port map (
           clkm         =>  sys_clock,
           o_S_5MHz     =>  source_clk_5MHz,
           o_CLK_5MHz   => clk_5MHz,
           o_CLK_1Hz    => clk_1Hz,
           o_S_100Hz    => open,
           o_stb_100Hz  => d_strobe_100Hz,  -- OUBLI PAS DE CHANGER POUR 1Hz, 100Hz juste pour simule
           o_stb_1Hz    => strobe_1_Hz,
           o_S_1Hz      => o_ledtemoin_b
    );
    
    
    BlockDesign: design_1_wrapper 
    port map(
        DDR_addr=> DDR_addr,
        DDR_ba=> DDR_ba,
        DDR_cas_n=> DDR_cas_n,
        DDR_ck_n=> DDR_ck_n,
        DDR_ck_p=> DDR_ck_p,
        DDR_cke=> DDR_cke,
        DDR_cs_n=> DDR_cs_n,
        DDR_dm=> DDR_dm,
        DDR_dq=> DDR_dq,
        DDR_dqs_n=> DDR_dqs_n,
        DDR_dqs_p=> DDR_dqs_p,
        DDR_odt=> DDR_odt,
        DDR_ras_n=> DDR_ras_n,
        DDR_reset_n=> DDR_reset_n,
        DDR_we_n=> DDR_we_n,
        FIXED_IO_ddr_vrn=> FIXED_IO_ddr_vrn,
        FIXED_IO_ddr_vrp=> FIXED_IO_ddr_vrp,
        FIXED_IO_mio=>FIXED_IO_mio,
        FIXED_IO_ps_clk=> FIXED_IO_ps_clk,
        FIXED_IO_ps_porb=> FIXED_IO_ps_porb,
        FIXED_IO_ps_srstb=> FIXED_IO_ps_srstb,
        Pmod_8LD_pin1_io => Pmod_8LD(0),
        Pmod_8LD_pin2_io => Pmod_8LD(1),
        Pmod_8LD_pin3_io => Pmod_8LD(2),
        Pmod_8LD_pin4_io => Pmod_8LD(3),
        Pmod_8LD_pin7_io => Pmod_8LD(4),
        Pmod_8LD_pin8_io => Pmod_8LD(5),
        Pmod_8LD_pin9_io => Pmod_8LD(6),
        Pmod_8LD_pin10_io  => Pmod_8LD(7),
        Pmod_OLED_pin1_io => Pmod_OLED(0),
        Pmod_OLED_pin2_io => Pmod_OLED(1),
        Pmod_OLED_pin3_io => Pmod_OLED(2),
        Pmod_OLED_pin4_io => Pmod_OLED(3),
        Pmod_OLED_pin7_io => Pmod_OLED(4),
        Pmod_OLED_pin8_io => Pmod_OLED(5),
        Pmod_OLED_pin9_io => Pmod_OLED(6),
        Pmod_OLED_pin10_io => Pmod_OLED(7),
        i_bclk => clk_5MHz,
        i_clk1Hz => clk_1Hz,
        i_adc_strobe=> adc_strobe,
        i_data_mouvement=> d_echantillon_mouv,
        i_analyse_cardio   => s_analyse_cardio,
        i_urgence_0 => s_urgence_cardiaque,
        i_sw_tri_i=> i_sw,
        o_leds_tri_o=> open
    );
    
    inst_analy_cardio: Analyse_cardio
    port map(
    i_echantillon => d_echantillon_cardio,
    i_bclk => clk_5MHz,
    i_strobe => adc_strobe,
    o_cpt => s_analyse_cardio
    );

    o_DAC_CLK <= source_clk_5MHz;
    o_ADC_CLK <= source_clk_5MHz;

      -- POUR LE PICOBLAZE --
      
    mef_pico : mef_ctrl_pico
    port map (
        i_clk                       => clk_5MHz,
        i_adc_pret_strobe           => adc_strobe,
        i_cpt_val                   => s_cpt_pico_val,
        i_reset                     => reset,
        ---- ----
        o_pico_pret_ech             => s_adc_ech_pret,
        o_cpt_en                    => s_cpt_pico_en,
        o_cpt_rst                   => s_cpt_pico_rst
    );
    
    cpt_pico : compteur_nbits
    generic map (
        nbits => 4
    )
    port map (
        clk             => clk_5MHz,
        i_en            => s_cpt_pico_en,
        reset           => s_cpt_pico_rst,
        o_val_cpt       => s_cpt_pico_val
    );

    Picoblaze : Pblaze_uCtrler
    port map(
          clk                       =>  clk_5MHz,          
          i_ADC_echantillon         => d_echantillon_cardio,
          i_ADC_echantillon_pret    => s_adc_ech_pret,
          i_reset                   => reset, 
          o_urgence                 => s_urgence_cardiaque,
          o_cpt_val                 => open                     -- Ce port sert a visualiser le code assembleur sur le 8LD
    );
    
    o_leds <= "1111" when s_urgence_cardiaque = '1' else "0000";
    
end Behavioral;

