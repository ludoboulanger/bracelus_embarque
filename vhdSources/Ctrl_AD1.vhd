--------------------------------------------------------------------------------
-- Controle du module pmod AD1
-- Ctrl_AD1.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity Ctrl_AD1 is
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge � fournir � l'ADC
    i_DO0                        : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC         
    i_DO1                        : in    std_logic;                      -- Bit de donn�e en provenance de l'ADC         
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe d�clencheur de la s�quence de r�ception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une r�ception compl�te d'un �chantillon  
    o_echantillon_mouv          : out   std_logic_vector (11 downto 0); -- valeur de l'�chantillon re�u
    o_echantillon_cardio        : out   std_logic_vector (11 downto 0)  -- valeur de l'�chantillon re�u
);
end Ctrl_AD1;

architecture Behavioral of Ctrl_AD1 is
  
    component AD7476_mef
    port ( 
        clk_ADC                 : in    std_logic; 
        reset                   : in    std_logic; 
        i_ADC_Strobe            : in    std_logic;  --  cadence echantillonnage AD1
        i_bit0                  : in std_logic;
        i_bit1                  : in std_logic;
        i_val_cpt               : in    std_logic_vector(3 downto 0);
        o_ADC_nCS               : out   std_logic;  -- Signal Chip select vers l'ADC  
        o_Decale                : out   std_logic;  -- Signal de d�calage
        o_FinSequence_Strobe    : out   std_logic;   -- Strobe de fin de s�quence d'�chantillonnage
        o_cpt_rst               : out   std_logic 
    );
    end component;
    
    component compteur_nbits
    generic (nbits : integer := 4);
    port ( 
        clk             : in    std_logic; 
        i_en            : in    std_logic; 
        reset           : in    std_logic; 
        o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
    );
    end component;
    
    
    component reg_dec_12b is
    Port ( 
        i_clk : in STD_LOGIC;
        i_reset : in STD_LOGIC;
        i_en : in STD_LOGIC; -- decal
        i_dat_bit : in STD_LOGIC; --entree serie
        o_dat : out STD_LOGIC_VECTOR(11 downto 0)
    );
    end component;  
    
    
    signal en_cpt : std_logic;
    signal cpt_rst : std_logic;
    signal cpt_val : std_logic_vector(3 downto 0);
    signal decal : std_logic;
    signal done_strobe : std_logic;
    signal ncs : std_logic;
    
    signal en_decal : std_logic;
    signal out_data_mouv : std_logic_vector(11 downto 0);
    signal out_data_cardio : std_logic_vector(11 downto 0);
    signal internal_data_mouv : std_logic_vector(11 downto 0);
    signal internal_data_cardio : std_logic_vector(11 downto 0);

  
    
begin


--  Machine a etats finis pour le controle du AD7476
    MEF : AD7476_mef
    port map (
        clk_ADC                 => clk_ADC,
        reset                   => reset,
        i_ADC_Strobe            => i_ADC_Strobe,
        i_val_cpt               => cpt_val,
        i_bit0                  => i_DO0,
        i_bit1                  => i_DO1,
        o_ADC_nCS               => ncs,
        o_Decale                => en_decal,
        o_FinSequence_Strobe    => done_strobe,
        o_cpt_rst               => cpt_rst
    );
    
    compteur : compteur_nbits
    port map (
        clk                     => clk_ADC,
        i_en                    => '1',
        reset                   => cpt_rst,
        o_val_cpt               => cpt_val
    );
    
    registre_12bits_mouv  : reg_dec_12b
    port map (
        i_clk => clk_ADC,
        i_reset => '0',
        i_en => en_decal,
        i_dat_bit => i_DO0, --entree serie
        o_dat => out_data_mouv
    );
    
    registre_12bits_cardio : reg_dec_12b
    port map (
        i_clk => clk_ADC,
        i_reset => '0',
        i_en => en_decal,
        i_dat_bit => i_DO1, --entree serie
        o_dat => out_data_cardio
    );
        
  

  done_strobe_process : process(clk_ADC)
  begin
       if rising_edge(clk_ADC) then
          if(done_strobe = '1') then 
              internal_data_mouv <= out_data_mouv;
              internal_data_cardio <= out_data_cardio;
          else
              internal_data_mouv <= internal_data_mouv;
              internal_data_cardio <= internal_data_cardio;
          end if;
       end if;
  end process;

  o_echantillon_mouv <= out_data_mouv when done_strobe = '1' else
                        internal_data_mouv;
  o_echantillon_cardio <= out_data_cardio when done_strobe = '1' else
                        internal_data_cardio;
                        
  -- o_echantillon_mouv <= internal_data_mouv;
  -- o_echantillon_cardio <= internal_data_cardio;
  o_echantillon_pret_strobe <= done_strobe;
  o_ADC_nCS <= ncs;

end Behavioral;
