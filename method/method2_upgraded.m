function [ABdiffsq, e_rx_sum_pdf, p_rx_logpdf, p_rx_sum_pdf, SIM_upgrade, upgrade_sol, confirm_sol] = method2_upgraded(params)
    GP = params.GP;
    L = params.L;
    N = params.N;
    r = params.rx_signal;
    N_OFDM_symbols = 10^2;

    Asq = zeros(1, GP);
    Bsq = zeros(1, GP);
    ABdiffsq = zeros(1, GP);
    ABdiffsq_ch = zeros(1, GP);
    ABplussq = zeros(1, GP);
    J = zeros(1, GP);
    SIM_upgrade = zeros(1, GP-1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for kk=1:GP
        sumA = 0;
        sumB = 0;
        sumABdiff = 0;
        sumABplus = 0;
        for m=1:N_OFDM_symbols
            sumA = sumA + abs(r((GP+N)*(m-1) + kk))^2;
            sumB = sumB + abs(r((GP+N)*(m-1) + (kk+N)))^2;
            sumABdiff = sumABdiff + abs(r((GP+N)*(m-1) + kk) - r((GP+N)*(m-1) + (kk+N)))^2;
            sumABplus = sumABplus + abs(r((GP+N)*(m-1) + kk) + r((GP+N)*(m-1) + (kk+N)))^2;
        end
        ABdiffsq(kk) = sumABdiff/(2*N_OFDM_symbols*(GP-kk+1));
        ABdiffsq_ch(kk) = sumABdiff/(2*N_OFDM_symbols);
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_e = params.J ./ (GP-(1:GP)+1); %%평균
    sigma_e = mean_e.^2 / N_OFDM_symbols; %%분산

    e_rx_logpdf = -0.5 * (abs(ABdiffsq - mean_e).^2 ./ sigma_e) - log(sqrt(2 * pi * sigma_e));
    
    e_rx_sum_pdf = cumsum(e_rx_logpdf, 'reverse');
    e_rx_sum_pdf = e_rx_sum_pdf .* (1 ./ (GP + 1 - (1:GP)));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    mean_p = (params.c_hat*(1-params.rho(4,16:-1:1))+J)./(GP+1-(1:GP)); %%평균
    % mean_p = (params.c_hat*(1-params.rho(4,16:-1:1))+J); %%평균
    
    sigma_p = mean_p.^2 / N_OFDM_symbols; %%분산
    
    p_rx_logpdf = -0.5 * (abs(ABdiffsq - mean_p).^2 ./ sigma_p) - log(sqrt(2 * pi * sigma_p));
    
    p_rx_sum_pdf = cumsum(p_rx_logpdf);
    p_rx_sum_pdf = p_rx_sum_pdf .* (1 ./ (1:GP));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    SIM_upgrade(1) = e_rx_sum_pdf(1);

    for u = 2:GP
        SIM_upgrade(u) = p_rx_sum_pdf(u-1) + e_rx_sum_pdf(u);
    end
    
    [~, upgrade_sol] = max(SIM_upgrade);
    [~, confirm_sol] = max(p_rx_sum_pdf);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end