function [ABdiffsq, p_rx_logpdf, SIM, upgrade_sol,confirm_sol] = method2_upgraded(params)
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
    SIM_n = zeros(1, GP-1);
    SIM_h = zeros(1, GP-1);
    SIM = zeros(1, GP-1);

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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    mean_p = (params.c_hat*(1-params.rho(4,16:-1:1))+J)/2; %%평균
    sigma_p = mean_p.^2 / N_OFDM_symbols; %%분산
    
    p_rx_logpdf = -0.5 * (abs(ABdiffsq_ch - mean_p).^2 ./ sigma_p) - log(sqrt(2 * pi * sigma_p));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for u = 1:GP-1
        SIM(u) = sum(p_rx_logpdf(1:u)) + sum(e_rx_logpdf(u:GP-1))/(GP-u);
    end

    [~, upgrade_sol] = max(SIM);
    [~, confirm_sol] = max(p_rx_logpdf);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end