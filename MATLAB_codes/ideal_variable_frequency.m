clear all
close all
clc

%Frecuencia de muestreo:
f_max =   50e3;
tau = 15e-5;

%Parametro de simulación
nciclos         = 75;                %Cantidad de ciclos simulados
simulation_time_constant = (nciclos+0.2)/f_max; %Tiempo de simulacion


%Factor de sobremuestreo continuo
npoints = 500; %Cantidad de muestras que se toman en cada ciclo (en tiempo continuo)
f_s = npoints * f_max;
t_s= 1/f_s;

%Señal discreta muestreada con factor de sobremuestreo npoints_continua
t_line = (0:2*pi*t_s:simulation_time_constant);


%Señal continua con delay pi/2
B = 1; 
A = B;
delay = pi/2; 

t_line_initial = (0:2*pi*t_s:5*tau+2*pi*t_s);
x_signal_initial = A * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1)));
y_signal_initial = A * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1)+delay));

t_line_constant = (t_line_initial(end):2*pi*t_s:t_line_initial(end)+simulation_time_constant);
x_signal_constant = sin(2*pi*f_max*(t_line_constant-t_line_initial(end)));
y_signal_constant = sin(2*pi*f_max*(t_line_constant-t_line_initial(end))+delay);

t_line_final = (t_line_constant(end):2*pi*t_s:t_line_constant(end)+20*tau);
x_signal_final = A * sin(2*pi*f_max*tau*(1-exp(-(t_line_final-t_line_constant(end))/tau)));
y_signal_final = A * sin(2*pi*f_max*tau*(1-exp(-(t_line_final-t_line_constant(end))/tau))+delay);

x_signal =[x_signal_initial,x_signal_constant,x_signal_final];
y_signal =[y_signal_initial,y_signal_constant,y_signal_final];

% x_signal = [x_signal, ones(1,npoints)* x_signal(end)];
% y_signal = [y_signal, ones(1,npoints)* y_signal(end)];

%Representación de figuras de Lissajous con delay pi/2

figure
plot(x_signal,y_signal,'-')
axis([-1 1 -1 1]), 
title(sprintf('Frecuencia=%d Delay=pi/2',f_max))
xlabel('Amplitud en x');
ylabel('Amplitud en y');
hold all
plot(x_signal(end),y_signal(end),'og')
legend('Fase','Fase final')
%Comparación entre señal ideal y señal muestreada en funcion del tiempo

% t_line = [t_line,(t_line(end): 2*pi*t_s:t_line(end)+(npoints-1)*2*pi*t_s)];

t_line = [t_line_initial,t_line_constant,t_line_final];

figure
subplot(211)
plot(t_line,x_signal,'-')
xlabel('tiempo')
legend('X')
subplot(212)
plot(t_line,y_signal,'-r')
xlabel('tiempo')
legend('Y')

