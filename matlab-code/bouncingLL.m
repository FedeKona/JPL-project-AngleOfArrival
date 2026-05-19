clear variables
close all
clc

%% Begin
randomness = 0;
runId = 12;    % -- random seed
rng(runId)

%% Parameters
Ts= 1;
n = 3;
L = 20;
W = L*Ts;        % -- L observations

lambdas = 2;        % -- the mean number of SIGNAL photon counts per symbol (only 1 slot has pulse within 1 symbol)
lambdab = 0.1;         % -- the mean number of BACKGROUND photon counts per slot 

inte = 8;      % -- integer part of the timing offset
epso = 0.4545;  % -- fractional part of the timing offset

%% Piecewise functions

% trapezoid:
% tau = starting time
% Ts = duration of rise/fall time
% n = duration of flat part in multiples of Ts
trapz = @(i,tau,Ts,n) ...
    (tau+ (n-i)*Ts>=0    & tau+ (n-i)*Ts< Ts      ).*(tau + (n-i)*Ts - 0) + ...                     % rise
    (tau+ (n-i)*Ts>=Ts   & tau+ (n-i)*Ts< n*Ts    ).*(Ts) + ...                                     % flat
    (tau+ (n-i)*Ts>=n*Ts & tau+ (n-i)*Ts< (n+1)*Ts).*((0 + (n+1)*Ts) - (tau + (n-i)*Ts));           % fall

psitrapzi = @(i,tau,Ts,n) lambdas*trapz(i,tau,Ts,n) + lambdab*Ts;

%% Generate the the observed sequence y
y = zeros(L,1); 

idx_up = mod(inte,L);
idx_mid = mod(inte+1:inte+n-1,L);
idx_down = mod(inte+n,L);


if randomness
    lmbd = zeros(L,1);
    lmbd = lmbd + ones(L,1) * 50 * lambdab;

    lmbd(idx_up+1) = lmbd(idx_up+1) + (1-epso) *  10 * lambdas;
    lmbd(idx_mid+1) = lmbd(idx_mid+1) + ones(n-1,1) *  10 * lambdas;
    lmbd(idx_down+1) = lmbd(idx_down+1) + epso *  10 * lambdas;

    y = poissrnd(lmbd);
else
    y = y + ones(L,1) * 50 * lambdab;

    y(idx_up+1) = y(idx_up+1) + (1-epso) *  10 * lambdas;
    y(idx_mid+1) = y(idx_mid+1) + ones(n-1,1) *  10 * lambdas;
    y(idx_down+1) = y(idx_down+1) + epso *  10 * lambdas;

    y = round(y);
end


%% Points
p = 2000;
tau = linspace(0, W, p).';

f = psitrapzi(0, tau, Ts, n);
logf = zeros(p,1);

for m=1:L
    logf = logf + y(m) .* log( psitrapzi(m-1, tau, Ts, n) );
end

I   = (0:(numel(y)-n-1));
yi  = y(1:end-n).';
yin = y(1+n:end).';
r   = lambdab/lambdas;
delta = Ts .* ( (yin.*(I+1+r) + yi.*(I-r)) ./ (yi+yin) );

for i = 0:length(delta)-1
    if delta(i+1) < i*Ts
        delta(i+1) = i*Ts;
    elseif delta(i+1) > (i+1)*Ts
        delta(i+1) = (i+1)*Ts;
    end
end

y_M = interp1(tau, logf, delta, 'linear', 'extrap');

% Nice Plot
set(groot,'defaultLineLineWidth',2);
set(groot,'defaultFigureColor','w')
set(groot,'defaultAxesFontSize',16);

% Interpreter for Axis Lables
set(groot,'defaulttextinterpreter','latex')
% Interpreter for Axis Ticks
set(groot, 'defaultAxesTickLabelInterpreter','latex')
% Interpreter for Legend
set(groot, 'defaultLegendInterpreter','latex')

% plot beamforming gain vs satellite angle and save plot
h = figure(1);
plot(tau, logf,'Color',[138,43,226]./255,'LineWidth', 2)
hold on
plot(delta, y_M,  'o', 'MarkerSize', 8, 'MarkerFaceColor', [255,140,0]./255, 'Color','k', 'LineWidth', 1.5);
xline((inte+epso)*Ts, '--r', ['Delay = ' num2str((inte+epso)*Ts,'%.2f')], 'LineWidth', 1.5, 'LabelOrientation','horizontal', 'LabelVerticalAlignment','bottom'); 
grid on
xlabel('Timing offset $\delta/T_s$')
ylabel('Log likelihood $\log l(\delta;\mathbf{x})$')
set(gca,'FontSize', 16)
hold off

addpath(genpath('/Users/fajmone/Documents/MATLAB/matlab2tikz'));
figurewidth = '10cm';
figureheight = '6cm';
matlab2tikz(...
    '/Users/fajmone/Documents/Projects/JPL-project-AngleOfArrival/matlab-code/bouncingLL.tex', ...
    'height', figureheight, 'width', figurewidth, 'strict', true);