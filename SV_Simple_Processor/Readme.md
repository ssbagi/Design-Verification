# Simple-Processor
A digital system that contains a number of 9-bit registers, a multiplexer, an adder/subtractor  unit, and a control unit (finite state machine). Data is input to this system via the 9-bit DIN 
input. This data can be loaded through the 9-bit wide multiplexer into the various registers, such as R0,….R7 and A. The multiplexer also allows data to be transferred from one register to another. The multiplexer’s output wires are called a bus in the figure because this term is often used for wiring that allows data to be transferred from one location in a system to another. Addition or subtraction is performed by using the multiplexer to first place one 9-bit number onto the bus wires and loading this number into register A. Once this is done, a second 9-bit number is placed onto the bus, the adder/subtractor unit performs the required operation, and the result is loaded into register G. The data in G can then be transferred to one of the other registers as required. 
 
The system can perform different operations in each clock cycle, as governed by the control unit. This unit determines when particular data is placed onto the bus wires and it controls which of the registers is to be loaded with this data? For example, if the control unit asserts the signals R0out and Ain, then the multiplexer will place the contents of register R0 onto the bus and this data will be loaded by the next active clock edge into register A. A system like this is often called a processor. It executes operations specified in the form of instructions. 
 
Table below lists the instructions that the processor has to support for this exercise. The left column shows the name of an instruction and its operand. The meaning of the syntax Rx [Ry] is that the contents of register Ry are loaded into register Rx. The mv (move) instruction allows data to be copied from one register to another. For the mvi (move immediate) instruction the expression Rx D indicates that the 9-bit constant D is loaded into register Rx. 

The Basic Instructions performed in the processor.
![image](https://github.com/user-attachments/assets/4e5938a8-b0fa-4fe5-8559-314c662bf4bd)

Each instruction can be encoded and stored in the IR register using the 9-bit format IIIXXXYYY, where III represents the instruction, XXX gives the Rx register, and YYY gives the Ry register. Although only two bits are needed to encode our four instructions, we are using three bits because other instructions will be added to the processor in later parts of this exercise. Instructions are loaded from an external source; hence IR has to be connected to the nine bits of the DIN input, as indicated in Figure 1. For the mvi instruction the YYY field has no meaning, and the immediate data #D has to be supplied on the 9-bit DIN input after the mvi instruction word is stored into IR. Some instructions, such as an addition or subtraction, take more than one clock cycle to complete, because multiple transfers have to be performed across the bus. The finite state machine in the control unit “steps through” such instructions, asserting the control signals needed in successive clock cycles until the instruction has completed. The processor starts executing the instruction on the DIN input when the Run signal is asserted and the processor asserts the Done output when the instruction is finished. 

The Control signals asserted in each Instruction/time step
![image](https://github.com/user-attachments/assets/c8eede0a-8723-42a7-ae4d-ac84ad0b5a93)

Architecture design of Simple Processor : 
![image](https://github.com/user-attachments/assets/d2aad673-2313-40d4-9f86-23676543df91)

Block Diagram of Datapath :
![image](https://github.com/user-attachments/assets/42e7941b-ad36-46e1-b453-b415e9fc2e63)

Block Diagram of Adder and Subtractor :
![image](https://github.com/user-attachments/assets/7ab88148-a216-46e3-a54e-58fc4861b2bb)

The FSM Logic Block design :
![FSM_UPDATED_PHOTO](https://github.com/user-attachments/assets/2b1c79e0-377e-4c2f-88fc-deb9a53d8346)

During College days we developed small project on Simple Basic Processor in order to explore the ASIC Flow using Synopsys Tools. The Project flow from RTL, Verfication, Logic Synthesis, Physical synthesis, Physical Design, STA, PV and Final GDS files were generated. The documentation of the flow, results and reports are all attached in this Git. 

LAB Documents       : https://github.com/ssbagi/Simple-Processor/tree/main/LAB%20Documents

Design Folder       : https://github.com/ssbagi/Design-Verification/tree/main/SV_Simple_Processor/Design

Verification Folder : https://github.com/ssbagi/Design-Verification/tree/main/SV_Simple_Processor/Verification

