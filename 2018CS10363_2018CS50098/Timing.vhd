LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

entity Assignment10 is


port( C : in std_logic;
		rx_in : in std_logic;
		LED : out std_logic_vector(15 downto 0);
		--reset : in std_logic;
		tx_out : out std_logic;
		PB0 : in std_logic;
		PB1 : in std_logic); 


end Assignment10;

architecture Behavioral of Assignment10 is

signal rx_full:std_logic;
signal tx_empty:std_logic;
signal wen:std_logic;
signal clk:std_logic :='1';	
signal ld_tx:std_logic;
signal rd_addr:STD_LOGIC_VECTOR(7 DOWNTO 0);
signal wr_addr:STD_LOGIC_VECTOR(7 DOWNTO 0);
signal tx:std_logic_vector(7 downto 0);
signal count_16_1: integer range 0 to 16;
signal count_16_2: integer range 0 to 16;
signal reset:std_logic;

--signal count_10: integer range 0 to 10;

--signal count16 : integer range 0 to 15;
signal rx_reg : std_logic_vector(7 downto 0);

signal tx_start : std_logic;
signal m : integer range 0 to 651;
  
TYPE State_type IS (idle,start,stop); 
SIGNAL state : State_Type;  
type timing_state_type is(t0,t1,t2,t3,t4,t5,t6,t7);
signal state_timing : timing_state_type;

 --- count is the variable counting 8 cosecutive 0
 --- count16 is the variable counting 16 cycles of rx_clk
 --- tmp is the variable counting number of input bits taken
 
 begin 
 memory1 : entity work.memory(Behavioral)
         port map(clk,wen,wr_addr,rx_reg,clk,ld_tx,rd_addr,tx);
 transmitter1 : entity work.transmitter(Behavioral)
        port map(clk,tx_empty,ld_tx,reset,tx_out,tx);
receiver1 : entity work.receiver(Behavioral)
        port map(clk,rx_in,rx_reg,reset,rx_full);  

--doutb1 <= tx(7 downto 0);
 process(C)
    begin
    if(C'event and C='1') then
           m <= m + 1;
              if(m=651) then
              m <=0;
              end if;
				  if(m<326) then
				  clk <= '1';
				  else
				  clk <='0';
				  end if;
    end if;
    end process;

process(clk)
begin
if (clk'event and clk='1') then
count_16_2<=count_16_2+1;
    if(count_16_2=15) then 
    count_16_2<=0;
		tx_start <= PB1;
		reset<=PB0;
		end if;
		end if;
end process;



process(clk,reset)
begin
if (reset='1') then
	state_timing <= t0;
	wr_addr<="00000000";
	else
	if (clk'event and clk='1') then
	count_16_1<=count_16_1+1;
    if(count_16_1=15) then 
    count_16_1<=0;
	
		case state_timing is
			when t0 =>
			state_timing <= t1;
			wen<='0';
			when t1 => 
			
			if( tx_start='1') then
			state_timing <= t2;
			rd_addr<="00000000";
			else
				if(rx_full='0') then
				state_timing <= t3;
				
				end if;
			end if;
			
			when t2 =>
			state_timing <=t5;
			ld_tx <= '1';
            rd_addr <= rd_addr+1;
			
			
			when t3 =>
			if(rx_full='1') then
			state_timing <= t4;
			wr_addr <= wr_addr+1;
            wen <='1';
			
			end if;
				
			when t4 =>
			wen <='0';
			state_timing <= t1;
			
			when t5 =>
			
			state_timing <= t6;
			ld_tx <= '0';
			
			when t6 =>
			
			if(tx_empty='1') then
				if(unsigned(rd_addr)=unsigned(wr_addr)) then
				state_timing <= t7;
				
				else
				state_timing <= t5;
				ld_tx <= '1';
                rd_addr <= rd_addr+1;
				
				--ld_tx <= '1';
				end if;
			
			end if;
			
			when t7 =>
			if(tx_start='0') then
			state_timing <= t1;
			wen<='0';
			end if;
			
		end case;
		end if;
		end if;
	end if;
		
end process;
	

LED <= rx_reg(7 downto 0)&tx(7 downto 0);


end Behavioral;

