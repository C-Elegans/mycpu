



module cpu(LED,clk);
	parameter NOP = 0,
	ADD = 1,
	SUB = 2,
	OR = 3,
	AND = 4,
	NOT = 5,
	XOR = 6,
	LSL = 7,
	LSR = 8,
	MOV = 9,
	CMP = 10,
	LDR = 11,
	STR = 12,
	PUSH = 13,
	POP = 14,
	JMP = 15;
	
	
	input clk;
	output [7:0]LED;
	reg [15:0]registers[8];
	wire [15:0]input_buffer;
	reg [1:0] state;
	reg [15:0] instruction;
	reg [3:0] opcode;
	reg [2:0] rd;
	reg [2:0] rs;
	reg [7:0] data;
	reg [3:0] flags;
	reg imm;
	reg [7:0] led;
	reg [15:0] data_1;
	reg [15:0] data_2;
	reg [7:0] data_address;
	wire [15:0] data_buffer;
	reg [15:0] write_buffer;
	reg wren_b;
	reg [15:0] shift_data;
	reg [3:0] shift_distance;
	wire [15:0] shift_buffer;
	reg direction;  //0 = left 1= right
	shift shifter(
		//.clock(clk),
		.data(shift_data),
		.direction(direction),
		.distance(shift_distance),
		.result(shift_buffer)
	);
	ram2 ram(
		.clock(clk),
		.address_a(registers[7][7:0]),   //program counter
		.q_a(input_buffer), 					//instruction read
		.wren_a(0),
		.address_b(data_address),
		.data_b(write_buffer),
		.q_b(data_buffer),
		.wren_b(wren_b)
	);
	
	always @(posedge clk)
	begin
		state = state + 1;
		if(state > 2) state = 0;
		case(state)
			0:	begin
					if(opcode == LDR)registers[rd] <= data_buffer;
					if(opcode == STR)wren_b <= 0;
					if(opcode == LSL)registers[rd] <= shift_buffer;
					if(opcode == LSR)registers[rd] <= shift_buffer;
					instruction <= input_buffer;
				end
			1:begin	//decode (sort of)
				imm <= instruction[0];
				opcode <= instruction[15:11];
				rd <= instruction[10:8];
				if(imm) data_2 <= instruction[8:1];
				else data_2 <= registers[instruction[7:5]];
				data_1 <= registers[rd];
				led <= data_2;
				end
			
			2:begin	//execute
				case(opcode)
					NOP: registers[rd] = data_1;
					ADD: registers[rd] = registers[rd] + data_2;
					SUB: registers[rd] = registers[rd] - data_2;
					OR:  registers[rd] = registers[rd] | data_2;
					AND: registers[rd] = registers[rd] & data_2;
					NOT: registers[rd] = !data_2;
					XOR: registers[rd] = registers[rd] ^ data_2;
					LSL: begin
						direction <= 0;
						shift_data <= data_1;
						shift_distance <= data_2;
						end
					LSR: begin
						direction <= 1;
						shift_data <= data_1;
						shift_distance <= data_2;
						end
					CMP:begin
						if(data_1 == data_2)flags <= 1;
						if(data_1 > data_2)flags <=2;
						if(data_1 < data_2)flags <=4;
					end
					LDR: data_address <= data_2;
					STR: begin
						data_address <= data_2;
						write_buffer <= data_1;
						wren_b <= 1;
						end
					MOV: registers[rd] = data_2;
					JMP: begin
						if(rd == 0)registers[7] = data_2 -1;
						else if(rd & flags[2:0])registers[7] = data_2 -1;
						else;
						end
					default: registers[rd] = data_1;
				endcase;
				registers[7] = registers[7] + 1;
				
				end
			
		endcase
	end
	
	assign LED = registers[6];
endmodule