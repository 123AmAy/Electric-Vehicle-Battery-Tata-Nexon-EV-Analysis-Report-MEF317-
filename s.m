% Thermal Heat Generation Analysis for Tata Nexon EV Battery Pack
% MEF317 Assignment: Thermal Management Simulation
clear all; close all; clc;

%% System Parameters
battery_capacity = 30.2; % kWh
pack_voltage     = 350;  % V (nominal)
pack_mass        = 270;  % kg
R_internal       = 0.166; % ohms (pack-level equivalent)
C_p              = 1800; % J/(kg·K) - effective thermal capacity
ambient_temp     = 25;   % °C

%% Assumed pack-level overpotentials (η) for each scenario
eta_city      = 1;  % V (low current, mild polarization)
eta_highway   = 2;  % V (moderate current)
eta_fast      = 5;  % V (high current, strong polarization)

%% Scenario 1: City Driving
fprintf('--- SCENARIO 1: CITY DRIVING ---\n');
P_city = 10; % kW
I_city = (P_city * 1000) / pack_voltage;
t_city = 3600; % seconds (1 hour)

Q_ohmic_city = I_city^2 * R_internal * t_city;           % I^2 R t
Q_pol_city   = I_city * eta_city * t_city;               % I * η * t
Q_total_city = Q_ohmic_city + Q_pol_city;

dT_city      = Q_total_city / (pack_mass * C_p);
T_max_city   = ambient_temp + dT_city;

fprintf('Power: %.1f kW | Current: %.1f A | Duration: %.0f s\n', P_city, I_city, t_city);
fprintf('Ohmic Heat: %.0f kJ | Polarization Heat: %.0f kJ | Total Heat: %.0f kJ\n', ...
        Q_ohmic_city/1000, Q_pol_city/1000, Q_total_city/1000);
fprintf('Temperature Rise: %.2f K | Max Temp: %.1f°C\n\n', dT_city, T_max_city);

%% Scenario 2: Highway Driving
fprintf('--- SCENARIO 2: HIGHWAY DRIVING ---\n');
P_highway = 22.5; % kW
I_highway = (P_highway * 1000) / pack_voltage;
t_highway = 3600; % seconds (1 hours)

Q_ohmic_highway = I_highway^2 * R_internal * t_highway;  % I^2 R t
Q_pol_highway   = I_highway * eta_highway * t_highway;   % I * η * t
Q_total_highway = Q_ohmic_highway + Q_pol_highway;

dT_highway    = Q_total_highway / (pack_mass * C_p);
T_max_highway = ambient_temp + dT_highway;

fprintf('Power: %.1f kW | Current: %.1f A | Duration: %.0f s\n', P_highway, I_highway, t_highway);
fprintf('Ohmic Heat: %.0f kJ | Polarization Heat: %.0f kJ | Total Heat: %.0f kJ\n', ...
        Q_ohmic_highway/1000, Q_pol_highway/1000, Q_total_highway/1000);
fprintf('Temperature Rise: %.2f K | Max Temp: %.1f°C\n\n', dT_highway, T_max_highway);

%% Scenario 3: Fast Charging
fprintf('--- SCENARIO 3: FAST CHARGING (0-80%%) ---\n');
P_fastcharge = 50; % kW
I_fastcharge = (P_fastcharge * 1000) / pack_voltage;
t_fastcharge = 3600; % seconds (30 minutes)

Q_ohmic_fastcharge = I_fastcharge^2 * R_internal * t_fastcharge;   % I^2 R t
Q_pol_fastcharge   = I_fastcharge * eta_fast * t_fastcharge;       % I * η * t
Q_total_fastcharge = Q_ohmic_fastcharge + Q_pol_fastcharge;

dT_fastcharge    = Q_total_fastcharge / (pack_mass * C_p);
T_max_fastcharge = ambient_temp + dT_fastcharge;

fprintf('Power: %.1f kW | Current: %.1f A | Duration: %.0f s\n', P_fastcharge, I_fastcharge, t_fastcharge);
fprintf('Ohmic Heat: %.0f kJ | Polarization Heat: %.0f kJ | Total Heat: %.0f kJ\n', ...
        Q_ohmic_fastcharge/1000, Q_pol_fastcharge/1000, Q_total_fastcharge/1000);
fprintf('Temperature Rise: %.2f K | Max Temp: %.1f°C\n\n', dT_fastcharge, T_max_fastcharge);

%% Summary Table and Visualization
fprintf('\nTHERMAL LOAD SUMMARY TABLE\n\n');
fprintf('| Scenario         | Duration | Heat (kJ) | ΔT (K) | T_max (°C) |\n');
fprintf('|------------------|----------|----------|--------|------------|\n');
fprintf('| City (normal)    | 1 hour   | %7.0f | %5.2f | %6.1f |\n', ...
        Q_total_city/1000, dT_city, T_max_city);
fprintf('| Highway (sust.)  | 1hours  | %7.0f | %5.2f | %6.1f |\n', ...
        Q_total_highway/1000, dT_highway, T_max_highway);
fprintf('| Fast Charging    | 1 hours   | %7.0f | %5.2f | %6.1f |\n', ...
        Q_total_fastcharge/1000, dT_fastcharge, T_max_fastcharge);
fprintf('========================================\n\n');

%% Visualization
scenarios     = {'City\nDriving', 'Highway\nDriving', 'Fast\nCharging'};
heat_generated = [Q_total_city/1000, Q_total_highway/1000, Q_total_fastcharge/1000];
temp_rise      = [dT_city, dT_highway, dT_fastcharge];

figure('Position', [100 100 1000 400]);

subplot(1,2,1);
bar(heat_generated, 'FaceColor', [0.2 0.6 0.9], 'EdgeColor', 'black', 'LineWidth', 1.5);
ylabel('Total Heat Generated (kJ)', 'FontSize', 11, 'FontWeight', 'bold');
set(gca, 'XTickLabel', scenarios, 'FontSize', 10);
title('Heat Generation Comparison', 'FontSize', 12, 'FontWeight', 'bold');
grid on; grid minor;

subplot(1,2,2);
bar(temp_rise, 'FaceColor', [0.9 0.3 0.3], 'EdgeColor', 'black', 'LineWidth', 1.5);
ylabel('Temperature Rise (K)', 'FontSize', 11, 'FontWeight', 'bold');
set(gca, 'XTickLabel', scenarios, 'FontSize', 10);
title('Temperature Rise Comparison', 'FontSize', 12, 'FontWeight', 'bold');
grid on; grid minor;
hold on; yline(5, 'g--', 'Passive Cooling Limit', 'LineWidth', 2);

sgtitle('Nexon EV Battery Thermal Analysis: Driving Scenarios', ...
        'FontSize', 13, 'FontWeight', 'bold');
