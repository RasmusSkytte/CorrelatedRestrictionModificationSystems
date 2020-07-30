close all;
clearvars;

% Load parameters
loadDefaultParameters

% Prepare figure
fh1 = figure(); clf;
fh1.Resize = 'off';
fh1.Position(1) = 0.5 * fh1.Position(1);
fh1.Position(3) = 2   * fh1.Position(3);

ax1 = subplot(1, 2, 1); hold on; box on;
ax2 = subplot(1, 2, 2); hold on; box on;

ax1.FontSize = 20;
ax2.FontSize = 20;

ax1.LineWidth = 1;
ax2.LineWidth = 1;

ax1.XLim = [0 0.12];
ax1.YLim = [0 6];
ax1.XTick = 0:0.03:0.15;

ax2.XLim = [0 1];
ax2.YLim = [0 6];

ax1.Position = [0.08 0.19 0.41 0.77];
ax2.Position = [0.58 0.19 0.41 0.77];

xlabel(ax2, '\rho')
ylabel(ax1, '{\color{red}P/C}, B/C, {\color{blue}D/\beta}')

xlabel(ax1, '\Delta \gamma / \Delta log10 \omega')


% Prepare figure
fh2 = figure(); clf;
fh2.Resize = 'off';
fh2.Position(1) = 0.5 * fh2.Position(1);
fh2.Position(3) = 2   * fh2.Position(3);

ax3 = subplot(1, 2, 1); hold on; box on;
ax4 = subplot(1, 2, 2); hold on; box on;

ax3.FontSize = 20;
ax4.FontSize = 20;

ax3.LineWidth = 1;
ax4.LineWidth = 1;

ax3.XLim = [0 0.12];
ax3.YLim = [0.46 0.52];
ax3.XTick = 0:0.03:0.15;

ax4.XLim = [0 1];
ax4.YLim = [0 3];

ax3.Position = [0.08 0.19 0.41 0.77];
ax4.Position = [0.58 0.19 0.41 0.77];

xlabel(ax3, '\Delta \gamma / \Delta log10 \omega')
ylabel(ax3, '\rho')

xlabel(ax4, '\rho')
ylabel(ax4, '{\color{blue}<\gamma>}, {\color{red}-<log10(\omega)>}')

ytickformat(ax3, '%.2f');

% Prepare scatters
s_D = scatter(ax1, [], [], 20, [], 'bo', 'filled');
s_B = scatter(ax1, [], [], 20, [], 'ko', 'filled');
s_P = scatter(ax1, [], [], 20, [], 'ro', 'filled');

% Change the lower bound of gamma
k = 50;
corr_coeff = nan(k, 1);

for r = 0.3/k:0.3/k:0.3
    
    % Seed the simulation
    rng(60);
       
    % Run the map
    [B_end, P_end, DD, ~, ~, ~, ~, ~, gamma_0, omega_0] = simulateModel(Alpha, Beta, Eta, Delta, C, threshold, T, avgRM, r, lb, ub, iterations, inf, [], [], [], [], 'SS');
    
    % Store correlation coefficient
    corr_coeff(round(r*50/0.3)) =  corr(gamma_0, omega_0);

    % Store outputs
    BB = sum(B_end);
    PP = sum(P_end);
    
    % Fit the "slope"
    fl = fit(log10(omega_0), gamma_0, 'poly1');
        
    % Update the figure
    s_D.XData = [s_D.XData fl.p1];
    s_D.YData = [s_D.YData DD / Beta];
    
    s_B.XData = [s_B.XData fl.p1];
    s_B.YData = [s_B.YData BB / C];
    
    s_P.XData = [s_P.XData fl.p1];
    s_P.YData = [s_P.YData PP / C];
    drawnow;

    if any(round(r, 5)==[0.024, 0.09, 0.234])
        figure(fh1)
        ax = axes; hold on; box on;
        switch round(r, 5)
            case 0.024
                ax.Position = [0.1 0.69 0.125 0.25];
                annotation('arrow', [1 1] * 0.138, [0.69 0.445]);
            case 0.09
                ax.Position = [0.23 0.69 0.125 0.25];
                annotation('arrow', [1 1] * 0.268, [0.69 0.445]);
            case 0.234
                ax.Position = [0.36 0.69 0.125 0.25];
                annotation('arrow', [1 1] * 0.436, [0.69 0.445]);
        end
        scatter(ax, gamma_0, log10(omega_0), 1, 'k.', 'MarkerFaceAlpha', 0.01, 'MarkerEdgeAlpha', 0.01)
%         plot(ax, fl(linspace(-6, 0)), linspace(-6, 0), 'g', 'LineWidth', 1.5)
        
        ax.FontSize = 10;
        axis(ax, 'square')
        ax.XTick = [0 1];
        ax.YTick = [-6 0];
        ax.XLim = [0 1];
        ax.YLim = [-6 0];
        xlabel(ax, '\gamma')
        ylabel(ax, 'log10(\omega)')
        ax.XLabel.Position(2) = -6.35;
        ax.YLabel.Position(1) = -0.075;
    end
    
end

% Plot the correlation coefficient
scatter(ax3, s_D.XData, corr_coeff, 'kx');



% Prepare scatters
s_D = scatter(ax2, [], [], 20, [], 'bo', 'filled');
s_B = scatter(ax2, [], [], 20, [], 'ko', 'filled');
s_P = scatter(ax2, [], [], 20, [], 'ro', 'filled');

% Loop over rho
k = 51;
mean_gamma = nan(k-1, 1);
mean_log10omega = nan(k-1, 1);
for r = 0:1/(k-1):(k-1)/k
    
    % Seed the simulation
    rng(60);
       
    % Run the map
    [B_end, P_end, DD, ~, ~, ~, ~, ~, gamma_0, omega_0] = simulateModel(Alpha, Beta, Eta, Delta, C, threshold, T, -r, f, lb, ub, iterations, inf, [], [], [], [], 'SS');
    
    % Store marginal means
    mean_gamma(round(r*(k-1)+1)) =  mean(gamma_0);
    mean_log10omega(round(r*(k-1)+1)) =  mean(log10(omega_0));

    % Store outputs
    BB = sum(B_end);
    PP = sum(P_end);
    
    % Update the figure
    s_D.XData = [s_D.XData r];
    s_D.YData = [s_D.YData DD / Beta];
    
    s_B.XData = [s_B.XData r];
    s_B.YData = [s_B.YData BB / C];
    
    s_P.XData = [s_P.XData r];
    s_P.YData = [s_P.YData PP / C];
    drawnow;
    
    if any(r==[0.1, 0.52, 0.88])
        figure(fh1)
        ax = axes; hold on; box on;
        switch r
            case 0.1
                ax.Position = [0.59  0.69 0.125 0.25];
                annotation('arrow', [1 1] * 0.621, [0.69 0.39])
                ylabel(ax, 'log10(\omega)')
                ax.YTick = [-4 0];
            case 0.52
                ax.Position = [0.695 0.69 0.125 0.25];
                annotation('arrow', [1 1] * 0.793, [0.69 0.48])
                ax.YTick = [];
            case 0.88
                ax.Position = [0.80  0.69 0.125 0.25];
                annotation('arrow', [0.91 0.935],  [0.80 0.76])
                ax.YTick = [];
        end
        scatter(ax, gamma_0, log10(omega_0), 1, 'k.', 'MarkerFaceAlpha', 0.01, 'MarkerEdgeAlpha', 0.01)
        ax.FontSize = 10;
        axis(ax, 'square')
        ax.XTick = [0 1];
        ax.XLim = [0 1];
        ax.YLim = [-4 0];
        xlabel(ax, '\gamma')
        
        ax.XLabel.Position(2) = -4.15;
        ax.YLabel.Position(1) = -0.075;
    end
end

% Plot the marginal means
scatter(ax4, s_D.XData, mean_gamma, 'bx');
scatter(ax4, s_D.XData, -mean_log10omega, 'rx');


% Save the figures
if ~exist('../../figures/Figure_3', 'dir')
    mkdir('../../figures/Figure_3')
end

if ~exist('../../figures/Figure_S1', 'dir')
    mkdir('../../figures/Figure_S1')
end

fh1.Color = [1 1 1];
set(fh1, 'PaperPositionMode', 'auto')
set(fh1, 'InvertHardcopy', 'off')

fh2.Color = [1 1 1];
set(fh2, 'PaperPositionMode', 'auto')
set(fh2, 'InvertHardcopy', 'off')

print(fh1, '../../figures/Figure_3/fig3.tif', '-dtiff')
print(fh2, '../../figures/Figure_S1/figS1.tif', '-dtiff')
