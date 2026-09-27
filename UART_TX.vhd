LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


ENTITY UART_TX IS
   PORT ( 
			CNT_TX_BIT_OUT : OUT STD_LOGIC;
			BUFF_EMPTY_OUT : OUT STD_LOGIC;
			TX_EN_OUT : OUT STD_LOGIC;
			CLK_50MHZ	:	IN	STD_LOGIC; 
			TX_DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			BUFF_REG_TX_LOAD : IN STD_LOGIC;
			TX_SIGNAL : OUT STD_LOGIC
          );

end UART_TX;

ARCHITECTURE SCHEMATIC OF UART_TX IS
	SIGNAL TX_EN : std_logic;
	SIGNAL TX_EN_Z : std_logic;
	SIGNAL BUFF_EMPTY : std_logic := '1';
	SIGNAL BUFF_REG_TX : std_logic_vector(7 DOWNTO 0);
	SIGNAL SHIFT_REG_TX : std_logic_vector(8 DOWNTO 0);
	SIGNAL CNT_TX_104us : std_logic_vector(13 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(5208, 14);
	SIGNAL CNT_TX_BIT : std_logic_vector(3 DOWNTO 0);
	
BEGIN

CNT_TX_BIT_OUT <= CNT_TX_BIT(3);
TX_EN_OUT <= TX_EN;
BUFF_EMPTY_OUT <= BUFF_EMPTY;
	
	imp_BUFF_REG_TX : process (CLK_50MHZ) is
begin  -- process load data in buffer TX
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if BUFF_REG_TX_LOAD = '1' then 
			BUFF_REG_TX(7 downto 0) <= TX_DATA_IN(7 downto 0);
		end if;
	end if;
end process;
	
	imp_SHIFT_REG_TX : process (CLK_50MHZ) is
begin  -- process shift data in TX
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if TX_EN_Z = '0' and TX_EN = '1' then
			SHIFT_REG_TX(8 downto 0) <= BUFF_REG_TX(7 downto 0) & '0';
		elsif CNT_TX_104us(13) = '1' then
			TX_SIGNAL <= SHIFT_REG_TX(0);
			SHIFT_REG_TX(8 downto 0) <= '1' & SHIFT_REG_TX(8 downto 1);
		end if;
	end if;
end process;
	
	imp_TX_EN : process (CLK_50MHZ) is
begin  -- process TX enable
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if CNT_TX_BIT = CONV_STD_LOGIC_VECTOR(10, 4) then 
				TX_EN <= '0';
		elsif BUFF_REG_TX_LOAD = '1' or BUFF_EMPTY = '0' then -- 
				TX_EN <= '1';
		end if;
	end if;
end process;	
	
		imp_BUFF_EMPTY : process (CLK_50MHZ) is
begin  -- process check if another data was received
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		TX_EN_Z <= TX_EN;
		if TX_EN_Z = '0' and TX_EN = '1' then
			BUFF_EMPTY <= '1';
		elsif BUFF_REG_TX_LOAD = '1' and TX_EN = '1' then 
			BUFF_EMPTY <= '0';
		end if;
	end if;
end process;
	
		imp_CNT_TX_104us : process (CLK_50MHZ) is
begin  -- process counter 104 us
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if  TX_EN = '1' then 
			if CNT_TX_104us(13) = '1' then
				CNT_TX_104us <= CONV_STD_LOGIC_VECTOR(5208, 14);
			else
				CNT_TX_104us <= CNT_TX_104us - 1;
			end if;	
		end if;
	end if;
end process;

	imp_CNT_TX_BIT : process (CLK_50MHZ) is
begin  -- process counter of TX bits shifted
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if CNT_TX_BIT = CONV_STD_LOGIC_VECTOR(10, 4) then
			CNT_TX_BIT <= CONV_STD_LOGIC_VECTOR(0, 4);
		elsif CNT_TX_104us(13) = '1' then
			CNT_TX_BIT <= CNT_TX_BIT + 1;
		end if;
	end if;
end process;
	
END SCHEMATIC;