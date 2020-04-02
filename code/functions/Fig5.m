close all;
clearvars;

% Load parameters
loadDefaultParameters

% Prepare figures
fh1 = figure(); clf;
fh1.Resize = 'off';
fh1.Position(1) = 0.5 * fh1.Position(1);
fh1.Position(3) = 2   * fh1.Position(3);

ax1 = subplot(1, 3, 1); hold on; box on;
ax2 = subplot(1, 3, 2); hold on; box on;
ax3 = subplot(1, 3, 3); hold on; box on;

ax1.Position = [0.085 0.23 0.23 0.68];
ax2.Position = [0.415 0.23 0.23 0.68];
ax3.Position = [0.745 0.23 0.23 0.68];

ax1.FontSize = 20;
ax2.FontSize = 20;
ax3.FontSize = 20;

ax1.LineWidth = 1;
ax2.LineWidth = 1;
ax3.LineWidth = 1;

ax2.XScale = 'log';
ax3.XScale = 'log';

ax1.XLim = [0 0.03];
ax1.XTick = 0:0.015:0.03;

ax2.XLim = [1e0 10^4.5];
ax2.XTick = 10.^(0:2:4);

ax3.XLim = [1e-3 1e3];
ax3.XTick = 10.^(-3:2:3);

ytickformat(ax1, '%.1f')
ytickformat(ax2, '%.1f')
ytickformat(ax3, '%.1f')

xlabel(ax1, '\gamma_i^\prime');
xlabel(ax2, '1/\omega_i');
xlabel(ax3, '\gamma_i^\prime / \omega_i');
ylabel(ax1, 'b_i')



fh2 = figure(); clf;
fh2.Resize = 'off';
fh2.Position(1) = 0.5 * fh2.Position(1);
fh2.Position(3) = 2   * fh2.Position(3);

ax4 = subplot(1, 3, 1); hold on; box on;
ax5 = subplot(1, 3, 2); hold on; box on;
ax6 = subplot(1, 3, 3); hold on; box on;

ax4.Position = [0.085 0.23 0.23 0.68];
ax5.Position = [0.415 0.23 0.23 0.68];
ax6.Position = [0.745 0.23 0.23 0.68];

ax4.FontSize = 20;
ax5.FontSize = 20;
ax6.FontSize = 20;

ax4.LineWidth = 1;
ax5.LineWidth = 1;
ax6.LineWidth = 1;

ax5.XScale = 'log';
ax6.XScale = 'log';

ax4.XTick = -0.1:0.2:1;

ax5.XLim = [1e0 10^4.5];
ax5.XTick = 10.^(0:2:4);

ax6.XLim = [1e-3 1e3];
ax6.XTick = 10.^(-3:2:3);

ytickformat(ax4, '%.1f')
ytickformat(ax5, '%.1f')
ytickformat(ax6, '%.1f')

xlabel(ax4, '\gamma_i^\prime');
xlabel(ax5, '1/\omega_i');
xlabel(ax6, '\gamma_i^\prime / \omega_i');

ylabel(ax4, 'b_i')

% Number of bacteria and phages
nB = 100;

% Starting condiiton
x0 = [ones(nB, 1); ones(nB, 1)]; % Everyone starts with a population of 1

for k = 1:2
    for j = 1:2
        
        % Set seed
        rng(60);
        
        % Load parameters
        loadDefaultParameters
        
        if j == 1
            
            if k == 1
                load('../data/Fig2/Uncorrelated.mat')
            elseif k == 2
                % Run dynamics
                [gamma, omega] = sampleDistribution(1, lb, ub, f, nB);
                [B_end, P_end, y, t] = DynamicalSystem(gamma, omega, {Alpha, Beta, Eta, Delta, C, T}, x0);
            end
            
        elseif j == 2
            
            if k == 1
                load('../data/Fig2/Correlated.mat')
            elseif k == 2
                % Run dynamics
                [gamma, omega] = sampleDistribution(4, lb, ub, f, nB);
                [B_end, P_end, y, t] = DynamicalSystem(gamma, omega, {Alpha, Beta, Eta, Delta, C, T}, x0);
            end
            
        end
        
        
        g_eff = gamma * (1 - sum(B_end) / C) - Alpha;
        x = g_eff ./ omega;
        % Plot result
        if k == 1
            scatter(ax1, g_eff,      B_end, 'o', 'Filled')
            scatter(ax2, 1 ./ omega, B_end, 'o', 'Filled')
            scatter(ax3, x,          B_end, 'o', 'Filled')
        elseif k == 2
            scatter(ax4, g_eff,      B_end,        'o', 'Filled')
            scatter(ax5, 1 ./ omega, B_end,        'o', 'Filled')
            scatter(ax6, x(x > 0),   B_end(x > 0), 'o', 'Filled')
        end
        
    end
end

% Save the figures
if ~exist('../../figures/Figure_5', 'dir')
    mkdir('../../figures/Figure_5')
end

drawnow;
fh1.Position(3) = 1120;
fh2.Position(3) = 1120;

fh1.Color = [1 1 1];
set(fh1, 'PaperPositionMode', 'auto')
set(fh1, 'InvertHardcopy', 'off')

fh2.Color = [1 1 1];
set(fh2, 'PaperPositionMode', 'auto')
set(fh2, 'InvertHardcopy', 'off')

print(fh1, '../../figures/Figure_5/fig5abc.tif', '-dtiff')
print(fh2, '../../figures/Figure_5/fig5def.tif', '-dtiff')
