function s = Plots(useLog, symbol1, symbol2, data1, data2, data3)
%Plots the data in as scatter
    data1 = data1(350:end);
    data2 = data2(350:end);
    data3 = data3(350:end);
    
    %nexttile
    
    plot(data1, data2,'Color', '[1 1 1 0.1]')
    hold on;
    
    switch nargin
        case 5
            s = scatter(data1, data2, 28,'filled');
        case 6
            s = scatter(data1, data2, 28, data3, 'filled');
    end
    
    color = '0.083, 0.083, 0.083';
    set(0, 'defaultfigurecolor', color)
    set(gca, 'Color', color)
    grid on;
    if(symbol2 ~= -1)
        ylabel(append(symbol1, '/', symbol2))
    else
        ylabel(symbol1)
    end
    
    xlabel('Time')
    ax = gca;
    ax.XColor = 'w';
    ax.YColor = 'w'; 
    colormap(jet(256))
    c = colorbar();
    c.Color = 'w';
    ax.GridAlpha = 0.05; 
    
    if(useLog == 1)
        yt = get(gca,'ytick');
        for j=2:2:length(yt)
            YTL{1,j} = num2str(round(yt(j)),'10^%d');
        end
        yticklabels(YTL);
    end
    
    %figure;
    nexttile
    
    plot(data1, data3);
    color = '0.083, 0.083, 0.083';
    set(0,'defaultfigurecolor', color)
    set(gca,'Color', color)
    grid on;
    if(symbol2 ~= -1)
        ylabel(append(symbol1, '/', symbol2))
    else
        ylabel("Risk")
    end
    
    xlabel('Time')
    ax = gca;
    ax.XColor = 'w';
    ax.YColor = 'w'; 
    ax.GridAlpha = 0.05;
    ax.YAxisLocation = 'right';
end