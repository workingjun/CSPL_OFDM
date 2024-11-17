function [ABdiffsq, mean_e, e_rx_logpdf, e_sol_rx] = method2_upgraded(params)
    GP = params.GP;
    L = params.L;
    N = params.N;
    r = params.rx_signal;
    N_OFDM_symbols = 10^2;

    Asq = zeros(1, GP);
    Bsq = zeros(1, GP);
    ABdiffsq = zeros(1, GP);
    ABplussq = zeros(1, GP);
    J = zeros(1, GP);
    e = zeros(1, GP);  
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for kk=1:GP
        sumA = 0;
        sumB = 0;
        sumABdiff = 0;
        sumABplus = 0;
        sumJ = 0;
        for m=1:N_OFDM_symbols
            for u = kk:GP
                sumJ = sumJ + abs(r((GP+N)*(m-1)+u)-r((GP+N)*(m-1)+N+u))^2;
            end
            sumA = sumA + abs(r((GP+N)*(m-1) + kk))^2;
            sumB = sumB + abs(r((GP+N)*(m-1) + (kk+N)))^2;
            sumABdiff = sumABdiff + abs(r((GP+N)*(m-1) + kk) - r((GP+N)*(m-1) + (kk+N)))^2;
            sumABplus = sumABplus + abs(r((GP+N)*(m-1) + kk) + r((GP+N)*(m-1) + (kk+N)))^2;
        end
        Asq(kk) = sumA/(N_OFDM_symbols);
        Bsq(kk) = sumB/N_OFDM_symbols;
        ABdiffsq(kk) = sumABdiff/(2*N_OFDM_symbols*(GP-kk+1));
        ABplussq(kk) = sumABplus/(2*N_OFDM_symbols);
        J(kk) = sumJ/(2*N_OFDM_symbols*(GP-kk+1));
    end

    % mean_A = (J(5))./(GP+1-(1:GP));
    % sigma_A = mean_A.^2/N_OFDM_symbols;
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mean_e = (params.c_hat * (1 - params.rho(4, 16:-1:1)) + J) ./ (2 * (GP - (1:GP) + 1)); %%평균
    sigma_e = mean_e.^2 / N_OFDM_symbols; %%분산

    % e_rx_pdf = (2 * pi * sigma_e).^(-0.5) .* exp(-0.5 .* (abs(ABdiffsq - mean_e).^2 ./ sigma_e));
    e_rx_logpdf = -0.5 * (abs(ABdiffsq - mean_e).^2 / sigma_e) - log(sqrt(2 * pi * sigma_e));

    % e_rx_sum_pdf = cumsum(e_rx_logpdf, 'reverse');
    % e_rx_sum_pdf = e_rx_sum_pdf .* (1 ./ (GP + 1 - (1:GP)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [~, e_sol_rx] = max(e_rx_logpdf);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end