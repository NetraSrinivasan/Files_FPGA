`timescale 1ns / 1ns
module testbench;

    logic clk, rst;
    parameter size = 15;
    logic [7:0]data;
    logic [3:0]row;
    //logic [7:0]arr[0:size-1];
    //logic [6:0]select_index;
    integer i = 0;
    integer start_time, end_time, exec_time;
    real throughput_per_second;
  
    bsort dut(clk, rst, data, row);
    always #5 clk = ~clk;
    
    initial begin
      	//$dumpfile("file.vcd");
      	//$dumpvars(1);	
      	//btn_up = 0;
      	//btn_down = 0;
        clk = 0;
        rst = 1;
        #25 rst = 0;
        
        start_time = $time;
        //#(10*size) $display("Array before sorting : ");
        //for(i = 0; i<size; i++) 
          //  #20 $write("%d\t", arr[i]);
        //$display("\n");
        
        wait(dut.sorting_done);
//        $display("Array after sorting : ");
//        for(i = 0; i<size; i++) 
//            $write("%d\t", arr[i]);
//        $display("\n");
        
        end_time = $time;
        exec_time = end_time - start_time;
        //$display("Execution time : %0t",exec_time);
      
      throughput_per_second = (size*1.0e9) / exec_time; 

      $display("Throughput: %0f per second", throughput_per_second);
        $finish;
    end
endmodule