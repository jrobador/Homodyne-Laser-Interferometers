clear all
close all
clc


% Define el nombre del archivo CSV
nombreArchivo = '../Docs/RefCurve_2023-06-15_1_192016.csv';

% Lee el archivo CSV
datos = csvread(nombreArchivo);

% Extrae las dos columnas en vectores separados
x_continuo = datos(:, 1)';
y_continuo = datos(:, 2)';

t_line_continuo = (0:5e-7:5e-7*(length(x_continuo)-1));
% Ahora tienes los datos en los vectores columna1 y columna2
% Puedes acceder a ellos como desees
plot(t_line_continuo,x_continuo)
hold all
plot(t_line_continuo,y_continuo)


DC_x = 2.2879;
DC_y = 2.4051;

x_continuo = x_continuo - DC_x;
y_continuo = y_continuo - DC_y;



