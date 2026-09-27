LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY SEMISEG IS
   PORT ( 
          CLK_50MHZ	:	IN	STD_LOGIC;
			 DIN			: 	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 CLK_AN		:	IN	STD_LOGIC;
          DIGIT		:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
          VALUE		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)		 
          );

end SEMISEG;

ARCHITECTURE SCHEMATIC OF SEMISEG IS
	SIGNAL DIGIT_SWITCH	:	STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL NUMBER_SWITCH	:	STD_LOGIC_VECTOR(4 DOWNTO 0);
	
BEGIN

imp_NUMBER_SWITCH : process (CLK_50MHZ) is
begin  -- process Digit switch
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if CLK_AN = '1'  then 
			DIGIT_SWITCH <= DIGIT_SWITCH + 1;
			case (DIGIT_SWITCH) is 
				when "00" =>
					NUMBER_SWITCH(4 downto 0) <= "00000";
					DIGIT <= "0111";
				when "01" =>
					NUMBER_SWITCH(4 downto 0) <= "11111";
					DIGIT <= "1011";
				when "10" =>
					NUMBER_SWITCH(4 downto 0) <= '0' & DIN(7 DOWNTO 4);
					DIGIT <= "1101";
				when "11" =>
					NUMBER_SWITCH(4 downto 0) <= '0' & DIN(3 DOWNTO 0);
					DIGIT <= "1110";
				when others =>
					NUMBER_SWITCH(4 downto 0) <= "11111";
					DIGIT <= "1111";
			end case;
		end if;	
	end if;
end process;

imp_SEG_SWITCH : process is
begin  -- process 7-segment number switch
   case NUMBER_SWITCH is 
      when "00000" =>			--0
			VALUE <= "00000011";			--ABCDEFG DP
      when "00001" =>			--1
			VALUE <= "10011111";
		when "00010" =>			--2, Z
			VALUE <= "00100101";
		when "00011" =>			--3
			VALUE <= "00001101";
		when "00100" =>			--4
			VALUE <= "10011001";
      when "00101" =>			--5, S
			VALUE <= "01001001";
		when "00110" =>			--6
			VALUE <= "01000001";
		when "00111" =>			--7
			VALUE <= "00011111";
		when "01000" =>			--8
			VALUE <= "00000001";
		when "01001" =>			--9, g
			VALUE <= "00001001";
		when "01010" =>			--A
			VALUE <= "00010001";
		when "01011" =>			--b
			VALUE <= "11000001";
		when "01100" =>			--C
			VALUE <= "01100011";
		when "01101" =>			--d
			VALUE <= "10000101";
		when "01110" =>			--E
			VALUE <= "01100001";
		when "01111" =>			--F
			VALUE <= "01110001";
		when others => 			--h
			VALUE <= "11010001";
   end case;
end process;

END SCHEMATIC;