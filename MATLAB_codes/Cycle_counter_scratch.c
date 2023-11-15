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

