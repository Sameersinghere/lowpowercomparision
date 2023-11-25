module dvs_15tap(
    input clk,
    input reset,
    input signed [15:0] s_axis_fir_tdata, 
    input [3:0] s_axis_fir_tkeep,
    input s_axis_fir_tlast,
    input s_axis_fir_tvalid,
    input m_axis_fir_tready,
    output reg m_axis_fir_tvalid,
    output reg s_axis_fir_tready,
    output reg m_axis_fir_tlast,
    output reg [3:0] m_axis_fir_tkeep,
    output reg signed [31:0] m_axis_fir_tdata,
    output reg voltage_select
);

    // Your original buffer, multiply, and accumulate logic 
    reg LOW_VOLTAGE, MEDIUM_VOLTAGE, HIGH_VOLTAGE, MAX_VOLTAGE;
    reg signed [15:0] in_sample; 
    reg signed [15:0] buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14; 
    wire signed [15:0] tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14; 
    reg signed [31:0] acc0, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14; 
    // ... (Same logic as the one provided in your initial FIR filter)
    
assign tap0 = 16'hFC9C;  // twos(-0.0265 * 32768) = 0xFC9C
    assign tap1 = 16'h0000;  // 0
    assign tap2 = 16'h05A5;  // 0.0441 * 32768 = 1445.0688 = 1445 = 0x05A5
    assign tap3 = 16'h0000;  // 0
    assign tap4 = 16'hF40C;  // twos(-0.0934 * 32768) = 0xF40C
    assign tap5 = 16'h0000;  // 0
    assign tap6 = 16'h282D;  // 0.3139 * 32768 = 10285.8752 = 10285 = 0x282D
    assign tap7 = 16'h4000;  // 0.5000 * 32768 = 16384 = 0x4000
    assign tap8 = 16'h282D;  // 0.3139 * 32768 = 10285.8752 = 10285 = 0x282D
    assign tap9 = 16'h0000;  // 0
    assign tap10 = 16'hF40C; // twos(-0.0934 * 32768) = 0xF40C
    assign tap11 = 16'h0000; // 0
    assign tap12 = 16'h05A5; // 0.0441 * 32768 = 1445.0688 = 1445 = 0x05A5
    assign tap13 = 16'h0000; // 0
    assign tap14 = 16'hFC9C; // twos(-0.0265 * 32768) = 0xFC9C
    // Additional DVS Logic:
    reg [1:0] performance_level;  // 00: Low, 01: Medium, 10: High, 11: Max
    always @(posedge clk or posedge reset) begin
        if (reset) 
            performance_level <= 2'b00;  // Default to low
        else begin
            // Placeholder logic: Adjust as per actual performance/load metric
            if (s_axis_fir_tvalid)
                performance_level <= performance_level + 1;
            else
                performance_level <= performance_level - 1;
        end
    end

    // Based on performance level, select voltage
    always @(performance_level) begin
        case(performance_level)
            2'b00: voltage_select <= LOW_VOLTAGE; 
            2'b01: voltage_select <= MEDIUM_VOLTAGE; 
            2'b10: voltage_select <= HIGH_VOLTAGE; 
            2'b11: voltage_select <= MAX_VOLTAGE; 
        endcase
    end
    
    // ... Rest of your FIR filter logic ...

    // Circular buffer for input samples
    always @(posedge clk) begin
        if (reset) begin
            buff0 <= 0; buff1 <= 0; //... initialize all buffers to 0
        end else begin
            buff0 <= s_axis_fir_tdata;
            buff1 <= buff0;
            //... (and so on for all buffers)
        end
    end

    // Multiply stage of FIR 
    always @(posedge clk) begin
        acc0 <= tap0 * buff0;
                    acc1 <= tap1 * buff1;
                    acc2 <= tap2 * buff2;
                    acc3 <= tap3 * buff3;
                    acc4 <= tap4 * buff4;
                    acc5 <= tap5 * buff5;
                    acc6 <= tap6 * buff6;
                    acc7 <= tap7 * buff7;
                    acc8 <= tap8 * buff8;
                    acc9 <= tap9 * buff9;
                    acc10 <= tap10 * buff10;
                    acc11 <= tap11 * buff11;
                    acc12 <= tap12 * buff12;
                    acc13 <= tap13 * buff13;
                    acc14 <= tap14 * buff14;
        //... (and so on for all accumulators)
    end

    // Accumulate stage of FIR 
    always @(posedge clk) begin
        m_axis_fir_tdata <= acc0 + acc1 + acc2 + acc3 + acc4 + acc5 + acc6 + acc7 + acc8 + acc9 + acc10 + acc11 + acc12 + acc13 + acc14;
    end 

endmodule
