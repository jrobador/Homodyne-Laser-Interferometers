function [discrete_displacement_vector,continuous_displacement_vector,actual_velocity_vector] = real_time_operation(x,y, T_s_adc)

discrete_displacement_vector = (1:length(x));
continuous_displacement_vector = (1:length(x));
actual_velocity_vector = (1:length(x));

reset = 1;
x_mem_length = 3;
ADC_NEW_SAMPLES = 1;



    for i = 1:1:length(x)
        
        
        %--------- A partir de aca es el código en tiempo real -------------
        
        % Bloquear funcionamiento hasta ingreso de nuevas muestras del ADC
        
        if(reset)
            
            reset  = 0;

            x_actual = x(i);  % Tomo las muestras actuales del ADC independientemente si son nuevas o no
            y_actual = y(i);  
            
            counter = 0; %Contador de muestras analizadas
            cycle_counter = 0; %Contador de ciclos de la señal
            velocity_counter_update = 0;
            x_mem(1:x_mem_length) = 0;
            y_mem = 0;
            cycle_counter_mem = 0;
            
            phi_t0 = phase_calculation(x_actual,y_actual);
            
            cycle_counter_direction = 1;
            actual_velocity = 0;
            
        end
        
        if(ADC_NEW_SAMPLES)
            x_actual = x(i);  % Ingresa nueva muestra x_actual 
            y_actual = y(i);  % e y_actual desde el ADC al micro

            counter = counter + 1 ; 
            velocity_counter_update = velocity_counter_update + 1;

            actual_time = counter*T_s_adc;              





            [cycle_counter,cycle_counter_direction] = cycle_counter_calculation(x_actual,y_actual,x_mem,y_mem,cycle_counter_direction,cycle_counter);


            if(velocity_counter_update * T_s_adc >= 0.005) % 50 milisegundos
                
                
                velocity_counter_update = 0;
                actual_velocity = (cycle_counter - cycle_counter_mem) * 275e-9 / 0.005;
                cycle_counter_mem = cycle_counter;
            end


            phi_actual = phase_calculation(x_actual,y_actual, cycle_counter);


            discrete_displacement = 275e-9 * cycle_counter;
            continuous_displacement = 550e-9/(4*pi) * (phi_actual-phi_t0);        


            % Actualizacion de memorias
            x_mem = [x_mem(2:end),x_actual];
            y_mem = y_actual;
            
            
        end
        %--------- Aca finaliza el código en tiempo real -------------    

        discrete_displacement_vector(i) = discrete_displacement;
        continuous_displacement_vector(i) = continuous_displacement;
        actual_velocity_vector(i) = actual_velocity;

        
    end
end
    