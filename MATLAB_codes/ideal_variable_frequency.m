clear all
close all
clc

%Frecuencia de muestreo:
f_max =   50e3;
tau = 15e-5;

%Parametro de simulación
nciclos         = 75;                %Cantidad de ciclos simulados

%Factor de sobremuestreo continuo
npoints_continuo = 2000; %Cantidad de muestras que se toman en cada ciclo (en tiempo continuo)
f_s_continuo = npoints_continuo * f_max;
t_s_continuo= 1/f_s_continuo;

% x_continuo =  A_x + B_x * cos(phi_t);
% y_continuo =  A_y + B_y * cos(phi_t+phase_initial);

A_x = 0.3; 
A_y = 0.2; 
B_x = 1.3; 
B_y = 0.7; 
delay = 27*pi/180;
phase_initial = pi/6;
%Señal continua con delay pi/2
[x_continuo, y_continuo, t_line_continuo] = quadrature_signal_generator(t_s_continuo,tau,nciclos,phase_initial,f_max,A_x,A_y,B_x,B_y,delay);


%Factor de sobremuestreo discreto
npoints_discreto = 4;
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

displacement_without_correction_continuo = optimal_counter_test_a_tan2(x_continuo,y_continuo);
displacement_without_correction_discreto = optimal_counter_test_a_tan2(x_discreto,y_discreto);


displacement_without_correction_continuo_original = a_tan2(x_continuo,y_continuo);
displacement_without_correction_discreto_original = a_tan2(x_discreto,y_discreto);


%DC Offset correction

% I_x1(k)
% I_y1(k)
x_discreto_no_DC = (max(y_discreto)-min(y_discreto))/2 * (x_discreto-(max(x_discreto)+min(x_discreto))/2);
y_discreto_no_DC = (max(x_discreto)-min(x_discreto))/2 * (y_discreto-(max(y_discreto)+min(y_discreto))/2);

%Correction of the Phase Delay
% I_x2(k)
% I_y2(k)
x_discreto_phase_correction = x_discreto_no_DC - y_discreto_no_DC;
y_discreto_phase_correction = x_discreto_no_DC + y_discreto_no_DC;


%AC amplitude correction

x_discreto_amp = 2*B_x*B_y*sin(pi/4-delay/2);
y_discreto_amp = 2*B_x*B_y*cos(pi/4-delay/2);

% I_x3(k)
% I_y3(k)

x_discreto_amplitude_correction = y_discreto_amp * x_discreto_phase_correction;
y_discreto_amplitude_correction = x_discreto_amp * y_discreto_phase_correction;

plot(x_discreto_amplitude_correction,y_discreto_amplitude_correction,'-r')
hold all


% Hacer variables los errores.
% DC Offset correction como en la FPGA
% DC phase correction como en la FPGA

displacement_with_correction_discreto = optimal_counter_test_a_tan2(x_discreto_amplitude_correction,y_discreto_amplitude_correction);
displacement_with_correction_discreto_original = a_tan2(x_discreto_amplitude_correction,y_discreto_amplitude_correction);



error_percentage = displacement_without_correction_discreto/displacement_with_correction_discreto;
error_distance  = displacement_with_correction_discreto -displacement_without_correction_discreto;


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

axis equal

