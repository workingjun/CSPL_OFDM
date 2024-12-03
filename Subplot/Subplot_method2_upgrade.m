function []=Subplot_method2_upgrade(params)  
    fig = figure(101);
    fig.Position = [200, 100, 1000, 600];
    sgtitle(['SNR: ' num2str(params.SNR_dB_fixed) 'dB']);

    
    subplot(2, 3, 1); 
    stem(1:16, params.ABdiffsq);
    grid on;
    xlim([0 17]);
    title('Random Variable / noise part', 'Interpreter', 'latex');
    
    subplot(2, 3, 2); 
    stem(1:16, params.ABdiffsq_ch);
    grid on;
    xlim([0 17]);
    title('Random Variable / channel part', 'Interpreter', 'latex');

    subplot(2, 3, 3); 
    stem(1:15, params.SIM);
    grid on;
    xlim([0 16]);
    title(['Method2 (LLR) / $\hat{L}$: '  num2str(params.new_sol)], 'Interpreter', 'latex');

    subplot(2, 3, 4);
    stem(1:16, params.SIM_channel); 
    grid on;
    xlim([0 17]);
    title(['channel part (LLR) / $\hat{L}$: ' num2str(params.confirm_sol)], 'Interpreter', 'latex');
   
    subplot(2, 3, 5);
    stem(1:16, params.SIM_noise);
    grid on;
    xlim([0 17]);
    title(['noise part (LLR) / $\hat{L}$: ' num2str(params.confirm2_sol)], 'Interpreter', 'latex');
    ylim([0 20]);

    subplot(2, 3, 6);         
    stem(1:16, params.SIM_upgrade);
    grid on;
    xlim([0 17]);
    title(['Method2 upgrade (LLR) / $\hat{L}$: '  num2str(params.upgrade_sol)], 'Interpreter', 'latex');

    
    fig = figure(102);
    fig.Position = [200, 0, 1280, 800];
    % set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
       
    subplot(4, 8, 1); 
    stem(1:16, [params.SIM_channel(1:1), zeros(1, 16-1)]);
    grid on;
    xlim([0 17]);
    ylim([0 5]);
    title(['channel / u=' num2str(1)], 'Interpreter', 'latex');

    subplot(4, 8, 2); 
    stem(1:16, params.SIM_noise(1:16));
    grid on;
    xlim([0 17]);
    ylim([-10 10]);
    title(['noise / u=' num2str(1)], 'Interpreter', 'latex');

    for u=2:params.GP
        subplot(4, 8, 2*u-1); 
        stem(1:16, [params.SIM_channel(1:u-1), zeros(1, 16-u+1)]);
        grid on;
        xlim([0 17]);
        ylim([0 5]);
        title(['channel / u=' num2str(u)], 'Interpreter', 'latex');

        subplot(4, 8, 2*u); 
        stem(1:16, [zeros(1, u-1), params.SIM_noise(u:16)]);
        grid on;
        xlim([0 17]);
        ylim([-10 10]);
        title(['noise / u=' num2str(u)], 'Interpreter', 'latex');
    end
    tightfig();

    pause;
end