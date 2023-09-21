function [phase] = phase_calculation(x,y, n)

    if (x > 0 && y >= 0)
       phase = atan (y/x) + 2 * pi * n;
    else

        if (x <= 0 && y > 0)
           phase = atan (y(end)/x(end)) + pi + 2 * pi * n;
        else

            if (x < 0 && y <= 0)
               phase = atan (y/x) + pi + 2 * pi * n;
            else

                if (x(end) >= 0 && y < 0)
                   phase = atan (y/x) + 2*pi + 2 * pi * n;
                else
                    phase = -1;
                end   
            end
        end
    end
    
    
end

