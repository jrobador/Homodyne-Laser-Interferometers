function [phase] = phase_calculation(x,y, n)
    arguments
        x, y, n = 0
    end

    if (x > 0 && y >= 0)
       phase = atan (y/x) + 2 * pi * n;
    end

    if (x <= 0 && y > 0)
       phase = atan (y(end)/x(end)) + pi + 2 * pi * n;
    end

    if (x < 0 && y <= 0)
       phase = atan (y/x) + pi + 2 * pi * n;
    end

    if (x(end) >= 0 && y < 0)
       phase = atan (y/x) + 2*pi + 2 * pi * n;
    end   
end

