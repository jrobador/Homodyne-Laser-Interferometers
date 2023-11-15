function [] = real_time_operation_simulink(x_actual, y_actual, reset)
    persistent T_s_adc;
    persistent counter;
    persistent global_counter;
    
    if isempty( T_s_adc) T_s_adc = 0; end
    if isempty( counter) counter = 0; end
    if isempty( global_counter) global_counter = 0; end
    
    T_s_continuo = 1e-6;
    T_s_adc =  4.902e-5;
    num_bits = 7;
    
    global_counter = global_counter + 1;
    
    DC_fall = 0.68491;
    mean_DC_signal = 2.334916058702977;
    new_range = mean_DC_signal - DC_fall;
        
    x_actual = x_actual / (2^num_bits * 3.3) - new_range;
    y_actual = y_actual / (2^num_bits * 3.3) - new_range;
    
    OSF = fix(T_s_adc / T_s_continuo);
    
    if (mod(global_counter, OSF) == 0)
        adc_new_sample = 1;
    else
        adc_new_sample = 0;
    end
        
    if (reset || global_counter == 1 || global_counter == 100)
        counter = 0; % Contador de muestras analizadas
    else
        if (adc_new_sample)
            counter = counter + 1;
            
            % Agregar (append) x_actual a el archivo csv x_actual_array.csv
            % Agregar (append) y_actual a el archivo csv y_actual_array.csv
            
            % Nombre de los archivos CSV
            x_csv_file = 'x_actual_array.csv';
            y_csv_file = 'y_actual_array.csv';
            
            % Abrir o crear archivos CSV en modo append (agregar al final)
            fid_x = fopen(x_csv_file, 'a');
            fid_y = fopen(y_csv_file, 'a');
            
            % Verificar si se pudieron abrir los archivos
            if fid_x == -1 || fid_y == -1
                error('Error al abrir los archivos CSV.');
            else
                % Escribir los valores de x_actual e y_actual en los archivos CSV
                fprintf(fid_x, '%f\n', x_actual);
                fprintf(fid_y, '%f\n', y_actual);
                
                % Cerrar los archivos
                fclose(fid_x);
                fclose(fid_y);
            end
        end
    end
end
