LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


ENTITY UART_RX IS
   PORT ( 
          CLK_50MHZ	:	IN	STD_LOGIC; 
			 RX : IN STD_LOGIC;
			 BUFF_REG_RX : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 RX_COMPLETE : OUT STD_LOGIC;
			 TEST_RX : OUT STD_LOGIC
          );

end UART_RX;

ARCHITECTURE SCHEMATIC OF UART_RX IS
	
	SIGNAL RX_SIGNAL : std_logic;
	SIGNAL RX_Z1 : std_logic;
	SIGNAL RX_Z2 : std_logic;
	SIGNAL RX_Z3 : std_logic;
	SIGNAL RX_START : std_logic;
	SIGNAL RX_EN : std_logic;
	SIGNAL CNT_RX_SR : std_logic_vector(13 DOWNTO 0);
	SIGNAL CNT_RX_BIT : std_logic_vector(3 DOWNTO 0);
	SIGNAL SHIFT_REG_RX : std_logic_vector(9 DOWNTO 0);
	SIGNAL RX_CHECK : std_logic;
	
BEGIN

TEST_RX <= RX_EN;

imp_RX_SIGNAL : process (CLK_50MHZ) is
begin  -- process RX signal sync
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		RX_SIGNAL <= RX;
	end if;
end process;

	imp_RX_START : process (CLK_50MHZ) is
begin  -- process receive start
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		RX_Z1 <= RX_SIGNAL;
		RX_Z2 <= RX_Z1;
		RX_Z3 <= RX_Z2;
		RX_START <= not RX_SIGNAL and RX_Z1 and not RX_EN;
	end if;
end process;

	imp_RX_CHECK : process (CLK_50MHZ) is
begin  -- process RX check
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if RX_START = '1' then 
				RX_CHECK <= '1';
		elsif CNT_RX_SR(13) = '1' then
				RX_CHECK <= '0';
		end if;
	end if;
end process;

	imp_CNT_RX_SR : process (CLK_50MHZ) is
begin  -- process counter of RX middle
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if  RX_EN = '0' then 
			CNT_RX_SR <= CONV_STD_LOGIC_VECTOR(2604, 14);
		else
			if CNT_RX_SR(13) = '1' then
				CNT_RX_SR <= CONV_STD_LOGIC_VECTOR(5208, 14);
			else
				CNT_RX_SR <= CNT_RX_SR - 1;
			end if;	
		end if;
	end if;
end process;

	imp_CNT_RX_BIT : process (CLK_50MHZ) is
begin  -- process counter of RX bits passed
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if RX_EN = '0' then
			CNT_RX_BIT <= CONV_STD_LOGIC_VECTOR(0, 4);
		elsif RX_EN = '1' then
			if CNT_RX_BIT = CONV_STD_LOGIC_VECTOR(10, 4) then
				CNT_RX_BIT <= CONV_STD_LOGIC_VECTOR(0, 4);
			elsif CNT_RX_SR(13) = '1' then
				CNT_RX_BIT <= CNT_RX_BIT + 1;
			end if;
		end if;
	end if;
end process;

imp_RX_COMPLETE : process (CLK_50MHZ) is
begin  -- process RX complete
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if CNT_RX_BIT = CONV_STD_LOGIC_VECTOR(10, 4) then
			RX_COMPLETE <= '1';
		else
			RX_COMPLETE <= '0';
		end if;
	end if;
end process;

	imp_RX_EN : process (CLK_50MHZ) is
begin  -- process RX enable
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if RX_START = '1' then 
				RX_EN <= '1';
		elsif ((RX_Z1 = '1' or RX_Z2 = '1' or RX_Z3 = '1') and RX_CHECK = '1' and CNT_RX_SR(13) = '1') or CNT_RX_BIT = CONV_STD_LOGIC_VECTOR(10, 4) then
				RX_EN <= '0';
		end if;
	end if;
end process;

	imp_SHIFT_REG_RX : process (CLK_50MHZ) is
begin  -- process shift register of RX
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if CNT_RX_SR(13) = '1' then
			SHIFT_REG_RX(9 downto 0) <= ((RX_Z1 and RX_Z2) or (RX_Z2 and RX_Z3) or (RX_Z1 and RX_Z3)) & SHIFT_REG_RX(9 downto 1);
		end if;
	end if;
end process;

imp_PRH_DAT : process (CLK_50MHZ) is
begin  -- process write in PRH_DAT RX signal
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if CNT_RX_BIT = CONV_STD_LOGIC_VECTOR(10, 4) then
				BUFF_REG_RX(7 downto 0) <= SHIFT_REG_RX(8 downto 1);
		end if;
	end if;
end process;
	
END SCHEMATIC;