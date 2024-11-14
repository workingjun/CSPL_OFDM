function []=Subplot_performance(params)
    fig = figure(1);
    fig.Position = [0, 0, 700, 600];

    subplot(2, 2, 1);
    plot(params.SNR_dB,params.M1_1,'b+-');
    hold on;
    plot(params.SNR_dB,params.M2_1,'R+-');
    plot(params.SNR_dB,params.M3_1,'k+-');
    % plot(params.SNR_dB, params.M4_1,'c+-');
    % plot(params.SNR_dB, params.M5_1,'yo-');
    grid on;
    xlabel('SNR (dB)', 'Fontsize', 12);
    ylabel('CD', 'Fontsize', 12);
    legend('Method2', 'new Method2', 'Joint f_{Pe}', 'Location','southeast');
    
    subplot(2, 2, 2);
    plot(params.SNR_dB,params.M1_2,'b+-');
    hold on;
    plot(params.SNR_dB,params.M2_2,'R+-');
    plot(params.SNR_dB,params.M3_2,'k+-');
    % plot(params.SNR_dB, params.M4_2,'c+-');
    % plot(params.SNR_dB,params.M5_2,'yo-');
    grid on;
    xlabel('SNR (dB)', 'Fontsize', 12)
    ylabel('GD', 'Fontsize', 12);
    legend('Method2', 'new Method2', 'Joint f_{Pe}', 'Location','southeast');
    
    subplot(2, 2, 3);
    plot(params.SNR_dB,params.M1_3,'b+-');
    hold on;
    plot(params.SNR_dB,params.M2_3,'R+-');
    plot(params.SNR_dB,params.M3_3,'k+-');
    % plot(params.SNR_dB, params.M4_3,'c+-');
    % plot(params.SNR_dB,params.M5_1,'yo-');
    grid on;
    xlabel('SNR (dB)', 'Fontsize', 12);
    ylabel('BD', 'Fontsize', 12);
    legend('Method2', 'new Method2', 'Joint f_{Pe}', 'Location','southeast');
    
    subplot(2, 2, 4);
    plot(params.SNR_dB,params.M1_4,'b+-');
    hold on;
    plot(params.SNR_dB,params.M2_4,'R+-');
    plot(params.SNR_dB,params.M3_4,'k+-');
    % plot(params.SNR_dB, params.M4_4,'c+-');
    % plot(params.SNR_dB,params.M5_1,'yo-');
    grid on;
    xlabel('SNR (dB)', 'Fontsize', 12);
    ylabel('ED', 'Fontsize', 12);
    legend('Method2', 'new Method2', 'Joint f_{Pe}', 'Location','southeast');
end