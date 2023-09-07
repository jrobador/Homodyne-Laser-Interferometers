function [longitud] = optimal_counter_test_a_tan2(x,y)
counter = 0;
    for i = 1:1:length(y)
        if i<20
            y_mem(1:4) = 0;
        else 
            y_mem = y(i-3:i-1);
        
        if(all(y_mem >= 0) || all(y_mem < 0))
            if x(i) >= 0
                if (y_mem(end) < 0 && y(i) >= 0)
                    counter = counter + 1;
                    counter_add = 1;
                end
                if (y_mem(end) > 0 && y(i) <= 0)
                    counter = counter - 1;
                    counter_add = -1;

                end                
            end
        else
            if(y_mem(end) < 0 && y(i) >= 0)
                counter = counter + counter_add;
            end
        end
        end
    end
   
   if (x(1) > 0 && y(1) >= 0)
       phi_t0 = atan (y(1)/x(1));
   end
       
   if (x(1) <= 0 && y(1) > 0)
       phi_t0 = atan (y(1)/x(1)) + pi;
   end
   
   if (x(1) < 0 && y(1) <= 0)
       phi_t0 = atan (y(1)/x(1)) + pi;
   end
   
   if (x(1) >= 0 && y(1) < 0)
       phi_t0 = atan (y(1)/x(1)) + 2*pi;
   end
   
   if (x(end) > 0 && y(end) >= 0)
       phi_t1 = atan (y(end)/x(end)) + 2 * pi * counter;
   end
       
   if (x(end) <= 0 && y(end) > 0)
       phi_t1 = atan (y(end)/x(end)) + pi + 2 * pi * counter;
   end
   
   if (x(end) < 0 && y(end) <= 0)
       phi_t1 = atan (y(end)/x(end)) + pi + 2 * pi * counter;
   end
   
   if (x(end) >= 0 && y(end) < 0)
       phi_t1 = atan (y(end)/x(end)) + 2*pi + 2 * pi * counter;
   end   

   
   longitud = 550e-9/(4*pi) * (phi_t1-phi_t0);
end
    