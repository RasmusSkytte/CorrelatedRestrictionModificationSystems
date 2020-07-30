function Fig4_Generator(k)

nSamples = 41;

% Load parameters
loadDefaultParameters

% Configure the loops
Eta_vals   = logspace(-6, -10, nSamples);
Alpha_vals = linspace(0.05, 0.75, nSamples);
Delta_vals = logspace(-2, 1, nSamples);
Beta_vals  = round(logspace(1, 3, nSamples));

% Prepare data folder
if ~exist('../data/Fig4', 'dir')
    mkdir('../data/Fig4')
    mkdir('../data/Fig4/Uncorrelated')
    mkdir('../data/Fig4/Correlated')
end

% Determine which test to run based on k
loop = find(k <= cumsum([numel(Eta_vals) numel(Alpha_vals) numel(Delta_vals) numel(Beta_vals)]), 1);

switch loop
    case 1
        Eta   = Eta_vals(k);
    case 2
        Alpha = Alpha_vals(k - numel(Eta_vals));
    case 3
        Delta = Delta_vals(k - numel(Eta_vals) - numel(Alpha_vals));
    case 4
        Beta  = Beta_vals(k  - numel(Eta_vals) - numel(Alpha_vals) - numel(Delta_vals));
end

% Perform run
for i = 1:2
    
    str = 'Correlated';
    if i == 2
        str = 'Uncorrelated';
        avgRM = 1;
    end
    
    % Containers for values
    D = [];
    B = [];
    P = [];
        
    % Loop over repeats
    for r = 1:5
       
        % Set seed
        rng(60 + r - 1);
        
        try
            % Run the map
            [B_end, P_end, DD] = simulateModel(Alpha, Beta, Eta, Delta, C, threshold, T, avgRM, f, lb, ub, iterations, inf, [], [], [], [], 'SS');
            
            % Store outputs
            D = [D DD];
            B = [B sum(B_end)];
            P = [P sum(P_end)];
        catch
        end
        
    end
    
    % Store the values
    save(sprintf('../data/Fig4/%s/alpha_%.2f_beta_%d_delta_1e%.3f_eta_1e%.2f.mat',       str, Alpha, Beta, log10(Delta), log10(Eta)), 'B', 'P', 'D', 'Alpha', 'Beta', 'Delta', 'Eta', 'C', 'threshold')

end

