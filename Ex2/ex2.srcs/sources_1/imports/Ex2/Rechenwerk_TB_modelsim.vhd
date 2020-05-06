---------------------------------------------------------------------------------------------
--							
-- Dateiname:	processor_testbench.vhd
--
-- Inhalt: 	Testbench zu processor_struct.vhd
-- Erklaerung: wir sollen mit diesem Programm folgende Signalen erzeugen:
-- 1.mux_R2_data_in
-- 2.mux_sel_sig
-- 3. R2_en
-- 4. R1_en
-- 5. instruction
-- 6. instruction_en
-- die 6 signalen sind Eingangssignalen für data_path_struct Programm(realer Rechenwerk)
-- zusätzlich noch 
-- 7. rst
-- 8. clk
--
--		clk   			: in std_logic;						    	-- clock
--		rst 			: in std_logic;						    	-- Reset, high active
--		mux_sel_sig 	: in std_logic;								-- control signal of Mux above Register R1
--		R1_en 			: in std_logic;				    			-- R1 enable-Signal
--		R2_en 			: in std_logic;								-- R2 enable-Signal
--		instruction 	: in std_logic_vector(3 DOWNTO 0);  		--  control signals for the ALU
--	    instruction_en 	: in std_logic;
--		mux_R2_data_in 	: in std_logic_vector(3 DOWNTO 0); 
--!@	

--hinweise aus PDF:
--Iterate through the mock-up "instruction memory" in order to test the data path.
--!!!use for loop to loop all ops inside buffer

--You have to enable the ALU if a computation has to be performed.
--!!!instrucion_en set to 1 if ops are computations

--Opcode "1000" and "1001" don't require processing by the ALU but storing
--new data to the registers. Opcode "1010" requires modifying the value of
--the Testbench's "program counter".
---!!!seperate r1_en and r2_en
---!!!add new signal programm counter!pointer to instruction memory?

--Results computed by the ALU need to be stored into register 1.
--!!!compare or shift op needed to r1_en

--You need to control the multiplexer for storing results from the ALU to
--register 1 or loading new data to the register.
--!!!mux=1 load new data to r1
--!!!mux=0 load results to r1
		
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;


---------------------------------------------------------------------------------------------

ENTITY Rechenwerk_TB IS
END Rechenwerk_TB;
----Anmerkung:
----Das Testbench ist ein Behavioral Stimuli und structural Rechenwerk
----testbench ist normalerweise mit einen response control versehen und structural modeling(stimuli und rechenwerk 2 Componenten)
---------------------------------------------------------------------------------------------

ARCHITECTURE behavior OF Rechenwerk_TB IS

-- STUDENT CODE HERE
signal mux_R2_data_in : std_logic_vector(3 DOWNTO 0);
signal mux_sel_sig : std_logic;
signal R2_en : std_logic;
signal R1_en : std_logic;
signal instruction_en : std_logic;
signal clk : std_logic := '0';
signal rst : std_logic := '1';
signal status_out :  std_logic_vector(2 DOWNTO 0);			-- output Status register
signal alu_res 		:  std_logic_vector(3 DOWNTO 0);    		-- output ALU 
signal alu_res_rdy 	:  std_logic;
signal program_counter : integer;
-- STUDENT CODE until HERE
signal instruction 	: std_logic_vector(3 DOWNTO 0);  	-- control signals for the ALU
-- STUDENT CODE HERE
COMPONENT data_path_struct IS
    PORT(
		clk   			: in std_logic;						    	-- clock
		rst 			: in std_logic;						    	-- Reset, high active
		mux_sel_sig 	: in std_logic;								-- control signal of Mux above Register R1
		R1_en 			: in std_logic;				    			-- R1 enable-Signal
		R2_en 			: in std_logic;								-- R2 enable-Signal
		instruction 	: in std_logic_vector(3 DOWNTO 0);  		--  control signals for the ALU
	    instruction_en 	: in std_logic;
		mux_R2_data_in 	: in std_logic_vector(3 DOWNTO 0);
	    status_out 		: out std_logic_vector(2 DOWNTO 0);			-- output Status register
		alu_res 		: out std_logic_vector(3 DOWNTO 0);    		-- output ALU 
		alu_res_rdy 	: out std_logic
    );
END COMPONENT;
-- STUDENT CODE until HERE
	
BEGIN

-- STUDENT CODE HERE
--initialize clk and rst
-- clk=100mhz --- 10ns
    clock_driver : process
    begin
        clk <= not clk;
        wait for 10ns;
    end process clock_driver;
    
--initialize rst
    rst <= '0' after 100ns;

-- STUDENT CODE until HERE

	main :PROCESS (rst, clk)
   
    file infile : text;
	
	variable f_status: FILE_OPEN_STATUS;
	variable value: bit_vector(7 downto 0);
	variable value_std: std_logic_vector(7 downto 0) := X"00";
	variable inbuf : LINE; -- buffer between the program and file
   
    begin	
		if (rst = '1') then
			-- STUDENT CODE HERE
            -- reset all signals and variables?
            mux_R2_data_in <= X"0";
            mux_sel_sig <= '0';
            R2_en <= '0';
            R1_en <= '0';
            instruction_en <= '0';
            program_counter <= 0;
            --instruction <= X"0";
            -- STUDENT CODE until HERE
			file_open(f_status, infile, "../../../../program.txt", read_mode);				
		elsif rising_edge(clk) then
			-- STUDENT CODE HERE
            -- for jump function we need to build a programm counter
            program_counter <= program_counter +1; 

			-- STUDENT CODE until HERE
			-- if not read til the end, each clock will read one line
			if endfile(infile) /= true then
				readline(infile, inbuf);

				read(inbuf, value);
				value_std := to_stdlogicvector(value);
			end if;
			
			instruction <= value_std(7 downto 4);
		
			-- STUDENT CODE HERE
--TODO:
-- 1.mux_R2_data_in
            mux_R2_data_in <= value_std(3 downto 0);
            --depending on instruction
            case instruction is
                --add
                when  "0000" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --minus
                when  "0001" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --or
                when  "0010" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --and
                when  "0011" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --xor
                when  "0100" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --not
                when  "0101" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --shr
                when  "0110" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --shl
                when  "0111" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                --load r1 new data
                when  "1000" => mux_sel_sig <= '1';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '0';
                --load r2 new data
                when  "1001" => mux_sel_sig <= '1';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '0';
                --jump
                when  "1010" => mux_sel_sig <= '0';
                                R2_en <= '1';
                                R1_en <= '1';
                                instruction_en <= '1';
                                program_counter <= to_integer(signed(mux_R2_data_in));
                                --should i modify the next instruction?
                                --instrucion <= 
                 when others => null;

          end case;
-- 2. mux_sel_sig
-- 3. R2_en
-- 4. R1_en
-- 6. instruction_en
--hinweise aus PDF:
--Iterate through the mock-up "instruction memory" in order to test the data path.
--!!!use for loop to loop all ops inside buffer

--You have to enable the ALU if a computation has to be performed.
--!!!instrucion_en set to 1 if ops are computations

--Opcode "1000" and "1001" don't require processing by the ALU but storing
--new data to the registers. Opcode "1010" requires modifying the value of
--the Testbench's "program counter".
---!!!seperate r1_en and r2_en
---!!!add new signal programm counter!pointer to instruction memory?

--Results computed by the ALU need to be stored into register 1.
--!!!compare or shift op needed to r1_en

--You need to control the multiplexer for storing results from the ALU to
--register 1 or loading new data to the register.
--!!!mux=1 load new data to r1
--!!!mux=0 load results to r1





			-- STUDENT CODE until HERE
		end if;
   end process main;

-- STUDENT CODE HERE
    data_path_struct1:data_path_struct
    PORT MAP(
        clk =>	clk	,				    	-- clock
		rst =>  rst	,				    	-- Reset, high active
		mux_sel_sig 	=> mux_sel_sig,
										-- control signal of Mux above Register R1
		R1_en 			=>	R1_en	,	    			-- R1 enable-Signal
		R2_en 			=>	R2_en	,					-- R2 enable-Signal
		instruction 	=>  instruction	,	--  control signals for the ALU
	    instruction_en 	=>  instruction_en,
		mux_R2_data_in 	=>  mux_R2_data_in,
	    status_out 		=>	status_out,		-- output Status register
		alu_res 		=>  alu_res	,	-- output ALU 
		alu_res_rdy 	=>  alu_res_rdy
    );
    


-- STUDENT CODE until HERE

---------------------------------------------------------------------------------------------

END;


 configuration rechen_config of Rechenwerk_TB is
    for behavior
        for data_path_struct1 : data_path_struct
            use entity work.data_path_struct(structural);
        end for;
    end for;
 end rechen_config;