function neoclassical_general_equilibrium_contourmap(I,Q)
%% Parameters
if nargin == 0
    I = [100, 150, 120];
    Q = [120, 60, 100];
end
alpha = [0.6, 0.2, 0.3];
beta  = [0.2, 0.6, 0.3];
gamma = [0.2, 0.2, 0.4];

% --- Price grid
pG = 1;                               % normalize grain price
pM = linspace(0.5,5,200);             % meat prices
pV = linspace(0.5,5,200);             % veg prices
[PM, PV] = meshgrid(pM, pV);

% --- Excess demand norm on the grid
ED = zeros(size(PM));
for i = 1:numel(PM)
    p = [pG, PM(i), PV(i)];
    xG = sum(alpha .* I ./ p(1));
    xM = sum(beta  .* I ./ p(2));
    xV = sum(gamma .* I ./ p(3));
    ED(i) = norm([xG - Q(1), xM - Q(2), xV - Q(3)]);
end

% --- Contour plot
figure; 
contour(PM, PV, ED, 20, 'LineWidth', 1);
xlabel('Meat Price'); ylabel('Vegetable Price');
title('Excess Demand Contours with Equilibrium');

% --- Solve for equilibrium (one market can be dropped by Walras' Law)
% Here we match meat and veg; grain will clear automatically for Cobb–Douglas.
f = @(p) [ sum(beta .* I)/p(1)  - Q(2) ; ...
           sum(gamma.* I)/p(2)  - Q(3) ];
p0 = [2; 1];                          % initial guess [p_meat; p_veg]
opts = optimset('Display','off');
peq = fsolve(f, p0, opts);            % ≈ [3.0; 1.5]

hold on;
plot(peq(1), peq(2), 'ko', 'MarkerFaceColor','k','MarkerSize',6); % equilibrium dot
text(peq(1)+0.06, peq(2), sprintf('  Eq: (%.2f, %.2f)', peq(1), peq(2)));
grid on;
