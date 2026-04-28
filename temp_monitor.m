function temp_monitor(a)
% TEMP_MONITOR Live temperature monitoring and LED control.
% Reads temperature from A0 every 1s, updates a live plot.
% Controls 3 LEDs based on comfort range (18-24C):
% Green (D10): Constant ON if 18-24C.
% Yellow (D11): Blinks at 0.5s intervals if < 18C.
% Red (D12): Blinks at 0.25s intervals if > 24C.
% Close the figure window to terminate the function.

    % Initialize the chart
    fig = figure('Name', 'Live Temperature Monitor');
    hLine = plot(nan, nan, 'b-', 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('Temperature (^\circC)');
    title('Real-Time Capsule Temperature');
    grid on;
    
    time_data = [];
    temp_data = [];
    
    % Set up multiple independent timers
    start_time = tic;
    last_read_time = tic;
    last_yellow_blink = tic;
    last_red_blink = tic;
    
    % Record the current on-off status of the light.
    yellow_state = 0;
    red_state = 0;
    
    disp('Temperature monitor running... Close the graph window to stop.');
    
    % Read the temperature once initially to avoid having no data in the first second.
    v_out = readVoltage(a, 'A0');
    current_temp = (v_out - 0.5) / 0.01;
    
    % When the chart window is present, it runs in an infinite loop. 
    while ishandle(fig)
        current_time = toc(start_time);
        % 1. Read data and update charts 
        if toc(last_read_time) >= 1.0
            v_out = readVoltage(a, 'A0');
            current_temp = (v_out - 0.5) / 0.01;
            
            time_data = [time_data, current_time];
            temp_data = [temp_data, current_temp];
            
            % Real-time updated line chart
            set(hLine, 'XData', time_data, 'YData', temp_data);
            
            % Make the X-axis dynamically scroll to display the data from the last 60 seconds.
            if current_time > 60
                xlim([current_time - 60, current_time + 5]);
            else
                xlim([0, max(10, current_time + 5)]);
            end
            drawnow; % Force MATLAB to immediately refresh the image
            
            last_read_time = tic; % Reset the read timer
        end
        
        % 2. LED control logic 
        if current_temp < 18
            % Turn off the green light and the red light
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D12', 0);
            
            % The yellow light flashes every 0.5 seconds.
            if toc(last_yellow_blink) >= 0.5
                yellow_state = ~yellow_state; % State reversal
                writeDigitalPin(a, 'D11', yellow_state);
                last_yellow_blink = tic;
            end
            
        elseif current_temp >= 18 && current_temp <= 24
            % The green light is always on, while the others are turned off.
            writeDigitalPin(a, 'D10', 1);
            writeDigitalPin(a, 'D11', 0);
            writeDigitalPin(a, 'D12', 0);
            
        else % current_temp > 24
            % Turn off the green light and the yellow light
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D11', 0);
            
            % The red light flashes extremely rapidly every 0.25 seconds.
            if toc(last_red_blink) >= 0.25
                red_state = ~red_state; % State reversal
                writeDigitalPin(a, 'D12', red_state);
                last_red_blink = tic;
            end
        end
        
        % A very short pause
        pause(0.05); 
    end
    
    % After closing the window, turn off all the lights and form a good habit.
    writeDigitalPin(a, 'D10', 0);
    writeDigitalPin(a, 'D11', 0);
    writeDigitalPin(a, 'D12', 0);
    disp('Monitor stopped.');
end