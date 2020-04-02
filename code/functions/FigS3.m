close all;
clearvars;

% Load parameters
loadDefaultParameters

fh = figure(1);
fh.Position(1) = 140;
fh.Position(3) = 1120;
fh.Position(4) = 400;
ax1 = subplot(1, 3, 1); hold on; box on; axis square
ax2 = subplot(1, 3, 2); hold on; box on; axis square
ax3 = subplot(1, 3, 3); hold on; box on; axis square

ax1.Position = [0.07 0.17 0.25 0.75];
ax2.Position = [0.41 0.17 0.25 0.75];
ax3.Position = [0.735 0.17 0.25 0.75];

plot(ax1, [-1 10], [-1 10], 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
plot(ax2, [-1 10], [-1 10], 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)
plot(ax3, [-1 10], [-1 10], 'Color', [0.75 0.75 0.75], 'LineWidth', 1.5)

ax1.XLim = [0 2];
ax2.XLim = [0 1];
ax3.XLim = [0 6];

xlabel(ax2, 'ODE Solution')
ylabel(ax1, 'Map Solution')

title(ax1, '\color{blue}D/\beta');
title(ax2, 'B/C');
title(ax3, '\color{red}P/C');

ax1.YLim = ax1.XLim;
ax2.YLim = ax2.XLim;
ax3.YLim = ax3.XLim;

ax1.FontSize = 20;
ax2.FontSize = 20;
ax3.FontSize = 20;

ax3.XTick = [0 3 6];

ax1.YTick = ax1.XTick;
ax2.YTick = ax2.XTick;
ax3.YTick = ax3.XTick;

ax1.LineWidth = 1;
ax2.LineWidth = 1;
ax3.LineWidth = 1;


% Load parameters
loadDefaultParameters

for j = 2:-1:1
    for k = 1:100
        
        if exist(sprintf('../data/FigS3/run_%d.mat', k), 'file')
            load(sprintf('../data/FigS3/run_%d.mat', k))
            
            % Seed the simulation?
            if j == 1
                rng(60);
            end
            
            % Run the map
            [BB, PP, DD] = simulateModel(Alpha, Beta, Eta, Delta, C, T, avgRM, f, lb, ub, 10*N, N, [], [], [], [], 'SS');
            
            % Update plots
            switch j
                case 1
                    symbol = 'x';
                    col_b = [0 0 1];
                    col_k = [0 0 0];
                    col_r = [1 0 0];
                case 2
                    symbol = 'o';
                    col_b = [178 178 255]/255;
                    col_k = [178 178 178]/255;
                    col_r = [255 178 178]/255;
            end
            scatter(ax1, D_end / Beta,   DD / Beta,   symbol, 'filled', 'MarkerFaceColor', col_b, 'MarkerEdgeColor', col_b, 'LineWidth', 1.5, 'DisplayName', 'D/\beta')
            scatter(ax2, sum(B_end) / C, sum(BB) / C, symbol, 'filled', 'MarkerFaceColor', col_k, 'MarkerEdgeColor', col_k, 'LineWidth', 1.5, 'DisplayName', 'B/C')
            scatter(ax3, sum(P_end) / C, sum(PP) / C, symbol, 'filled', 'MarkerFaceColor', col_r, 'MarkerEdgeColor', col_r, 'LineWidth', 1.5, 'DisplayName', 'P/C')
            
            drawnow;
        end
    end
end

% Save the figures
if ~exist('../../figures/Figure_S3', 'dir')
    mkdir('../../figures/Figure_S3')
end

fh.Color = [1 1 1];
set(fh, 'PaperPositionMode', 'auto')
set(fh, 'InvertHardcopy', 'off')

print(fh, '../../figures/Figure_S3/figS3.tif', '-dtiff')