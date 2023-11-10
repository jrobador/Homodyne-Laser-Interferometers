clear all
close all
clc

%Frecuencia de muestreo:

%f_signal_max = 7000
%velocity_signal_max = 

f_max =   6800;

% global cycle_counter_direction;
global T_s_adc;

% global x_mem_length;
% global counter;
% global velocity_counter_update;
% global velocity_time_update;
% global cycle_counter;
% global y_mem;
% global x_mem;
% global phi_t0;
% global actual_velocity_mem;




%Parametro de simulación
nciclos         = 75;                %Cantidad de ciclos simulados


T_s_continuo = 1e-6;
f_s_continuo = 1/T_s_continuo;

% Define the CSV file name
signal_1 =  '../Docs/senales_del_5_10_23/senal_1/RefCurve_2023-10-05_1_152357.Wfm.bin';
signal_2 =  '../Docs/senales_del_5_10_23/senal_2/RefCurve_2023-10-05_1_153025.Wfm.bin';
signal_3 =  '../Docs/senales_del_5_10_23/senal_2/RefCurve_2023-10-05_1_153701.Wfm.bin';
signal_4 =  '../Docs/senales_del_5_10_23/senal_4/RefCurve_2023-10-05_1_154212.Wfm.bin';
signal_5 =  '../Docs/senales_del_5_10_23/senal_5/RefCurve_2023-10-05_0_155044.Wfm.bin';


nombreArchivo = signal_4;
% Open the file
fileID = fopen(nombreArchivo, 'rb'); % Use 'rb' for binary files

% Check if fopen was successful
if fileID == -1
    error('Failed to open the file. Check the file path and permissions.');
end

% Read the binary data from the file
datos = fread(fileID, [2 inf], 'float');

% Close the file
fclose(fileID);

length_data = length(datos);

% Extract the two columns into separate vectors
x_continuo_with_DC = datos(1, fix(0.1*length_data)+1:fix(1*length_data));
y_continuo_with_DC = datos(2, fix(0.1*length_data)+1:fix(1*length_data));

DC_x_ = mean(x_continuo_with_DC(1.1e6:1.4e6));
DC_y_ = mean(y_continuo_with_DC(1.1e6:1.4e6));
DC_x = 2.334916058702977;
DC_y = 2.334916058702977;

day_5_10_signal_1_DC_x = 2.343874884930942;
day_5_10_signal_1_DC_y = 2.317484897654688;
day_5_10_signal_2_DC_x = 2.347196800489482;
day_5_10_signal_2_DC_y = 2.320153213670329;
day_5_10_signal_4_DC_x = 2.350440333533054;
day_5_10_signal_4_DC_y = 2.325077440278444;

day_28_10_signal_2_DC_x = 2.350611797314772;
day_28_10_signal_2_DC_y = 2.326030315304315;
day_28_10_signal_3_DC_x = 2.350263989766313;
day_28_10_signal_3_DC_y = 2.318026914087430;

% Calculate the averages for x and y components
promedio_signals_x = mean([day_5_10_signal_1_DC_x, day_5_10_signal_2_DC_x, day_5_10_signal_4_DC_x, day_28_10_signal_2_DC_x, day_28_10_signal_3_DC_x]);
promedio_signals_y = mean([day_5_10_signal_1_DC_y, day_5_10_signal_2_DC_y, day_5_10_signal_4_DC_y, day_28_10_signal_2_DC_y, day_28_10_signal_3_DC_y]);

% Display the results
disp(['Average of x components: ' num2str(promedio_signals_x)]);
disp(['Average of y components: ' num2str(promedio_signals_y)]);

% Average of x components: 2.3485
% Average of y components: 2.3214
% Average of both = 2.334916058702977


x_continuo = x_continuo_with_DC - DC_x;
y_continuo = y_continuo_with_DC - DC_y;

%Filtrado analogico
% Frecuencia de corte para el filtro pasabajos (un poco menos de 130 kHz)
f_corte = 150e3; 
% Orden del filtro (puedes ajustar este valor según tus necesidades)
orden = 6;

% Diseña el filtro pasabajos
[b, a] = butter(orden, f_corte / (f_s_continuo / 2), 'low');



% Aplica el filtro a las señales x_continuo e y_continuo

x_continuo = filter(b, a, x_continuo);
y_continuo = filter(b, a, y_continuo);

x_continuo = x_continuo(100:end);
y_continuo = y_continuo(100:end);






t_line_continuo = (0:T_s_continuo:T_s_continuo*(length(x_continuo)-1));
% Ahora tienes los datos en los vectores columna1 y columna2
% Puedes acceder a ellos como desees


%Factor de sobremuestreo discreto
npoints_discreto = 3;
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
plot(x_discreto,y_discreto,'-o')
hold all
plot(x_continuo,y_continuo,'-')
axis([-1 1 -1 1]), 
title(sprintf('Frecuencia=%d Delay=pi/2',f_max))
xlabel('Amplitud en x');
ylabel('Amplitud en y');
hold all
plot(x_continuo(1),y_continuo(1),'or')
hold all
plot(x_continuo(end),y_continuo(end),'og')
hold all
plot(x_discreto(1),y_discreto(1),'oy')
hold all
plot(x_discreto(end),y_discreto(end),'ok')
legend('muestras en discreto','valores continuos','fase inicial continuo','fase final continuo','fase inicial discreto','fase final discreto')
axis equal

viscircles([0,0],1,'Color','k');

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



% Calcular la FFT de la señal x_discreto
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

%-----------------Aca empieza la realidad-------------------------------------------

discrete_displacement_vector = (1:length(x_discreto));
continuous_displacement_vector = (1:length(x_discreto));
actual_velocity_vector = (1:length(x_discreto));

reset = 1;
T_s_adc = t_s_discreto;
counter = 0;
for i = 1:1:length(x_discreto)
        
    
    if(i == 1)
        reset = 1;
    else
        reset = 0;
    end
    [discrete_displacement,continuous_displacement,actual_velocity] = real_time_operation(x_discreto(i),y_discreto(i),reset);
    
    discrete_displacement_vector(i) = discrete_displacement;
    continuous_displacement_vector(i) = continuous_displacement;
    actual_velocity_vector(i) = actual_velocity;

end
%Representación de figuras de Lissajous con delay pi/2

%Grafico evoulucion contadores

figure
plot(t_line_discreto,discrete_displacement_vector)
hold all 
plot(t_line_discreto,continuous_displacement_vector)
hold all
plot(t_line_discreto,actual_velocity_vector)

legend('discrete_displacement_vector continuo','continuous_displacement_vector','actual_velocity_vector')
