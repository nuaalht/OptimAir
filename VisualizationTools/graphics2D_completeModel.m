function graphics2D_completeModel(WP,totalTrajectory,configuration)

    % Select variables to plot
    plotStates = configuration.plotStates;
    plotControls = configuration.plotControls;
    plotAccels = configuration.plotStates;

    % Calculate corresponding time for each WP
    middlePositions = [];
    for i = 1:totalTrajectory.numOfSegments-1
        middlePositions = [middlePositions totalTrajectory.segmentSize*i];
    end
    WP_time = [0 totalTrajectory.time(middlePositions) totalTrajectory.totalTime];
    WP_index = [1 middlePositions totalTrajectory.numOfPoints];

    % PLOT STATES
    if plotStates
        statesToPlot = {'Vx [m/s]' 'Vy [m/s]' 'Vz [m/s]'...
            'Roll [�]' 'Pitch [�]' 'Yaw [�]'...
            'p [rad/s]' 'q [rad/s]' 'r [rad/s]'...
            'North Position [m]' 'East Position [m]' 'Altitude [m]'};
        for i = 1:totalTrajectory.numOfStates
            if (i > 3) && (i < 10) % Convert from radians to degrees
                figure
                hold on
                plot(totalTrajectory.time,rad2deg(totalTrajectory.states(i,:)))
                for j = 1:numel(WP_time)
                    xval = WP_time(j);
                    ymin = min(rad2deg(totalTrajectory.states(i,WP_index(j))),0);
                    ymax = max(rad2deg(totalTrajectory.states(i,WP_index(j))),0);
                    xPoints = [xval,xval];
                    yPoints = [ymin,ymax];
                    plot(xPoints,yPoints,'r--')
                    text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
                end
                hold off
                grid
                margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
                xlim([-margin totalTrajectory.totalTime+margin]);
                title(statesToPlot{i})
                xlabel('Time [s]')
                ylabel(statesToPlot{i})
            else
                figure
                hold on
                plot(totalTrajectory.time,totalTrajectory.states(i,:))
                for j = 1:numel(WP_time)
                    xval = WP_time(j);
                    ymin = min(totalTrajectory.states(i,WP_index(j)),0);
                    ymax = max(totalTrajectory.states(i,WP_index(j)),0);
                    xPoints = [xval,xval];
                    yPoints = [ymin,ymax];
                    plot(xPoints,yPoints,'r--')
                    text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
                end
                hold off
                grid
                margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
                xlim([-margin totalTrajectory.totalTime+margin]);
                title(statesToPlot{i})
                xlabel('Time [s]')
                ylabel(statesToPlot{i})
            end
        end
    end
        
    % PLOT CONTROLS
    if plotControls
        controlsToPlot = {'Aileron deflection [�]' 'Elevator deflection [�]'...
            'Rudder deflection [�]' 'Throttle command [%]'};
        for i = 1:totalTrajectory.numOfControls
            if i < 4 % Convert from radians to degrees
                figure
                hold on
                plot(totalTrajectory.time,rad2deg(totalTrajectory.controls(i,:)))
                for j = 1:numel(WP_time)
                    xval = WP_time(j);
                    ymin = min(rad2deg(totalTrajectory.controls(i,WP_index(j))),0);
                    ymax = max(rad2deg(totalTrajectory.controls(i,WP_index(j))),0);
                    xPoints = [xval,xval];
                    yPoints = [ymin,ymax];
                    plot(xPoints,yPoints,'r--')
                    text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
                end
                hold off
                grid
                margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
                xlim([-margin totalTrajectory.totalTime+margin]);
                title(controlsToPlot{i})
                xlabel('Time [s]')
                ylabel(controlsToPlot{i})
            else
                figure
                hold on
                plot(totalTrajectory.time,totalTrajectory.controls(i,:).*100)
                for j = 1:numel(WP_time)
                    xval = WP_time(j);
                    ymin = min(totalTrajectory.controls(i,WP_index(j)).*100,0);
                    ymax = max(totalTrajectory.controls(i,WP_index(j)).*100,0);
                    xPoints = [xval,xval];
                    yPoints = [ymin,ymax];
                    plot(xPoints,yPoints,'r--')
                    text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
                end
                hold off
                grid
                margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
                xlim([-margin totalTrajectory.totalTime+margin]);
                title(controlsToPlot{i})
                xlabel('Time [s]')
                ylabel(controlsToPlot{i})
            end
        end
    end
    
    % PLOT ACCELERATIONS
    if plotAccels
        accelsToPlot = {'Acceleration module [m/s^2]' 'Acceleration z-axis [m/s^2]'};
        for i = 1:2
            figure
            hold on
            plot(totalTrajectory.time,totalTrajectory.accels(i,:))
            for j = 1:numel(WP_time)
                xval = WP_time(j);
                ymin = min(totalTrajectory.accels(i,WP_index(j)),0);
                ymax = max(totalTrajectory.accels(i,WP_index(j)),0);
                xPoints = [xval,xval];
                yPoints = [ymin,ymax];
                plot(xPoints,yPoints,'r--')
                text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
            end
            hold off
            grid
            margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
            xlim([-margin totalTrajectory.totalTime+margin]);
            title(accelsToPlot{i})
            xlabel('Time [s]')
            ylabel(accelsToPlot{i})
        end
    end
    
end

