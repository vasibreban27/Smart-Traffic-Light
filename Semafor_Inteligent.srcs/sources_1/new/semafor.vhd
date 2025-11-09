library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity semafor is
    generic(
        CLOCK_FREQ : natural := 50000000; --50MHz procesor zynq
        T_MIN_NS : natural := 10; --secunde default
        T_MIN_EW : natural := 10;
        T_YELLOW : natural := 3;
        T_PED : natural := 10 --secunde pietoni
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        btn : in std_logic_vector(3 downto 0);
        sw : in std_logic_vector(3 downto 0);
        green_ns_i : in std_logic_vector(3 downto 0);
        green_ew_i : in std_logic_vector(3 downto 0);
        led_out : out std_logic_vector(3 downto 0)
    );
end semafor;
--btn(0)-prioritate pietoni, btn(1)-proritate NS, btn(2)-prioritate EW
--sw(0)-night mode
--led(0)-NS, led(1)-EW, led(2)-pietoni, led(3)-mod urgenta/proritate 


architecture Behavioral of semafor is

type state_t is (
    ALL_RED,
    NS_GREEN,
    NS_YELLOW,
    EW_GREEN,
    EW_YELLOW,
    PED_GREEN,
    NIGHT_BLINK
    );
signal state : state_t := ALL_RED;

--semanle second tick generator - va transforma 100MHz intr-un Hz(un impuls pe sec)(va genera un impuls logic la fiecare secunda)
signal sec_counter : natural := 0;
signal second_tick : std_logic := '0';

--contor in secunde pt starea curenta
signal timer_s : natural := 0;

--butoane si switchuri sincronizate
signal btn_sync : std_logic_vector(3 downto 0);
signal sw_sync : std_logic_vector(3 downto 0);

--semnale request proritate
signal ped_req : std_logic := '0';
signal prio_ns : std_logic := '0';
signal prio_ew : std_logic := '0';

--timpi verde (ori tmin ori valoare introdusa in secunde)
function to_seconds(v:std_logic_vector(3 downto 0); tmin:natural) return natural is
    variable val : natural := to_integer(unsigned(v));
    begin
        if val = 0 then 
            return tmin;
        else
            return val;
        end if;
end function;

--semnale pentru verde 
signal green_ns_s : natural := T_MIN_NS;
signal green_ew_s : natural := T_MIN_EW;

signal leds : std_logic_vector(3 downto 0) := (others => '0');

begin

--sincronziare butoane si switch-uri
process(clk)
    begin
    if rising_edge(clk) then 
        btn_sync <= btn;
        sw_sync <= sw;
    end if;
end process;
    
--second tick generator - va transforma 100MHz intr-un Hz(un impuls pe sec)(va genera un impuls logic la fiecare secunda)
--divizor de frecventa - numarator
process(clk)
    begin
        if rising_edge(clk) then 
            if rst = '1' then
                sec_counter <= 0;
                second_tick <= '0';
            else
                if sec_counter >= CLOCK_FREQ - 1 then
                    sec_counter <= 0;
                    second_tick <= '1';
                else
                    sec_counter <= sec_counter + 1;
                    second_tick <= '0';
                end if;
             end if;
          end if;
end process;


--detectare moment apasare buton exacta
--'1' logic la un moment de timp, nu ramane blocat
--logica apasare buton pe cazuri(request-uri)
process(clk)
    variable prev_btn : std_logic_vector(3 downto 0) := (others =>'0');
    begin
        if rising_edge(clk) then 
            if rst = '1' then   
                prev_btn := (others=>'0');
                ped_req <= '0';
                prio_ns <= '0';
                prio_ew <= '0';
            else
                for i in 0 to 3 loop
                    if btn_sync(i) = '1' and prev_btn(i) = '0' then
                        if i = 0 then   
                            ped_req <= '1'; --buton apasat pietoni
                        elsif i = 1 then
                            prio_ns <= '1'; --buton urgenta prioritate nord-sud
                        elsif i = 2 then
                            prio_ew <= '1'; --buton urgenta prioritate est-vest
                        end if;
                    end if;
                    prev_btn(i) := btn_sync(i);
                 end loop;
              end if;
           end if;
end process;

--update timp verde din PS
process(green_ns_i,green_ew_i)
begin
    green_ns_s <= to_seconds(green_ns_i,T_MIN_NS);
    green_ew_s <= to_seconds(green_ew_i,T_MIN_EW);
end process;

--proces principal
process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            state <= ALL_RED;
            timer_s <= 1;
            leds <= (others => '0');
        else
            if sw_sync(0) = '1' then --night mode
                state <= NIGHT_BLINK; 
            else
                if second_tick = '1' then
                    if timer_s > 0 then
                        timer_s <= timer_s - 1;
                    end if;
                case state is
                    when ALL_RED => 
                        if timer_s = 0 then
                            if prio_ns = '1' then
                                state <= NS_GREEN;
                                timer_s <= green_ns_s;
                                prio_ns <= '0';
                            else
                                state <= NS_GREEN;
                                timer_s <= green_ns_s;
                            end if;
                        end if;
                        
                     when NS_GREEN =>
                        if prio_ns = '1' then
                            prio_ns <= '0';
                            timer_s <= green_ns_s;
                        elsif timer_s = 0 then
                            state <= NS_YELLOW;
                            timer_s <= T_YELLOW;
                        end if;
                        
                     when NS_YELLOW =>
                        if timer_s = 0 then
                            state <= ALL_RED;
                            timer_s <= 1;
                        end if;
                     
                     when EW_GREEN =>
                        if prio_ew = '1' then
                            prio_ew <= '0';
                            timer_s <= green_ew_s;
                        elsif timer_s = 0 then
                            state <= EW_YELLOW;
                            timer_s <= T_YELLOW;
                        end if;
                     
                     when EW_YELLOW =>
                        if timer_s = 0 then
                            if ped_req = '1' then
                                state <= PED_GREEN;
                                timer_s <= T_PED;
                                ped_req <= '0';
                            else
                                state <= ALL_RED;
                                timer_s <= 1;
                            end if;
                         end if;
                      
                     when PED_GREEN =>
                        if timer_s = 0 then
                            state <= ALL_RED;
                            timer_s <= 1;
                        end if;
                        
                     when NIGHT_BLINK => null;
                     when others => 
                        state <= ALL_RED;
                        timer_s <= 1;
                     end case;
                    if state = ALL_RED and timer_s = 0 then
                        null;
                    end if;
                 end if;
              end if;
           end if;
        end if;
end process;


--proces pentru afisare pe leduri
process(state,timer_s,sw_sync,prio_ns,prio_ew)
begin 
    leds <= (others => '0');
    case state is   
        when NS_GREEN => 
            leds(0) <= '1';  --ledul 0 pentru directia nord sud
        when NS_YELLOW =>
            if (timer_s mod 2) = 0 then
                leds(0) <= '1';
            else
                leds(0) <= '0';
            end if;
            
         when EW_GREEN =>
            leds(1) <= '1';  --led 1 pt directia est vest
         when EW_YELLOW =>
            if (timer_s mod 2) = 0 then
                leds(1) <= '1';  
            else
                leds(1) <= '0';
            end if;
         
         when PED_GREEN =>
            leds(2) <= '1'; --led 2 pt pietoni
          
         when NIGHT_BLINK =>
            if (sec_counter mod 2) = 0 then
                leds(3) <= '1'; --led 3 pt mod noapte
            else    
                leds(3) <= '0';
            end if;
            
         when ALL_RED => null;
         when others => null;
    end case;
    
    if prio_ns = '1' or prio_ew = '1' then
      leds(3) <= '1';  --led 3 pt prioritate
    end if;
end process;
                                
led_out <= leds;                

end Behavioral;
