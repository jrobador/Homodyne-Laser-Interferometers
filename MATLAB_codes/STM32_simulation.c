#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// Función para actualizar x_mem e y_mem
void shift_left_memory(float mem[], int memLength, float newValue) {
    for (int i = 0; i < memLength; i++) {
        mem[i] = mem[i + 1];  // Desplazamiento a la izquierda
    }
    mem[memLength - 1] = newValue;  // Agregar nuevo dato a la derecha
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

int all_positive_or_all_negative(x_mem[],x_mem_length_algorithm){
    return 1
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


        float x_values_procesed[100000]; // Arreglo para almacenar los valores de x
        float y_values_procesed[100000]; // Arreglo para almacenar los valores de y

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
             
        // float b[] = {}

        int counter=0;
        int global_counter = 0;
        int cycle_counter;
        int cycle_counter_mem;
        float velocity_counter_update;
        float phi_t0;        
        int cycle_counter_direction;
        float actual_velocity;  
        float actual_velocity_mem;
        float continuous_displacement;
        float continuous_displacement_mem;

        float x_mem[mem_length_filter];
        float y_mem[mem_length_filter];



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

                phi_t0 = 0;  //phase_calculation(x_actual,y_actual,0);

                cycle_counter_direction = 1;
                actual_velocity_mem = 0;
                
                actual_velocity = 0;
                //discrete_displacement = 0;
                continuous_displacement = 0;
            }
            else  
            {
                counter = counter + 1 ; 
                velocity_counter_update = velocity_counter_update + 1;


                shift_left_memory(x_mem, mem_length_filter, x_actual);
                shift_left_memory(y_mem, mem_length_filter, y_actual);

            // Implement cycle_counter_calculation function
            // (replace with actual logic from your MATLAB code)
            cycle_counter_calculation(&cycle_counter_direction, &cycle_counter, x_mem[actual_index], y_mem, x_mem[actual_index - 1 - (x_mem_length_algorithm - 1):actual_index - 1],y_mem[actual_index - 1 - (y_mem_length_algorithm - 1):actual_index - 1]);

            // if (fabs(actual_velocity_mem) <= v_locked) {
            //     phi_actual = phase_calculation(dot_product(b, x_mem, x_mem_length_algorithm), dot_product(b, y_mem, y_mem_length_algorithm), cycle_counter);
            // } else {
            //     phi_actual = phase_calculation(x_mem[actual_index], y_mem[actual_index], cycle_counter);
            // }

            // continuous_displacement = (light_wave_length / 2) / (2 * M_PI) * (phi_actual - phi_t0);

            // if (velocity_counter_update * T_s_adc >= velocity_time_update) {
            //     velocity_counter_update = 0;
            //     actual_velocity_mem = (continuous_displacement - continuous_displacement_mem) / velocity_time_update;
            //     continuous_displacement_mem = continuous_displacement;
            // }
            // actual_velocity = actual_velocity_mem;


                x_values_procesed[i] = x_mem[actual_index];
                y_values_procesed[i] = y_mem[actual_index];


            }


                    
           //____________________________ ACA TERMINA EL CODIGO DEL MICROPROCESADOR_____________________________________________

        }
            printf("%d\n",x_count );
            printf("%d\n",y_count );
        // Guarda los nuevos arreglos en archivos
        FILE *nuevoArchivoX = fopen("x_procesed_array.csv", "w");
        FILE *nuevoArchivoY = fopen("y_procesed_array.csv", "w");

        if (nuevoArchivoX && nuevoArchivoY) {
            for (int i = 0; i < x_count; i++) {
                fprintf(nuevoArchivoX, "%f\n", x_values_procesed[i]);
            }

            for (int i = 0; i < y_count; i++) {
                fprintf(nuevoArchivoY, "%f\n", y_values[i]);
            }

            fclose(nuevoArchivoX);
            fclose(nuevoArchivoY);
        } else {
            printf("No se pudo crear uno de los archivos CSV de salida.\n");
        }
    } else {
        printf("No se pudieron abrir los archivos CSV de entrada.\n");
    }

    return 0;
}
