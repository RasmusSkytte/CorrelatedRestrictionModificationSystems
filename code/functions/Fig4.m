close all;
clearvars;

nSamples = 41;
repeats = 5;

% Configure the loops
Eta_vals   = logspace(-6, -10, nSamples);
Alpha_vals = linspace(0.05, 0.75, nSamples);
Delta_vals = logspace(-2, 1, nSamples);
Beta_vals  = round(logspace(1, 3, nSamples));

% Plot the results
fh0 = figure(10); clf;
fh0.Resize = 'off';
fh0.Position(2) = 0.15 * fh0.Position(2);
fh0.Position(3) = 2    * fh0.Position(3);
fh0.Position(4) = 750;
ax1 = subplot(3, 2, 1);     hold on;
ax2 = subplot(3, 2, 3);     hold on;
ax3 = subplot(3, 2, 5);     hold on;
ax4 = subplot(3, 2, 2:2:6); hold on;

ax1.Box = 'on';
ax2.Box = 'on';
ax3.Box = 'on';
ax4.Box = 'on';

ax1.FontSize = 20;
ax2.FontSize = 20;
ax3.FontSize = 20;
ax4.FontSize = 20;

ax1.XLim = [0.05 0.75];
ax1.XTick = 0.1:0.2:0.70;

ax2.XTick = 10.^(-2:1);

ax3.XTick = 10.^(-10:-6);

ax1.YLim = [0 2.4];
ax2.YLim = [0 3.1];
ax3.YLim = [0 3.1];
ax4.YLim = [0 4];

ax2.XScale = 'log';
ax3.XScale = 'log';
ax4.XScale = 'log';

xlabel(ax1, '\alpha');
xlabel(ax2, '\delta');
xlabel(ax3, '\eta');
xlabel(ax4, '\beta');

ax1.XTick = 0:0.2:1;

ax1.Position = [0.54  0.705 0.36 0.284];
ax2.Position = [0.09  0.605 0.36 0.383];
ax3.Position = [0.09  0.112 0.36 0.383];
ax4.Position = [0.54  0.112 0.36 0.495];

ax0 = axes;
ax0.Visible = 'off';
ax0.Position = [0 0 1 1];
text(ax0, 0.015, 0.538, 'B/C, {\color{red}P/(10*C)}, {\color{blue} D/\beta}', 'FontSize', 20, 'Rotation', 90, 'HorizontalAlignment', 'Center')

for i = 1:2
    
    % Plot the results
    s_D = errorbar(ax1, nan, nan, nan, 'b.');
    s_B = errorbar(ax1, nan, nan, nan, 'k.');
    s_P = errorbar(ax1, nan, nan, nan, 'r.');
    
    % Adjust the color
    if i == 1
        s_D.Color(s_D.Color == 0) = 178/255;
        s_B.Color(s_B.Color == 0) = 178/255;
        s_P.Color(s_P.Color == 0) = 178/255;
    end
    
    % Select the data
    switch i
        case 1
            str = 'Uncorrelated';
        case 2
            str = 'Correlated';
    end
    
    % Load parameters
    loadDefaultParameters
    
    % Load the data
    for k = 1:numel(Alpha_vals)
        
        fname = sprintf('../data/Fig4/%s/alpha_%.2f_beta_%d_delta_1e%.3f_eta_1e%.2f.mat', str, Alpha_vals(k), Beta, log10(Delta), log10(Eta));
        if exist(fname, 'file')
            load(fname);
        else
            error('Data not created')
        end
        
        % Update data
        s_D.XData = [s_D.XData Alpha];
        s_B.XData = [s_B.XData Alpha];
        s_P.XData = [s_P.XData Alpha];
        
        s_D.YData = [s_D.YData mean(D) / Beta];
        s_B.YData = [s_B.YData mean(B) / C];
        s_P.YData = [s_P.YData mean(P) / (10 * C)];
        
        s_D.YNegativeDelta = [s_D.YNegativeDelta std(D) / (Beta * numel(D))];
        s_B.YNegativeDelta = [s_B.YNegativeDelta std(B) / (C * numel(D))];
        s_P.YNegativeDelta = [s_P.YNegativeDelta std(P) / (10 * C * numel(D))];
        
        s_D.YPositiveDelta = s_D.YNegativeDelta;
        s_B.YPositiveDelta = s_B.YNegativeDelta;
        s_P.YPositiveDelta = s_P.YNegativeDelta;
    end
     
    % Convert to shaded error bar
    axes(ax1);
    h_D = shadedErrorBar(s_D.XData, s_D.YData, [s_D.YPositiveDelta; s_D.YNegativeDelta], 'lineProps', {'Color', s_D.Color, 'LineWidth', 1.5});
    h_B = shadedErrorBar(s_B.XData, s_B.YData, [s_B.YPositiveDelta; s_B.YNegativeDelta], 'lineProps', {'Color', s_B.Color, 'LineWidth', 1.5});
    h_P = shadedErrorBar(s_P.XData, s_P.YData, [s_P.YPositiveDelta; s_P.YNegativeDelta], 'lineProps', {'Color', s_P.Color, 'LineWidth', 1.5});
    delete(s_D);
    delete(s_B);
    delete(s_P);
    
end

% Plot reference line
loadDefaultParameters
plot(ax1, [1 1] * Alpha, ax1.YLim, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5)

for i = 1:2
    
    % Plot the results
    s_D = errorbar(ax2, nan, nan, nan, 'b.');
    s_B = errorbar(ax2, nan, nan, nan, 'k.');
    s_P = errorbar(ax2, nan, nan, nan, 'r.');
    
    % Adjust the color
    if i == 1
        s_D.Color(s_D.Color == 0) = 178/255;
        s_B.Color(s_B.Color == 0) = 178/255;
        s_P.Color(s_P.Color == 0) = 178/255;
    end
    
    % Select the data
    switch i
        case 1
            str = 'Uncorrelated';
        case 2
            str = 'Correlated';
    end
    
    % Load parameters
    loadDefaultParameters
    
    % Load the data
    for k = 1:numel(Delta_vals)
        
        fname = sprintf('../data/Fig4/%s/alpha_%.2f_beta_%d_delta_1e%.3f_eta_1e%.2f.mat', str, Alpha, Beta, log10(Delta_vals(k)), log10(Eta));
        if exist(fname, 'file')
            load(fname);
        else
            error('Data not created')
        end
        
        % Update data
        s_D.XData = [s_D.XData Delta];
        s_B.XData = [s_B.XData Delta];
        s_P.XData = [s_P.XData Delta];
        
        s_D.YData = [s_D.YData mean(D) / Beta];
        s_B.YData = [s_B.YData mean(B) / C];
        s_P.YData = [s_P.YData mean(P) / (10 * C)];
        
        s_D.YNegativeDelta = [s_D.YNegativeDelta std(D) / (Beta * numel(D))];
        s_B.YNegativeDelta = [s_B.YNegativeDelta std(B) / (C * numel(D))];
        s_P.YNegativeDelta = [s_P.YNegativeDelta std(P) / (10 * C * numel(D))];
        
        s_D.YPositiveDelta = s_D.YNegativeDelta;
        s_B.YPositiveDelta = s_B.YNegativeDelta;
        s_P.YPositiveDelta = s_P.YNegativeDelta;
    end

    % Convert to shaded error bar
    axes(ax2);
    h_D = shadedErrorBar(s_D.XData, s_D.YData, [s_D.YPositiveDelta; s_D.YNegativeDelta], 'lineProps', {'Color', s_D.Color, 'LineWidth', 1.5});
    h_B = shadedErrorBar(s_B.XData, s_B.YData, [s_B.YPositiveDelta; s_B.YNegativeDelta], 'lineProps', {'Color', s_B.Color, 'LineWidth', 1.5});
    h_P = shadedErrorBar(s_P.XData, s_P.YData, [s_P.YPositiveDelta; s_P.YNegativeDelta], 'lineProps', {'Color', s_P.Color, 'LineWidth', 1.5});
    delete(s_D);
    delete(s_B);
    delete(s_P);
    
end

% Plot reference line
loadDefaultParameters
plot(ax2, [1 1] * Delta, ax2.YLim, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5)


for i = 1:2
    
    % Plot the results
    s_D = errorbar(ax3, nan, nan, nan, 'b.');
    s_B = errorbar(ax3, nan, nan, nan, 'k.');
    s_P = errorbar(ax3, nan, nan, nan, 'r.');
    
    % Adjust the color
    if i == 1
        s_D.Color(s_D.Color == 0) = 178/255;
        s_B.Color(s_B.Color == 0) = 178/255;
        s_P.Color(s_P.Color == 0) = 178/255;
    end
    
    % Select the data
    switch i
        case 1
            str = 'Uncorrelated';
        case 2
            str = 'Correlated';
    end
    
    % Load parameters
    loadDefaultParameters
    
    % Load the data
    for k = 1:numel(Eta_vals)
        
        fname = sprintf('../data/Fig4/%s/alpha_%.2f_beta_%d_delta_1e%.3f_eta_1e%.2f.mat', str, Alpha, Beta, log10(Delta), log10(Eta_vals(k)));
        if exist(fname, 'file')
            load(fname);
        else
            error('Data not created')
        end
        
        % Update data
        s_D.XData = [s_D.XData Eta];
        s_B.XData = [s_B.XData Eta];
        s_P.XData = [s_P.XData Eta];
        
        s_D.YData = [s_D.YData mean(D) / Beta];
        s_B.YData = [s_B.YData mean(B) / C];
        s_P.YData = [s_P.YData mean(P) / (10 * C)];
        
        s_D.YNegativeDelta = [s_D.YNegativeDelta std(D) / (Beta * numel(D))];
        s_B.YNegativeDelta = [s_B.YNegativeDelta std(B) / (C * numel(D))];
        s_P.YNegativeDelta = [s_P.YNegativeDelta std(P) / (10 * C * numel(D))];
        
        s_D.YPositiveDelta = s_D.YNegativeDelta;
        s_B.YPositiveDelta = s_B.YNegativeDelta;
        s_P.YPositiveDelta = s_P.YNegativeDelta;
    end

    % Convert to shaded error bar
    axes(ax3);
    h_D = shadedErrorBar(s_D.XData, s_D.YData, [s_D.YPositiveDelta; s_D.YNegativeDelta], 'lineProps', {'Color', s_D.Color, 'LineWidth', 1.5});
    h_B = shadedErrorBar(s_B.XData, s_B.YData, [s_B.YPositiveDelta; s_B.YNegativeDelta], 'lineProps', {'Color', s_B.Color, 'LineWidth', 1.5});
    h_P = shadedErrorBar(s_P.XData, s_P.YData, [s_P.YPositiveDelta; s_P.YNegativeDelta], 'lineProps', {'Color', s_P.Color, 'LineWidth', 1.5});
    delete(s_D);
    delete(s_B);
    delete(s_P);
    
end

% Plot reference line
loadDefaultParameters
plot(ax3, [1 1] * Eta, ax3.YLim, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5)


for i = 1:2
    
    % Plot the results
    s_D = errorbar(ax4, nan, nan, nan, 'b.');
    s_B = errorbar(ax4, nan, nan, nan, 'k.');
    s_P = errorbar(ax4, nan, nan, nan, 'r.');
    
    % Adjust the color
    if i == 1
        s_D.Color(s_D.Color == 0) = 178/255;
        s_B.Color(s_B.Color == 0) = 178/255;
        s_P.Color(s_P.Color == 0) = 178/255;
    end
    
    % Select the data
    switch i
        case 1
            str = 'Uncorrelated';
        case 2
            str = 'Correlated';
    end
    
    % Load parameters
    loadDefaultParameters
    
    % Load the data
    for k = 1:numel(Beta_vals)
        
        fname = sprintf('../data/Fig4/%s/alpha_%.2f_beta_%d_delta_1e%.3f_eta_1e%.2f.mat', str, Alpha, Beta_vals(k), log10(Delta), log10(Eta));
        if exist(fname, 'file')
            load(fname);
        else
            error('Data not created')
        end
        
        % Update data
        s_D.XData = [s_D.XData Beta];
        s_B.XData = [s_B.XData Beta];
        s_P.XData = [s_P.XData Beta];
        
        s_D.YData = [s_D.YData mean(D) / Beta];
        s_B.YData = [s_B.YData mean(B) / C];
        s_P.YData = [s_P.YData mean(P) / (10 * C)];
        
        s_D.YNegativeDelta = [s_D.YNegativeDelta std(D) / (Beta * numel(D))];
        s_B.YNegativeDelta = [s_B.YNegativeDelta std(B) / (C * numel(D))];
        s_P.YNegativeDelta = [s_P.YNegativeDelta std(P) / (10 * C * numel(D))];
        
        s_D.YPositiveDelta = s_D.YNegativeDelta;
        s_B.YPositiveDelta = s_B.YNegativeDelta;
        s_P.YPositiveDelta = s_P.YNegativeDelta;
    end
    
    % Convert to shaded error bar
    axes(ax4);
    h_D = shadedErrorBar(s_D.XData, s_D.YData, [s_D.YPositiveDelta; s_D.YNegativeDelta], 'lineProps', {'Color', s_D.Color, 'LineWidth', 1.5});
    h_B = shadedErrorBar(s_B.XData, s_B.YData, [s_B.YPositiveDelta; s_B.YNegativeDelta], 'lineProps', {'Color', s_B.Color, 'LineWidth', 1.5});
    h_P = shadedErrorBar(s_P.XData, s_P.YData, [s_P.YPositiveDelta; s_P.YNegativeDelta], 'lineProps', {'Color', s_P.Color, 'LineWidth', 1.5});
    delete(s_D);
    delete(s_B);
    delete(s_P);
end


% Plot reference line
loadDefaultParameters
plot(ax4, [1 1] * Beta, ax4.YLim, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5)


% Adjust some labels
ax1.XLabel.Position(2) = -0.4;
ax2.XLabel.Position(2) = -0.5;

% Save the figures
if ~exist('../../figures/Figure_4', 'dir')
    mkdir('../../figures/Figure_4')
end

fh0.Color = [1 1 1];
set(fh0, 'PaperPositionMode', 'auto')
set(fh0, 'InvertHardcopy', 'off')

print(fh0, '../../figures/Figure_4/fig4.tif', '-dtiff')