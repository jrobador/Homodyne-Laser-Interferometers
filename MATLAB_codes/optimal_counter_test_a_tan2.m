function [longitud,counter_vector] = optimal_counter_test_a_tan2(x,y)
counter_vector(1:length(x)) = 0;
counter = 0;
mem_length = 3 ;
y_mem = 0;
    for i = 1:1:length(y)
        if i<=mem_length
            x_mem(1:mem_length) = 0;
        else 
            x_mem = x(i-mem_length:i-1);

            if (y_mem < 0 && y(i) >= 0)
                if(all(x_mem >= 0) || all(x_mem <= 0))
                    if x(i) >= 0
                        counter = counter + 1;
                        counter_add = 1;
                    end
                else
                    if(counter_add == 1)
                        counter = counter + counter_add;
                    end
                end
            end

            if (y_mem > 0 && y(i) <= 0)
                if(all(x_mem >= 0) || all(x_mem <= 0))
                    if x(i) >= 0
                        counter = counter - 1;
                        counter_add = -1;
                    end
                else
                     if(counter_add == -1)
                            counter = counter + counter_add;
                     end
                end
            end
            
        end
        counter_vector(i) = counter;
        y_mem = y(i);

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
    