LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



ENTITY CLOCK_H_M IS
   PORT ( 
          CLK_50MHZ	:	IN	STD_LOGIC; 
			 ---------ram_cs----------------------------------
			 CE1 : OUT  STD_LOGIC;
			 CE2 : OUT  STD_LOGIC;
			 ------------------------------------------------
          LED_OUT	:	OUT	STD_LOGIC 
          );

end CLOCK_H_M;

ARCHITECTURE SCHEMATIC OF CLOCK_H_M IS

	SIGNAL CNT	:	STD_LOGIC_VECTOR (21 DOWNTO 0);
	SIGNAL CNT_S	:	STD_LOGIC_VECTOR (24 DOWNTO 0);
	SIGNAL CNT_BTN2	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL CNT_BTN2_EN	:	STD_LOGIC;
	SIGNAL CNT_BTN3	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL CNT_BTN3_EN	:	STD_LOGIC;
	SIGNAL CNT_17_z	:	STD_LOGIC;
	SIGNAL CNT_21_z	:	STD_LOGIC;
	SIGNAL F_1HZ	:	STD_LOGIC;
	SIGNAL F_1HZ_Z	:	STD_LOGIC;
	SIGNAL F_2HZ	:	STD_LOGIC;
	SIGNAL F_190HZ	:	STD_LOGIC;
	SIGNAL F_12HZ	:	STD_LOGIC;
	SIGNAL F_6HZ	:	STD_LOGIC;
	SIGNAL SEC_IMP:	STD_LOGIC;
	SIGNAL M_IMP	:	STD_LOGIC;
	SIGNAL M_IMP_Z	:	STD_LOGIC;
	SIGNAL DM_IMP	:	STD_LOGIC;
	SIGNAL DM_IMP_Z1	:	STD_LOGIC;
	SIGNAL DM_IMP_Z2	:	STD_LOGIC;
	SIGNAL H_IMP	:	STD_LOGIC;
	SIGNAL H_IMP_Z1	:	STD_LOGIC;
	SIGNAL H_IMP_Z2	:	STD_LOGIC;
	SIGNAL DH_IMP	:	STD_LOGIC;
	SIGNAL DH_IMP_Z1	:	STD_LOGIC;
	SIGNAL DH_IMP_Z2	:	STD_LOGIC;
	SIGNAL SEC	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL MIN	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL DMIN	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL HOUR	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL DHOUR	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL MIN_DIGIT	:	STD_LOGIC;
	SIGNAL DMIN_DIGIT	:	STD_LOGIC;
	SIGNAL HOUR_DIGIT	:	STD_LOGIC;
	SIGNAL DHOUR_DIGIT	:	STD_LOGIC;
	SIGNAL DIGIT_SWITCH	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL NUMBER_SWITCH	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	SIGNAL DOT_PERM	:	STD_LOGIC;
	SIGNAL DOT_BLINK	:	STD_LOGIC;
	SIGNAL BTN2_Z1	:	STD_LOGIC;
	SIGNAL BTN2_Z2	:	STD_LOGIC;
	SIGNAL BTN2_Z3	:	STD_LOGIC;
	SIGNAL BTN2_CLR	:	STD_LOGIC;
	SIGNAL BTN2_CLR_Z	:	STD_LOGIC;
	SIGNAL BTN_M_PUSH	:	STD_LOGIC;
	SIGNAL BTN_M_HOLD	:	STD_LOGIC;
	SIGNAL BTN3_Z1	:	STD_LOGIC;
	SIGNAL BTN3_Z2	:	STD_LOGIC;
	SIGNAL BTN3_Z3	:	STD_LOGIC;
	SIGNAL BTN3_CLR	:	STD_LOGIC;
	SIGNAL BTN3_CLR_Z	:	STD_LOGIC;
	SIGNAL BTN_H_PUSH	:	STD_LOGIC;
	SIGNAL BTN_H_HOLD	:	STD_LOGIC;
	
BEGIN



	imp_F_2HZ : process (CLK_50MHZ) is
begin  -- process Frequancy 2 Hz
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if CNT_S = CONV_STD_LOGIC_VECTOR(24999999, 25) then
			CNT_S <= CONV_STD_LOGIC_VECTOR(0, 25);
			F_2HZ <= '1';
		else
			CNT_S <= CNT_S + 1;
			F_2HZ <= '0';
		end if;
	end if;
end process;

	imp_F1HZ : process (CLK_50MHZ) is
begin  -- process Frequancy 1 Hz (Miander)
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		if F_2HZ = '1'  then
			F_1HZ <= not F_1HZ;
		end if;
	end if;
end process;

	imp_SEC_IMP : process (CLK_50MHZ) is
begin  -- process Seconds impulse
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge
		F_1HZ_Z <= F_1HZ;
		SEC_IMP <= F_1HZ and not F_1HZ_Z;
	end if;
end process;

	imp_F12HZ : process (CLK_50MHZ) is
begin  -- process Frequancy 12 Hz
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		CNT_21_z <= CNT(21);
		if CNT(21) = '1' and CNT_21_z = '0' then
			F_12HZ <= '1';
		else
			F_12HZ <= '0';
		end if;
	end if;
end process;

--imp_F6HZ : process (CLK_50MHZ) is
--begin  -- process Frequancy 12 Hz
	--if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		--CNT_22_z <= CNT(22);
		--if CNT(22) = '1' and CNT_22_z = '0' then
			--F_6HZ <= '1';
		--else
			--F_6HZ <= '0';
		--end if;
	--end if;
--end process;

	--imp_LED_SWITCH : process (CLK_50MHZ) is
--begin  -- process LED switching
	--if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		--if F_1HZ = '1' then        
			--LED_SWITCH <= not LED_SWITCH;
		--end if;
	--end if;
--end process;

	imp_BTN2_FILTER : process (CLK_50MHZ) is
begin  -- process Button 2 filtering 
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if F_190HZ = '1'  then 
			BTN2_Z1 <= BTN2;
			BTN2_Z2 <= BTN2_Z1;
			BTN2_Z3 <= BTN2_Z2; 
		end if;
	end if;
end process;

BTN2_CLR <= BTN2_Z1 and BTN2_Z2 and BTN2_Z3;

imp_CNT_BTN2 : process (CLK_50MHZ) is
begin  -- process Counter for Button 2 holding
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if  BTN2_CLR = '1' then
			if SEC_IMP = '1' then
				CNT_BTN2 <= CNT_BTN2 + 1;
			end if;
		else
			CNT_BTN2 <= CONV_STD_LOGIC_VECTOR(0, 2);
			CNT_BTN2_EN <= '0';
		end if;
		if CNT_BTN2(0) = '1' then
			CNT_BTN2_EN <= '1';
		end if;
	end if;
end process;

	imp_BTN2_PUSH : process (CLK_50MHZ) is
begin  -- process Button 2 push 
		if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
			BTN2_CLR_Z <= BTN2_CLR; 
			BTN_M_PUSH <= BTN2_CLR and not BTN2_CLR_Z;
		end if;
	end process;
	
	imp_BTN2_HOLD : process (CLK_50MHZ) is
begin  -- process Button 2 hold 
		if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
			BTN_M_HOLD <= CNT_BTN2_EN and F_12HZ;
		end if;
	end process;

	imp_BTN3_FILTER : process (CLK_50MHZ) is
begin  -- process Button 3 filtering 
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if F_190HZ = '1'  then 
			BTN3_Z1 <= BTN3;
			BTN3_Z2 <= BTN3_Z1;
			BTN3_Z3 <= BTN3_Z2; 
		end if;
	end if;
end process;

BTN3_CLR <= BTN3_Z1 and BTN3_Z2 and BTN3_Z3;

imp_CNT_BTN3 : process (CLK_50MHZ) is
begin  -- process Counter for Button 2 holding
	if CLK_50MHZ'event and CLK_50MHZ = '1' then     -- rising clock edge 
		if  BTN3_CLR = '1' then
			if SEC_IMP = '1' then
				CNT_BTN3 <= CNT_BTN3 + 1;
			end if;
		else
			CNT_BTN3 <= CONV_STD_LOGIC_VECTOR(0, 2);
			CNT_BTN3_EN <= '0';
		end if;
		if CNT_BTN3(0) = '1' then
			CNT_BTN3_EN <= '1';
		end if;
	end if;
end process;

	imp_BTN3_PUSH : process (CLK_50MHZ) is
begin  -- process Button 3 push 
		if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
			BTN3_CLR_Z <= BTN3_CLR; 
			BTN_H_PUSH <= BTN3_CLR and not BTN3_CLR_Z;
		end if;
	end process;
	
		imp_BTN3_HOLD : process (CLK_50MHZ) is
begin  -- process Button 3 hold 
		if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
			BTN_H_HOLD <= CNT_BTN3_EN and F_12HZ;
		end if;
	end process;
	
	imp_DOT_BLINK : process (CLK_50MHZ) is
begin  -- process Dot blinking 
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if F_2HZ = '1' then        
			DOT_BLINK <= not DOT_BLINK;
		end if;
	end if;
end process;

	imp_SEC : process (CLK_50MHZ) is
begin  -- process Seconds units count
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if SEC_IMP = '1' then 
			if SEC = CONV_STD_LOGIC_VECTOR(59, 6) then
				SEC <= CONV_STD_LOGIC_VECTOR(0, 6);
				M_IMP_Z <= '1'; 
			else
				SEC <= SEC + 1;
				M_IMP_Z <= '0'; 
			end if;	
		end if;	
	end if;
end process;

	--M_IMP <= (M_IMP_Z and SEC_IMP) or (BTN2_CLR and F_6HZ);
	M_IMP <= M_IMP_Z and SEC_IMP;

	imp_MIN : process (CLK_50MHZ) is
begin  -- process Minutes units count
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
			DM_IMP_Z2 <= DM_IMP_Z1;
			if M_IMP = '1' or BTN_M_PUSH = '1' or BTN_M_HOLD = '1' then
				if MIN = CONV_STD_LOGIC_VECTOR(9, 6) then
					MIN <= CONV_STD_LOGIC_VECTOR(0, 6);
					DM_IMP_Z1 <= '1';
				else
					MIN <= MIN + 1;
					DM_IMP_Z1 <= '0';
				end if;	
		end if;	
	end if;
end process;

	DM_IMP <= DM_IMP_Z1 and not DM_IMP_Z2;

	imp_DMIN : process (CLK_50MHZ) is
begin  -- process Minutes decimals count
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		H_IMP_Z2 <= H_IMP_Z1;
		if DM_IMP = '1' then
			if DMIN = CONV_STD_LOGIC_VECTOR(5, 6) then
				DMIN <= CONV_STD_LOGIC_VECTOR(0, 6);
				H_IMP_Z1 <= '1';
			else
				DMIN <= DMIN + 1;
				H_IMP_Z1 <= '0';
			end if;
		end if;	
	end if;
end process;

H_IMP <= H_IMP_Z1 and not H_IMP_Z2;

	imp_HOUR : process (CLK_50MHZ) is
begin  -- process Hour units count
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		DH_IMP_Z2 <= DH_IMP_Z1;
		if H_IMP = '1' or BTN_H_PUSH = '1' or BTN_H_HOLD = '1' then
			if HOUR = CONV_STD_LOGIC_VECTOR(9, 6) or (DHOUR = CONV_STD_LOGIC_VECTOR(2, 6) and HOUR = CONV_STD_LOGIC_VECTOR(3, 6)) then
				HOUR <= CONV_STD_LOGIC_VECTOR(0, 6);
				DH_IMP_Z1 <= '1';
			else
				HOUR <= HOUR + 1;	
				DH_IMP_Z1 <= '0';
			end if;
		end if;
	end if;
end process;

DH_IMP <= DH_IMP_Z1 and not DH_IMP_Z2;

	imp_DHOUR : process (CLK_50MHZ) is
begin  -- process Hour decimals count
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if DH_IMP = '1' then
			if DHOUR = CONV_STD_LOGIC_VECTOR(2, 6) then
				DHOUR <= CONV_STD_LOGIC_VECTOR(0, 6);
			else
				DHOUR <= DHOUR + 1;
			end if;
		end if;	
	end if;
end process;	


	imp_NUMBER_SWITCH : process (CLK_50MHZ) is
begin  -- process Number switch
	if CLK_50MHZ'event and CLK_50MHZ = '1' then			-- rising clock edge 
		if F_190HZ = '1'  then 
			DIGIT_SWITCH <= DIGIT_SWITCH + 1;
			case (DIGIT_SWITCH) is 
				when "00" =>
					NUMBER_SWITCH(5 downto 0) <= MIN(5 downto 0);
					MIN_DIGIT <= '0';
					DMIN_DIGIT <= '1';
					HOUR_DIGIT <= '1';
					DHOUR_DIGIT <= '1';
					DOT_PERM <= '1';
				when "01" =>
					NUMBER_SWITCH(5 downto 0) <= DMIN(5 downto 0);
					MIN_DIGIT <= '1';
					DMIN_DIGIT <= '0';
					HOUR_DIGIT <= '1';
					DHOUR_DIGIT <= '1';
					DOT_PERM <= '1';
				when "10" =>
					NUMBER_SWITCH(5 downto 0) <= HOUR(5 downto 0);
					MIN_DIGIT <= '1';
					DMIN_DIGIT <= '1';
					HOUR_DIGIT <= '0';
					DHOUR_DIGIT <= '1';
					DOT_PERM <= DOT_BLINK;
				when "11" =>
					NUMBER_SWITCH(5 downto 0) <= DHOUR(5 downto 0);
					MIN_DIGIT <= '1';
					DMIN_DIGIT <= '1';
					HOUR_DIGIT <= '1';
					DHOUR_DIGIT <= '0';
					DOT_PERM <= '1';
				when others =>
					NUMBER_SWITCH(5 downto 0) <= MIN(5 downto 0);
					MIN_DIGIT <= '1';
					DMIN_DIGIT <= '1';
					HOUR_DIGIT <= '1';
					DHOUR_DIGIT <= '1';
					DOT_PERM <= '1';
			end case;
		end if;	
	end if;
end process;

	imp_SEG_SWITCH : process is
begin  -- process 7-segment number switch
   case NUMBER_SWITCH is 
      when "000000" =>
         A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '1';
      when "000001" =>
			A <= '1';
			B <= '0';
			C <= '0';
			D <= '1';
			E <= '1';
			F <= '1';
			G <= '1';
		when "000010" =>
			A <= '0';
			B <= '0';
			C <= '1';
			D <= '0';
			E <= '0';
			F <= '1';
			G <= '0';
		when "000011" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '1';
			F <= '1';
			G <= '0';
		when "000100" =>
         A <= '1';
			B <= '0';
			C <= '0';
			D <= '1';
			E <= '1';
			F <= '0';
			G <= '0';
      when "000101" =>
			A <= '0';
			B <= '1';
			C <= '0';
			D <= '0';
			E <= '1';
			F <= '0';
			G <= '0';
		when "000110" =>
			A <= '0';
			B <= '1';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
		when "000111" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '1';
			E <= '1';
			F <= '1';
			G <= '1';
		when "001000" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
		when "001001" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '1';
			F <= '0';
			G <= '0';
		when others => 
			A <= '0';
			B <= '1';
			C <= '1';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
   end case;
end process;
		
	AN1 <= DMIN_DIGIT;
	AN0 <= MIN_DIGIT;
	AN3 <= DHOUR_DIGIT;
	AN2 <= HOUR_DIGIT;
	
	DP <= DOT_PERM;

END SCHEMATIC;