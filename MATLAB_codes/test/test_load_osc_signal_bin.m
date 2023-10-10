clear all
close all
clc

% Define the CSV file name
nombreArchivo = '../Docs/senales_del_5_10_23/senal_1/RefCurve_2023-10-05_1_152357.Wfm.bin';
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

% Extract the two columns into separate vectors
x_continuo = datos(1, :);
y_continuo = datos(2, :);

t_line_continuo = (0:5e-7:5e-7*(length(x_continuo)-1));

% Now that you have the data in the column vectors, you can manipulate and plot them
plot(t_line_continuo, x_continuo)
hold all
plot(t_line_continuo, y_continuo)

DC_x = 2.2879;
DC_y = 2.4051;

x_continuo = x_continuo - DC_x;
y_continuo = y_continuo - DC_y;