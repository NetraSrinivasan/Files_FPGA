`timescale 1ns / 1ns

module mux(input clk, input rst, input logic [7:0]arr[0:14], output logic [7:0]data, output logic [3:0]row);
    reg [3:0]index;
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            index <= 0;
        end
        else begin
            data <= arr[index];
            row <= index;
            index <= (index== 14)? 0 : index + 1;
        end
    end
endmodule 

module bsort(clk, rst, data, row);
    input clk, rst;
    parameter size = 15;
    logic [7:0]arr[0:size-1];
    output logic [7:0]data;
    output logic [3:0]row;
    logic [7:0]temp;
    logic [7:0]lfsr;
    logic [6:0]index;
    integer i;
    integer j;
    logic [7:0]mem[0:size-1];
    logic sorting_done, init_done;
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin 
            lfsr <= 8'b11010101;
            index <= 0;
            i <= 0;
            j <= 0;
            init_done <= 0;
            sorting_done <= 0;
            for(int k = 0; k<size; k++)
                mem[k] <= 8'b0;
        end
        else if(!init_done) begin
            lfsr <= {lfsr[6:0], lfsr[7]^lfsr[5]^lfsr[4]^lfsr[3]};
            mem[index] <= lfsr;
            if(index == size-1) begin
                index <= 0;
                init_done <= 1;
                i <= 0;
                j <= 0;
            end
            else begin
                index <= index+1; 
            end
        end 
        else if(!sorting_done) begin
            if(i< size-1) begin
                if(j < size-1-i) begin
                    if(mem[j] > mem[j+1]) begin
                        temp = mem[j];
                        mem[j] = mem[j+1];
                        mem[j+1] = temp;
                    end
                    j <= j+1;
                end
                else if(j >= size-1-i)begin
                    j <= 0;
                    i <= i+1;
                end
            end
            else begin
                sorting_done <= 1;
            end
        end
    end
    always@(posedge clk) begin
        for(int k = 0; k < size; k++) 
            arr[k] = mem[k];
    end
    mux uut (.clk(clk), .rst(rst), .arr(arr), .data(data), .row(row));
endmodule