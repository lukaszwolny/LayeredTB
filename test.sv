`include "enviroment.sv"
program test(acc_if vif);
  environment env;
  initial 
  begin
    env = new(vif);
    env.gen.repeat_count = 20;
    env.run();
  end
endprogram