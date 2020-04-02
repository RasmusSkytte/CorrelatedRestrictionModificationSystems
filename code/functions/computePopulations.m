function [bb, pp, BB, PP] = computePopulations(alpha, beta, eta, delta, C, gamma, omega)

% Compute helping sums
s1 = sum(1 ./ (beta * (1 - omega) ) );
s2 = sum(delta ./ (eta * beta * (1 - omega) ) );
s3 = sum(gamma ./ (eta * (1 - omega)));
s4 = sum(omega ./ (1 - omega));
s5 = sum(1 ./ (eta * (1 - omega)));

% Write the equation for B.
f1 = @(B) sum((eta * B + delta) ./ (beta * (gamma * (1 - B / C) - alpha)) ...
    .* omega ./ (1 - omega) ...
    .* ( (1 - B / C) * s3 / (1 + s4) - alpha * s5 / (1 + s4)));

% Solve for B
f = @(B)B - (s2 - f1(B)) / (1 - s1);
BB = bisection(f,0,(1-alpha/min(gamma)-eps)*C);

% Solve for P
PP = ((1 - BB / C) * (s3 / (1 + s4)) - alpha * s5 / (1 + s4));

% Compute bi's
bb = (BB + delta / eta) ./ (beta * (1 - omega)) .* (1 - eta * PP * omega ./ (gamma * (1 - BB / C) - alpha));

% Compute pi's
pp = (gamma*(1 - BB / C) - alpha - eta * omega .* PP) ./ (eta * (1-omega));

end
