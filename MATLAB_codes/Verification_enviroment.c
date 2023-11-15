#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

        // Multiplica los valores por dos
        for (int i = 0; i < x_count; i++) {
            x_values[i] *= 2;
            y_values[i] *= 2;
        }
            printf("%d\n",x_count );
            printf("%d\n",y_count );
        // Guarda los nuevos arreglos en archivos
        FILE *nuevoArchivoX = fopen("x_procesed_array.csv", "w");
        FILE *nuevoArchivoY = fopen("y_procesed_array.csv", "w");

        if (nuevoArchivoX && nuevoArchivoY) {
            for (int i = 0; i < x_count; i++) {
                fprintf(nuevoArchivoX, "%f\n", x_values[i]);
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
