# Coverage

The Coverage consists of : 

## Code coverage :
- To identify what code has been (and more importantly not been) executed in the design under verification.
- The objective of code coverage is to determine if you have forgotten to exercise some code in the design.
- How much of the implementation has been exercised.
  - Statement coverage or Block coverage :
    - Statement, line or block coverage measures how much of the total lines of code were executed by the verification suite. 
  - Path coverage :
    - To measure all possible ways you can execute a sequence of statements.
    - There is more than one way to execute a sequence of statements.
  - Expression coverage :
    - To measure the various ways decisions through the code are made.
  - FSM coverage :
    - Each state in an FSM is usually explicitly coded using a choice in a case statement, any unvisited state will be clearly identifiable through uncovered statements.

## Functional coverage :
- Functional coverage records relevant metrics (e.g., packet length, instruction opcode, buffer occupancy level) to ensure that the verification process has exercised the design through all of the interesting values.
- How much of the original design specification has been exercised.






