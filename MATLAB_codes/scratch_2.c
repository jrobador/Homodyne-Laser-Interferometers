#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *archivo = fopen("scratch_array.csv", "r");
    
    if (archivo) {
        char linea[100];  // Tamaño suficiente para una línea de datos
        
        FILE *nuevoArchivo = fopen("nuevo_array.csv", "w");
        if (nuevoArchivo) {
            if (fgets(linea, sizeof(linea), archivo) != NULL) {
                // Procesa la línea de datos (aquí puedes realizar la conversión necesaria)
                printf("Linea de datos entrada: %s", linea);

                printf("Linea de datos salida: ");
                char *token = strtok(linea, "\n");
                while (token != NULL) {
                    float numero;
                    if (sscanf(token, "%f", &numero) == 1) {
                        float resultado = numero * 2;
                        fprintf(nuevoArchivo, "%f, ", resultado);
                        printf("%f,", resultado);
                    }
                    token = strtok(NULL, ",");
                }
            }
            fclose(nuevoArchivo);
        } else {
            printf("No se pudo crear el nuevo archivo CSV.\n");
        }
        
        fclose(archivo);
    } else {
        printf("No se pudo abrir el archivo CSV.\n");
    }
    
    return 0;
}