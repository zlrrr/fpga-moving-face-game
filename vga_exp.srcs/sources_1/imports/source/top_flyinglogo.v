	`timescale 1 ns / 1 ns


module top_flyinglogo(clk, rst, hsync, vsync, vga_r, vga_g, vga_b,left,right,up,down,speed1,speed2,speed3,speed4);
input           clk;
input           rst;
input           left;
input           right;
input           up;
input           down;
input           speed1;
input           speed2;
input           speed3;
input           speed4;

output          hsync;
output          vsync;
output [3:0]    vga_r;
output [3:0]    vga_g;
output [3:0]    vga_b;


wire            pclk;
wire            valid;
wire [9:0]      h_cnt;
wire [9:0]      v_cnt;
reg [11:0]      vga_data;

reg [13:0]      rom_addr;
reg [15:0]      rom_addr2;
reg [15:0]      rom_addr3;

wire [11:0]      douta;
wire [11:0]      douta2;
wire [11:0]      douta3;

wire            logo_area;
wire            wall_area1;
wire            wall_area2;
wire            wall_area3;
wire            wall_area4;
wire            ball_area1;
wire            area;
wire            target_area;

wire            die_logo_area;
wire            win_logo_area;

wire            block_area1;
wire            block_area2;
wire            block_area3;

reg [1:0]       die;
reg [1:0]       win;
reg [9:0]       logo_x;
reg [9:0]       logo_y;
reg [9:0]       block_x1;
reg [9:0]       block_y1;
reg [9:0]       block_x2;
reg [9:0]       block_y2;
reg [9:0]       block_x3;
reg [9:0]       block_y3;
parameter [9:0] logo_length = 10'b0001100100;
parameter [9:0] logo_hight  = 10'b0001100100;

parameter [9:0] block_length = 10'b0000010100;
parameter [9:0] block_hight  = 10'b0000010100;

parameter [9:0] die_length = 200;
parameter [9:0] die_hight  = 200;

parameter [9:0] win_length = 250;
parameter [9:0] win_hight  = 131;

parameter [9:0] die_x = 220;
parameter [9:0] die_y  = 140;

parameter [9:0] win_x = 195;
parameter [9:0] win_y  = 175;

parameter [9:0] ball_x  = 10'b0110111000;
parameter [9:0] ball_y  = 10'b0001010000;
parameter [9:0] ball_r  = 10'b0000010100;

reg [9:0]    move_speed;
reg [9:0]    block_speed;

reg [7:0]       speed_cnt;
wire            speed_ctrl;

dcm_25m u0
     (
     // Clock in ports
      .clk_in1(clk),      // input clk_in1
      // Clock out ports
      .clk_out1(pclk),     // output clk_out1
      // Status and control signals
      .resetn(rst));   

smile_rom u11 (
      .clka(pclk),    // input wire clka
      .addra(rom_addr),  // input wire [13 : 0] addra
      .douta(douta)  // output wire [11 : 0] douta
    );   

win_rom u12 (
      .clka(pclk),    // input wire clka
      .addra(rom_addr2),  // input wire [15 : 0] addra
      .douta(douta2)  // output wire [11 : 0] douta
    ); 

die_rom u13 (
      .clka(pclk),    // input wire clka
      .addra(rom_addr3),  // input wire [15 : 0] addra
      .douta(douta3)  // output wire [11 : 0] douta
    ); 	

vga_640x480 u2 (
    .pclk(pclk), 
    .reset(rst), 
    .hsync(hsync), 
    .vsync(vsync), 
    .valid(valid), 
    .h_cnt(h_cnt), 
    .v_cnt(v_cnt)
    );

//assign area = ((v_cnt <= v_total) & (v_cnt >= 10'b0000000001) & (h_cnt <= h_total) & (h_cnt >= 10'b0000000001)) ? 1'b1 : 1'b0;
	
assign logo_area = ((v_cnt >= logo_y) & (v_cnt <= logo_y + logo_hight - 1) & (h_cnt >= logo_x) & (h_cnt <= logo_x + logo_length - 1)) ? 1'b1 : 
                  1'b0;
                  
assign wall_area1 =  ((v_cnt <= 10'b0000101000) & (v_cnt >= 10'b0000010100) & (h_cnt <= 10'b1001101100) & (h_cnt >= 10'b0000010100)) ? 1'b1 : 
                                    1'b0;
assign wall_area2 =  ((v_cnt <= 10'b0110111000) & (v_cnt >= 10'b0000101000) & (h_cnt <= 10'b0000101000) & (h_cnt >= 10'b0000010100)) ? 1'b1 : 
                                                                        1'b0;
assign wall_area3 =  ((v_cnt <= 10'b0110111000) & (v_cnt >= 10'b0000101000) & (h_cnt <= 10'b1001101100) & (h_cnt >= 10'b1001011000)) ? 1'b1 : 
                                                                                                            1'b0;
assign wall_area4 =  ((v_cnt <= 10'b0111001100) & (v_cnt >= 10'b0110111000) & (h_cnt <= 10'b1001101100) & (h_cnt >= 10'b0000010100)) ? 1'b1 : 
                                                                                                                     1'b0;
//assign ball_area1 = ((h_cnt - ball_x)*(h_cnt - ball_x) + (v_cnt - ball_y)*(v_cnt - ball_y) <= (ball_r * ball_r)) ? 1'b1 : 
                                                                              //                                       1'b0;   
																													 
assign block_area1 =  ((v_cnt >= block_y1) & (v_cnt <= block_y1 + block_hight - 1) & (h_cnt >= block_x1) & (h_cnt <= block_x1 + block_length - 1)) ? 1'b1 : 
                  1'b0;	

assign block_area2 =  ((v_cnt >= block_y2) & (v_cnt <= block_y2 + block_hight - 1) & (h_cnt >= block_x2) & (h_cnt <= block_x2 + block_length - 1)) ? 1'b1 : 
                  1'b0;	

assign block_area3 =  ((v_cnt >= block_y3) & (v_cnt <= block_y3 + block_hight - 1) & (h_cnt >= block_x3) & (h_cnt <= block_x3 + block_length - 1)) ? 1'b1 : 
                  1'b0;									
      
assign target_area = ((v_cnt <= 250) & (v_cnt >= 230) & (h_cnt <= 580) & (h_cnt >= 560)) ? 1'b1 : 1'b0;

assign die_logo_area = ((v_cnt >= die_y) & (v_cnt <= die_y + die_hight - 1) & (h_cnt >= die_x) & (h_cnt <= die_x + die_length - 1)) ? 1'b1 : 
                  1'b0;
				
assign win_logo_area = ((v_cnt >= win_y) & (v_cnt <= win_y + win_hight - 1) & (h_cnt >= win_x) & (h_cnt <= win_x + win_length - 1)) ? 1'b1 : 
                  1'b0;				
	  
always @(negedge rst or posedge pclk)
begin: logo_display
  if (rst == 1'b0)
    begin
     vga_data <= 12'b111111111111;
	 die <=  2'b00;
	 win <=  2'b00;
	end
  else 
  begin
     if (valid == 1'b1)
     begin
		if(win == 2'b01 & win_logo_area == 1'b1)	//显示胜利时的rom图像
		begin
			//move_speed <= 9'b000000000;
			//block_speed <= 9'b000000000;
		   rom_addr2 <= rom_addr2 + 16'b0000000000000001;
           vga_data <= douta2;
		end
		else if(die == 2'b01 & die_logo_area == 1'b1)	//显示失败时的rom图像
		begin
			//move_speed <= 9'b000000000;
			//block_speed <= 9'b000000000;
			rom_addr3 <= rom_addr3 + 16'b0000000000000001;
            vga_data <= douta3;
		end
        else if (logo_area == 1'b1)
        begin
           rom_addr <= rom_addr + 14'b00000000000001;
           vga_data <= douta;
		   if(target_area == 1'b1)	//logo的区域接触到目标方块的区域时判定胜利
				begin
					win <= 2'b01;		
				end
			else if((block_area1 == 1'b1) | (block_area2 == 1'b1) | (block_area3 == 1'b1))
								   //logo的区域接触到运动方块的区域时判定失败
				begin
					die <= 2'b01;
				end
        end
        else if((wall_area1 == 1'b1) | (wall_area2 == 1'b1) |(wall_area3 == 1'b1) |(wall_area4 == 1'b1))
        begin
             vga_data <= 12'b111111111111;
        end
        else if((block_area1 == 1'b1) | (block_area2 == 1'b1) | (block_area3 == 1'b1))
        begin
             vga_data <= 12'b000011111111;
        end
        else if(target_area == 1'b1)
        begin
             vga_data <= 12'b111100001111;
        end
		else
        begin
           rom_addr <= rom_addr;
		   if(win == 2'b01)
			rom_addr2 <= rom_addr2;
		   else if(die == 2'b01)
			rom_addr3 <= rom_addr3;  
           vga_data <= 12'b000000000000;
        end
     end
     else
     begin
        vga_data <= 12'b111111111111;
        if (v_cnt == 0)
		 begin
           rom_addr <= 14'b00000000000000;
		   if(win == 2'b01)
			rom_addr2 <= 16'b0000000000000000;
		   else if(die == 2'b01)
			rom_addr3 <= 16'b0000000000000000;  
		 end
     end
  end
end

assign vga_r = vga_data[11:8];
assign vga_g = vga_data[7:4];
assign vga_b = vga_data[3:0];

always @(negedge rst or posedge pclk)
begin: speed_control
   if (rst == 1'b0)
     speed_cnt <= 8'h00;
   else 
   begin
   if ((v_cnt[5] == 1'b1) & (h_cnt == 1))
     speed_cnt <= speed_cnt + 8'h01;
   end
end

debounce u3(.sig_in(speed_cnt[5]), .clk(pclk), .sig_out(speed_ctrl)); 

always @(negedge rst or posedge pclk)
begin: speed_switch1
   if (rst == 1'b0)
     block_speed <= 1;
   else 
   begin
   if (speed1 == 1)		//拨码开关1的置1使得速度增加至3
   begin
	if(block_speed <= 3)
     block_speed <= block_speed + 1;
	else
	 block_speed <= block_speed;
   end
  else if (speed2 == 1)   //拨码开关2的置1使得速度减少至1
     begin
	if(block_speed >= 2)
     block_speed <= block_speed - 1;
	else
	 block_speed <= block_speed;
   end
   end
end

always @(negedge rst or posedge pclk)
begin: speed_switch2
   if (rst == 1'b0)
     move_speed <= 1;
   else 
   begin
   if (speed3 == 1)
   begin
	if(move_speed <= 5)
     move_speed <= move_speed + 1;
	else
	 move_speed <= move_speed;
   end
  else if (speed4 == 1)
     begin
	if(move_speed >= 2)
     move_speed <= move_speed - 1;
	else
	 move_speed <= move_speed;
   end
   end
end

always @(negedge rst or posedge pclk)
begin: move_smile
  if (rst == 1'b0)
  begin
     logo_x <= 10'b0010000000;
     logo_y <= 10'b0010000000;
  end
  else 
  begin
   if (speed_ctrl == 1'b1 & die == 1'b0 & win == 1'b0)		
					//只有在胜利和失败条件都未触发的情况下才允许logo移动
   begin
           if(left)
					if(logo_x >= 10'b0000101000)	//向左在围墙边界内移动
                    begin
					//	logo_x <= (logo_x - move_speed + 10'b1010000000 ) % 10'b1010000000;
						logo_x <= logo_x - move_speed ;
                        logo_y <=  logo_y;    
                    end    
					else
					begin
						logo_x <=  logo_x;  
                        logo_y <=  logo_y;
					end
          else if(right)    
					if(logo_x <= 10'b1001011000 - logo_length)	//向右在围墙边界内移动
                    begin
                     //  logo_x <= (logo_x + move_speed ) % 10'b1010000000;  
					   logo_x <= logo_x + move_speed ; 
					   logo_y <=  logo_y;  
                    end
					else
					begin
						logo_x <=  logo_x;  
                        logo_y <=  logo_y;
					end
          else if(down)
					if(logo_y <= 10'b0110111000 - logo_hight)  //向下在围墙边界内移动
                     begin
                     //   logo_y <= (logo_y + move_speed ) % 10'b0111100000;
						logo_y <= logo_y + move_speed;
                        logo_x <=  logo_x;                 
                     end
					 else
					begin
						logo_x <=  logo_x;  
                        logo_y <=  logo_y;
					end
          else if(up)
					if(logo_y >= 10'b0000101000)			//向上在围墙边界内移动
                     begin
                     //   logo_y <= (logo_y - move_speed + 10'b0111100000 ) % 10'b0111100000;
						logo_y <= logo_y - move_speed ;
                        logo_x <=  logo_x;
                     end
					 else
					begin
						logo_x <=  logo_x;  
                        logo_y <=  logo_y;
					end
   end
  end
end

always @(negedge rst or posedge pclk)
begin: move_block1
  reg		flag; 
  if (rst == 1'b0)
  begin
     block_x1 <= 280;
     block_y1 <= 80;
	 flag <= 1'b0;
  end
  else 
  begin
   if (speed_ctrl == 1'b1 & die == 1'b0 & win == 1'b0)
			//只有在胜利和失败条件都未触发的情况下才允许方块移动
   begin
           if(block_y1 >= 350)		
                   flag <= 1'b1;
		   else if(block_y1 <= 80)
				   flag <= 1'b0;		//触发改变方向的flag
			
			
		   case(flag)				
		   1'b0 :
                     begin
						block_y1 <=  block_y1 + block_speed;
                        block_x1 <=  block_x1;
                     end
		   1'b1 :
					 begin
						block_x1 <=  block_x1;
                        block_y1 <=  block_y1 - block_speed;
                     end
		   endcase
   end
  end
end

always @(negedge rst or posedge pclk)
begin: move_block2
  reg		flag2; 
  if (rst == 1'b0)
  begin
     block_x2 <= 60;
     block_y2 <= 260;
	 flag2 <= 1'b0;
  end
  else 
  begin
   if (speed_ctrl == 1'b1 & die == 1'b0 & win == 1'b0)
   begin
           if(block_x2 >= 520)
                   flag2 <= 1'b1;
		   else if(block_x2 <= 60)
				   flag2 <= 1'b0;
			
			
		   case(flag2)
		   1'b0 :
                     begin
						block_x2 <=  block_x2 + block_speed;
                        block_y2 <=  block_y2;
                     end
		   1'b1 :
					 begin
						block_x2 <=  block_x2 - block_speed;
                        block_y2 <=  block_y2;
                     end
		   endcase
   end
  end
end

always @(negedge rst or posedge pclk)
begin: move_block3
  reg		flag3; 
  if (rst == 1'b0)
  begin
     block_x3 <= 550;
     block_y3 <= 80;
	 flag3 <= 1'b0;
  end
  else 
  begin
   if (speed_ctrl == 1'b1 & die == 1'b0 & win == 1'b0)
   begin
           if(block_y3 >= 350)
                   flag3 <= 1'b1;
		   else if(block_y3 <= 80)
				   flag3 <= 1'b0;
			
			
		   case(flag3)
		   1'b0 :
                     begin
						block_y3 <=  block_y3 + block_speed;
                        block_x3 <=  block_x3;
                     end
		   1'b1 :
					 begin
						block_x3 <=  block_x3;
                        block_y3 <=  block_y3 - block_speed;
                     end
		   endcase
   end
  end
end

endmodule