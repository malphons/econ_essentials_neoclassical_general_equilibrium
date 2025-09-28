function neoclassical_general_equilibrium_vectorfield(I,Q)
%% Parameters
if nargin == 0
    I = [100, 150, 120];
    Q = [120, 60, 100];
end
alpha = [0.6, 0.2, 0.3];
beta  = [0.2, 0.6, 0.3];
gamma = [0.2, 0.2, 0.4];


% --- Reuse grid PM, PV from above (or re-create a coarser grid for clarity)
pM2 = linspace(0.6,4.5,28);
pV2 = linspace(0.6,4.0,28);
[PM2, PV2] = meshgrid(pM2, pV2);

dPM = zeros(size(PM2));   % price adjustment for meat
dPV = zeros(size(PM2));   % price adjustment for veg

for i = 1:numel(PM2)
    p = [1, PM2(i), PV2(i)];
    xM = sum(beta  .* I ./ p(2));
    xV = sum(gamma .* I ./ p(3));
    % Excess demand (demand - supply)
    zM = xM - Q(2);
    zV = xV - Q(3);
    % Tâtonnement: prices rise if excess demand > 0, fall if < 0
    dPM(i) = zM;
    dPV(i) = zV;
end

% --- Solve for equilibrium (one market can be dropped by Walras' Law)
% Here we match meat and veg; grain will clear automatically for Cobb–Douglas.
f = @(p) [ sum(beta .* I)/p(1)  - Q(2) ; ...
           sum(gamma.* I)/p(2)  - Q(3) ];
p0 = [2; 1];                          % initial guess [p_meat; p_veg]
opts = optimset('Display','off');
peq = fsolve(f, p0, opts);            % ≈ [3.0; 1.5]

figure;
quiver(PM2, PV2, dPM, dPV, 'AutoScale','on');  % vector field
hold on; plot(peq(1), peq(2), 'ko', 'MarkerFaceColor','k','MarkerSize',6);
xlabel('Meat Price'); ylabel('Vegetable Price');
title('Price-Adjustment Vector Field (Tâtonnement)');
grid on;
