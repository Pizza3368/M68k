module ram32kdecoder(input select, input uds_l, input lds_l,
    input as_l, input we_l, output wren_l, output wren_u,
    output oe_l, output oe_u);

    // LDS
    assign wren_l = select & (~as_l) & (~lds_l) & (~we_l);
    assign oe_l = select & (~as_l) & (~lds_l) & we_l;
    // UDS
    assign wren_u = select & (~as_l) & (~uds_l) & (~we_l);
    assign oe_u = select & (~as_l) & (~uds_l) & we_l;
    
endmodule
