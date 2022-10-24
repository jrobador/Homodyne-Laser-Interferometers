clear all
close all
clc

%Frecuencia de muestreo:
f_max =   50e3;
tau = 15e-5;

%Parametro de simulación
nciclos         = 75;                %Cantidad de ciclos simulados

%Factor de sobremuestreo continuo
npoints = 500; %Cantidad de muestras que se toman en cada ciclo (en tiempo continuo)
f_s = npoints * f_max;
t_s= 1/f_s;

% x_signal =  A_x + B_x * cos(phi_t);
% y_signal =  A_x + B_x * cos(phi_t+phase_initial);

A_x = 0; 
A_y = 0;
B_x = 1;
B_y = 1;
delay = 0;
phase_initial =0;
%Señal continua con delay pi/2
[x_signal, y_signal, t_line] = quadrature_signal_generator(t_s,tau,nciclos,phase_initial,f_max,A_x,A_y,B_x,B_y,delay);

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
ylim = [-1.5,1.5];

%Comparación entre señal ideal y señal muestreada en funcion del tiempo

% t_line = [t_line,(t_line(end): 2*pi*t_s:t_line(end)+(npoints-1)*2*pi*t_s)];

figure
plot(t_line,x_signal,'-')

hold all
plot(t_line,y_signal,'-r')
xlabel('tiempo')
legend('X','Y')

longitud = a_tan2(x_signal,y_signal);

