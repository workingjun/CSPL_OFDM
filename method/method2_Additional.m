function [e_rx, mean_e_og, e_rx_pdf, e_rx_multi_pdf, y_rx, y_rx_pdf, y_rx_multi_pdf, L_sol_erx] = method2_Additional(params)
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
        e_rx(u) = r_diff_sum/(2*N_OFDM_symbols);%*(GP-u+1));
        y_rx(u) = r_diff_sum/(2*N_OFDM_symbols);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_e_og = params.J; %./ (GP - (1:GP) + 1); 
    sigma_e = mean_e_og.^2 / N_OFDM_symbols;

    e_rx_pdf = (2 * pi * sigma_e).^(-0.5) .* exp(-0.5 .* (abs(e_rx - mean_e_og).^2 ./ sigma_e));

    e_rx_multi_pdf = cumprod(e_rx_pdf, 'reverse');
    e_rx_multi_pdf = e_rx_multi_pdf .^ (1 ./ (GP + 1 - (1:GP)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mean_y = params.J(L+1); 
    sigma_y = mean_y.^2 / N_OFDM_symbols;

    y_rx_pdf = (2 * pi * sigma_y).^(-0.5) .* exp(-0.5 .* (abs(y_rx - mean_y).^2 ./ sigma_y));

    y_rx_multi_pdf = cumprod(y_rx_pdf, 'reverse');
    y_rx_multi_pdf = y_rx_multi_pdf .^ (1 ./ (GP + 1 - (1:GP)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [~, L_sol_erx] = max(e_rx_multi_pdf);
    [~, L_sol_yrx] = max(y_rx_multi_pdf);

end
