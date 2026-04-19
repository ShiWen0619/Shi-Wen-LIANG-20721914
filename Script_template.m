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

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here