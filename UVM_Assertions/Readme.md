# Assertions

Assertions are primarily used to validate the behavior of a design. An assertion is a check embedded in design or bound to a design unit during the simulation. Warnings or errors are generated on the failure of a specific condition or sequence of events.

Assertions Types :
- Immediate Assertion    : Check for the condition at the current simulation time.  
- Concurrent Assertion   : Check the sequence of events spread over multiple clock cycles.

## Sequences
Boolean expression events that evaluate over a period of time involving single/multiple clock cycles. SVA provides a keyword to represent these events called “sequence”.

## Implication Operator
|->  : Overlapped Assertion
|=>  : Non-Overlapped Assertion

## Examples 

### Normal Example 
Link : https://github.com/ssbagi/Design-Verification/blob/main/UVM_Assertions/assertion_examples.svh

### APB Protocol Assertion
Link : https://github.com/ssbagi/Design-Verification/blob/main/UVM_APB_AGENT_INFRASTRUCTURE/Interface/cfs_apb_if.sv




