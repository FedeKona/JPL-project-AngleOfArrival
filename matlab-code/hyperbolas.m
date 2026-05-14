% Hyperbola plotting for TDOA localization example

clear variables
close all
clc


% Color palette
Palette = orderedcolors("gem");

% Sensor and emitter positions

E = [500,400]*3;     % Source

x1 = -300; y1 = 200;     % Sensor 1
x2 = -500; y2 = -100;  % Sensor 2
x3 = -250;  y3 = -300;  % Sensor 3

x = [x1, x2, x3];
y = [y1, y2, y3];

S = [x', y'];          % Sensors

% Plot window
R = [min([x,E(1)]) - 0.5*abs(min([x,E(1)])), ...
     max([x,E(1)]) + 0.5*abs(max([x,E(1)])), ...
     min([y,E(2)]) - 0.5*abs(min([y,E(2)])), ...
     max([y,E(2)]) + 0.5*abs(max([y,E(2)]))];


% Nice Plot
set(groot, ...
    'defaultLineLineWidth', 2, ...
    'defaultFigureColor',    'w', ...
    'defaultAxesFontSize',   16, ...
    'defaulttextinterpreter','latex', ...
    'defaultAxesTickLabelInterpreter','latex', ...
    'defaultLegendInterpreter','latex');


figure('Color','w'); 
hold on; 

% Plot sensors
plot(S(:,1), S(:,2), 'ko', 'MarkerFaceColor','k', 'MarkerSize',8);

% Label sensors with subscripts under the points
space = 50; % space for labels
text(S(1,1)-space*1.5, S(1,2)-space*1.5, sprintf('Element {%d}', 1),'HorizontalAlignment','center','FontSize',11);
text(S(2,1)-space, S(2,2)-space, sprintf('Element {%d}', 2),'HorizontalAlignment','center','FontSize',11);
text(S(3,1)+space, S(3,2)-space, sprintf('Element {%d}', 3),'HorizontalAlignment','center','FontSize',11);

% Plot emitter
plot(E(1), E(2), 'ko', 'MarkerSize',12, 'LineWidth',2, 'MarkerFaceColor','w');
text(E(1)+60, E(2)-40, 'Source', 'HorizontalAlignment','left','FontSize',11);

% Hyperbolas for pairs
pairs = [1 2; 1 3; 3 2];

for k = 1:size(pairs,1)
    f1 = S(pairs(k,1),:);
    f2 = S(pairs(k,2),:);

    % constant distance-difference from the emitter to this pair
    d = abs(norm(E - f1) - norm(E - f2));

    %hyperbola as the zero-contour of |d1-d2| - d
    plotHyperbola(f1, f2, d, R,Palette(k,:));
    plotAsymptotes(f1, f2, d, R, k);
end

box on;
axis equal; 
xlim(R(1:2)); 
ylim(R(3:4));
xlabel('x');
ylabel('y');
ax = gca;
ax.XTick = linspace(ax.XLim(1), ax.XLim(2), 7);
ax.YTick = linspace(ax.YLim(1), ax.YLim(2), 7);
grid on;

addpath(genpath('/Users/fajmone/Documents/MATLAB/matlab2tikz'));
figurewidth = '10cm';
figureheight = '7cm';
matlab2tikz(...
    '/Users/fajmone/Documents/Projects/JPL-project-AngleOfArrival/latex-code/figs/hperbolas.tex', ...
    'height', figureheight, 'width', figurewidth, 'strict', true);


% ------------- hyperbolas -------------
function [h1,h2] = plotHyperbola(F1, F2, d, R, color)
    % Draws the hyperbola defined by |dist(P,F1)-dist(P,F2)| = d
    % over rectangle R = [xmin xmax ymin ymax].

    Nx = 100; Ny = 100;
    [xg, yg] = meshgrid(linspace(R(1), R(2), Nx), linspace(R(3), R(4), Ny));

    d1 = sqrt((xg - F1(1)).^2 + (yg - F1(2)).^2);
    d2 = sqrt((xg - F2(1)).^2 + (yg - F2(2)).^2);

    Z1 = (d2-d1) - d;
    Z2 = (d1-d2) - d;
    h1 = contour(xg, yg, Z1, [0 0], 'Color',color, 'LineWidth', 2);
    h2 = contour(xg, yg, Z2, [0 0], 'Color', color, 'LineWidth', 1, 'LineStyle', '--');

end

function plotAsymptotes(F1, F2, d, R, change)
    % For a hyperbola with foci F1,F2 and |r1 - r2| = d:
    % Asymptotes are y = ±(b/a) x.
    C = (F1 + F2)/2;                 % center (midpoint of the foci)
    L = norm(F2 - F1);               
    a = d/2;                         
    c = L/2;

    b = sqrt(c^2 - a^2);
    m = b/a;                         % slope in principal coordinates

    % Unit vectors along and perpendicular to the focal line
    u = (F2 - F1) / L;               
    v = [-u(2), u(1)];               

    % Direction vectors of the two asymptotes in world coordinates
    dir1 = u +  m * v;
    dir2 = u -  m * v;

    % Make long line segments centered at C
    t = linspace(min(R), max(R), 2);
    P1 = C + t.' .* dir1;
    P2 = C + t.' .* dir2;

    if change == 3
        plot(P1(:,1), P1(:,2), '--', 'Color', 'k', 'LineWidth', 1.0);
    else
        plot(P2(:,1), P2(:,2), '--', 'Color', 'k', 'LineWidth', 1.0);
        return;
    end

end