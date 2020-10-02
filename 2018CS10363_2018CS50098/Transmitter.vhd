LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;


entity transmitter is
--  Port ( );

port( C : in std_logic;
		tx_empty: out std_logic;
		tx_start:in std_logic;
		reset : in std_logic;
		tx_out : out std_logic ;
		tx:in std_logic_vector(7 downto 0)
		); 

end transmitter;

architecture Behavioral of transmitter is

type txstate_type is(idle,start,s0,s1,s2,s3,s4,s5,s6,s7);
signal state_tx : txstate_type;
signal count_16: integer range 0 to 16;

begin


process(C)
begin
if (C'event and C='1') then

count_16<=count_16+1;
if(count_16=15) then 
count_16<=0;
case state_tx is
          when idle =>
          if(tx_start='1') then
            state_tx <= start;
				tx_empty <='0';
				tx_out <= '0';
          else
            state_tx <= idle;
				tx_out <= '1';
          end if;
          when start =>
			 tx_out <= tx(7);
          state_tx <= s0;
          when s0 =>
          state_tx <= s1;
	  tx_out <= tx(6);
          when s1 =>
          state_tx <= s2;
	  tx_out <= tx(5);
          when s2 =>
          state_tx <= s3;
	  tx_out <= tx(4);
          when s3 =>
          state_tx <= s4;
	  tx_out <= tx(3);
          when s4 =>
          state_tx <= s5;
	  tx_out <= tx(2);
          when s5 =>
          state_tx <= s6;
	  tx_out <= tx(1);
          when s6 =>
          state_tx <= s7;
	  tx_out <= tx(0);
          when s7 =>
          state_tx <= idle;
			 tx_empty <='1';
	  tx_out <= '1';
        end case;
        end if;
end if;

    end process;
------ transmitter ----

end Behavioral;
