---------------------------------------------------------------------------------------------
--							
-- Dateiname:	processor_testbench.vhd
--
-- Inhalt: 	Testbench zu processor_struct.vhd
--
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;


---------------------------------------------------------------------------------------------

ENTITY Rechenwerk_TB IS
END Rechenwerk_TB;

---------------------------------------------------------------------------------------------

ARCHITECTURE behavior OF Rechenwerk_TB IS

-- STUDENT CODE HERE


-- STUDENT CODE until HERE
signal instruction 	: std_logic_vector(3 DOWNTO 0);  	-- control signals for the ALU
-- STUDENT CODE HERE


-- STUDENT CODE until HERE
	
BEGIN

-- STUDENT CODE HERE


-- STUDENT CODE until HERE

	PROCESS (rst, clk)
   
    file infile : text;
	
	variable f_status: FILE_OPEN_STATUS;
	variable value: bit_vector(7 downto 0);
	variable value_std: std_logic_vector(7 downto 0) := X"00";
	variable inbuf : LINE; -- buffer between the program and file
   
   begin	
		if (rst = '1') then
			-- STUDENT CODE HERE


			-- STUDENT CODE until HERE
			file_open(f_status, infile, "program.txt", read_mode);				
		elsif rising_edge(clk) then
			-- STUDENT CODE HERE


			-- STUDENT CODE until HERE
			
			if endfile(infile) /= true then
				readline(infile, inbuf);

				read(inbuf, value);
				value_std := to_stdlogicvector(value);
			end if;
			
			instruction <= value_std(7 downto 4);
		
			-- STUDENT CODE HERE


			-- STUDENT CODE until HERE
		end if;
   end process;

-- STUDENT CODE HERE


-- STUDENT CODE until HERE

---------------------------------------------------------------------------------------------

END;
