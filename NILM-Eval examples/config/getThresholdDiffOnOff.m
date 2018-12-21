% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

% Returns a threshold that defines whether
% the specified appliance is in state 'on' or 'off'
function [threshold] = getThresholdDiffOnOff(applianceID) 
    
threshold_vector = [
                    
        500;   % Electric heater bedroom
        500;   % Water Heater
        500;  % Oven
        30;  % TV
        15;   % Coffee Maker
        500;  % Electric kettle
        500;  % Electric heater salong
        500;   % Microwave oven
        500;  % Electric heater terrace
        500;  % Dishwasher
        15;   % Fridge
        500;   % Washing machine
    ];

     threshold = threshold_vector(applianceID,1);
end


