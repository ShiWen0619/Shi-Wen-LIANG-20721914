clear;
a = arduino('COM7', 'Uno');
%% TASK 3 – ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]
VOC = 0.5;
TC  = 0.01;
greenPin  = 'D10';
yellowPin = 'D9';
redPin    = 'D8';

t_start = tic;
last_read = 0;
prev_temp = 0;
rate = 0;                    % temperature change rate in °C/s

% b)
while true
    t_now = toc(t_start);
    
    % Read temperature every 1 second
    if t_now - last_read >= 1
        Vout = readVoltage(a, 'A0');
        current_temp = (Vout - VOC) / TC;
        if prev_temp ~= 0
            rate = current_temp - prev_temp;
        end
        prev_temp = current_temp;
        
        % c)
        predicted_temp = current_temp + rate * 300;
        disp(['Current: ' num2str(current_temp,'%.2f') ' C | ' ...
              'Rate: ' num2str(rate*60,'%.2f') ' C/min | ' ...
              'Predicted (5min): ' num2str(predicted_temp,'%.2f') ' C']);
        
        last_read = t_now;
    end
    
    % d)
    rate_per_min = rate * 60;   % convert to °C/min
    
    if rate_per_min > 4
        % Fast increase → constant red light
        writeDigitalPin(a, redPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, greenPin, 0);
    elseif rate_per_min < -4
        % Fast decrease → constant yellow light
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, greenPin, 0);
    else
        % Stable → constant green light
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, greenPin, 1);
    end
    
    pause(0.05);
end