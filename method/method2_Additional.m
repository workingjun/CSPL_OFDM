function [e_rx, mean_e_og, sigma_e_og, e_logpdf, e_sum_pdf, L_sol_erx] = method2_Additional(params)
    N = params.N;
    GP = params.GP;
    L = params.L;

    r = params.rx_signal;    
    N_OFDM_symbols = 10^2;
    
    e_rx = zeros(1, GP);
    y_rx = zeros(1, GP);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for u = 1:GP
        r_diff_sum = 0;
        for m = 1:N_OFDM_symbols      
            r_diff_sum = r_diff_sum + abs(r((GP+N)*(m-1)+N+u) - r((GP+N)*(m-1)+u))^2;
        end
        e_rx(u) = r_diff_sum/(2*N_OFDM_symbols*(GP-u+1));
        % e_rx(u) = r_diff_sum/(2*N_OFDM_symbols);
        y_rx(u) = r_diff_sum/(2*N_OFDM_symbols);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_e_og = params.J ./ (GP - (1:GP) + 1);
    sigma_e_og = mean_e_og.^2 / N_OFDM_symbols;

    e_logpdf = -0.5 * (abs(e_rx - mean_e_og).^2 ./ sigma_e_og) - log(sqrt(2 * pi * sigma_e_og));

    e_sum_pdf = cumsum(e_logpdf, 'reverse');
    e_sum_pdf = e_sum_pdf .* (1 ./ (GP + 1 - (1:GP)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [~, L_sol_erx] = max(e_sum_pdf);

end
