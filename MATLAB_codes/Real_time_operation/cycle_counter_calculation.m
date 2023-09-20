function [cycle_counter, cycle_counter_direction] = cycle_counter_calculation(x_actual,y_actual,x_mem,y_mem,cycle_counter_direction,cycle_counter)

    if (y_mem < 0 && y_actual >= 0)
        if(all(x_mem >= 0) || all(x_mem <= 0))
            if x_actual >= 0
                cycle_counter = cycle_counter + 1;
                cycle_counter_direction = 1;
            end
        else
            if(cycle_counter_direction == 1)
                cycle_counter = cycle_counter + cycle_counter_direction;
            end
        end
    end

    if (y_mem > 0 && y_actual <= 0)
        if(all(x_mem >= 0) || all(x_mem <= 0))
            if x_actual >= 0
                cycle_counter = cycle_counter - 1;
                cycle_counter_direction = -1;
            end
        else
             if(cycle_counter_direction == -1)
                    cycle_counter = cycle_counter + cycle_counter_direction;
             end
        end
    end
end

