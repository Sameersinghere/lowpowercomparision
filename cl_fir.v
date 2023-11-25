module cl_fir(
    input clk,
    input reset,
    input signed [15:0] data_in,
    output reg signed [15:0] filtered_data,
    input low_power_mode   // input to signal when to simulate low power mode
);

integer i;

// Define the filter coefficients (example coefficients)
reg signed [15:0] coefficients [0:3];
initial begin
    coefficients[0] = 16'h1000;
    coefficients[1] = 16'h2000;
    coefficients[2] = 16'h3000;
    coefficients[3] = 16'h1000;
end

// Internal registers for storing delayed input samples
reg signed [15:0] delay_line [0:3];

// Clock gating logic
reg gated_clk;
always @(posedge clk or posedge reset) begin
    if (reset) 
        gated_clk <= 0;
    else if (!low_power_mode)
        gated_clk <= clk;  // Pass the actual clock when not in low power mode
    else 
        gated_clk <= 0;    // Block the clock in low power mode
end

// Combinational logic for filter operation
reg [2:0] delay_counter = 0;  // 3-bit counter for example, giving 8 possible values

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 4; i = i + 1) begin
            delay_line[i] <= 0;
        end
        filtered_data <= 0;
        delay_counter <= 0; // Reset counter during reset
    end 
    else begin  
        for (i = 3; i > 0; i = i - 1) begin
            delay_line[i] <= delay_line[i - 1];
        end
        delay_line[0] <= data_in;

        filtered_data <= delay_line[0] * coefficients[0] +
                         delay_line[1] * coefficients[1] +
                         delay_line[2] * coefficients[2] +
                         delay_line[3] * coefficients[3];
    end
end

endmodule

