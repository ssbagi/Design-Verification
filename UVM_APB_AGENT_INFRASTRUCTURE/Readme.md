# UVM APB AGENT Infrastructure

The Verification of APB using UVM Methodology. 

Understanding the APB Protocol referred the ARM Document and ARM SoC Book. Reference Links 
1. ARM SoC Book         : https://www.arm.com/resources/education/books/fundamentals-soc
2. ARM Modern SoC Book  : https://www.arm.com/resources/education/books/modern-soc
3. ARM APB Protocol     : https://developer.arm.com/documentation/ihi0024/latest/

# Udemy Course
- Course Name  : Unveiling UVM in SystemVerilog language: From Building UVM Agents to Functional Coverage and Debugging Techniques
- Link         : https://www.udemy.com/course/design-verification-with-systemverilog-uvm/

# APB Protocol 
- Usage for **low throughput** completer devices.
- The peripherals and register based interface.
- Used for **single-beat transfers** and completer-side backpressure. The low-performance devices.
- The completers handle a **single in-flight transfer one at time**, with **no overlap between transfers i.e., no pipelinin**g.
- Every transfer is handled over multiple clock cycles and bus throughput reduced accordingly. 


![image](https://github.com/user-attachments/assets/1ac93e88-b81b-4bc2-8eeb-18769038a18b)


![image](https://github.com/user-attachments/assets/56ef8f88-493e-4d48-95b7-ff5f68c74c67)


# APB FSM

![image](https://github.com/user-attachments/assets/1f8f14ca-f0b5-45bf-9378-add4ee5de27a)

![image](https://github.com/user-attachments/assets/a8552f2f-1659-40ae-a144-391945321e7a)

![image](https://github.com/user-attachments/assets/7cb47662-2daa-4385-aa7b-de8a4c2d6037)


# Basic Read Transfer

![image](https://github.com/user-attachments/assets/9b2ae235-164e-4498-a05c-f1979c75a3ee)

- When we want to read data we move into SETUP State (PSEL = 0 to PSEL = 1). During this time we send the Address and PWRITE = 0. Refer the TIME = T1.
- Next we move to ACCESS State (PSEL = 1 and PENABLE = 1). Since APB is single beat transfer and move to IDLE state at TIME = T3.
- Then Again IDLE -> SETUP -> ACCESS.
- At time T5 we observe the  PREADY = 0. Holding in the ACCESS state. At time T6 we make PREADY = 1 and get the data. Then move to IDLE state.

# Write Transfer

![image](https://github.com/user-attachments/assets/1421182d-3f93-4586-a147-137344bf0b92)

- This is aslo similar to Read Transfer.
- During Setup State PSEL = 1 ----> PADDR = Address, PWDATA = Data and PWRITE = 1. Then we move to Access state by PENABLE = 1.
- APB is single beat transfer we send the data to Slave. Then move back to IDLE state.
- IDLE --> SETUP --> ACCESS --> ACCESS(PREADY = 0)/SETUP(PREADY = 1 and PENABLE = 0)/IDLE(PSEL = 0 and PREADY = 0). The cycle continues. 

# Low Power Version
- As we know static and dynamic power consumption.
- Due to switching activity we have dynamic power consumption. Hence, we try to keep the PADDR, PWDATA and PRDATA same state. Even PWRITE also.
- The PSEL and PENABLE used to inform the completer when PWRITE is valid.
- The APB protocol replaces multi-bit switching between transfers with two single-bit switching operation on the PSEL and PENABLE signals. 

![image](https://github.com/user-attachments/assets/0b9e74f2-3310-4168-acc6-7513a1963131)

# Transfers Responses
The response comes in the ACCESS state only. The PSLVERR signal notifies response state from the Target device. PSEL, PENABLE and PREADY are all set to 1. 
PSLVERR 
0 : Valid
1 : Invalid. Slave Error.

# APB Assertion Rules 

![image](https://github.com/user-attachments/assets/0a074ba4-897c-4040-ac17-780a5e05ec17)

# APB Protocol Checks

