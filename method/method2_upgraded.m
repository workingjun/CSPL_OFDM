function [ABdiffsq, ABdiffsq_ch, mean_p, e_rx_sum_pdf, p_rx_sum_pdf, SIM_upgrade, SIM_channel,SIM_noise, upgrade_sol, confirm_sol, confirm2_sol] = method2_upgraded(params)
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
    e_rx_sum_pdf = zeros(GP, GP);
    p_rx_sum_pdf = zeros(GP, GP);
    SIM_noise = zeros(1, GP);
    SIM_channel = zeros(1, GP);

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
     
    % mean_p = (params.c_hat*(1-params.rho(4,16:-1:1))+J)./(GP+1-(1:GP)); %%평균
    mean_p = params.c_hat*(1-params.rho(4,16:-1:1))+J; %%평균
    sigma_p = mean_p.^2 / N_OFDM_symbols; %%분산
    
    p_rx_logpdf = -0.5 * (abs(ABdiffsq_ch - mean_p).^2 ./ sigma_p) - log(sqrt(2 * pi * sigma_p));
    
    % p_rx_sum_pdf = cumsum(p_rx_logpdf);
    % p_rx_sum_pdf = p_rx_sum_pdf .* (1 ./ (1:GP));

    for u=1:GP-1
        for kk=1:u
            p_rx_sum_pdf(u, kk) = p_rx_logpdf(kk);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_e = params.J(4) ./ (GP-(1:GP)+1); %%평균
    sigma_e = mean_e.^2 / N_OFDM_symbols; %%분산

    e_rx_logpdf = -0.5 * (abs(ABdiffsq - mean_e).^2 ./ sigma_e) - log(sqrt(2 * pi * sigma_e));
    
    % e_rx_sum_pdf = cumsum(e_rx_logpdf, 'reverse');
    % e_rx_sum_pdf = e_rx_sum_pdf .* (1 ./ (GP + 1 - (1:GP)));
    
    for u=1:GP
        for kk=u:GP
            e_rx_sum_pdf(u, kk) = e_rx_logpdf(kk);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% 이전에 했던 방식; 노이즈 파트가 다름
    % p_rx_sum_pdf = zeros(1, GP-1); e_rx_sum_pdf = zeros(1, GP-1); 
    % for u = 1:GP-1
    %     p_rx_sum_pdf(u) = sum(p_rx_logpdf(1:u))/u;
    %     e_rx_sum_pdf(u) = sum(e_rx_logpdf(u+1:GP))/(GP-u);
    %     SIM_upgrade(u) =  p_rx_sum_pdf(u) + e_rx_sum_pdf(u);
    % end
   
    SIM_noise(1) = sum(e_rx_sum_pdf(1, :))/GP;
    SIM_upgrade(1) = SIM_noise(1);
   
    for u = 2:GP
        SIM_channel(u) = sum(p_rx_sum_pdf(u-1, :))/(u-1);
        SIM_noise(u) = sum(e_rx_sum_pdf(u, :))/(GP-u+1);
        SIM_upgrade(u) = SIM_channel(u) + SIM_noise(u);
    end
    
    [~, upgrade_sol] = max(SIM_upgrade);
    [~, confirm_sol] = max(SIM_channel);
    [~, confirm2_sol] = max(SIM_noise);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



