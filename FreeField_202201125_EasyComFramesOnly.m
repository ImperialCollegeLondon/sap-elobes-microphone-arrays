classdef FreeField_202201125_EasyComFramesOnly < FreeFieldArray
        properties (SetAccess=protected)
            % properties from ElobesMicArray
            sensorCartesianPositionsDefault
            refChan
    
        end
    methods
        function[obj] = FreeField_202201125_EasyComFramesOnly()
       
            % Use superclass to create the object
            obj = obj@FreeFieldArray();
            
            % Populate the parameters
            obj.sensorCartesianPositionsDefault = predefinedSensorPositions();
            obj.refChan = 2;  % in the middle (between the eyes)
        end
    end
    
end

function[sensor_pos] = predefinedSensorPositions()
% evaluate to determine the postitions of the elements relative to
% the origin

sensor_pos = 1e-3 .* [... % [x,y,z] offsets of sensors
        82, -5, -29;...
        -1, -1,  30;...
       -77, -2,  11;...
       -83, -5, -60];
end