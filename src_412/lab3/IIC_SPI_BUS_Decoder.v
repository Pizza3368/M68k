module IIC_SPI_BUS_Decoder (
    input unsigned [31:0] Address,
    input IOSelect,
    input AS_L,
	 
    output reg SPI_Enable_H,
    output reg IIC0_Enable 
);

    always @(*) begin

        // defaults output are inactive, override as required later
        SPI_Enable_H = 1'b0;
        IIC0_Enable = 1'b0; 

        // TODO: design decoder to produce SPI_Enable_H for addresses in range
        // [00408020 to 0040802F]. Use SPI_Select_H input to simplify decoder
        // this comes from the IOSelect_H signal on the top level schematic which is asserted high for CPU
        // addresses in the range hex [0040 0000 - 0040 FFFF] so you only need to decode the lower 16 address lines 
        // in conjunction with SPI_Select_H (think about it)
        // AS_L must be included in decoder decision making to make sure only 1 clock edge seen by 
        // SPI controller per 68k read/write. You don’t have to do anything more.
        if (IOSelect && (~AS_L)) begin
            if(Address[15:4] == 12'h802) begin
                SPI_Enable_H = 1'b1;
            end else if (Address[15:4] == 12'h800) begin
					IIC0_Enable = 1'b1;
				end
        end

    end
endmodule