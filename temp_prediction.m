function temp_prediction(a)
% TEMP_PREDICTION Monitors temperature and predicts future values.
% Continuously calculates the rate of temperature change (C/s) using a
% 10-second moving window to smooth out noise spikes. It prints the 
% current temperature and expected temperature in 5 minutes.
% LED Indicators:
% - Red (D12): Temp increasing > +4 C/min.
% - Yellow (D11): Temp decreasing < -4 C/min.
% - Green (D10): Temp is stable within the comfort range.

% Initialize buffers for the moving window (medium term smoothing)
buffer_size = 10; % Store data for the last 10 seconds
time_buffer = [];
temp_buffer = [];

disp('Temperature Prediction Running... Press Ctrl+C to stop in the Command Window.');

start_time = tic;

while true
    % 1. Read current data
    v_out = readVoltage(a, 'A0');
    current_temp = (v_out - 0.5) / 0.01;
    current_time = toc(start_time);

    % 2. Update sliding window buffers
    time_buffer = [time_buffer, current_time];
    temp_buffer = [temp_buffer, current_temp];

    % Keep only the latest 'buffer_size' samples
    if length(time_buffer) > buffer_size
        time_buffer(1) = [];
        temp_buffer(1) = [];
    end

    % 3. Calculate Rate of Change (Derivative) with Noise Filtering
        rate_C_per_sec = 0;
        
        if length(time_buffer) > 1
            % Use the built-in polyfit (polynomial fitting) function in MATLAB
            % It will refer to all the data points within the past 10 seconds and calculate the most stable slope, completely disregarding any sudden noise.
            p = polyfit(time_buffer, temp_buffer, 1);
            rate_C_per_sec = p(1); % The first coefficient of the fitted straight line is the slope (C/s)
            
            % We take the average temperature of these 10 seconds as the current display.
            current_temp = mean(temp_buffer); 
        end
        
        % Convert the rate per second to the rate per minute
        rate_C_per_min = rate_C_per_sec * 60;
        
        % 4. Predict expected temperature in 5 minutes (300 seconds)
        % Based on the stable current temperature and the filtered stable slope for prediction
        predicted_temp = current_temp + (rate_C_per_sec * 300);

    % 5. Print to console
    fprintf('Current Temp: %.2f C | Rate: %.4f C/s | Expected in 5 mins: %.2f C\n', ...
        current_temp, rate_C_per_sec, predicted_temp);

    % 6. LED Control Logic
    if rate_C_per_min > 4
        % Increasing too fast
        writeDigitalPin(a, 'D10', 0);
        writeDigitalPin(a, 'D11', 0);
        writeDigitalPin(a, 'D12', 1); % Red ON

    elseif rate_C_per_min < -4
        % Decreasing too fast
        writeDigitalPin(a, 'D10', 0);
        writeDigitalPin(a, 'D11', 1); % Yellow ON
        writeDigitalPin(a, 'D12', 0);

    else
        % Rate is stable. Check if it's within comfort range (18-24C)
        if current_temp >= 18 && current_temp <= 24
            writeDigitalPin(a, 'D10', 1); % Green ON
        else
            writeDigitalPin(a, 'D10', 0); % Turn off if stable but out of bounds
        end
        writeDigitalPin(a, 'D11', 0);
        writeDigitalPin(a, 'D12', 0);
    end

    pause(1); % Wait 1 second before next cycle
end
end