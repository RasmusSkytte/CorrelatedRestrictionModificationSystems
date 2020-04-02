close all;
clearvars;

% Load parameters
loadDefaultParameters

% Prepare data folder
if ~exist('../data/Fig2', 'dir')
    mkdir('../data/Fig2')
end

% Prepare figure
fh1 = figure(); clf;
fh1.Resize = 'off';
fh1.Position(4) = 0.8 * fh1.Position(4);

ax1 = axes;
ax1.Box = 'on';
ax1.NextPlot = 'add';
ax1.FontSize = 20;
ax1.LineWidth = 1;
ax1.XScale = 'log';
ax1.YLim = [0 2.0];
ax1.YTick = 0:0.5:2;

ytickformat(ax1, '%.1f');

ax1.Position = [0.15 0.25 0.81 0.7];

xlabel(ax1, 'Added species');
ylabel(ax1, '{\color{red}P/(10*C)}, B/C, {\color{blue}D/\beta}')

ax1.YLabel.FontSize = 18;

fh2 = figure(); clf;
fh2.Resize = 'off';
fh2.Position(1) = 0.5 * fh2.Position(1);
fh2.Position(3) = 2   * fh2.Position(3);

ax2 = subplot(1, 3, 1); hold on; box on;
ax3 = subplot(1, 3, 2); hold on; box on;

ax2.Position = [0.08 0.18 0.34 0.77];
ax3.Position = [0.53 0.18 0.34 0.77];

ax2.FontSize = 20;
ax3.FontSize = 20;

ax2.LineWidth = 1;
ax3.LineWidth = 1;

ax2.YScale = 'log';
ax3.YScale = 'log';

ax2.XLim  = [0 1];
ax2.YLim  = [1e-8 1];
ax2.YTick = [1e-8 1e-6 1e-4 1e-2 1e0];

ax3.XLim  = [0 1];
ax3.YLim  = [1e-8 1];
ax3.YTick = [1e-8 1e-6 1e-4 1e-2 1e0];

ax2.CLim = [4.5 6.5];
ax3.CLim = ax2.CLim;

xlabel(ax2, '\gamma');
ylabel(ax2, '\omega');

xlabel(ax3, '\gamma');


fh3 = figure(); clf;
fh3.Resize = 'off';
fh3.Position(1) = 0.5  * fh3.Position(1);
fh3.Position(3) = 2    * fh3.Position(3);
fh3.Position(4) = 0.55 * fh3.Position(4);

ax4 = subplot(1, 3, 1); hold on; box on;
ax5 = subplot(1, 3, 2); hold on; box on;
ax6 = subplot(1, 3, 3); hold on; box on;

ax4.Position = [0.075 0.38 0.25 0.57];
ax5.Position = [0.400 0.38 0.25 0.57];
ax6.Position = [0.725 0.38 0.25 0.57];

ax4.FontSize = 20;
ax5.FontSize = 20;
ax6.FontSize = 20;

ax4.LineWidth = 1;
ax5.LineWidth = 1;
ax6.LineWidth = 1;

ax4.XScale = 'log';
ax6.XScale = 'log';

ax4.YLim = [0 1];

ax5.XLim = [0.85 1];
ax5.YLim = [0 1];

ax6.XLim = [1e-4 1];
ax6.YLim = [0 1];
ax6.XTick = [1e-8 1e-6 1e-4 1e-2 1];

ytickformat(ax4, '%.1f');
ytickformat(ax5, '%.1f');
ytickformat(ax6, '%.1f');

xlabel(ax4, 'Population');
xlabel(ax5, '\gamma');
xlabel(ax6, '\omega');

% ax4.XLabel.Position(2) = -0.33;
ax5.XLabel.Position(2) = -0.33;
ax6.XLabel.Position(2) = -0.33;

ylabel(ax4, 'pmf.');

for j = 1:2

    % Seed the simulation?
    rng(60);

    if j == 1   % dont use default values for avgRM and f
        avgRM = 1;
    elseif j == 2
        avgRM = 4;
    end
    % Recompute normalization
    f = 2-(1/2)^(1/avgRM-1);

    % Prepare figure
    switch j
        case 1
            pD = plot(ax1, nan, nan, 'Color', [178 178 255]/255, 'LineWidth', 1.5, 'DisplayName', 'D / \beta');
            pB = plot(ax1, nan, nan, 'Color', [178 178 178]/255, 'LineWidth', 1.5, 'DisplayName', 'B / C');
            pP = plot(ax1, nan, nan, 'Color', [255 178 178]/255, 'LineWidth', 1.5, 'DisplayName', 'P / (10 * C)');
            axCloud = ax2;
        case 2
            pD = plot(ax1, nan, nan, 'b', 'LineWidth', 1.5, 'DisplayName', 'D / \beta');
            pB = plot(ax1, nan, nan, 'k', 'LineWidth', 1.5, 'DisplayName', 'B / C');
            pP = plot(ax1, nan, nan, 'r', 'LineWidth', 1.5, 'DisplayName', 'P / (10 * C)');
            axCloud = ax3;
    end
    ax1.XLim  = [1 iterations];
    ax1.XTick = logspace(0, 10, 11);

    % Generate the data
    if j == 1 && exist('../data/Fig2/Uncorrelated.mat', 'file')
        load('../data/Fig2/Uncorrelated.mat')

        pP.XData = 1:(iterations);
        pP.YData = phages/(10*C);

        pB.XData = 1:(iterations);
        pB.YData = bacteria/C;

        pD.XData = 1:(iterations);
        pD.YData = diversity/Beta;

    elseif j == 2 && exist('../data/Fig2/Correlated.mat', 'file')
        load('../data/Fig2/Correlated.mat')

        pP.XData = 1:(iterations);
        pP.YData = phages/(10*C);

        pB.XData = 1:(iterations);
        pB.YData = bacteria/C;

        pD.XData = 1:(iterations);
        pD.YData = diversity/Beta;
    else

        if j == 1
            sname = '../data/Fig2/Uncorrelated.mat';
        elseif j == 2
            sname = '../data/Fig2/Correlated.mat';
        end

        % Simulate the model
        [B_end, P_end, D_end, bacteria, phages, diversity, gamma, omega, gamma_0, omega_0] = simulateModel(Alpha, Beta, Eta, Delta, C, T, avgRM, f, lb, ub, iterations, inf, pD, pB, pP, sname);

        pP.YData = pP.YData/10;

        % Save data
        save(sname, 'B_end', 'P_end', 'D_end', 'bacteria', 'phages', 'diversity', 'gamma', 'omega', 'gamma_0', 'omega_0', 'Alpha', 'Beta', 'Delta', 'Eta', 'C', 'T', 'avgRM', 'f', 'lb', 'ub')

    end

    % Plot the point clouds
    scatter(axCloud, gamma_0, omega_0, 1, 'kx')

    % Plot the selected points
    s_c = scatter(axCloud, gamma, omega, 20, log10(B_end), 'filled');

    % Plot the extinciton line
    oo = logspace(-8, 0, 1e3);
    gg = (Alpha + oo * Eta * sum(P_end)) / (1 - sum(B_end) / C);
    h_l = plot(axCloud, gg, oo, 'r', 'LineWidth', 1.5);

    % Create inset
    if j == 1
        figure(fh2)
        axI = axes;
        axI.Box = 'on';
        axI.NextPlot = 'add';
        axI.Position = [0.1275 0.265 0.15 0.275];
        axI.CLim = ax2.CLim;

        scatter(axI, gamma_0, omega_0, '.k')
        scatter(axI, gamma,   omega, 20, log10(B_end), 'filled')
        plot(gg, oo, 'r', 'LineWidth', 1.5)

        axI.XTick = [0.998 1];
        axI.YTick = [1e-4 1];
        axI.YScale = 'log';
        axI.XLim = [0.998 1];
        axI.YLim = [1e-4 1];
        axI.FontSize = 14;
        xlabel(axI, '\gamma');
        ylabel(axI, '\omega');
        axI.XLabel.Position(2) = 1e-4;
        axI.YLabel.Position(1) = 0.979;
        axI.LineWidth = 1.5;

    elseif j == 2

        c = colorbar(ax3);
        c.Position(1:2) = [0.885 0.19];
        c.Label.String = 'b_i';
        c.Label.Position(1) = 4.1;
        c.TickLabels = cellfun(@(d)sprintf('10^{%.1f}', d), num2cell(c.Ticks), 'UniformOutput', false);

    end


    % Plot the distribution of b_i's
    binEdges = logspace(4, 7, 16);
    counts = histcounts(B_end, binEdges)/numel(B_end);
    x = reshape([binEdges; binEdges], 1, 2*numel(binEdges));
    y = circshift(reshape([zeros(2, 1) [counts; counts]], 1, 2*numel(binEdges)), -1);

    ax4.XLim  = [10^4 10^6.5];
    ax4.XTick = 10.^(floor(log10(binEdges(1))):ceil(log10(binEdges(end))));

    switch j
        case 1
            p = patch(ax4, x, y, ones(size(x)));
            axes(ax4);
            hatchfill(p, 'single', -45, 5);
            ax4.Children(1).LineWidth = 1;
            ax4.Children(2).LineWidth = 1;
        case 2
            p = patch(ax4, x, y, ones(size(x)), 'FaceColor', [178 178 178]/255, 'EdgeColor', [0 0 0]);
            uistack(p, 'bottom')
    end

    % Plot the distribution of gamma
    binEdges = linspace(0.85, 1, 14);
    counts = histcounts(gamma, binEdges)/numel(B_end);
    x = reshape([binEdges; binEdges], 1, 2*numel(binEdges));
    y = circshift(reshape([zeros(2, 1) [counts; counts]], 1, 2*numel(binEdges)), -1);

    switch j
        case 1
            p = patch(ax5, x, y, ones(size(x)));
            axes(ax5);
            hatchfill(p, 'single', -45, 5);
            ax5.Children(1).LineWidth = 1;
            ax5.Children(2).LineWidth = 1;
        case 2.
            p = patch(ax5, x, y, ones(size(x)), 'FaceColor', [178 178 178]/255, 'EdgeColor', [0 0 0]);
            uistack(p, 'bottom')
    end

    % Plot the distribution of gamma
    binEdges = logspace(-4, 0, 14);
    counts = histcounts(omega, binEdges)/numel(B_end);
    x = reshape([binEdges; binEdges], 1, 2*numel(binEdges));
    y = circshift(reshape([zeros(2, 1) [counts; counts]], 1, 2*numel(binEdges)), -1);

    switch j
        case 1
            p = patch(ax6, x, y, ones(size(x)));
            axes(ax6);
            hatchfill(p, 'single', -45, 5);
            ax6.Children(1).LineWidth = 1;
            ax6.Children(2).LineWidth = 1;
        case 2
            p = patch(ax6, x, y, ones(size(x)), 'FaceColor', [178 178 178]/255, 'EdgeColor', [0 0 0]);
            uistack(p, 'bottom')
    end



end

% Finalize axis position
ax2.Position = [0.08 0.19 0.35 0.77];
ax3.Position = [0.53 0.19 0.35 0.77];

ax1.XLabel.Position(2) = -0.35;
ax1.YLabel.Position(2) = 0.8;

% Save the figures
if ~exist('../../figures/Figure_2', 'dir')
    mkdir('../../figures/Figure_2')
end

drawnow;
fh2.Position(3) = 1120;
fh3.Position(3) = 1120;

fh1.Color = [1 1 1];
set(fh1, 'PaperPositionMode', 'auto')
set(fh1, 'InvertHardcopy', 'off')

fh2.Color = [1 1 1];
set(fh2, 'PaperPositionMode', 'auto')
set(fh2, 'InvertHardcopy', 'off')

fh3.Color = [1 1 1];
set(fh3, 'PaperPositionMode', 'auto')
set(fh3, 'InvertHardcopy', 'off')

print(fh1, '../../figures/Figure_2/fig2b.tif', '-dtiff')
print(fh2, '../../figures/Figure_2/fig2gh.tif', '-dtiff')
print(fh3, '../../figures/Figure_2/fig2cde.tif', '-dtiff')
