clear;
a = arduino('COM7', 'Uno');

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% h)
greenPin = 'D10';
yellowPin = 'D9';
redPin = 'D8';
VOC = 0.5;
TC = 0.01;

% i)
figure('Position',[100 100 900 500]);
h = plot(0,20,'b-','LineWidth',2);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Live Capsule Temperature Monitoring');
grid on;
xlim([0 60]);
ylim([10 35]);

% Initialize data and timing variables
time_data = 0;
temp_data = 20;
t_start = tic;         % Start timer
last_read = 0;

% Read initial temperature
Vout = readVoltage(a, 'A0');
current_temp = (Vout - VOC) / TC;

% Variables for blinking LEDs
last_yellow = 0;
last_red = 0;
yellow_state = 0;
red_state = 0;

% Main monitoring loop
while true
    t_now = toc(t_start);   % Get current time
    
    % i)
    if t_now - last_read >= 1
        Vout = readVoltage(a, 'A0');
        current_temp = (Vout - VOC) / TC;   % Convert voltage to temperature
        
        time_data(end+1) = t_now;
        temp_data(end+1) = current_temp;
        
        set(h, 'XData', time_data, 'YData', temp_data);
        drawnow;
        
        % Adjust x-axis to show recent data
        if length(time_data) > 60
            xlim([t_now-60, t_now]);
        else
            xlim([0 max(60, t_now)]);
        end
        
        ylim([min(10, min(temp_data)-3), max(35, max(temp_data)+3)]);
        
        disp(['Current Temp = ' num2str(current_temp, '%.2f') ' °C']);
        last_read = t_now;
    end
    
    % j)
    if current_temp >= 18 && current_temp <= 24
        % Normal range: Green LED on
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
        
    elseif current_temp < 18
        % Too low: Yellow LED blinking
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, redPin, 0);
        if t_now - last_yellow >= 0.5
            yellow_state = ~yellow_state;
            writeDigitalPin(a, yellowPin, yellow_state);
            last_yellow = t_now;
        end
        
    else
        % Too high: Red LED blinking fast
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        if t_now - last_red >= 0.25
            red_state = ~red_state;
            writeDigitalPin(a, redPin, red_state);
            last_red = t_now;
        end
    end
    
    pause(0.05);   % Small delay to reduce CPU usage
end