clear all
close all
clc

%Frecuencia de muestreo:
f_max =   50e3;
tau = 15e-5;

%Parametro de simulación
nciclos         = 75;                %Cantidad de ciclos simulados

%Factor de sobremuestreo continuo
npoints = 2000; %Cantidad de muestras que se toman en cada ciclo (en tiempo continuo)
f_s = npoints * f_max;
t_s= 1/f_s;

% x_signal =  A_x + B_x * cos(phi_t);
% y_signal =  A_y + B_y * cos(phi_t+phase_initial);

A_x = 0; 
A_y = 0; 
B_x = 1; 
B_y = 1; 
delay = 0;
phase_initial =0;
%Señal continua con delay pi/2
[x_signal, y_signal, t_line] = quadrature_signal_generator(t_s,tau,nciclos,phase_initial,f_max,A_x,A_y,B_x,B_y,delay);


%Comparación entre señal ideal y señal muestreada en funcion del tiempo

% t_line = [t_line,(t_line(end): 2*pi*t_s:t_line(end)+(npoints-1)*2*pi*t_s)];

figure
plot(t_line,x_signal,'-')

hold all
plot(t_line,y_signal,'-r')
xlabel('tiempo')
legend('X','Y')

figure %%JC cambio de figura
plot(x_signal,y_signal,'-')
axis([-1 1 -1 1]), 
title(sprintf('Frecuencia=%d Delay=pi/2',f_max))
xlabel('Amplitud en x');
ylabel('Amplitud en y');
hold all
plot(x_signal(end),y_signal(end),'og')
hold all
plot(x_signal(1),y_signal(1),'or')
legend('Fase','Fase final','Fase inicial')
hold all
%ylim = [-1.5,1.5];
displacement_without_correction = a_tan2(x_signal,y_signal);

%DC Offset correction

% I_x1(k)
% I_y1(k)
x_signal_no_DC = (max(y_signal)-min(y_signal))/2 * (x_signal-(max(x_signal)+min(x_signal))/2);
y_signal_no_DC = (max(x_signal)-min(x_signal))/2 * (y_signal-(max(y_signal)+min(y_signal))/2);

%Correction of the Phase Delay
% I_x2(k)
% I_y2(k)
x_signal_phase_correction = x_signal_no_DC - y_signal_no_DC;
y_signal_phase_correction = x_signal_no_DC + y_signal_no_DC;


%AC amplitude correction

x_signal_amp = 2*B_x*B_y*sin(pi/4-delay/2);
y_signal_amp = 2*B_x*B_y*cos(pi/4-delay/2);

% I_x3(k)
% I_y3(k)

x_signal_amplitude_correction = y_signal_amp * x_signal_phase_correction;
y_signal_amplitude_correction = x_signal_amp * y_signal_phase_correction;

plot(x_signal_amplitude_correction,y_signal_amplitude_correction,'-r')
hold all


% Hacer variables los errores.
% DC Offset correction como en la FPGA
% DC phase correction como en la FPGA

displacement_with_correction = a_tan2(x_signal_amplitude_correction,y_signal_amplitude_correction);

error_percentage = displacement_without_correction/displacement_with_correction;
error_distance  = displacement_with_correction -displacement_without_correction;
