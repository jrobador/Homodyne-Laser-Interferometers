function [longitud] = a_tan2(x,y)
counter = 1;
    for i = 1:1:length(x)
        if i == 1
            x_mem = x(i);
        else
            if y(i) > 0
                if (x_mem < 0 && x(i) > 0)
                    counter = counter + 1;
                end
                if (x_mem > 0 && x(i) < 0)
                    counter = counter - 1;
                end                
            end
            x_mem = x(i);
        end
    end
   
   if x(1) > 0
       phi_t0 = atan (y(1)/x(1));
   else
       phi_t0 = atan (y(1)/x(1)) + pi;
   end
   
   if x(end) > 0
       phi_t1 = atan (y(end)/x(end)) + 2 * pi * counter;
   else
       phi_t1 = atan (y(end)/x(end)) + pi + 2 * pi * counter ;
   end
   
   longitud = 550e-9/(4*pi) * (phi_t1-phi_t0);
end
    