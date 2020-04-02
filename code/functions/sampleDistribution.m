function [gamma,  omega] = sampleDistribution(avgRM,  lb,  ub,  f,  N)

% Allocate
gamma = nan(N, 1);
omega = nan(N, 1);

    
    % If avgRM > 0, use real distributions
    if avgRM > 0
          
        k = 1;
        while k <= N

                % Compute number of RM systems in new bacteria
                if avgRM == 1
                    nRM = 1;
                else
                    nRM = poissrnd(avgRM);
                    while nRM < 1
                        nRM = poissrnd(avgRM);
                    end
                end

                % Sample the distribution
                gamma(k) = prod(1 - f * rand(nRM, 1));
                omega(k) = prod(10.^(lb/avgRM + (ub-lb/avgRM) * rand(nRM, 1)));
                k = k + 1;

        end
        
    else % Use the joint normal probability distribution
        
        r = -avgRM;
        
        % Sample the distribution
        mu = [0.5 -2];
        s_gamma = 0.125;
        s_omega = 0.5;
        sigma = [s_gamma^2               r * s_gamma * s_omega;
                 r * s_gamma * s_omega   s_omega^2];

        R = mvnrnd(mu, sigma, N);
        I = or(R(:, 1)<0, R(:, 2)>0);
        while(sum(I)>0)
            R(I, :) = mvnrnd(mu, sigma, sum(I));
            I = or(R(:, 1)<0, R(:, 2)>0);
        end
        gamma = R(:, 1);
        omega = 10.^R(:, 2);
        
    end
end

