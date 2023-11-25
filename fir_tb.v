module fir_tb;

    // Time scale directive for simulation
    `timescale 1ns/1ps

    // Inputs and outputs for the FIR filter
    reg clk;
    reg reset;
    reg signed [15:0] data_in;
    wire signed [15:0] filtered_data;
    reg low_power_mode;

    // Instantiate the FIR filter module
    dvs_FIR fir_instance (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .filtered_data(filtered_data),
        .low_power_mode(low_power_mode));
    

    initial begin
        // Reset scenario
        reset = 1;
        clk = 0;
        data_in = 0;
        low_power_mode = 0;
        #10;
        
        reset = 0;
        #10;

        // Normal operation without low_power_mode active
        data_in = 16'h1234;
        #10;
        data_in = 16'h5678;
        #10;
        data_in = 16'h9ABC;
        #10;
        data_in = 16'hDEF0;
        #10;

        // Activate low_power_mode
        low_power_mode = 1;
        data_in = 16'hABCD;
        #10;
        data_in = 16'h1234;
        #10;

        // Switch back to normal mode
        low_power_mode = 0;
        data_in = 16'h9876;
        #10;
        data_in = 16'h5432;
        #10;

        // Complete the simulation
        $finish;
    end

    always #5 clk = ~clk;  // Clock generation with period of 10ns

endmodule
