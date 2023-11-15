function [discrete_displacement,continuous_displacement,actual_velocity] = real_time_operation(x_actual,y_actual, reset)

    persistent cycle_counter_direction;
    persistent velocity_counter_update;
    persistent cycle_counter;
    persistent y_mem;
    persistent x_mem;
    persistent continuous_displacement_mem;
    persistent phi_t0;
    persistent actual_velocity_mem;
    persistent b;
    persistent a;
    persistent initialization;

    
    %--------- A partir de aca es el código en tiempo real -------------
    % Bloquear funcionamiento hasta ingreso de nuevas muestras del ADC
    
    global T_s_adc;
    
    x_mem_length_algorithm = 3;
    y_mem_length_algorithm = 1;
    mem_length_filter = 100;
    actual_index = fix(mem_length_filter/2);
    velocity_time_update = 1e-3;
    light_wave_length = 500e-9;
    v_locked = 6.25e-6;
    v_untracked = v_locked*2;
    %-----------------------------
    %-------- CALCULOS INICIALES
    
    %-------- INICIALIZACIONES GENERALES
    if(isempty(initialization))
    
        initialization = 1 ;



        
        F_s_adc = 1 / T_s_adc;

        f_locked = v_locked / (light_wave_length/2);
        f_untracked = v_untracked / (light_wave_length/2);

        f_locked_norm = f_untracked / (F_s_adc/2); %(frecuencia chequeable normalizada) 
        f_cut_norm = f_locked_norm * 2 ;

        b = fir1(mem_length_filter-1,f_cut_norm);
        a = 1;
    end
     %--------    
    
    
    
    
    
    ADC_NEW_SAMPLES = 1;
    if(reset)

        cycle_counter = 0; %Contador de ciclos de la señal
        velocity_counter_update = 0;
        x_mem(1:mem_length_filter) = 0;
        y_mem(1:mem_length_filter) = 0;
        continuous_displacement_mem = 0;

        phi_t0 = phase_calculation(x_actual,y_actual,0);

        cycle_counter_direction = 1;
        actual_velocity_mem = 0;

    end

    if(ADC_NEW_SAMPLES)
        % Actualizacion de memorias
        x_mem = [x_mem(2:end),x_actual];
        y_mem = [y_mem(2:end),y_actual];
        
        
        velocity_counter_update = velocity_counter_update + 1;

        %actual_time = counter*T_s_adc;              





        [cycle_counter,cycle_counter_direction] = cycle_counter_calculation(x_mem(actual_index),y_mem(actual_index),x_mem(actual_index-1-(x_mem_length_algorithm-1):actual_index-1),y_mem(actual_index-1-(y_mem_length_algorithm-1):actual_index-1),cycle_counter_direction,cycle_counter);


        if(abs(actual_velocity_mem) <= v_locked)
            phi_actual = phase_calculation(dot(b, x_mem),dot(b, y_mem), cycle_counter);
        else
            phi_actual = phase_calculation(x_mem(actual_index),y_mem(actual_index), cycle_counter);
        end


        discrete_displacement = (light_wave_length/2) * cycle_counter;
        continuous_displacement = (light_wave_length/2)/(2*pi) * (phi_actual-phi_t0);        

        if(velocity_counter_update * T_s_adc >= velocity_time_update) 

            velocity_counter_update = 0;
            actual_velocity_mem = (continuous_displacement - continuous_displacement_mem) / velocity_time_update;
            continuous_displacement_mem = continuous_displacement;
        end
        actual_velocity = actual_velocity_mem;


            
        
        
        



    end
    %--------- Aca finaliza el código en tiempo real -------------    



end
    