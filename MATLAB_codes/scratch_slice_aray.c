#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int *slice_array(int *array, int start, int end) {
    int numElements = (end - start + 1);
    int numBytes = sizeof(int) * numElements;

    int *slice = (int *)malloc(numBytes);
    if (slice == NULL) {
        // Manejo de error si malloc falla
        perror("Error al asignar memoria para el slice");
        exit(EXIT_FAILURE);
    }

    memcpy(slice, array + start, numBytes);

    return slice;
}

void sumarDosATodos(int result_array[], int array[], int size) {
    for (int i = 0; i < size; i++) {
        result_array[i] = array[i] + 2;
    }
}

int main() {
    int arr[5] = {10, 2, 3, 5, 1};


    int result_array[4];

    // Imprime el slice antes de la suma
    printf("Slice antes de sumar 2: [");
    for (int i = 0; i < 4; i++) {
        printf("%d", slicedArray[i]);
        if (i < 3) {
            printf(", ");
        }
    }
    printf("]\n");

    // Suma 2 a cada elemento del slice
    sumarDosATodos(result_array, slice_array(arr, 1, 4), 4);

    // Imprime el slice después de la suma
    printf("Slice después de sumar 2: [");
    for (int i = 0; i < 4; i++) {
        printf("%d", result_array[i]);
        if (i < 3) {
            printf(", ");
        }
    }
    printf("]\n");

    // Libera la memoria asignada para el slice
    free(slicedArray);

    return 0;
}
