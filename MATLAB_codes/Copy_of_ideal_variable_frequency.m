clear all
close all
clc

%Frecuencia de muestreo:
f_max =   130e3;
tau = 15e-5;

%Parametro de simulación
nciclos         = 75;                %Cantidad de ciclos simulados

% Define el nombre del archivo CSV
nombreArchivo = '../Docs/RefCurve_2023-06-15_1_192016.csv';

% Lee el archivo CSV
datos = csvread(nombreArchivo);

% Extrae las dos columnas en vectores separados
x_continuo = datos(:, 1)';
y_continuo = datos(:, 2)';

x_continuo = x_continuo(1:fix(0.8*length(x_continuo)));
y_continuo = y_continuo(1:fix(0.8*length(y_continuo)));

x_continuo = x_continuo - mean(x_continuo(fix(0.4*length(x_continuo)):fix(0.7*length(x_continuo))));
y_continuo = y_continuo - mean(y_continuo(fix(0.4*length(y_continuo)):fix(0.7*length(y_continuo))));

T_s_continuo = 5e-7;
f_s_continuo = 1/T_s_continuo;

t_line_continuo = (0:T_s_continuo:T_s_continuo*(length(x_continuo)-1));
% Ahora tienes los datos en los vectores columna1 y columna2
% Puedes acceder a ellos como desees


%Filtrado analogico
% Frecuencia de corte para el filtro pasabajos (un poco menos de 130 kHz)
f_corte = 130e3; 
% Orden del filtro (puedes ajustar este valor según tus necesidades)
orden = 6;

% Diseña el filtro pasabajos
[b, a] = butter(orden, f_corte / (f_s_continuo / 2), 'low');

% Aplica el filtro a las señales x_continuo e y_continuo
x_continuo = filter(b, a, x_continuo);
y_continuo = filter(b, a, y_continuo);


%Factor de sobremuestreo discreto
npoints_discreto = 6;
f_s_discreto = npoints_discreto * f_max;
t_s_discreto = 1/f_s_discreto;

%Señal discreta con delay pi/2
OSF = fix(f_s_continuo/ f_s_discreto);


x_discreto = x_continuo(1:OSF:end);
y_discreto = y_continuo(1:OSF:end);

t_line_discreto = t_line_continuo(1:OSF:end);


%Comparación entre señal ideal y señal muestreada en funcion del tiempo

% t_line_continuo = [t_line_continuo,(t_line_continuo(end): 2*pi*t_s_continuo:t_line_continuo(end)+(npoints_continuo-1)*2*pi*t_s_continuo)];

figure
subplot(211)
stem(t_line_discreto,x_discreto)
hold all
plot(t_line_continuo,x_continuo,'-')
xlabel('tiempo')
legend('x discreto','x continuo')
subplot(212)
stem(t_line_discreto,y_discreto)
hold all
plot(t_line_continuo,y_continuo,'-')
xlabel('tiempo')
legend('y discreto','y continuo')
grid on

figure %%JC cambio de figura
plot(x_continuo,y_continuo,'-')
axis([-1 1 -1 1]), 
title(sprintf('Frecuencia=%d Delay=pi/2',f_max))
xlabel('Amplitud en x');
ylabel('Amplitud en y');
hold all
plot(x_continuo(end),y_continuo(end),'og')
hold all
plot(x_continuo(1),y_continuo(1),'or')
legend('Fase','Fase final','Fase inicial')
hold all
%ylim = [-1.5,1.5];

displacement_without_correction_continuo_original = a_tan2(x_continuo,y_continuo);
displacement_without_correction_continuo = optimal_counter_test_a_tan2(x_continuo,y_continuo);

displacement_without_correction_discreto_original = a_tan2(x_discreto,y_discreto);
displacement_without_correction_discreto = optimal_counter_test_a_tan2(x_discreto,y_discreto);

%Representación de figuras de Lissajous con delay pi/2

figure
plot(x_discreto,y_discreto,'-o')
hold all
plot(x_continuo,y_continuo,'-')
axis([-1 1 -1 1]), 
title(sprintf('Frecuencia=%d Delay=pi/2',f_max))
xlabel('Amplitud en x');
ylabel('Amplitud en y');
hold all
plot(x_continuo(end),y_continuo(end),'og')
legend('muestras en discreto','valores continuos','Valor final')
axis equal

% Calcular la FFT de la señal x_continuo
X_continuo_fft = fft(x_continuo);

% Calcular el eje de frecuencia en Hz
N_continuo = length(X_continuo_fft);
frequencies_continuo = (0:N_continuo-1) * (f_s_continuo / N_continuo);

% Calcular el espectro de amplitud (magnitud)
amplitude_spectrum_continuo = abs(X_continuo_fft);

% Graficar la FFT en función de la frecuencia
figure
plot(frequencies_continuo, amplitude_spectrum_continuo)
xlabel('Frecuencia (Hz)')
ylabel('Magnitud')
title('Respuesta en Frecuencia de la señal x_continuo')
grid on



% Calcular la FFT de la señal x_continuo
X_discreto_fft = fft(x_discreto);

% Calcular el eje de frecuencia en Hz
N_discreto = length(X_discreto_fft);
frequencies_discreto = (0:N_discreto-1) * (f_s_discreto / N_discreto);

% Calcular el espectro de amplitud (magnitud)
amplitude_spectrum_discreto = abs(X_discreto_fft);

% Graficar la FFT en función de la frecuencia
figure
plot(frequencies_discreto, amplitude_spectrum_discreto)
xlabel('Frecuencia (Hz)')
ylabel('Magnitud')
title('Respuesta en Frecuencia de la señal x_discreto')
grid on
