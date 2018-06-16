function graphics2D_pointMassModel(WP,totalTrajectory,configuration)

    % Select variables to plot
    plotStates = configuration.options.plotStates; % Without quaternions
    plotControls = configuration.options.plotControls;
    plotEuler = configuration.options.plotStates;
    plotQuatNormError = configuration.options.plotStates;
    plotAccels = configuration.options.plotStates;
    plotSLdist = configuration.options.plotStates;
    createTimeSeries = true;

    % Calculate corresponding time for each WP
    middlePositions = [];
    for i = 1:totalTrajectory.numOfSegments-1
        middlePositions = [middlePositions totalTrajectory.segmentSize*i];
    end
    WP_time = [0 totalTrajectory.time(middlePositions) totalTrajectory.totalTime];
    WP_index = [1 middlePositions totalTrajectory.numOfPoints];

    % PLOT STATES
    if plotStates
        statesToPlot = {'Velocity [m/s]' 'q0' 'q1' 'q2' 'q3'...
            'North Position [m]' 'East Position [m]' 'Altitude [m]'};
        for i = 1:totalTrajectory.numOfStates
            if i == 1 % TAS and Flat-earth velocity
                % Obtain Flat-Earth velocity
                velocityEarth = zeros(numel(totalTrajectory.states(i,:)),1);
                for j = 1:numel(totalTrajectory.states(i,:))
                    velocityEarth(j) = tasAndWind2velocityEarthNorm(totalTrajectory.states(i,j),...
                        totalTrajectory.euler(2,j), totalTrajectory.euler(1,j),...
                        configuration.dynamics.windVelocityEarth);
                end
                figure
                hold on
                plot(totalTrajectory.time,totalTrajectory.states(i,:))
                plot(totalTrajectory.time,velocityEarth)
                for j = 1:numel(WP_time)
                    xval = WP_time(j);
                    ymin = min(min(totalTrajectory.states(i,WP_index(j)),0),velocityEarth(WP_index(j)));
                    ymax = max(max(totalTrajectory.states(i,WP_index(j)),0),velocityEarth(WP_index(j)));
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
                legend('True Air Speed','Velocity Earth')
                xlabel('Time [s]')
                ylabel(statesToPlot{i})
            elseif (i > 1) && (i < 6)
                % Do not plot quaternions
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
        controlsToPlot = {'Angle of Attack [�]' 'Thrust [N]'...
            'Angular Velocity in x-axis [�/s]'};
        for i = 1:totalTrajectory.numOfControls
            if i == 1 || i == 3 % Convert from radians to degrees
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
                plot(totalTrajectory.time,totalTrajectory.controls(i,:))
                for j = 1:numel(WP_time)
                    xval = WP_time(j);
                    ymin = min(totalTrajectory.controls(i,WP_index(j)),0);
                    ymax = max(totalTrajectory.controls(i,WP_index(j)),0);
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
    
    % PLOT EULER ANGLES (Convert from radians to degrees)
    if plotEuler
        eulerToPlot = {'Yaw [�]' 'Pitch [�]' 'Roll [�]'};
        for i = 1:3
            figure
            hold on
            plot(totalTrajectory.time,rad2deg(totalTrajectory.euler(i,:)))
            for j = 1:numel(WP_time)
                xval = WP_time(j);
                ymin = min(rad2deg(totalTrajectory.euler(i,WP_index(j))),0);
                ymax = max(rad2deg(totalTrajectory.euler(i,WP_index(j))),0);
                xPoints = [xval,xval];
                yPoints = [ymin,ymax];
                plot(xPoints,yPoints,'r--')
                text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
            end
            hold off
            grid
            margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
            xlim([-margin totalTrajectory.totalTime+margin]);
            title(eulerToPlot{i})
            xlabel('Time [s]')
            ylabel(eulerToPlot{i})
        end
    end
    
    % PLOT QUATERNION NORMALIZATION ERROR
    if plotQuatNormError
        quatNorm = sqrt(totalTrajectory.states(2,:).^2 + totalTrajectory.states(3,:).^2 + totalTrajectory.states(4,:).^2 + totalTrajectory.states(5,:).^2);
        eulerToPlot = {'Quaternion norm'};
        figure
        hold on
        plot(totalTrajectory.time,quatNorm)
        for j = 1:numel(WP_time)
            xval = WP_time(j);
            ymin = min(quatNorm(WP_index(j)),0);
            ymax = max(quatNorm(WP_index(j)),0);
            xPoints = [xval,xval];
            yPoints = [ymin,ymax];
            plot(xPoints,yPoints,'r--')
            text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
        end
        hold off
        grid
        margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
        xlim([-margin totalTrajectory.totalTime+margin]);
        title(eulerToPlot)
        xlabel('Time [s]')
        ylabel(eulerToPlot)
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
    
    % PLOT EAST DISTANCE TO SAFETY LINE
    if (plotSLdist == true) && (WP.SL_north(1) ~= false)
        distToPlot = {'Distance to Safety Line (East) [m]'};
        for i = 1:1
            figure
            hold on
            plot(totalTrajectory.time,totalTrajectory.SL_dist(i,:))
            for j = 1:numel(WP_time)
                xval = WP_time(j);
                ymin = min(totalTrajectory.SL_dist(i,WP_index(j)),0);
                ymax = max(totalTrajectory.SL_dist(i,WP_index(j)),0);
                xPoints = [xval,xval];
                yPoints = [ymin,ymax];
                plot(xPoints,yPoints,'r--')
                text(xval,ymax,num2str(j),'Color','r','VerticalAlignment','bottom')
            end
            hold off
            grid
            margin = totalTrajectory.totalTime/20; % Lateral margins for x-axis in seconds
            xlim([-margin totalTrajectory.totalTime+margin]);
            title(distToPlot{i})
            xlabel('Time [s]')
            ylabel(distToPlot{i})
        end
    end
    
    % CREATE TIMESERIES
    if createTimeSeries
        FG_q0 = timeseries(totalTrajectory.states(2,:)', totalTrajectory.time)';
        FG_q1 = timeseries(totalTrajectory.states(3,:)', totalTrajectory.time)';
        FG_q2 = timeseries(totalTrajectory.states(4,:)', totalTrajectory.time)';
        FG_q3 = timeseries(totalTrajectory.states(5,:)', totalTrajectory.time)';
        FG_x = timeseries(totalTrajectory.states(6,:)', totalTrajectory.time)';
        FG_y = timeseries(totalTrajectory.states(7,:)', totalTrajectory.time)';
        FG_alt = timeseries(totalTrajectory.states(8,:)', totalTrajectory.time)';
        FG_time = totalTrajectory.totalTime;
        assignin('base','FG_q0',FG_q0);
        assignin('base','FG_q1',FG_q1);
        assignin('base','FG_q2',FG_q2);
        assignin('base','FG_q3',FG_q3);
        assignin('base','FG_x',FG_x);
        assignin('base','FG_y',FG_y);
        assignin('base','FG_alt',FG_alt);
        assignin('base','FG_time',FG_time);
    end
    
end

