figure
subplot(211)
stem(x_discreto)
hold all
plot(x_continuo,'-')
xlabel('tiempo')
legend('x discreto','x continuo')
subplot(212)
stem(t_line_discreto,y_discreto)
hold all
plot(t_line_continuo,y_continuo,'-')
xlabel('tiempo')
legend('y discreto','y continuo')
grid on