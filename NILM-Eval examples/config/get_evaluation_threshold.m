% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

function [threshold] = get_evaluation_threshold(appliance, household)

    thresholdMatrix = [15;   % Electric heater bedroom
                       15;   % Water Heater
                       15;  % Oven
                       15;  % TV
                       15;   % Coffee Maker
                       15;  % Electric kettle
                       15;  % Electric heater salong
                       15;   % Microwave oven
                       15;  % Electric heater terrace
                       15;  % Dishwasher
                       15;   % Refrigerator
                       15];   % Washing machine

    threshold = thresholdMatrix(appliance, household);             

end

