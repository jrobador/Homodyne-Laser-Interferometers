#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


// Función para actualizar x_mem e y_mem
void shift_left_memory(float mem[], int memLength, float newValue) {
    for (int i = 0; i < memLength; i++) {
        mem[i] = mem[i + 1];  // Desplazamiento a la izquierda
    }
    mem[memLength - 1] = newValue;  // Agregar nuevo dato a la derecha
}


float *slice_array(float *array, int start, int end) {
    int numElements = (end - start + 1);
    int numBytes = sizeof(int) * numElements;

    float *slice = (float *)malloc(numBytes);
    if (slice == NULL) {
        // Manejo de error si malloc falla
        perror("Error al asignar memoria para el slice");
        exit(EXIT_FAILURE);
    }

    memcpy(slice, array + start, numBytes);

    return slice;
}

int all_positive_or_all_negative(float arr[], int length) {
    int all_positive = 1;
    int all_negative = 1;

    for (int i = 0; i < length; i++) {
        if (arr[i] >= 0) {
            all_negative = 0;
        } else {
            all_positive = 0;
        }
    }

    return all_positive || all_negative;
}

float dot_product(const float* a, const float* b, int length) {
    float result = 0.0;

    for (int i = 0; i < length; ++i) {
        result += a[i] * b[i];
    }

    return result;
}


void cycle_counter_calculation(int *cycle_counter, int *cycle_counter_direction, float x_actual, float y_actual, float x_mem[], float y_mem, int x_mem_length_algorithm) {

    if (y_mem < 0 && y_actual > 0) {
        if (all_positive_or_all_negative(x_mem,x_mem_length_algorithm)) {
            if (x_actual >= 0) {
                *cycle_counter = *cycle_counter + 1;
                *cycle_counter_direction = 1;
            }
        } else {
            if (*cycle_counter_direction == 1) {
                *cycle_counter = *cycle_counter + *cycle_counter_direction;
            }
        }
    }

    if (y_mem > 0 && y_actual < 0) {
        if (all_positive_or_all_negative(x_mem,x_mem_length_algorithm)) {
            if (x_actual >= 0) {
                *cycle_counter = *cycle_counter - 1;
                *cycle_counter_direction = -1;
            }
        } else {
            if (*cycle_counter_direction == -1) {
                *cycle_counter = *cycle_counter + *cycle_counter_direction;
            }
        }
    }
}


float phase_calculation(float x, float y, int n) {

    float phase;

    if (x > 0 && y >= 0) {
        phase = atan(y / x) + 2 * M_PI * n;
    } else {
        if (x <= 0 && y > 0) {
            phase = atan(y / x) + M_PI + 2 * M_PI * n;
        } else {
            if (x < 0 && y <= 0) {
                phase = atan(y / x) + M_PI + 2 * M_PI * n;
            } else {
                if (x >= 0 && y < 0) {
                    phase = atan(y / x) + 2 * M_PI + 2 * M_PI * n;
                } else {
                    phase = -1;
                }
            }
        }
    }

    return phase;
}




int main() {
    FILE *archivo_1 = fopen("x_actual_array.csv", "r");
    FILE *archivo_2 = fopen("y_actual_array.csv", "r");

    if (archivo_1 && archivo_2) {
        char caracter;
        char linea[10];  // Tamaño suficiente para una línea de datos
        int pos = 0;

        float x_values[100000]; // Arreglo para almacenar los valores de x
        float y_values[100000]; // Arreglo para almacenar los valores de y
        int x_count = 0;       // Contador de valores de x
        int y_count = 0;       // Contador de valores de y

        while ((caracter = fgetc(archivo_1)) != EOF) {
            if (caracter == '\n') {
                linea[pos] = '\0'; // Termina la cadena
                float numero;
                if (sscanf(linea, "%f", &numero) == 1) {
                    x_values[x_count] = numero;
                    x_count++;
                }
                pos = 0; // Reinicia la posición del buffer de línea
            } else {
                linea[pos++] = caracter;
            }
        }
                
        pos = 0; // Reinicia la posición del buffer de línea

        while ((caracter = fgetc(archivo_2)) != EOF) {
            if (caracter == '\n') {
                linea[pos] = '\0'; // Termina la cadena
                float numero;
                if (sscanf(linea, "%f", &numero) == 1) {
                    y_values[y_count] = numero;
                    y_count++;
                }
                pos = 0; // Reinicia la posición del buffer de línea
            } else {
                linea[pos++] = caracter;
            }
        }

        fclose(archivo_1);
        fclose(archivo_2);



       //____________________________ ACA COMIENZA EL CODIGO DEL MICROPROCESADOR_____________________________________________


        float x_values_procesed[35000]; // Arreglo para almacenar los valores de x
        float y_values_procesed[35000]; // Arreglo para almacenar los valores de y
        //float cycle_counter_save[100000];
        float continuous_displacement_save[35000];
        float actual_velocity_save[35000];



        int reset = 0;

        int x_mem_length_algorithm = 3;
        //int y_mem_length_algorithm = 1;
        int mem_length_filter = 100;
        int actual_index = mem_length_filter/2 - 1; //el -1 es porque en matlab los arreglos empiezan en 1
        float velocity_time_update = 1e-3;
        float light_wave_length = 500e-9;
        float v_locked = 6.25e-6;
        float T_s_adc =  4.902e-5;

        float x_actual;
        float y_actual;
             
        float b[] = {0.001374957032307, 0.001396489767070, 0.001450072942597, 0.001535878775111, 0.001653933223175, 0.001804114892868, 0.001986154640355, 0.002199635877442, 0.002443995582192, 0.002718526013155, 0.003022377122284, 0.003354559658036, 0.003713948946749, 0.004099289336884, 0.004509199287402, 0.004942177078254, 0.005396607117751, 0.005870766818564, 0.006362834011128, 0.006870894860469, 0.007392952249846, 0.007926934592167, 0.008470705027862, 0.009022070965899, 0.009578793922740, 0.010138599612471, 0.010699188239933, 0.011258244947571, 0.011813450365801, 0.012362491216086, 0.012903070915511, 0.013432920131525, 0.013949807235674, 0.014451548605503, 0.014936018724499, 0.015401160030828, 0.015844992466772, 0.016265622682196, 0.016661252846971, 0.017030189029205, 0.017370849098147, 0.017681770113000, 0.017961615161315, 0.018209179613351, 0.018423396761630, 0.018603342817916, 0.018748241243005, 0.018857466388009, 0.018930546429148, 0.018967165581627, 0.018967165581627, 0.018930546429148, 0.018857466388009, 0.018748241243005, 0.018603342817916, 0.018423396761630, 0.018209179613351, 0.017961615161315, 0.017681770113000, 0.017370849098147, 0.017030189029205, 0.016661252846971, 0.016265622682196, 0.015844992466772, 0.015401160030828, 0.014936018724499, 0.014451548605503, 0.013949807235674, 0.013432920131525, 0.012903070915511, 0.012362491216086, 0.011813450365801, 0.011258244947571, 0.010699188239933, 0.010138599612471, 0.009578793922740, 0.009022070965899, 0.008470705027862, 0.007926934592167, 0.007392952249846, 0.006870894860469, 0.006362834011128, 0.005870766818564, 0.005396607117751, 0.004942177078254, 0.004509199287402, 0.004099289336884, 0.003713948946749, 0.003354559658036, 0.003022377122284, 0.002718526013155, 0.002443995582192, 0.002199635877442, 0.001986154640355, 0.001804114892868, 0.001653933223175, 0.001535878775111, 0.001450072942597, 0.001396489767070, 0.001374957032307};

        int counter=0;
        int global_counter = 0;
        int cycle_counter;
        int cycle_counter_mem;
        float velocity_counter_update;
        float phi_t0;        
        float phi_actual;        
        int cycle_counter_direction;
        float actual_velocity;  
        float actual_velocity_mem;
        float continuous_displacement;
        float continuous_displacement_mem;

        float x_mem[mem_length_filter];
        float y_mem[mem_length_filter];

        int temp = 1;



        for (int i = 0; i < x_count; i++) {

            global_counter = global_counter + 1;

            // Recibo los valores del ADC y luego ejecuto lo siguiente.
            x_actual = x_values[i];
            y_actual = y_values[i];

            if(reset || global_counter == 1 || global_counter == 100 )
            {
                counter = 0; //Contador de muestras analizadas
                cycle_counter = 0; //Contador de ciclos de la señal
                velocity_counter_update = 0;

                for (int j = 0; j < mem_length_filter; ++j) {
                    x_mem[j]=0;
                    y_mem[j]=0;
                }
                
                cycle_counter_mem = 0;

                phi_t0 = 0;
                phi_actual = 0;

                cycle_counter_direction = 1;
                actual_velocity_mem = 0;
                
                actual_velocity = 0;
                //discrete_displacement = 0;
                continuous_displacement = 0;
            }
            else  
            {
                if(counter == 0)
                    phi_t0 = phase_calculation(x_actual, y_actual,0);

                shift_left_memory(x_mem, mem_length_filter, x_actual);
                shift_left_memory(y_mem, mem_length_filter, y_actual);


                if(counter > actual_index){
                    velocity_counter_update = velocity_counter_update + 1;





                    // Implement cycle_counter_calculation function
                    // (replace with actual logic from your MATLAB code)
                    cycle_counter_calculation(&cycle_counter, &cycle_counter_direction, x_mem[actual_index], y_mem[actual_index], slice_array(x_mem, actual_index - 1 - (x_mem_length_algorithm - 1), actual_index - 1),y_mem[actual_index - 1],x_mem_length_algorithm );

                    if (fabs(actual_velocity_mem) <= v_locked) {
                        phi_actual = phase_calculation(dot_product(b, x_mem, mem_length_filter), dot_product(b, y_mem, mem_length_filter), cycle_counter);
                    } 
                    else {
                        phi_actual = phase_calculation(x_mem[actual_index], y_mem[actual_index], cycle_counter);
                    }

                    continuous_displacement = (light_wave_length / 2) / (2 * M_PI) * (phi_actual - phi_t0);

                    if (velocity_counter_update * T_s_adc >= velocity_time_update) {
                     velocity_counter_update = 0;
                     actual_velocity_mem = (continuous_displacement - continuous_displacement_mem) / velocity_time_update;
                     continuous_displacement_mem = continuous_displacement;
                    }
                    actual_velocity = actual_velocity_mem;


                    x_values_procesed[i] = x_mem[actual_index];
                    y_values_procesed[i] = y_mem[actual_index];
                    //cycle_counter_save[i] = cycle_counter;
                    continuous_displacement_save[i] = continuous_displacement;
                    actual_velocity_save[i] = actual_velocity; 

                }
                counter = counter + 1 ; 

            }


                    
           //____________________________ ACA TERMINA EL CODIGO DEL MICROPROCESADOR_____________________________________________

        }
            printf("%d\n",x_count );
            printf("%d\n",y_count );
        // Guarda los nuevos arreglos en archivos
        FILE *nuevoArchivoX = fopen("x_procesed_array.csv", "w");
        FILE *nuevoArchivoY = fopen("y_procesed_array.csv", "w");
        FILE *nuevoArchivoC = fopen("continuous_displacement_save.csv", "w");
        FILE *nuevoArchivoV = fopen("actual_velocity_save.csv", "w");



        if (nuevoArchivoX && nuevoArchivoY && nuevoArchivoC) {
            for (int i = 0; i < x_count; i++) {
                fprintf(nuevoArchivoX, "%f\n", x_values_procesed[i]);
            }

            for (int i = 0; i < y_count; i++) {
                fprintf(nuevoArchivoY, "%f\n", y_values[i]);
            }           

            for (int i = 0; i < x_count; i++) {
                fprintf(nuevoArchivoC, "%0.9f\n", continuous_displacement_save[i]);
            }

            for (int i = 0; i < x_count; i++) {
                fprintf(nuevoArchivoV, "%0.9f\n", actual_velocity_save[i]);
            }

            fclose(nuevoArchivoX);
            fclose(nuevoArchivoY);
            fclose(nuevoArchivoC);
            fclose(nuevoArchivoV);
        } else {
            printf("No se pudo crear uno de los archivos CSV de salida.\n");
        }
    } else {
        printf("No se pudieron abrir los archivos CSV de entrada.\n");
    }

    return 0;
}
