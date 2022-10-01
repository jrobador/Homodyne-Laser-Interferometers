function [x_signal, y_signal, t_line] = quadrature_signal_generator(t_s,tau,nciclos,f_max,A_x,A_y,B_x,B_y,delay)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

t_line_initial = (0:2*pi*t_s:5*tau);
x_signal_initial = A_x + B_x * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1)));
y_signal_initial = A_y + B_y * sin(2*pi*f_max*(t_line_initial+tau*(exp(-t_line_initial/tau)-1))+delay);

syms t_symbol_1;
t_delay_for_continuity_1 = double(vpasolve(sin(2*pi*f_max*t_symbol_1) == x_signal_initial(end),t_symbol_1));

t_line_constant = (t_line_initial(end):2*pi*t_s:t_line_initial(end)+nciclos/f_max); %Tiempo de simulacion);
x_signal_constant = A_x + B_x *sin(2*pi*f_max*(t_line_constant-t_line_initial(end)+t_delay_for_continuity_1));
y_signal_constant = A_y + B_y*sin(2*pi*f_max*(t_line_constant-t_line_initial(end)+t_delay_for_continuity_1)+delay);%%JC Había error acá con un paréntesis, Hacia que no coincidan los retardos

syms t_symbol_2;
t_delay_for_continuity_2 = double(vpasolve(sin(2*pi*f_max*tau*(1-exp(-t_symbol_2/tau))) == x_signal_constant(end),t_symbol_2));

t_line_final = (t_line_constant(end):2*pi*t_s:t_line_constant(end)+10*tau);
x_signal_final = A_x + B_x * sin(2*pi*f_max*tau*(1-exp(-(t_line_final-t_line_constant(end)+t_delay_for_continuity_2)/tau)));
y_signal_final = A_y + B_y * sin(2*pi*f_max*tau*(1-exp(-(t_line_final-t_line_constant(end)+t_delay_for_continuity_2)/tau))+delay);

x_signal =[x_signal_initial,x_signal_constant,x_signal_final];
y_signal =[y_signal_initial,y_signal_constant,y_signal_final];
t_line = [t_line_initial,t_line_constant,t_line_final];

end


