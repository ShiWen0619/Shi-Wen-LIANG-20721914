function temp_prediction(a)
a = arduino('COM5', 'Uno'); 

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]
greenPin  = 'D10';
yellowPin = 'D9';
redPin    = 'D8';
VOC = 0.5;
TC  = 0.01;

% 初始化数据
    temps = [];      % 温度历史
    times = [];      % 时间历史
    t_start = tic;
    last_read = 0;

    disp('=== Task 3 Temperature Prediction Started ===');
    disp('Rate > +4°C/min  → Red LED ON');
    disp('Rate < -4°C/min  → Yellow LED ON');
    disp('Stable           → Green LED ON');

    while true
        t_now = toc(t_start);
        
        % 每1秒读取一次温度
        if t_now - last_read >= 1
            Vout = readVoltage(a, 'A0');
            current_temp = (Vout - VOC) / TC;
            
            % 保存历史数据（用于计算变化率）
            times(end+1) = t_now;
            temps(end+1) = current_temp;
            
            % b) 计算温度变化率 (°C/s) —— 使用最近10秒数据减少噪声
            rate = 0;   % 默认变化率
            if length(temps) >= 11
                recent_times = times(end-9:end);
                recent_temps = temps(end-9:end);
                p = polyfit(recent_times, recent_temps, 1);
                rate = p(1);                    % °C/s
            end
            
            % c) 预测5分钟（300秒）后的温度
            predicted_temp = current_temp + rate * 300;
            
            % 显示结果
            disp(['Current: ' num2str(current_temp,'%.2f') '°C | ' ...
                  'Rate: ' num2str(rate*60, '%.2f') ' °C/min | ' ...
                  'Predicted (5min): ' num2str(predicted_temp,'%.2f') '°C']);
            
            last_read = t_now;
        end
        
        % d) 根据变化率控制 LED（常亮）
        rate_per_min = rate * 60;   % 转换为 °C/min
        
        if rate_per_min > 4
            writeDigitalPin(a, redPin,    1);   % 升温太快 → 红灯
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, greenPin,  0);
        elseif rate_per_min < -4
            writeDigitalPin(a, redPin,    0);
            writeDigitalPin(a, yellowPin, 1);   % 降温太快 → 黄灯
            writeDigitalPin(a, greenPin,  0);
        else
            writeDigitalPin(a, redPin,    0);
            writeDigitalPin(a, yellowPin, 0);
            writeDigitalPin(a, greenPin,  1);   % 稳定 → 绿灯
        end
        
        pause(0.05);
    end
end