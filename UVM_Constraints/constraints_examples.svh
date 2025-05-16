// Assertions
// Question 1
class packet;
    rand bit [32:0] addr;
    rand bit [32:0] data;
	
	constraint addr_within_range {addr inside {[1:100]};};
    constraint data_within_range {data inside {[25:500]};};
	
	constraint addr_range {addr > 0; addr < 101;};
	constraint data_range {data > 24; data < 501;};
	
endclass

module tb();
	packet p;
	
	initial begin
		p = new();
		repeat(10)
		begin
          assert(p.randomize()) else $error("Randomization Failed");
		  $display("[GENERATED] ADDR = %0d DATA = %0d", p.addr, p.data);
          #10;
		end
	end
	
endmodule

//Question2
class packet;
    rand bit [32:0] addr;
    rand bit [32:0] data;
	rand int arr[5];//Static Array
	
	constraint addr_within_range {addr inside {[1:100]};};
    constraint data_within_range {data inside {[25:500]};};
	
	constraint addr_range {addr > 0; addr < 101;};
	constraint data_range {data > 24; data < 501;};
	
	constraint arr_elem_gen { foreach(arr[i])
			if(i == 0)
				arr[i] == 1;
			else if (i < 4) 
				arr[i+1] == arr[i] + 10;
	}
	
endclass


// Question 3.
class packet_len;
	rand bit[31:0] pkt_len, data;
  constraint pkt_len_range {pkt_len inside {[1:50]};};
	constraint data_constraint_range {
		if (pkt_len < 25)
			data inside {[25:200]};
		else
			data inside {[50:500]};
	};

endclass

module tb();
	packet_len p;
	
	initial begin
		p = new();
        repeat(10) begin
          assert(p.randomize()) else $error("Randomization Failed");
          $display("[GENERATED] PACKET_LEN = %0d DATA = %0d", p.pkt_len, p.data);
          #10;
		end
	end
	
endmodule


//Question 4 : Pattern Genreation
//Pattern : 00000_11111 [Index 0 to 4 : 0 and Index 5 to 9 : 1]
class pattern_gen;
    rand bit[4:0] arr[10];
  	constraint arr_pattern { foreach(arr[i])
			if(i<5)
				arr[i] == 0;
			else
				arr[i] == 1;
	}
endclass


module tb();
	pattern_gen p;
	
	initial begin
		p = new();
        repeat(10) begin
          assert(p.randomize()) else $error("Randomization Failed");
          $display("[GENERATED] Array = %0p", p.arr);
          #10;
		end
	end
	
endmodule

//Question 5 : Pattern Genreation Multiples of 5. Size = 7.
class pattern_multiple_gen;
	rand bit[4:0] arr[7];
	constraint arr_pattern { foreach(arr[i])
		arr[i] == i * 5;
	}
endclass

module tb();
	pattern_gen p;
	
	initial begin
		p = new();
        repeat(10) begin
          assert(p.randomize()) else $error("Randomization Failed");
          $display("[GENERATED] Array = %0p", p.arr);
          #10;
		end
	end
	
endmodule


