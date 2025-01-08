// `timescale 1ns / 1ps

module tb_dram();

    // Inputs
    reg Clock;
    reg Reset_L;
    reg [31:0] Address;
    reg [15:0] DataIn;
    reg UDS_L;
    reg LDS_L;
    reg DramSelect_L;
    reg WE_L;
    reg AS_L;

    // Outputs
    wire [15:0] DataOut;
    wire SDram_CKE_H;
    wire SDram_CS_L;
    wire SDram_RAS_L;
    wire SDram_CAS_L;
    wire SDram_WE_L;
    wire [12:0] SDram_Addr;
    wire [1:0] SDram_BA;
    wire [15:0] SDram_DQ;
    wire Dtack_L;
    wire ResetOut_L;
    wire [4:0] DramState;

    // Internal Variables to monitor changes
    reg [4:0] prev_DramState;
    reg [4:0] Command;

    M68kDramController_Verilog dut (
        .Clock(Clock), 
        .Reset_L(Reset_L), 
        .Address(Address), 
        .DataIn(DataIn), 
        .UDS_L(UDS_L), 
        .LDS_L(LDS_L), 
        .DramSelect_L(DramSelect_L), 
        .WE_L(WE_L), 
        .AS_L(AS_L), 
        .DataOut(DataOut), 
        .SDram_CKE_H(SDram_CKE_H), 
        .SDram_CS_L(SDram_CS_L), 
        .SDram_RAS_L(SDram_RAS_L), 
        .SDram_CAS_L(SDram_CAS_L), 
        .SDram_WE_L(SDram_WE_L), 
        .SDram_Addr(SDram_Addr), 
        .SDram_BA(SDram_BA), 
        .SDram_DQ(SDram_DQ), 
        .Dtack_L(Dtack_L), 
        .ResetOut_L(ResetOut_L), 
        .DramState(DramState)
    );

    // Clock generation (20ns period for a 50MHz clock)
    initial begin
        Clock = 1'b0;
        forever begin
            #5;
            Clock = ~Clock;
        end
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        Clock <= 0;
        Reset_L <= 1'b0;
        Address <= 0;
        DataIn <= 0;
        UDS_L <= 1;
        LDS_L <= 1;
        DramSelect_L <= 1;
        WE_L <= 1;
        AS_L <= 1;
        prev_DramState <= 5'h0;

        // Reset the system
        #10;
        Reset_L <= 1'b1; // Release reset
        #10;

        #1000;


        // read
        DramSelect_L <= 1'b0;
        AS_L <= 1'b0;
        Address <= 32'hf0000001;
        WE_L <= 1'b1;
        DataIn <= 16'd255;
        UDS_L <= 1'b0;
        LDS_L <= 1'b0;
        #30;

        UDS_L <= 1'b1;
        LDS_L <= 1'b1;
        AS_L <= 1'b1;
        WE_L <= 1'b1;
        #10;

        #140;

        // write
        DramSelect_L <= 1'b0;
        AS_L <= 1'b0;
        WE_L <= 1'b0;
        #10;
        UDS_L <= 1'b1;
        LDS_L <= 1'b0;
        #20;
        
        UDS_L <= 1'b1;
        LDS_L <= 1'b1;
        AS_L <= 1'b1;
        WE_L <= 1'b1;
        #40;













        #40;
        $stop;
        
    end

    // Monitor state changes and display information
    always @(posedge Clock) begin
        if (prev_DramState != DramState) begin
            prev_DramState = DramState;
            // Command is a concatenation of control signals
            Command = {SDram_CKE_H, SDram_CS_L, SDram_RAS_L, SDram_CAS_L, SDram_WE_L};
            $display("Time=%03t, State=%01h, Command=%05b, ResetOut_L=%h", $time, DramState, Command, ResetOut_L);
        end
    end

endmodule
