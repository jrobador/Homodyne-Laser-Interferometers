clear all
close all
clc

f_max =   50e3;

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

t_line_initial = (0:2*pi*t_s:5*tau);
x_signal_initial = A * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1)));
y_signal_initial = A * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1)+delay));

t_line_constant = (t_line_initial(end):2*pi*t_s:t_line_initial(end)+simulation_time_constant);

syms t_delay_for_continuity_1;
t_delay_for_continuity_1 = vpasolve(sin(2*pi*50e3*t_delay_for_continuity_1) == x_signal_initial(end),t_delay_for_continuity_1);


