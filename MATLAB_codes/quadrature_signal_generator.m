function [x_signal, y_signal, t_line] = quadrature_signal_generator(t_s,tau,nciclos,phase_initial,f_max,A_x,A_y,B_x,B_y,delay)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if(phase_initial == 0 || phase_initial == pi/2 || phase_initial == pi || phase_initial == 3*pi/2)
    phase_initial =phase_initial + 1e-4;
end

t_line_initial = (0:t_s:5*tau);
x_signal_initial = A_x + B_x * cos(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1))+phase_initial);
y_signal_initial = A_y + B_y * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1))+phase_initial+delay);

syms t_symbol_1;
t_delay_for_continuity_1 = double(vpasolve(A_y + B_y*sin(2*pi*f_max*t_symbol_1+phase_initial+delay) == y_signal_initial(end),t_symbol_1));

t_line_constant = (t_line_initial(end):t_s:t_line_initial(end)+nciclos/f_max); %Tiempo de simulacion);
x_signal_constant = A_x + B_x *cos(2*pi*f_max*(t_line_constant-t_line_initial(end)+t_delay_for_continuity_1)+phase_initial);
y_signal_constant = A_y + B_y*sin(2*pi*f_max*(t_line_constant-t_line_initial(end)+t_delay_for_continuity_1)+delay+phase_initial);%%JC Había error acá con un paréntesis, Hacia que no coincidan los retardos

syms t_symbol_2;
t_delay_for_continuity_2 = double(vpasolve(A_y + B_y*sin(2*pi*f_max*tau*(1-exp(-t_symbol_2/tau))+phase_initial+delay) == y_signal_constant(end),t_symbol_2));

t_line_final = (t_line_constant(end):t_s:t_line_constant(end)+10*tau);
x_signal_final = A_x + B_x * cos(2*pi*f_max*tau*(1-exp(-(t_line_final-t_line_constant(end)+t_delay_for_continuity_2)/tau))+phase_initial);
y_signal_final = A_y + B_y * sin(2*pi*f_max*tau*(1-exp(-(t_line_final-t_line_constant(end)+t_delay_for_continuity_2)/tau))+delay+phase_initial);

x_signal =[x_signal_initial,x_signal_constant,x_signal_final];
y_signal =[y_signal_initial,y_signal_constant,y_signal_final];
t_line = [t_line_initial,t_line_constant,t_line_final];

end


