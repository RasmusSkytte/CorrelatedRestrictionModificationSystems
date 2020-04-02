close all;
clearvars;

% Load parameters
loadDefaultParameters

% Create iterations to loop over
I = 10.^(1:log10(iterations));


% Loop over models
for j = 1:2
            
    fh = figure();
    fh.Position(1) = 0.5  * fh.Position(1);
    fh.Position(3) = 2    * fh.Position(3);
    fh.Position(4) = 1.75  * fh.Position(4);

    % Loop over itrations
    for i = 1:numel(I)

        % Seed the simulation?
        rng(60);
        
        % Load parameters
        loadDefaultParameters
        
        % Set the current iterations
        iterations = I(i);
        
        % Create axes
        ax1 = subplot(numel(I), 3, 1 + 3*(i-1)) ; hold on; box on;
        ax2 = subplot(numel(I), 3, 2 + 3*(i-1)); hold on; box on;
        ax3 = subplot(numel(I), 3, 3 + 3*(i-1)); hold on; box on;

        % ax1.Position = [0.075 0.36 0.25 0.57];
        % ax2.Position = [0.400 0.36 0.25 0.57];
        % ax3.Position = [0.725 0.36 0.25 0.57];

        ax1.FontSize = 20;
        ax2.FontSize = 20;
        ax3.FontSize = 20;

        ax1.LineWidth = 1;
        ax2.LineWidth = 1;
        ax3.LineWidth = 1;

        ax1.XScale = 'log';
        ax3.XScale = 'log';

        ax1.YLim = [0 1];
        ax2.YLim = [0 1];
        ax3.YLim = [0 1];

        ytickformat(ax1, '%.1f');
        ytickformat(ax2, '%.1f');
        ytickformat(ax3, '%.1f');

        if i == numel(I)
            xlabel(ax1, 'Population');
            xlabel(ax2, '\gamma');
            xlabel(ax3, '\omega');
        else
            ax1.XTick = [];
            ax2.XTick = [];
            ax3.XTick = [];
        end
        
        ax1.YTick = [0 1];
        ax2.YTick = [0 1];
        ax3.YTick = [0 1];

        ylabel(ax1, sprintf('T = 10^{%d}', log10(I(i))));

        
        % Set parameters
        if j == 1
            avgRM = 1;
            f = 1;
        end
        
        % Run the map
        [B_end, P_end, D_end, bacteria, phages, diversity, gamma, omega, gamma_0, omega_0] = simulateModel(Alpha, Beta, Eta, Delta, C, T, avgRM, f, lb, ub, iterations, inf, [], [], [], [], 'SS');
        
        
        % Plot the distribution of b_i's
        binEdges = logspace(3, 7, 16);
        counts = histcounts(B_end, binEdges)/numel(B_end);
        
        ax1.XLim  = [10^3 10^6.5];
        ax1.XTick = 10.^(floor(log10(binEdges(1))):ceil(log10(binEdges(end))));
        
        histogram(ax1, B_end, binEdges, 'Normalization', 'Probability')
        
        
        % Plot the distribution of gamma
        binEdges = linspace(0, 1, 14);
        
        ax2.XLim = [0 1];
        
        histogram(ax2, gamma, binEdges, 'Normalization', 'Probability')
        
        
        % Plot the distribution of omega
        binEdges = logspace(-4, 0, 14);
        
        histogram(ax3, omega, binEdges, 'Normalization', 'Probability')
        
        
    end
    
    fh.Color = [1 1 1];
    set(fh, 'PaperPositionMode', 'auto')
    set(fh, 'InvertHardcopy', 'off')

end

% Save the figures
if ~exist('../../figures/Figure_S1', 'dir')
    mkdir('../../figures/Figure_S1')
end

drawnow;

% print(fh1, '../../figures/Figure_S1/figS1ab.tif', '-dtiff')
% print(fh2, '../../figures/Figure_S1/figS1cd.tif', '-dtiff')
% print(fh3, '../../figures/Figure_S1/figS1efg.tif', '-dtiff')