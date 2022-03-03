classdef Sampled_Donley2021 < SampledArray & BinauralArray
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
        function[obj] = Sampled_Donley2021(distance)
            
            % use superclass to create the object with input parameter
            obj = obj@SampledArray();
            
            obj.supportsRotation=1; % using anechoic measurements 
            obj.availableInterpolationMethods = {'none','nearest_neighbour'};
            obj.interpolationMethod = 'nearest_neighbour';
            
            obj.sensorCartesianPositionsDefault = predefinedSensorPositions();
            %obj.refChan = nan; % reference is the origin
            obj.refChan = 2;
            
            % populate the parameters
            obj.refChanLeft = 5;
            obj.refChanRight = 6;
            obj.channelsLeft = [1;5];
            obj.channelsRight = [3;6];
            
            % specific to this array, have a choice of measurment distances
            if nargin==0
                distance = 100; % cm (not sure, just assuming, doest matter really)
            end
            obj.distance = distance/100; % in metres
            
        end
        function[rMin, rMax] = getValidSrcRadiusRange(obj)
            rMin = obj.distance;
            rMax = obj.distance;
        end
        function[ir,src_pos,fs] = loadSampledData(obj)
            % returns the raw impulse responses and their positions
            %       ir: impulse responses in [nSamples,nMic,nPos] matrix
            %  src_pos: source positions as [nPos x 3] matrix in cartesian
            %           co-ordinates
            %       fs: sample rate of the data (in Hz)
            
            % FRL's EasyCom Dataset
            rel_dir = obj.getDataDirectory();
            dat_path = fullfile(rel_dir,'Device_ATFs.h5');
            ir=h5read(dat_path,['/' 'IR']); % [nMic x nPos x nSamples]
            ir=permute(ir,[3 1 2]); % [nSamples,nMic,nPos]
            nPos= size(ir,3);
            fs=h5read(dat_path,['/' 'SamplingFreq_Hz']);
            phi=h5read(dat_path,['/' 'Phi']); % [nPos x 1] azimuth (radian)
            theta=h5read(dat_path,['/' 'Theta']); % [nPos x 1] inclination (radian)
            src_pos = mysph2cart(phi(:),theta(:),obj.distance*ones(nPos,1));
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
    nan nan nan;...
    nan nan nan;...
    ];

sensor_pos=sensor_pos(:,[3 1 2]); % yzx to xyz
sensor_pos = sensor_pos *1e-3; % in m
end