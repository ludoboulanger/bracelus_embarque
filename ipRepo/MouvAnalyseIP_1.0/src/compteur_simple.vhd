--------------------------------------------------------------------------------
-- compteur_simple.vhd
-- D. Dalle 13 décembre 2018, révision 26 décembre 2018 
-- version avec équations de transitions booléenes explicitement codées
-- dans cette version, le reset est synchrone
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity compteur_simple is
   port ( 
          clk             : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (3 downto 0)
          );
end compteur_simple;

architecture BEHAVIORAL of compteur_simple is               
-- compteur binaire 4 bits simple avec reset synchrone

 signal  NQ, Q: std_logic_vector (3 downto 0);
  
 BEGIN
 
-- equations de transition du compteur (prochain etat)
 transition_proc : process ( Q, reset)
    begin   
        NQ(0) <= (not reset) and (not Q(0)) ; 
        NQ(1) <= (not reset) and (Q(1) xor   Q(0));
        NQ(2) <= (not reset) and (Q(2) xor ( Q(0) and Q(1))); 
        NQ(3) <= (not reset) and (Q(3) xor ( Q(0) and Q(1) and Q(2)) );                                             
    end process;

-- prochain etat du compteur
compteur_proc : process (clk)
   begin
        if (rising_edge(clk)) then
           Q(0) <= NQ(0); 
           Q(1) <= NQ(1);
           Q(2) <= NQ(2); 
           Q(3) <= NQ(3);                               
       end if;
   end process;
        
-- sortie
  o_val_cpt <= Q;
  
 END Behavioral;
  