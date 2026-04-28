% Insert name here
% Insert email address here


%% PRELIMINARY TASK - PRELIMINARY TASKARDUINO AND GIT INSTALLATION [5 MARKS]

% Establish a communication connection with Arduino

if ~exist('a', 'var')
    a = arduino('COM9', 'Uno');
end


% Let the LED connected to pin D12 blink several times for testing

for i = 1:5
    writeDigitalPin(a, 'D12', 1); % Supply a high level (5V), and the light will turn on.
    pause(0.5);                   % Pause for 0.5 seconds
    writeDigitalPin(a, 'D12', 0); % Supply a low level (0V), and the light will turn on.
    pause(0.5);                   % Pause for 0.5 seconds
end

% Insert answers here

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

duration = 600; % The designated collection time
temp = zeros(1, duration); % Pre-allocate memory for storing temperature data
time = 1:duration;         % timer shaft

% 1. reading data
disp('Start recording the temperature data for 10 minutes. Please be patient and wait.');
for i = 1:duration
    v_out = readVoltage(a, 'A0'); % Read the voltage from the A0 interface
    % Convert voltage to temperature
    temp(i) = (v_out - 0.5) / 0.01; 
    pause(1); % About once every second.
end

% 2. Calculate statistical data
maxi = max(temp);
mini = min(temp);
average = mean(temp);

% 3. plot
figure;
plot(time, temp, 'b-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature (^\circC)');
title('Spacecraft Capsule Temperature over 10 Minutes');


% 4. Print formatted data to the screen 
current_date = datestr(now, 'dd/mm/yyyy');
fprintf('Data logging initiated - %s\n', current_date);
fprintf('Location - Nottingham\n\n'); % \n\n 

% Loop from 0 to 10 minutes
for m = 0:10
    % Decide which data point to extract
    if m == 0
        idx = 1; % At the 0th minute, which is the first data point at the very beginning.
    else
        idx = m * 60; % Locate the corresponding data point
    end
    
    % Ensure the output format
    fprintf('Minute\t\t%d\n', m);
    fprintf('Temperature\t%.2f C\n\n', temp(idx));
end

fprintf('Max temp\t\t%.2f C\n', maxi);
fprintf('Min temp\t\t%.2f C\n', mini);
fprintf('Average temp\t%.2f C\n\n', average);
fprintf('Data logging terminated\n');


% 5. Write to the text file "capsule_temperature.txt"
fileID = fopen('capsule_temperature.txt', 'w');
fprintf(fileID, 'Data logging initiated - %s\n', current_date);
fprintf(fileID, 'Location - Nottingham\n\n');

for m = 0:10
    if m == 0
        idx = 1;
    else
        idx = m * 60;
    end
    fprintf(fileID, 'Minute\t\t%d\n', m);
    fprintf(fileID, 'Temperature\t%.2f C\n\n', temp(idx));
end

fprintf(fileID, 'Max temp\t\t%.2f C\n', maxi);
fprintf(fileID, 'Min temp\t\t%.2f C\n', mini);
fprintf(fileID, 'Average temp\t%.2f C\n\n', average);
fprintf(fileID, 'Data logging terminated\n');
fclose(fileID);

% Insert answers here

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% Apply the monitoring function

temp_monitor(a);

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

temp_prediction(a);

% Insert answers here


