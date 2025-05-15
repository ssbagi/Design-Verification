class environment;
generator gen;
driver drv;
monitor mon;
scoreboard sco;
 
mailbox gdmbx, msmbx;
 
virtual simple_processor_intf vif;
event gddone,msdone;
 
function new(mailbox gdmbx, mailbox msmbx,virtual simple_processor_intf vif);
this.gdmbx = gdmbx;
this.msmbx = msmbx;
this.vif = vif;
gen = new(vif,gdmbx);
drv = new(vif,gdmbx);
mon = new(vif,msmbx);
sco = new(vif,msmbx);
endfunction
 
task main();

gen.done = gddone;
drv.done = gddone;
mon.done = msdone;
sco.done = msdone; 

drv.vif = vif;
mon.vif = vif;

fork
gen.main();
drv.main();
mon.run();
sco.run();
join_any
endtask
endclass