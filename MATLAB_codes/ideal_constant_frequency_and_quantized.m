 
clear all
close all
clc

%Frecuencia de muestreo:
f_max =   50e3;

%Parametro de simulación
nciclos         = 1;                %Cantidad de ciclos simulados
simulation_time = (nciclos+0.2)*2*pi/f_max; %Tiempo de simulacion


%Factor de sobremuestreo discreto
npoints_discreto = 4;
f_s_discreto = npoints_discreto * f_max;
t_s_discreto = 1/f_s_discreto;

%Factor de sobremuestreo continuo
npoints_continuo = 500; %Cantidad de muestras que se toman en cada ciclo (en tiempo continuo)
f_s_continuo = npoints_continuo * f_max;
t_s_continuo= 1/f_s_continuo;




t_line_continuo = (0:t_s_continuo:simulation_time);


%Señal continuo con delay pi/2
B = 1; 
A = B;
initial_phase = -pi/2;
delay = 0; 

x_continuo = A * cos(2*pi*f_max*t_line_continuo+initial_phase);
y_continuo = B * sin(2*pi*f_max*t_line_continuo + delay+initial_phase);

x_continuo = [x_continuo, ones(1,npoints_continuo)* x_continuo(end)];
y_continuo = [y_continuo, ones(1,npoints_continuo)* y_continuo(end)];

%Señal discreta con delay pi/2
OSF = fix(f_s_continuo/ f_s_discreto);

x_discreto = x_continuo(1:OSF:end);
y_discreto = y_continuo(1:OSF:end);

%Señal discreta muestreada con factor de sobremuestreo npoints_discreto
t_line_continuo = [t_line_continuo,(t_line_continuo(end): 2*pi*t_s_continuo:t_line_continuo(end)+(npoints_continuo-1)*2*pi*t_s_continuo)];

t_line_discreto = t_line_continuo(1:OSF:end);


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


grid on

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

displacement_discreto = a_tan2(x_discreto,y_discreto);
displacement_continuo = a_tan2(x_continuo,y_continuo);
