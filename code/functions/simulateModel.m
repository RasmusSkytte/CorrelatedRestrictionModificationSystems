function [B_end, P_end, D_end, bacteria, phages, diversity, gamma, omega, gamma_0, omega_0] = simulateModel(alpha, beta, eta, delta, C, T, avgRM, f, lb, ub, iterations, N, pD, pB, pP, sname, varargin)

% Determine solver
if numel(varargin) == 1 && strcmpi(varargin{1}, 'SS')
    useODE = false;
else
    useODE = true;
end

% Initialize empty lists
gamma = [];
omega = [];

gamma_0 = [];
omega_0 = [];

I = [];
y = [];

bacteria  = nan(1, iterations);
phages    = nan(1, iterations);
diversity = nan(1, iterations);


% Check if the sytems is limited
if N < inf
    [gamma_0, omega_0] = sampleDistribution(avgRM, lb, ub, f, N);
end

% Keep track of total bacterial population and total phage population
BB = 0;
PP = 0;

% Main loop
for i = 1:iterations
    
    % Generate new species
        if i <= iterations
        
        % Check if the sytems is limited
        if N < inf
            
            % All species are considered viable
            J = true(size(gamma_0));
            
            % Determine the subset of viable, unchosen species
            J = and(J, ~ismember(gamma_0, gamma));
            
            % Select random specie from viable
            J = find(J);
            
            % Are all viable species sampled?
            if isempty(J)
                return;
            end
            
            j = randi(numel(J));
            gamma = [gamma; gamma_0(J(j))];
            omega = [omega; omega_0(J(j))];
            
        else
            
            % Generate new gamma, omega value
            [g, o]  = sampleDistribution(avgRM, lb, ub, f, 1);
            gamma   = [gamma;   g];
            omega   = [omega;   o];
            gamma_0 = [gamma_0; g];
            omega_0 = [omega_0; o];
        end
        
    end
    
    % Count the number of species
    nB = numel(gamma);
    
    % Solve system using ODE solver
    if useODE
        
        % Set starting conditions
        if i == 1
            x0 = ones(2*nB, 1); % Everyone starts with a population of 1
        else
            b = ones(nB-sum(I), 1); % New bacteria and phages start with a population of 1
            x0 = [y(1:sum(I), end); b; abs(y(sum(I)+(1:sum(I)), end)); b];
        end
        
        % Run dynamics
        [~, ~, y] = DynamicalSystem(gamma, omega, {alpha, beta, eta, delta, C, T}, x0);
        
        % Determine the end populations
        B_end = y(1:nB, end);
        P_end = y((nB+1):end, end);
        
        
    else % Solve system using Steady State solution
        
        % Is the added point unviable?
        if gamma(end) * (1 - BB / C) < alpha + eta * omega(end) * PP
            
            gamma(end) = [];
            omega(end) = [];
            continue;
            
        else
            
            % Compute populations
            [B_end, P_end] = computePopulations(alpha, beta, eta, delta, C, gamma, omega);
            
            % Remove non-viable and recompute
            while any(B_end < 1)
                [~, I] = min(B_end);
                gamma(I) = [];
                omega(I) = [];
                
                [B_end, P_end] = computePopulations(alpha, beta, eta, delta, C, gamma, omega);
            end
            
        end
        
    end
    
    % Apply threshold of survival
    I = B_end > 1;
    
    % Ignore species below threshold
    B_end(~I) = [];
    P_end(~I) = [];
    
    % Update total populations
    BB = sum(B_end);
    PP = sum(P_end);
    
    % Store data
    diversity(i) = sum(I);
    bacteria(i)  = sum(B_end);
    phages(i)    = sum(P_end);
    D_end        = diversity(i);
    
    % Remove the dead species
    if useODE
        y([~I; ~I], :) = [];
    end
    gamma(~I) = [];
    omega(~I) = [];
    
    % Plot progress
    if ~isempty(pD)
        pD.XData = [pD.XData i];
        pD.YData = [pD.YData D_end / beta];
    end
    
    if ~isempty(pB)
        pB.XData = [pB.XData i];
        pB.YData = [pB.YData sum(B_end) / C];
    end
    
    if ~isempty(pP)
        pP.XData = [pP.XData i];
        pP.YData = [pP.YData sum(P_end) / (10 * C)];
    end
    
    % Force graphic update
    drawnow;

    if mod(i, 100) == 0 && ~isempty(sname)
        save(sname, 'bacteria', 'phages', 'diversity', 'gamma', 'omega', 'gamma_0', 'omega_0', 'C', 'alpha', 'beta', 'eta', 'delta', 'C', 'T', 'avgRM', 'f', 'lb', 'ub', 'iterations')
    end
end