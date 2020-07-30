function FigS3_Generator(k)

% Load parameters
loadDefaultParameters

% Create data folder
if ~exist('../data', 'dir')
    mkdir('../data')
end
if ~exist('../data/FigS3', 'dir')
    mkdir('../data/FigS3')
end

% Loop over system sizes
M = round(logspace(1, 3, 100));

% Skip completed runs
if exist(sprintf('../data/FigS3/run_%d.mat', k), 'file')
    return;
end

% Seed the simulation?
rng(60);

% Create save name
sname = sprintf('../data/FigS3/run_%d.mat', k);

% Simulate the model
[B_end, P_end, D_end] = simulateModel(Alpha, Beta, Eta, Delta, C, threshold, T, avgRM, f, lb, ub, 10*M(k), M(k), [], [], [], sname);
N = M(k);

% Save the data
save(sname, 'B_end', 'P_end', 'D_end', 'Alpha', 'Beta', 'Delta', 'Eta', 'C', 'threshold', 'N');

end
