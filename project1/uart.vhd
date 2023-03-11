-- uart.vhd: UART controller - receiving part
-- Author(s): xkalaa00
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK			:	in std_logic;
	RST			: 	in std_logic;
	DIN			: 	in std_logic;
	DOUT		: 	out std_logic_vector(7 downto 0);
	DOUT_VLD	: 	out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
	
signal en_out 	: std_logic;
signal en_cnt	: std_logic;
signal cnt1		: std_logic_vector(4 downto 0);
signal cnt2		: std_logic_vector(3 downto 0);

begin
	FSM: entity work.UART_FSM(behavioral)
    port map (
		CLK 		=> CLK,
		RST			=> RST,
		DIN 		=> DIN,
		CNT			=> cnt1,
		CNT_2		=> cnt2,
		EN_OUT 		=> en_out,
		EN_CNT 		=> en_cnt,
		DOUT_VLD 	=> DOUT_VLD
    );

process (CLK) begin
		if rising_edge(CLK) then 
		
			if RST = '1' then
				cnt1 <= "00000";
				cnt2 <= "0000";
			end if;

			if en_cnt = '1' then
				cnt1 <= cnt1 + 1;
			elsif en_cnt = '0' then
				cnt1 <= "00000";
				cnt2 <= "0000";
			end if;

			if cnt1(4) = '1' and en_out = '1' then
				cnt1 <= "00000";	

				case cnt2 is 
					when "0000" => DOUT(0) <= DIN;
					when "0001" => DOUT(1) <= DIN;
					when "0010" => DOUT(2) <= DIN;
					when "0011" => DOUT(3) <= DIN;
					when "0100" => DOUT(4) <= DIN;
					when "0101" => DOUT(5) <= DIN;
					when "0110" => DOUT(6) <= DIN;
					when "0111" => DOUT(7) <= DIN;
					when others => null;
				end case;

				cnt2 <= cnt2 + 1;
			end if;
		end if;
	end process;
end behavioral;
