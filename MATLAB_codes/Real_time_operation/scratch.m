clear all
close all
clc

T_s = 0.005;
F_s = 1/T_s;

T = 0.1;
F = 1/T;

t = (0:T_s:5*T);
rng default  %initialize random number generator
x = sin(2*pi*t/T) + 1*rand(size(t));

f_locked_norm = F / (F_s/2); %(frecuencia chequeable normalizada) 
f_cut = f_locked_norm * 2 ;

b = fir1(5,f_cut);
a = 1;
y = filter(b,a,x);

plot(t,x)
hold all
plot(t,y)