library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.unsigned;

entity div16_8_8 is
	generic(
		A_WIDTH			: POSITIVE := 17;--signed
		B_WIDTH			: POSITIVE := 8;--unsigned
		RESULT_WIDTH	: POSITIVE := 9--signed,first bit is flag bit!
	);
	port (
		clk        : in  STD_LOGIC;
		en         : in  STD_LOGIC;
		rstn       : in  STD_LOGIC;
		a          : in  STD_LOGIC_VECTOR( A_WIDTH-1 downto 0);
		b          : in  STD_LOGIC_VECTOR( B_WIDTH-1 downto 0);
		result     : out STD_LOGIC_VECTOR( RESULT_WIDTH-1 downto 0)		
	);
end entity div16_8_8;

architecture rtl of div16_8_8 is

    type unsigned_8_array  is array(natural range <>) of UNSIGNED( 7 downto 0);
	type unsigned_16_array is array(natural range <>) of UNSIGNED(15 downto 0);
    signal zero : std_logic_vector(0 to 7) := (others => '0');
    signal b_new : UNSIGNED(15 downto 0);
    --buffer to store intermeduiate value with size 9
    --which means the calculation steps will not exceed 9
	signal r_remainder 		: unsigned_16_array(1 to 9);--we need
	signal r_shifted_b 		: unsigned_16_array(1 to 9);
	signal r_b 		: unsigned_16_array(1 to 9);--b not shifted
	signal r_result    		: unsigned_8_array (1 to 9);
	signal r_result_signed 	: SIGNED(8 downto 0);--we need 
	signal r_sign      		: STD_LOGIC_VECTOR(1 to 9);
	signal r_en		     	: STD_LOGIC_VECTOR(1 to 9);--?
begin

	process(clk, rstn, en)
		variable v_result 	: UNSIGNED( 8 downto 1);
        variable a_signed 	: SIGNED(16 downto 0);
        variable a_unsigned : UNSIGNED(15 downto 0);
        variable b_new1 : UNSIGNED(15 downto 0);
	begin
		if rstn = '0' then
	       
	        -- STUDENT CODE HERE
	        			r_sign <= "000000000";
			r_result_signed <= "000000000";
			r_result <= (others => (others => '0'));
			r_remainder <= (others => (others => '0'));
			r_shifted_b <= (others => (others => '1'));
--            r_result_signed <= (others =>'0');--initialize vector with all 0
--            r_result <= (others =>(others =>'0'));
--            r_remainder <= (others =>(others =>'0'));
--            r_shifted_b <= (others =>(others =>'0'));
--            r_sign <= (others =>'0');
--            r_b <= (others =>(others =>'0'));
--            b_new1 := (others =>'0');
            -- STUDENT CODE until HERE
		elsif rising_edge(clk) then
    		-- STUDENT CODE HERE
    		if en = '1' then
    				-- Assignment for the new incoming
			-- Check & record the sign of A 
			-- if neg, abs(A) neglect MSB => r_remainder
			-- if pos, neglect MSB => r_remainder
			-- assign r_shifted_b with value of b and appended 0s
			if a(A_WIDTH-1) = '1' then
				a_signed := abs(signed(a));
				r_remainder(1) <= unsigned(a_signed(15 downto 0));
				r_sign(1) <= '1';
			else
				r_remainder(1) <= unsigned(a(15 downto 0));
				r_sign(1) <= '0';
			end if;
		
			r_shifted_b(1) <= unsigned(b & "00000000");
		
			for i in 2 to RESULT_WIDTH loop
				r_sign(i) <= r_sign(i-1);
				if r_remainder(i-1) >= r_shifted_b(i-1) then 
					r_remainder(i) <= r_remainder(i-1) - r_shifted_b(i-1);
					r_result(i) <= shift_left(r_result(i-1),1) + 1;
				else
					r_remainder(i) <= r_remainder(i-1);
					r_result(i) <= shift_left(r_result(i-1),1);
				end if;
				-- shift b to the right
				r_shifted_b(i) <= '0' & r_shifted_b(i-1)(A_WIDTH-2 downto 1); 	
			end loop;
			
			v_result := shift_left(r_result(9),1);
			if r_remainder(9) >= r_shifted_b(9) then
				v_result := v_result + 1;
			end if;
			--output result  
			if r_sign(9) = '1' and v_result /= 0 then
			    r_result_signed <= signed('1' & (not v_result + 1));
			else
			    r_result_signed <= signed('0' & v_result);     
			end if;
			else
				r_result_signed <= "000000000";
			end if;
--            --The divider should have a pipelined
--            --architecture and accept a new set of input values in each clock cycle.
--            -- -43/6 = -7..-1,the remainder has same signness with dividend
            
--            --check first bit to decide pos or neg
--            a_signed := signed(a);
--            --store new input into buffer
--            for i in RESULT_WIDTH-1 downto 1 loop
--                --move all buffer right 1 block
--                r_sign(integer(i)+1) <= r_sign(integer(i));--store first sign bit into sign buffer
--                r_remainder(integer(i)+1) <= r_remainder(integer(i));--force type convertion
--                r_shifted_b(integer(i)+1) <= r_shifted_b(integer(i));--left shift buffer
--                r_b(integer(i)+1) <= r_b(integer(i));--left shift b
--                r_result(integer(i)+1) <= r_result(integer(i));
                
--            end loop;
--            -- read new input
--            r_sign(1) <= a(16);--store first sign bit into sign buffer
--            if r_sign(1) = '1' then--if negative convert 2.complement to original number
--                r_remainder(1) <= unsigned(abs(a_signed(15 downto 0)));--credit on Herr Xiao,true 2.complement inside array
--            else--otherwise no abs, or just leave abs
--                r_remainder(1) <= unsigned(a_signed(15 downto 0));
--            end if;
            
--            b_new1 := unsigned("00000000"&(b));
--            --b_new <= b_new1;
--            r_b(1) <= b_new1;
--            for i in 15 downto 0 loop--when loop can cause infinite loop if input is 0
--                if b_new1(15) = '0' then--if the most left bit is 0 the shift left 1
--                    b_new1 := shift_left(b_new1,1);  
--                else
--                    exit;
--                end if;
--            end loop;
--            b_new <= b_new1;
--            r_shifted_b(1) <= b_new1;

            
--            for i in 1 to RESULT_WIDTH loop
--                --for each calculation following is needed
--                --hint:here i neglect the signness and just add sign at the end of calculation
--                --avoid mishandle at initialization phase
--                if to_integer(r_remainder(i)) /= 0 then
--                --check completeness
--                    if to_integer(r_remainder(i)) < to_integer(r_b(i)) then 
--                    --if remainder smaller than (unshifted)divisor b(unsigned observation) then complete
--                    --the result sign will be added at the end
--                    --the remainder is not relevant
--                    else
--                    --if remainder bigger than divisor then still need to calculate
--                    --compare
--                        if to_integer(r_shifted_b(i)) > to_integer(r_remainder(i)) then
--                        --b bigger than a
--                        --result add 0
                       
--                            r_result(i) <= shift_left(r_result(i), 1);
--                            r_result(i)(0) <= '0';
--                        --r_result(i) <= r_result(i) & '0';
                    
--                        else 
--                        --b smaller than a do the substraction
--                            r_remainder(i) <= to_unsigned(to_integer(r_remainder(i))- to_integer(r_shifted_b(i)),16);
--                        --result add 1
                        
--                            r_result(i) <= shift_left(r_result(i), 1);
--                            r_result(i)(0) <= '1';
--                        --r_result(i) <= r_result(i) & '1';
--                        end if;
--                    --shift b right 1 step
--                        r_shifted_b(i) <= shift_right(r_shifted_b(i), 1);
--                    end if;
                
--                end if;
--            end loop;
            
            
--            --assign output result with sign
--            r_result_signed <= signed(r_sign(9)& std_logic_vector(r_result(9)));
			-- STUDENT CODE until HERE
		end if;
	end process;
	
	result <= STD_LOGIC_VECTOR(r_result_signed);

end architecture rtl;
