-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): xkalaa00
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK      : in std_logic;
   RST      : in std_logic;
   DIN      : in std_logic;
   CNT      : in std_logic_vector(4 downto 0);
   CNT_2    : in std_logic_vector(3 downto 0);
   EN_OUT   : out std_logic;
   EN_CNT   : out std_logic;
   DOUT_VLD : out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
   
type state_type is (START_process, BEGIN_process, DATA_process, STOP_process, VALID_process);

signal state : state_type := START_process;

begin 

   EN_OUT <= '1' when state = DATA_process else '0';
   EN_CNT <= '1' when state = BEGIN_process or state = DATA_process else '0';
   DOUT_VLD <= '1' when state = VALID_process else '0';
   
process (CLK) begin
      if rising_edge(CLK) then
            if RST = '1' then
               state <= START_process;
            end if;

            case state is
               when START_process => if DIN = '0' then
                  state <= BEGIN_process;
                  end if;

               when BEGIN_process => if CNT = "10000" then
                  state <= DATA_process;
                  end if;
                  
               when DATA_process => if CNT = "10000" then
                  if CNT_2 = "1000" then
                  state <= STOP_process;
                  end if;
               end if;

               when STOP_process => if DIN = '1' then
                  state <= VALID_process;
                  end if;

               when VALID_process => state <= START_process; 

               when others => null;
            end case;
      end if;
   end process;
end behavioral;
