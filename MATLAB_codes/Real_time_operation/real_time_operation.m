function [discrete_displacement,continuous_displacement,actual_velocity] = real_time_operation(x_actual,y_actual, reset)

    global cycle_counter_direction;
    global T_s_adc;
    global x_mem_length;
    global counter;
    global velocity_counter_update;
    global cycle_counter;
    global y_mem;
    global x_mem;
    global cycle_counter_mem;
    global phi_t0;
    global actual_velocity_mem;
    


    
    %--------- A partir de aca es el código en tiempo real -------------
    % Bloquear funcionamiento hasta ingreso de nuevas muestras del ADC
    ADC_NEW_SAMPLES = 1;
    if(reset)

        counter = 0; %Contador de muestras analizadas
        cycle_counter = 0; %Contador de ciclos de la señal
        velocity_counter_update = 0;
        x_mem(1:x_mem_length) = 0;
        y_mem = 0;
        cycle_counter_mem = 0;

        phi_t0 = phase_calculation(x_actual,y_actual,0);

        cycle_counter_direction = 1;
        actual_velocity_mem = 0;

    end

    if(ADC_NEW_SAMPLES)

        counter = counter + 1 ; 
        velocity_counter_update = velocity_counter_update + 1;

        actual_time = counter*T_s_adc;              





        [cycle_counter,cycle_counter_direction] = cycle_counter_calculation(x_actual,y_actual,x_mem,y_mem,cycle_counter_direction,cycle_counter);


        if(velocity_counter_update * T_s_adc >= 0.005) % 50 milisegundos


            velocity_counter_update = 0;
            actual_velocity_mem = (cycle_counter - cycle_counter_mem) * 275e-9 / 0.005;
            cycle_counter_mem = cycle_counter;
        end
        actual_velocity = actual_velocity_mem;

        phi_actual = phase_calculation(x_actual,y_actual, cycle_counter);


        discrete_displacement = 275e-9 * cycle_counter;
        continuous_displacement = 550e-9/(4*pi) * (phi_actual-phi_t0);        


        % Actualizacion de memorias
        x_mem = [x_mem(2:end),x_actual];
        y_mem = y_actual;


    end
    %--------- Aca finaliza el código en tiempo real -------------    



end
    