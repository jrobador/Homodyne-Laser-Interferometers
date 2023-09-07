% Define el nombre del archivo CSV
nombreArchivo = '../Docs/RefCurve_2023-06-15_1_192016.csv';

% Lee el archivo CSV
datos = csvread(nombreArchivo);

% Extrae las dos columnas en vectores separados
columna1 = datos(:, 1)';
columna2 = datos(:, 2)';

t_line_continuo = (0:5e-7:5e-7*(length(columna1)-1));
% Ahora tienes los datos en los vectores columna1 y columna2
% Puedes acceder a ellos como desees
plot(t_line_continuo,columna1)
hold all
plot(t_line_continuo,columna2)


