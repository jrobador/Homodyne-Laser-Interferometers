 
clear all
close all
clc

%Frecuencia de muestreo:
f_max =   50e3;

%Parametro de simulación
nciclos         = 100;                %Cantidad de ciclos simulados
simulation_time = (nciclos+0.2)*2*pi/f_max; %Tiempo de simulacion


%Factor de sobremuestreo discreto
npoints_discreto = 16;
f_s_discreto = npoints_discreto * f_max;
t_s_discreto = 1/f_s_discreto;

%Factor de sobremuestreo continuo
npoints_continuo = 500; %Cantidad de muestras que se toman en cada ciclo (en tiempo continuo)
f_s_continua = npoints_continuo * f_max;
t_s_continua= 1/f_s_continua;

%Señal discreta muestreada con factor de sobremuestreo npoints_discreto
t_line_discreto = (0:2*pi*t_s_discreto:simulation_time);

%Señal discreta muestreada con factor de sobremuestreo npoints_continua
t_line_continua = (0:2*pi*t_s_continua:simulation_time);


%Señal continua con delay pi/2
B = 1; 
A = B;
delay = pi/2; 

x_continuo = A * sin(f_max*t_line_continua);
y_continuo = B * sin(f_max*t_line_continua+delay);

x_continuo = [x_continuo, ones(1,npoints_continuo)* x_continuo(end)];
y_continuo = [y_continuo, ones(1,npoints_continuo)* y_continuo(end)];
%Señal discreta con delay pi/2
B = 1; 
A = B;
delay = pi/2; 

x_discreto = A * sin(f_max*t_line_discreto);
y_discreto = B * sin(f_max*t_line_discreto + delay);  

x_discreto = [x_discreto, ones(1,npoints_discreto)* x_discreto(end)];
y_discreto = [y_discreto, ones(1,npoints_discreto)* y_discreto(end)];

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
%Comparación entre señal ideal y señal muestreada en funcion del tiempo

t_line_continua = [t_line_continua,(t_line_continua(end): 2*pi*t_s_continua:t_line_continua(end)+(npoints_continuo-1)*2*pi*t_s_continua)];
t_line_discreto = [t_line_discreto,(t_line_discreto(end): 2*pi*t_s_discreto:t_line_discreto(end)+(npoints_discreto-1)*2*pi*t_s_discreto)];

figure
subplot(211)
stem(t_line_discreto,x_discreto)
hold all
plot(t_line_continua,x_continuo,'-')
xlabel('tiempo')
legend('x discreto','x continuo')
subplot(212)
stem(t_line_discreto,y_discreto)
hold all
plot(t_line_continua,y_continuo,'-')
xlabel('tiempo')
legend('y discreto','y continuo')

