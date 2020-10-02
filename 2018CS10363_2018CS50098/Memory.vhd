----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:38 10/17/2019 
-- Design Name: 
-- Module Name:    memory - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC; --wen from timing circuit
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --Written to memory at addra
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC; --Should be ld_tx by logical deduction
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) --Returned on reading file
  );
end memory;

architecture Behavioral of memory is

	type Memory_type is array (0 to 255) of std_logic_vector (7 downto 0);
	signal Memory_array : Memory_type;
	signal address : unsigned (7 downto 0);
begin
	process (clkb)
	begin
    if rising_edge(clkb) then    
        if (enb = '1') then
            address <= unsigned(addrb);    
        end if;
    end if;
    end process;
	doutb <= Memory_array (to_integer(address));
	process (clka)
	begin
		if rising_edge(clka) then	
			if (wea = '1') then
				Memory_array (to_integer(unsigned(addra))) <= dina (7 downto 0);	
			end if;
		end if;
	end process;
end Behavioral;
