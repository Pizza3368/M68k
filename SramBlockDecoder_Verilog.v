module SramBlockDecoder_Verilog( 
		input unsigned [16:0] Address, // lower 17 lines of address bus from 68k
		input SRamSelect_H,				 // from main (top level) address decoder indicating 68k is talking to Sram
		
		// 4 separate block select signals that parition 256kbytes (128k words) into 4 blocks of 64k (32 k words)
		output reg Block0_H, 
		output reg Block1_H, 
		output reg Block2_H, 
		output reg Block3_H 
);	

	always@(*)begin
		if (SRamSelect_H) begin
			case(Address[16:15])
				2'h0: {Block0_H, Block1_H, Block2_H, Block3_H} = 4'b1000;
				2'h1: {Block0_H, Block1_H, Block2_H, Block3_H} = 4'b0100;
				2'h2: {Block0_H, Block1_H, Block2_H, Block3_H} = 4'b0010;
				2'h3: {Block0_H, Block1_H, Block2_H, Block3_H} = 4'b0001;
			endcase
		end else begin
			{Block0_H, Block1_H, Block2_H, Block3_H} = 4'b0000;
		end

	
		// default block selects are inactive - override as appropriate later
		
		// Block0_H <= 0; 
		// Block1_H <= 0;
		// Block2_H <= 0; 
		// Block3_H <= 0;
	
		// decode the top two address lines plus SRamSelect to provide 4 block select signals
		// for 4 blocks of 64k bytes (32k words) to give 256k bytes in total		
	end
endmodule
