function []=Subplot_method2_upgrade(params)  
    fig = figure(101);
    fig.Position = [200, 100, 1000, 600];
    sgtitle(['SNR: ' num2str(params.SNR_dB_fixed) 'dB']);


    subplot(2, 3, 1);
    stem(1:16, params.p_rx_sum_pdf); 
    grid on;
    xlim([0 17]);
    title(['channel part(Joint pdf) / $\hat{L}$: ' num2str(params.confirm_sol)], 'Interpreter', 'latex');
   
    subplot(2, 3, 2);
    stem(1:16, params.e_rx_sum_pdf);
    grid on;
    xlim([0 17]);
    title(['noise part(Joint) / $\hat{L}$: ' num2str(params.confirm2_sol)], 'Interpreter', 'latex');

    subplot(2, 3, 3);         
    stem(1:16, params.SIM_upgrade);
    grid on;
    xlim([0 17]);
    title(['Joint of method2 upgrade / $\hat{L}$: '  num2str(params.upgrade_sol)], 'Interpreter', 'latex');
    
    subplot(2, 3, 4); 
    stem(1:16, params.p_rx_logpdf);
    grid on;
    xlim([0 17]);
    title('channel part(log pdf)', 'Interpreter', 'latex');

    subplot(2, 3, 5); 
    stem(1:16, params.e_rx_logpdf);
    grid on;
    xlim([0 17]);
    title('noise part(log pdf)', 'Interpreter', 'latex');

    subplot(2, 3, 6); 
    stem(1:15, params.SIM);
    grid on;
    xlim([0 16]);
    title(['Joint of method2 / $\hat{L}$: '  num2str(params.new_sol)], 'Interpreter', 'latex');
    
    pause;
end