%% Nexon EV Thermal Analysis: Cooling Effectiveness Plot
clear all; close all; clc;

%% System Parameters (From Your Report)
Q_total = 14775;        % kJ (fast charging)
t = 3600;               % s
N_modules = 10;
pack_mass = 270;        % kg
Cp = 1800;              % J/kgK
T_ambient = 25;         % °C (coolant inlet)

%% Heat Rates
Q_rate = Q_total * 1000 / t;        % W (total)
Q_module = Q_rate / N_modules;      % W/module
R_thermal = 0.05;                   % K/W

%% WITHOUT COOLING (Your Original Lumped Model)
dT_no_cooling = (Q_total * 1000) / (pack_mass * Cp);  % K
T_max_no_cooling = T_ambient + dT_no_cooling;         % °C

%% WITH COOLING (Thermal Resistance Model)
dT_with_cooling = Q_module * R_thermal;               % K
T_max_with_cooling = T_ambient + dT_with_cooling;     % °C

%% Results
fprintf('=== COOLING EFFECTIVENESS ===\n');
fprintf('Without Cooling: ΔT = %.1f K, T_max = %.1f°C\n', dT_no_cooling, T_max_no_cooling);
fprintf('With Cooling:    ΔT = %.1f K, T_max = %.1f°C\n', dT_with_cooling, T_max_with_cooling);
fprintf('Temperature Reduction: %.1f°C (%.0f%%)\n', T_max_no_cooling - T_max_with_cooling, ...
    100*(1 - T_max_with_cooling/T_max_no_cooling));

%% PLOT 1: Temperature Comparison Bar Chart
figure('Position', [100, 100, 1000, 600]);
scenarios = categorical({'Without Cooling', 'With Liquid Cooling'});
T_max = [T_max_no_cooling, T_max_with_cooling];

b = bar(scenarios, T_max, 'FaceColor', 'flat');
b.CData(1,:) = [0.9, 0.3, 0.3];  % Red for no cooling
b.CData(2,:) = [0.2, 0.6, 0.9];  % Blue for cooling

ylabel('Maximum Cell Temperature (°C)', 'FontSize', 12, 'FontWeight', 'bold');
title('Nexon EV Fast Charging: Cooling Effectiveness', 'FontSize', 14, 'FontWeight', 'bold');
grid on; grid minor;

% Safe limit line
yline(45, 'g--', 'Safe Limit 45°C', 'LineWidth', 2, 'FontSize', 11);
yline(60, 'r--', 'Operating Limit 60°C', 'LineWidth', 2, 'FontSize', 11);

% Legend and annotations
legend('No Cooling (Passive)', 'Liquid Plate Cooling', 'Location', 'northwest');
text(1, T_max_no_cooling+2, sprintf('%.1f°C', T_max_no_cooling), ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'r');
text(2, T_max_with_cooling+2, sprintf('%.1f°C', T_max_with_cooling), ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'b');

%% PLOT 2: Temperature Rise Comparison
figure('Position', [150, 150, 1000, 500]);
subplot(1,2,1);
bar(categorical({'No Cooling', 'With Cooling'}), [dT_no_cooling, dT_with_cooling], ...
    'FaceColor', 'flat');
b.CData(1,:) = [0.9, 0.4, 0.2];  % Orange
b.CData(2,:) = [0.3, 0.7, 0.3];  % Green
ylabel('Temperature Rise ΔT (K)', 'FontSize', 12, 'FontWeight', 'bold');
title('Temperature Rise Comparison', 'FontSize', 13);
grid on; ylim([0, max(dT_no_cooling)*1.1]);

subplot(1,2,2);
pie([dT_no_cooling, dT_with_cooling], {'No Cooling', 'Liquid Cooling'});
title('ΔT Distribution', 'FontSize', 13);

sgtitle
