LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity CanBusDecoder is
	Port (
		Address 		: in Std_logic_vector(31 downto 0) ;
		CanBusSelect_H 	: in Std_logic ;		-- active when 68k accesses range 0x00500000-0050FFFF
		AS_L			: in Std_Logic ;

		CAN_Enable0_H	: out Std_logic ; 
		CAN_Enable1_H	: out Std_logic
	);
end ;

architecture bhvr of CanBusDecoder is
Begin
	process(Address, CanBusSelect_H, AS_L)
	Begin
		CAN_Enable0_H  <= '0' ;	-- default is NOT active
		CAN_Enable1_H  <= '0' ;

-- Design for the Canbus Controller decoderrs. Each controller occupies 256 bytes 
-- of memory space. This is why CAN controller has (A7..0) pins, but chip has an 8 bit
-- data bus and is mapped to upper half of 68k’s data bus, so address should be connected to 
-- (A8..1) thus each device occupies 512 bytes in the 68k’s space.
--
-- Using CanBusSelect_H signal above to reduce decoder expression/complexity, design the following

-- TODO : enable Can0 if 68k is accessing an address in range $00500000 - $005001FF
-- TODO : enable Can1 if 68k is accessing an address in range $00500200 - $005003FF

    if CanBusSelect_H = '1' and AS_L = '0' then
            -- Enable Can0 if 68k is accessing an address in the range $00500000 - $005001FF
            -- Since we're interested in A8..1 for matching (512 bytes alignment), we compare
            -- relevant address bits to see if they fall within the desired range.
            if Address(19 downto 9) = "00000000000" then -- Corresponds to $00500000 - $005001FF
                CAN_Enable0_H <= '1';
            end if;

            -- Enable Can1 if 68k is accessing an address in the range $00500200 - $005003FF
            -- Checking the address bits against the range for Can1.
            if Address(19 downto 9) = "00000000001" then -- Corresponds to $00500200 - $005003FF
                CAN_Enable1_H <= '1';
            end if;
    end if;
	
	end process;
END ;
