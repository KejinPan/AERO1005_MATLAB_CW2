% Insert name here
% Insert email address here


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Establish a communication connection with Arduino

a = arduino('COM9', 'Uno');


% Let the LED connected to pin D12 blink several times for testing
for i = 1:5
    writeDigitalPin(a, 'D12', 1); % Supply a high level (5V), and the light will turn on.
    pause(0.5);                   % Pause for 0.5 seconds
    writeDigitalPin(a, 'D12', 0); % Supply a low level (0V), and the light will turn on.
    pause(0.5);                   % Pause for 0.5 seconds
end

% Insert answers here

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here