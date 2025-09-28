function neoclassical_general_equilibrium(I,Q)
%% Paris Food Markets General Equilibrium Demo

%% Parameters
if nargin == 0
    I = [100, 150, 120];   % incomes
    Q = [120, 60, 100];    % supply: [grain, meat, veg]
end
alpha = [0.6, 0.2, 0.3];
beta  = [0.2, 0.6, 0.3];
gamma = [0.2, 0.2, 0.4];


%% Price grid for visualization
p_grain = 1; % normalize
p_meat_range = linspace(0.5,5,100);
p_veg_range  = linspace(0.5,5,100);

excess_demand = zeros(length(p_meat_range), length(p_veg_range));

for i = 1:length(p_meat_range)
    for j = 1:length(p_veg_range)
        p = [p_grain, p_meat_range(i), p_veg_range(j)];
        
        % Demand per consumer
        x_grain = sum(alpha .* I ./ p(1));
        x_meat  = sum(beta  .* I ./ p(2));
        x_veg   = sum(gamma .* I ./ p(3));
        
        % Excess demand norm
        excess_demand(i,j) = norm([x_grain-Q(1), x_meat-Q(2), x_veg-Q(3)]);
    end
end

%% Heatmap of excess demand
imagesc(p_meat_range, p_veg_range, excess_demand')
set(gca,'YDir','normal')
xlabel('Meat Price')
ylabel('Vegetable Price')
title('Excess Demand Surface')
colorbar
