close all;
clearvars;

% Load parameters
loadDefaultParameters

% Prepare figure
fh1 = figure(1); clf;
fh1.Position(1) = 0.5 * fh1.Position(1);
fh1.Position(3) = 2   * fh1.Position(3);

ax1 = subplot(1, 2, 1); box on; hold on;
ax2 = subplot(1, 2, 2); box on; hold on;

ax1.Position = [0.09 0.21 0.38 0.75];
ax2.Position = [0.59 0.21 0.38 0.75];

ax1.FontSize = 20;
ax2.FontSize = 20;

ax2.XLim = [0 1];
ax2.YLim = [1e-8 1];
ax2.CLim = [4.5 6.5];

ax1.XLim = [1e0 1e5];
ax1.YLim = [0 3];

ax2.XTick = 0:0.25:1;
ax2.YTick = logspace(-8, 0, 5);

ax1.XTick = 10.^(0:5);

ax2.YScale = 'log';
ax1.XScale = 'log';

ax1.LineWidth = 1;
ax2.LineWidth = 1;

ytickformat(ax1, '%.1f');

ylabel(ax2, '\omega')
xlabel(ax2, '\gamma')

ylabel(ax1, '{\color{red}P/(10*C)}, B/C, {\color{blue} D/\beta}')
xlabel(ax1, 'Added species')
ax1.YLabel.Position(2) = 1.35;


fh2 = figure(); clf;
fh2.Position(1) = 0.5  * fh2.Position(1);
fh2.Position(3) = 2    * fh2.Position(3);
fh2.Position(4) = 0.55 * fh2.Position(4);

ax3 = subplot(1, 3, 1); hold on; box on;
ax4 = subplot(1, 3, 2); hold on; box on;
ax5 = subplot(1, 3, 3); hold on; box on;

ax3.Position = [0.075 0.36 0.25 0.57];
ax4.Position = [0.400 0.36 0.25 0.57];
ax5.Position = [0.725 0.36 0.25 0.57];

ax3.FontSize = 20;
ax4.FontSize = 20;
ax5.FontSize = 20;

ax3.LineWidth = 1;
ax4.LineWidth = 1;
ax5.LineWidth = 1;

ax3.XScale = 'log';
ax5.XScale = 'log';

ax3.YLim = [0 1];

ax4.XLim = [0.85 1];
ax4.YLim = [0 1];

ax5.XLim = [1e-4 1];
ax5.YLim = [0 1];
ax5.XTick = [1e-8 1e-6 1e-4 1e-2 1];

ytickformat(ax3, '%.1f');
ytickformat(ax4, '%.1f');
ytickformat(ax5, '%.1f');

xlabel(ax3, 'Population');
xlabel(ax4, '\gamma');
xlabel(ax5, '\omega');

% ax4.XLabel.Position(2) = -0.33;
ax4.XLabel.Position(2) = -0.33;
ax5.XLabel.Position(2) = -0.33;

ylabel(ax3, 'pmf.');


% Seed the simulation?
rng(60);

% Load parameters
loadDefaultParameters

% Select axes
avgRM = 1;
f = 1;
lb = -2;

s_p = scatter(ax2, [], [], 1, 'kx');
s_c = scatter(ax2, [], [], 20, [], 'o', 'filled');
h_l = plot(ax2, nan, nan, 'r', 'LineWidth', 1.5);
h_D = plot(ax1, nan, nan, 'b', 'LineWidth', 1.5, 'DisplayName', 'D/\beta');
h_B = plot(ax1, nan, nan, 'k', 'LineWidth', 1.5, 'DisplayName', 'B/C');
h_P = plot(ax1, nan, nan, 'r', 'LineWidth', 1.5, 'DisplayName', 'P/(10*C)');

% Run the map
[B_end, P_end, D_end, bacteria, phages, diversity, gamma, omega, gamma_0, omega_0] = simulateModel(Alpha, Beta, Eta, Delta, C, threshold, T, avgRM, f, lb, ub, iterations, inf, h_D, h_B, h_P, [], 'SS');

% Update plots
s_p.XData = gamma_0;
s_p.YData = omega_0;

s_c.XData = gamma;
s_c.YData = omega;
s_c.CData = log10(B_end);

oo = logspace(-8, 0, 1e3);
gg = (Alpha + oo * Eta * sum(P_end)) / (1 - sum(B_end) / C);

h_l.XData = gg;
h_l.YData = oo;


figure(fh1)
axI = axes;
axI.Box = 'on';
axI.NextPlot = 'add';
axI.Position = [0.64 0.3 0.15 0.275];
axI.CLim = ax2.CLim;

scatter(axI, gamma_0, omega_0, '.k')
scatter(axI, gamma,   omega, 20, log10(B_end), 'filled')
plot(gg, oo, 'r', 'LineWidth', 1.5)

axI.XTick = [0.98 1];
axI.YTick = [1e-4 1];
axI.YScale = 'log';
axI.XLim = [0.98 1];
axI.YLim = [1e-4 1];
axI.FontSize = 14;
xlabel(axI, '\gamma');
ylabel(axI, '\omega');
axI.XLabel.Position(2) = 1e-4;
axI.YLabel.Position(1) = 0.979;
axI.LineWidth = 1.5;


% Plot the distribution of b_i's
binEdges = logspace(4, 7, 16);
counts = histcounts(B_end, binEdges)/numel(B_end);
x = reshape([binEdges; binEdges], 1, 2*numel(binEdges));
y = circshift(reshape([zeros(2, 1) [counts; counts]], 1, 2*numel(binEdges)), -1);

ax3.XLim  = [10^4 10^6.5];
ax3.XTick = 10.^(floor(log10(binEdges(1))):ceil(log10(binEdges(end))));

p = patch(ax3, x, y, ones(size(x)));
axes(ax3);
hatchfill(p, 'single', -45, 5);
ax3.Children(1).LineWidth = 1;
ax3.Children(2).LineWidth = 1;


% Plot the distribution of gamma
binEdges = linspace(0.85, 1, 14);
counts = histcounts(gamma, binEdges) / numel(gamma);
x = reshape([binEdges; binEdges], 1, 2 * numel(binEdges));
y = circshift(reshape([zeros(2, 1) [counts; counts]], 1, 2 * numel(binEdges)), -1);

p = patch(ax4, x, y, ones(size(x)));
axes(ax4);
hatchfill(p, 'single', -45, 5);
ax4.Children(1).LineWidth = 1;
ax4.Children(2).LineWidth = 1;


% Plot the distribution of omega
binEdges = logspace(-4, 0, 14);
counts = histcounts(omega, binEdges) / numel(omega);
x = reshape([binEdges; binEdges], 1, 2 * numel(binEdges));
y = circshift(reshape([zeros(2, 1) [counts; counts]], 1, 2 * numel(binEdges)), -1);

p = patch(ax5, x, y, ones(size(x)));
axes(ax5);
hatchfill(p, 'single', -45, 5);
ax5.Children(1).LineWidth = 1;
ax5.Children(2).LineWidth = 1;


% Save the figures
if ~exist('../../figures/Figure_S4', 'dir')
    mkdir('../../figures/Figure_S4')
end

fh1.Color = [1 1 1];
set(fh1, 'PaperPositionMode', 'auto')
set(fh1, 'InvertHardcopy', 'off')

fh2.Color = [1 1 1];
set(fh2, 'PaperPositionMode', 'auto')
set(fh2, 'InvertHardcopy', 'off')


print(fh1, '../../figures/Figure_S4/figS4ab.tif', '-dtiff')
print(fh2, '../../figures/Figure_S4/figS4cde.tif', '-dtiff')