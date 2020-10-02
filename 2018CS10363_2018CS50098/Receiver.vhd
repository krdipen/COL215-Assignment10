LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

entity receiver is
	port(C : in std_logic;
		  rx_in : in std_logic;
		  rx_out : out std_logic_vector(7 downto 0);
		  reset : in std_logic;
		  rx_full : out std_logic
		 );
end receiver;


--idle refers to an ideal state where it is waiting for start bit
--start refers to the state where the receiver thinks it has received start bit and is waiting for 8 continuous 0 to determine whether the given signal is really start_bit or noise.
--si refers to the state when the receiver is reading bits given by the transmitter

architecture Behavioral of receiver is
	signal count16 : integer := 0;
	signal i : integer := 0;
	signal count: integer range 0 to 7;
	signal tmp: integer range 0 to 7;
	signal rx_reg :std_logic_vector(7 downto 0);
--	signal old_bit : std_logic := '1';
	--signal rx_reg : std_logic_vector(7 downto 0) := "00000000";
	type state_type is (idle,start,stop);
	signal state : state_type;
begin
rx_out <= rx_reg(7 downto 0);
	process (C)
	begin
	if (C'event and C='1') then
	if (reset='1') then
	state <= idle;
	count <=0;
	count16<=0;
	tmp<=0;
	
	else
	
		
	
	case state is
		when idle =>
		
			if(rx_in='0') then
				if( count = 7) then
					rx_full <= '0';
					state <= start;
					count16<=0;
					count <= 0;
				else
				    count <= count+1;
				end if;
			else
			count <=0;
			end if;
		when start =>
			if(tmp=1) then
			--tx_start<='0';
			end if;
			if( count16 = 15) then 
			tmp <= tmp +1;
			count16 <= 0;
			rx_reg <= rx_reg(6 downto 0)&rx_in;
				if(tmp=7) then
				    
				   --tx <= "0"&rx_reg(6 downto 0)&rx_in&"1";
					state <= stop;
					count16 <= 0;
					count <= 0;
				end if;
			else
			count16 <= count16 +1;
			end if;
		when stop => 
		    
			count16 <= count16+1;
			if( count16 = 15) then
			--tx_start<='1';
			 state <= idle;
			 rx_full <= '1';
			 count <= 0;
			 
			end if;
	
	end case;
	
	end if;
	end if;
   end process;


end Behavioral;
