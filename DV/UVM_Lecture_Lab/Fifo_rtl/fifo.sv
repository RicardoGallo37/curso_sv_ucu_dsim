//////////////////////////////////////////
// FIFO DUT
//////////////////////////////////////////
module fifo #(parameter DEPTH = 4, WIDTH = 8) (
    input  logic               clk, rst_n,
    input  logic               wr_en, rd_en,
    input  logic [WIDTH-1:0]   din,
    output logic [WIDTH-1:0]   dout,
    output logic               full, empty
);
    logic [WIDTH-1:0] mem [DEPTH-1:0];
    logic [$clog2(DEPTH):0] wptr, rptr;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) wptr <= 0;
        else if (wr_en && !full) begin
            mem[wptr] <= din;
            wptr <= wptr + 1;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) rptr <= 0;
        else if (rd_en && !empty) begin
            dout <= mem[rptr];
            rptr <= rptr + 1;
        end
    end

    assign full  = (wptr - rptr) == DEPTH;
    assign empty = (wptr == rptr);
endmodule