function [B_end, P_end, y, t] = DynamicalSystem(gamma, omega, params, x0)

% Set the parameters
alpha   = params{1};
beta    = params{2};
eta     = params{3};
delta   = params{4};
C       = params{5};
T_end   = params{6};

% Set the number of bacteria
nB = numel(x0) / 2;

% Convert omega to matrix
omega = repmat(omega, 1, nB) - diag(omega) + eye(nB);

% Configure the model
ode = @(t, x)df_dt(x, nB, gamma, omega, C, alpha, beta, eta, delta);

options = odeset('NonNegative', find(x0 > 0));
sol = ode45(ode, [0 T_end], x0, options);
t = sol.x;
y = sol.y;

B_end = y(1:nB, end);
P_end = y((nB+1):end, end);

end

function y = df_dt(x, nB, gamma, omega, C, alpha, beta, eta, delta)

% Allocate y
y = zeros(size(x));

% Compute B
B = sum(x(1:nB));

% Growth kinetics
y(1:nB) = (gamma * (1 - B / C) - alpha) .* x(1:nB);

% Phage killings
y(1:nB) = y(1:nB) - eta * omega * x((nB+1):end) .* x(1:nB);

% Phage profilation, adsorption and decay
y((nB+1):end) = eta * beta * omega * x((nB+1):end) .* x(1:nB) -  x(nB + (1:nB)) * (eta*B + delta);

end