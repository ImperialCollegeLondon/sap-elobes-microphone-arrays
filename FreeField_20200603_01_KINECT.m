classdef FreeField_20200603_01_KINECT < FreeFieldArray
        properties (SetAccess=protected)
            % properties from ElobesMicArray
            sensorCartesianPositionsDefault
            refChan
        end
    methods
        function[obj] = FreeField_20200603_01_KINECT()
       
            % Use superclass to create the object
            obj = obj@FreeFieldArray();
            
            % Populate the parameters
            obj.sensorCartesianPositionsDefault = predefinedSensorPositions();
            obj.refChan = 1;  % reference is the origin

        end
    end
    
end

function[sensor_pos] = predefinedSensorPositions()
% evaluate to determine the postitions of the elements relative to
% the origin
%
% centre mic is origin, mic1. circular array numbered counterclockwise with
% mic2 being in the 'broadside' direction
radius=0.04; %40 mm radius
nMicsCirc = 6;
thetaStep = 360/nMicsCirc;
[x_pos, y_pos, z_pos] = mysph2cart(deg2rad(90+[0:thetaStep:360-thetaStep]), deg2rad(90)*ones(1,nMicsCirc),radius*ones(1,nMicsCirc));

%add ref mic at origin
sensor_pos = [[0,x_pos].',[0,y_pos].',[0,z_pos].'];

end