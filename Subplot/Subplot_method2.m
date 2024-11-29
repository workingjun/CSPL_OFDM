function []=Subplot_method2(params)  
    fig = figure(101);
    fig.Position = [200, 100, 1000, 600];
    sgtitle(['SNR: ' num2str(params.SNR_dB_fixed) 'dB']);


    subplot(2, 3, 1);
    stem(1:16, params.p_rx_sum_pdf); 
    xlim([0 17]);
    title(['channel part(Joint) / $\hat{L}$: ' num2str(params.confirm_sol)], 'Interpreter', 'latex');
   
    subplot(2, 3, 2);
    stem(1:16, params.e_rx_sum_pdf);
    xlim([0 17]);
    title('noise part(Joint) of method2 upgrade');

    subplot(2, 3, 3);         
    stem(1:16, params.SIM_upgrade);
    xlim([0 17]);
    title(['Joint of method2 upgrade / $\hat{L}$: '  num2str(params.upgrade_sol)], 'Interpreter', 'latex');
    
    subplot(2, 3, 4); 
    stem(1:16, params.p_rx_logpdf);
    xlim([0 17]);

    subplot(2, 3, 5); 
    stem(1:15, params.SIM);
    xlim([0 16]);
    title(['Joint of method2 / $\hat{L}$: '  num2str(params.new_sol)], 'Interpreter', 'latex');

    pause;
end