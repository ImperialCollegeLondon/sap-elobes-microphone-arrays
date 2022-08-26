classdef Sampled_20220826_Thiemann2019_bte_horiz_o15a_approx < SampledArray & BinauralArray
    properties (SetAccess=protected)
        % properties from ElobesMicArray
        sensorCartesianPositionsDefault
        refChan
            
        % properties from BinauralArray
        refChanLeft
        refChanRight
        channelsLeft
        channelsRight
        
        % new properties to allow level to be calibrated to measurements
        %micGain
    end
    
    properties (Hidden)
        % Store some precomputed values
        distance = [];
    end
    methods
        function[obj] = Sampled_20220826_Thiemann2019_bte_horiz_o15a_approx()
            
            % use superclass to create the object with input parameter
            obj = obj@SampledArray();
            
            obj.supportsRotation=1; % using anechoic measurements 
            obj.availableInterpolationMethods = {'none','nearest_neighbour'};
            obj.interpolationMethod = 'nearest_neighbour';
            
            obj.sensorCartesianPositionsDefault = predefinedSensorPositions();
            obj.refChan = nan; % reference is the origin
            
            % populate the parameters
            obj.refChanLeft = 1;
            obj.refChanRight = 2;
            obj.channelsLeft = [1;3];
            obj.channelsRight = [2;4];
            
            obj.distance = 1.2; % in metres
            
        end
        function[rMin, rMax] = getValidSrcRadiusRange(obj)
            rMin = obj.distance;
            rMax = obj.distance;
        end
        function[ir,src_pos,fs] = loadSampledData(obj)
            rel_dir = obj.getDataDirectory()
            dat_path = fullfile(rel_dir,'hrir.mat');
            in_dat = load(dat_path);
            
            ir = in_dat.hrir;
            src_pos = ElobesMicArray.mysph2cart(deg2rad(in_dat.az_deg),...
                                 deg2rad(in_dat.inc_deg),...
                                 obj.distance);
            fs = in_dat.fs;
        end
    end

end

function[sensor_pos] = predefinedSensorPositions()
% evaluate to determine the postitions of the elements relative to
% the origin
radius = 0.09;%obj.sphereRadius; %0.082;     % radius on which microphones lie [metres]
spacing = 0.015;   % distance between front and back microphones [metres]
angle_offset = deg2rad(7.5); % line bisecting microphones is offset back from a line through the sphere

angle_spacing = asin(spacing/2 /radius);
az = [pi/2 + angle_offset - angle_spacing; ...%front left
    -(pi/2 + angle_offset) + angle_spacing; ...%front right
    pi/2 + angle_offset + angle_spacing; ...%rear left
    -(pi/2 + angle_offset) - angle_spacing];   %rear right
inc = pi/2 * ones(4,1);

sensor_pos = radius * [cos(az).*sin(inc), sin(az).*sin(inc), cos(inc)]; % [x,y,z] offsets of sensors
end