% This file is part of the project NILM-Eval (https://github.com/beckel/nilm-eval).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich, 2014
% Author: Romano Cicchetti

% Returns a matrix that specifies the phase of each (appliance,
% house)-pair
function [phase_matrix] = getPhaseMatrix(dataset) 

if strcmpi(dataset, 'eco')
    phase_matrix = [2 1 2 1 3 1; % fridge
                    1 1 2 1 0 0;    % freezer
                    0 0 0 1 3 0;    % microwave
                    0 1 0 0 0 0;    % dishwasher
                    0 2 2 3 2 2;    % entertainment
                    2 1 2 0 3 1;    % water kettle
                    0 1 0 0 0 0;    % cooker 
                    2 0 2 3 3 1;    % coffee machine
                    1 0 0 0 0 0;    % washing machine
                    3 0 0 0 0 0;    % dryer
                    0 1 0 2 0 2;    % lamp
                    1 0 0 0 3 0;    % pc
                    0 1 0 3 0 3;    % laptop
                    0 2 0 0 0 0;    % tv
                    0 2 0 0 0 0;    % stereo
                    0 1 2 3 3 0;    % tablet
                    0 0 0 0 0 3;    % router
                    0 0 0 0 2 0];    % illuminated fountain

elseif strcmpi(dataset, 'powermundsen')
    phase_matrix = [3;        % Electric heater bedroom
                    2;        % Water Heater
                    2;        % Oven
                    2;        % TV
                    3;        % Coffee Maker
                    2;        % Electric kettle
                    3;        % Electric heater salong
                    2;        % Microwave oven
                    3;        % Electric heater terrace
                    1;       % Dishwasher
                    3;       % Fridge
                    1];      % Washing machine

                    
else
	    error('dataset not available');
end

end
