
function [f,c,ceq,totalTrajectory] = optimizeTrajectoryPointMassModel(WP,guess,configuration)

    segment = cell(WP.numOfWP-1,1);

    for i = 1:WP.numOfWP-1
        
        % Calculate initial TAS
        configuration.dynamics.initTAS = velocityEarthAndWind2tas(configuration.dynamics.initVel, 0, WP.heading(1), configuration.dynamics.windVelocityEarth);
        
        if i == 1 % Properties for first segment
            boundaries.phase1.initBoundsLow = [configuration.dynamics.initTAS;eul2quat([WP.heading(1) 0 0])';WP.north(1);WP.east(1);WP.up(1)];
            boundaries.phase1.initBoundsUpp = [configuration.dynamics.initTAS;eul2quat([WP.heading(1) 0 0])';WP.north(1);WP.east(1);WP.up(1)];
            boundaries.phase1.finalBoundsLow = [configuration.dynamics.minVel;eul2quat([WP.heading(2) 0 0])';WP.north(2);WP.east(2);WP.up(2)];
            boundaries.phase1.finalBoundsUpp = [configuration.dynamics.maxVel;eul2quat([WP.heading(2) 0 0])';WP.north(2);WP.east(2);WP.up(2)];
        end

        segmentGuess.time = guess.time{i};
        segmentGuess.states = guess.states{i};
        segmentGuess.controls = guess.controls{i};
        segment{i} = optimizeSegmentPointMassModel(boundaries,segmentGuess,configuration);
        
        % Properties for the rest of the segments
        if i ~= WP.numOfWP-1 % Not necessary in the last iteration
            lastVel = segment{i}.Phases(1).StateGrid.Values(1,end);
            boundaries.phase1.initBoundsLow = [lastVel;eul2quat([WP.heading(i+1) 0 0])';WP.north(i+1);WP.east(i+1);WP.up(i+1)];
            boundaries.phase1.initBoundsUpp = [lastVel;eul2quat([WP.heading(i+1) 0 0])';WP.north(i+1);WP.east(i+1);WP.up(i+1)];
            boundaries.phase1.finalBoundsLow = [configuration.dynamics.minVel;eul2quat([WP.heading(i+2) 0 0])';WP.north(i+2);WP.east(i+2);WP.up(i+2)];
            boundaries.phase1.finalBoundsUpp = [configuration.dynamics.maxVel;eul2quat([WP.heading(i+2) 0 0])';WP.north(i+2);WP.east(i+2);WP.up(i+2)];
        end
        
    end
    
    totalTrajectory.totalTime = 0;
    totalTrajectory.time = [];
    totalTrajectory.states = [];
    totalTrajectory.controls = [];
    totalTrajectory.accels = [];
    totalTrajectory.SL_dist = cell(2,1);
    totalTrajectory.SL_dist{1} = [];
    totalTrajectory.SL_dist{2} = [];
    for i = 1:WP.numOfWP-1
        totalTrajectory.time = [totalTrajectory.time segment{i}.Phases(1).RealTime+totalTrajectory.totalTime];
        totalTrajectory.totalTime = totalTrajectory.totalTime + segment{i}.Phases(1).FinalTime.Value;
        totalTrajectory.states = [totalTrajectory.states segment{i}.Phases(1).StateGrid.Values];
        totalTrajectory.controls = [totalTrajectory.controls segment{i}.Phases(1).ControlGrids.Values];
        totalTrajectory.accels = [totalTrajectory.accels segment{i}.Phases(1).PathConstraintFunctions(1).OutputGrid.Values(1:2,:)];
        if configuration.SL.active > 0
            totalTrajectory.SL_dist{1} = [totalTrajectory.SL_dist{1} segment{i}.Phases(1).PathConstraintFunctions(1).OutputGrid.Values(3,:)];
        end
        if configuration.SL.active > 1
            totalTrajectory.SL_dist{2} = [totalTrajectory.SL_dist{2} segment{i}.Phases(1).PathConstraintFunctions(1).OutputGrid.Values(4,:)];
        end
    end
    totalTrajectory.segmentSize = numel(segment{1}.Phases(1).RealTime);
    totalTrajectory.numOfSegments = WP.numOfWP - 1;
    totalTrajectory.numOfPoints = numel(totalTrajectory.time);
    [totalTrajectory.numOfStates,~] = size(totalTrajectory.states);
    [totalTrajectory.numOfControls,~] = size(totalTrajectory.controls);
    totalTrajectory.euler = quat2eul(totalTrajectory.states(2:5,:)','ZYX')';
    
    f = totalTrajectory.totalTime;
    c = [];
    ceq = [];
    
end

