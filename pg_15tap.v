module pg_15tap( 
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
    output reg voltage_select,
    input power_enable 
);

    // Register and wire declarations
    reg [15:0] buff[14:0];
    wire signed [15:0] tap[14:0];
    reg signed [31:0] acc[14:0];
    reg [1:0] performance_level = 2'b00;  // 00: Low, 01: Medium, 10: High, 11: Max

// Voltage definitions
parameter LOW_VOLTAGE = 1'b0;       // Define your actual voltage values or levels here.
parameter MEDIUM_VOLTAGE = 1'b1;    // Placeholder values for demonstration.
parameter HIGH_VOLTAGE = 1'b0;      // You can adjust these based on your application.
parameter MAX_VOLTAGE = 1'b1;

    assign tap[0] = 16'hFC9C;
    assign tap[1] = 16'h0000;
    assign tap[2] = 16'h05A5;
    //... (continue for all taps)

    reg logic_enabled;

    always @(posedge clk or posedge reset) begin
        if (reset)
            logic_enabled <= 1'b0;
        else
            logic_enabled <= power_enable;
    end

    always @(posedge clk) begin
        if (reset || !logic_enabled) begin
            buff[0] <= 0; 
            buff[1] <= 0; 
            //... (initialize all buffers to 0)
        end else if(logic_enabled) begin
            buff[0] <= s_axis_fir_tdata;
            buff[1] <= buff[0];
            //... (and so on for all buffers)
        end
    end

    always @(posedge clk) begin
        if(logic_enabled) begin
            acc[0] <= tap[0] * buff[0];
            acc[1] <= tap[1] * buff[1];
            // ... (rest of your accumulator logic)
        end
    end

    always @(posedge clk) begin
        if(logic_enabled) begin
            m_axis_fir_tdata <= acc[0] + acc[1] + acc[2] ; //... (and so on for all accumulators)
        end
    end 

    // Handling output and other logic
    always @(posedge clk) begin
        if(logic_enabled) begin
            if(s_axis_fir_tvalid) begin
                s_axis_fir_tready <= 1;
                m_axis_fir_tvalid <= 1;
                m_axis_fir_tlast <= s_axis_fir_tlast;
                m_axis_fir_tkeep <= s_axis_fir_tkeep;
            end else begin
                s_axis_fir_tready <= 0;
                m_axis_fir_tvalid <= 0;
            end
        end else begin
            s_axis_fir_tready <= 0;
            m_axis_fir_tvalid <= 0;
        end
    end

    // Voltage select logic based on performance level (as an example, details need to be filled)
    always @(posedge clk) begin
        if(logic_enabled) begin
            // Example voltage selection logic
            case(performance_level)
                2'b00: voltage_select <= LOW_VOLTAGE;
                2'b01: voltage_select <= MEDIUM_VOLTAGE;
                2'b10: voltage_select <= HIGH_VOLTAGE;
                2'b11: voltage_select <= MAX_VOLTAGE;
                default: voltage_select <= LOW_VOLTAGE;
            endcase
        end
    end

endmodule
