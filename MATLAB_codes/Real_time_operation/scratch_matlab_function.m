function [discrete_displacement_o,continuous_displacement_o,actual_velocity_o, x_actual, y_actual] = real_time_operation_simulink(x_actual, y_actual, reset)

    persistent cycle_counter_direction;
    persistent T_s_adc;
    persistent x_mem_length;
    persistent counter;
    persistent velocity_counter_update;
    persistent cycle_counter;
    persistent y_mem;
    persistent x_mem;
    persistent cycle_counter_mem;
    persistent phi_t0;
    persistent actual_velocity_mem;
    persistent global_counter;
    persistent discrete_displacement;
    persistent continuous_displacement;
    persistent actual_velocity;
    
    

    if isempty( cycle_counter_direction) cycle_counter_direction = 0; end
    if isempty( T_s_adc) T_s_adc = 0; end
    if isempty( x_mem_length) x_mem_length = 0; end
    if isempty( counter) counter = 0; end
    if isempty( velocity_counter_update) velocity_counter_update = 0; end
    if isempty( cycle_counter) cycle_counter = 0; end
    if isempty( y_mem) y_mem = 0; end
    if isempty( x_mem) x_mem = 0; end
    if isempty( cycle_counter_mem) cycle_counter_mem = 0; end
    if isempty( phi_t0) phi_t0 = 0; end
    if isempty( actual_velocity_mem) actual_velocity_mem = 0; end
    if isempty( global_counter) global_counter = 0; end
    if isempty( discrete_displacement) discrete_displacement = 0; end
    if isempty( continuous_displacement) continuous_displacement = 0; end
    if isempty( actual_velocity) actual_velocity = 0; end
    
    
    
    T_s_continuo = 1e-6;
    
    T_s_adc =  4.902e-5;

    
    num_bits = 7;
    x_mem_length = 3;

    global_counter = global_counter +1;
    
% Average of both = 2.334916058702977 DC -> 0V -> 2.33 - 0.7 = 1.63

    diode_fall = 0.68491;
    mean_DC_signal = 2.334916058702977;
    new_range = mean_DC_signal-diode_fall;
    
%     x_actual = x_actual/2^num_bits*new_range*2-new_range;
%     y_actual = y_actual/2^num_bits*new_range*2-new_range; 
    
    x_actual = x_actual/2^num_bits*3.3-new_range;
    y_actual = y_actual/2^num_bits*3.3-new_range;
    
%    x_actual = x_actual - (1.65 - diode_fall);
    
    %--------- A partir de aca es el código en tiempo real -------------
    % Bloquear funcionamiento hasta ingreso de nuevas muestras del ADC
    
    
    OSF = fix(T_s_adc/T_s_continuo);
    
    
    if( mod(global_counter, OSF) == 0 )
        adc_new_sample = 1;
    else
        adc_new_sample = 0;
    end
        

        
    if(reset || global_counter == 1 || global_counter == 100 )

        counter = 0; %Contador de muestras analizadas
        cycle_counter = 0; %Contador de ciclos de la señal
        velocity_counter_update = 0;
        
        x_mem = zeros(1,x_mem_length);
        x_mem(1:x_mem_length) = 0;
        
        y_mem = 0;
        cycle_counter_mem = 0;

        phi_t0 = phase_calculation(x_actual,y_actual,0);

        cycle_counter_direction = 1;
        actual_velocity_mem = 0;
        
        actual_velocity = 0;
        discrete_displacement = 0;
        continuous_displacement = 0;
        
    
    else

        if(adc_new_sample)

            counter = counter + 1 ; 
            velocity_counter_update = velocity_counter_update + 1;

            %actual_time = counter*T_s_adc;              





            [cycle_counter,cycle_counter_direction] = cycle_counter_calculation(x_actual,y_actual,x_mem,y_mem,cycle_counter_direction,cycle_counter);


            if(velocity_counter_update * T_s_adc >= 0.005) % 5 milisegundos


                velocity_counter_update = 0;
                actual_velocity_mem = (cycle_counter - cycle_counter_mem) * 275e-9 / 0.005;
                cycle_counter_mem = cycle_counter;
            end
            actual_velocity = actual_velocity_mem;

            phi_actual = phase_calculation(x_actual,y_actual, cycle_counter);


            discrete_displacement = 250e-9 * cycle_counter;
            continuous_displacement = 500e-9/(4*pi) * (phi_actual-phi_t0);        


            % Actualizacion de memorias
            x_mem = [x_mem(2:end),x_actual];
            %y_mem = y_actual;
            if(y_actual ~= 0 )y_mem = y_actual; end


        end
        %--------- Aca finaliza el código en tiempo real -------------    

    end

    discrete_displacement_o = discrete_displacement;
    continuous_displacement_o = continuous_displacement;
    actual_velocity_o = actual_velocity;
    
    
end
