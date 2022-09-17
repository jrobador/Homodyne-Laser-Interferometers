function [longitud] = a_tan2(x,y)
    for i = 1:1:length(X)
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
   
   if x(0) > 0
       phi_t0 = atan (y(1)/x(1));
   else
       phi_t0 = atan (y(1)/x(1)) + pi;
   end
   
   if x(0) > 0
       phi_t1 = atan (length(y)/length(x)) + 2 * pi * counter;
   else
       phi_t1 = atan (length(y)/length(x)) + pi + 2 * pi * counter ;
   end
   
   longitud = 550e-9/(4*pi) * (phi_t1-phi_t0);
end
    