% Define default parameters
C       = 1;    % Carrying capacity
Eta     = 1e-8; % Adsorption rate
Alpha   = 0.2;  % Dilution rate of bacteria
Beta    = 50;   % Burst size of phages
Delta   = 0.2;  % Decay rate of phages
T       = 1e4;  % Time between addition of species
lb      = -4;   % Lower bound for omega
ub      = 0;    % Upper bound for omega
avgRM   = 4;    % Average number of RM per species
N       = 1e3;  % Number of points in distribution clouds when limited
S       = 5;    % Min number of species

threshold = 1e-8; % Threshold value for bacterial densities.

% Compute normalization factor
f = 2-(1/2)^(1/avgRM-1);

iterations = 1e5; 	% Number of iterations
