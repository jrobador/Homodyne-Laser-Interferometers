function [longitud,counter_vector] = a_tan2(x,y)
counter_vector(1:length(x)) = 0;

counter = 0;
    for i = 1:1:length(y)
        if i == 1
            y_mem = y(i);
        else
            if x(i) >= 0
                if (y_mem < 0 && y(i) >= 0)
                    counter = counter + 1;
                end
                if (y_mem > 0 && y(i) <= 0)
                    counter = counter - 1;
                end                
            end
            y_mem = y(i);
        end
       counter_vector(i) = counter;

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
    