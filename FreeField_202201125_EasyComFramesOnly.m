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

% FRL's AR glass sensor positions
% taken from https://github.com/facebookresearch/EasyComDataset

% Note the different coordiaten system
% Ours (here)   |    Theirs (FRL)
% ---------------------------------
%       X       |       Z       
%       Y       |       X       
%       Z       |       Y       

% their given xyz (in mm) - yzx in our format
sensor_pos = [...
    82 -5 -29;...
    -1 -1 30;...
    -77 -2 11;...
    -83 -5 -60;...
    ];

sensor_pos=sensor_pos(:,[3 1 2]); % yzx to xyz
sensor_pos = sensor_pos *1e-3; % in m
end