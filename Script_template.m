% Insert name here
% Insert email address here


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
clear;
a = arduino('COM5', 'Uno'); 
for i = 1:10
    writeDigitalPin(a, 'D4', 1); 
    pause(0.5);                   
    writeDigitalPin(a, 'D4', 0);                  
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
% b)
duration = 600;                    
temps = zeros(1, duration+1);      
V0C = 0.5;    
TC  = 0.01;         
disp('Data acquisition started');
for t = 1:duration+1
    Vout = readVoltage(a, 'A0');             
    temps(t) = (Vout - V0C) / TC;             
    if t < duration+1
        pause(1);                         
    end
end
disp('Data acquisition completed');
min_temp = min(temps);
max_temp = max(temps);
avg_temp = mean(temps);

% c)
figure('Position', [100 100 900 500]);
plot((0:duration)/60, temps, 'b-', 'LineWidth', 2);  
xlabel('Time (minutes)');
ylabel('Temperature (°C)');
title('Capsule Temperature Over 10 Minutes');
grid on;
saveas(gcf, 'capsule_temperature_plot.png');

% d)
data_date = input('Enter the date when data was recorded (dd/mm/yyyy): ', 's');      
location = input('Enter the actual location: ', 's');                 
fprintf('Data logging initiated - %s\n', data_date);
fprintf('Location - %s\n', location);

minute_indices = 1:60:length(temps);          
minute_temps   = temps(minute_indices);

for m = 0:10
    fprintf('Minute\t%d\n', m);
    fprintf('Temperature\t%.2f C\n', minute_temps(m+1));                           
end

fprintf('Max temp\t%.2f C\n', max_temp);
fprintf('Min temp\t%.2f C\n', min_temp);
fprintf('Average temp\t%.2f C\n', avg_temp);
disp('Data logging terminated');

% e) 
filename = 'capsule_temperature.txt';
fid = fopen(filename, 'w');
fprintf(fid, 'Data logging initiated - %s\n', data_date);
fprintf(fid, 'Location - %s\n\n', location);
for m = 0:length(minute_temps)-1
    fprintf(fid, 'Minute\t%d\n', m);
    fprintf(fid, 'Temperature\t%.2f C\n\n', minute_temps(m+1));
end
fprintf(fid, 'Max temp\t%.2f C\n', max_temp);
fprintf(fid, 'Min temp\t%.2f C\n', min_temp);
fprintf(fid, 'Average temp\t%.2f C\n', avg_temp);
fprintf(fid, 'Data logging terminated\n');
fclose(fid);
fid_check = fopen(filename, 'r');
fclose(fid_check);
disp('done');

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% temp_monitor


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]
% temp_prediction


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here