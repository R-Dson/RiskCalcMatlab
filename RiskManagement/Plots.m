function s = Plots(useLog, Bollinger, movingAverage, PlotSettings, RiskPlot, symbol1, symbol2, data1, data2, data3)
%Plots the data in as scatter
%     data1 = data1(350:end);
%     data2 = data2(350:end);
%     data3 = data3(350:end);
    
    %nexttile
    
    thickness = PlotSettings.Thickness;
    intensity = [1 1 1 PlotSettings.LineIntensity];
    plot(data1, real(data2),'Color', intensity)
    hold on;
    
    if Bollinger ~= -1
        plot(data1, Bollinger);
    end
    if movingAverage.ma20WeeksInDays ~= -1
        minVal = min(length(data1), length(movingAverage.ma20WeeksInDays));
        data1 = data1((length(data1) - minVal)+1:length(data1));
        movingAverage.ma20WeeksInDays = movingAverage.ma20WeeksInDays((length(movingAverage.ma20WeeksInDays) - minVal)+1:length(movingAverage.ma20WeeksInDays));
        plot(data1, movingAverage.ma20WeeksInDays);
    end
    if movingAverage.ma50Day ~= -1
        minVal = min(length(data1), length(movingAverage.ma50Day));
        data1 = data1((length(data1) - minVal)+1:length(data1));
        movingAverage.ma50Day = movingAverage.ma50Day((length(movingAverage.ma50Day) - minVal)+1:length(movingAverage.ma50Day));
        plot(data1, movingAverage.ma50Day);
    end
    if movingAverage.ma350Day ~= -1
        minVal = min(length(data1), length(movingAverage.ma350Day));
        data1 = data1((length(data1) - minVal)+1:length(data1));
        movingAverage.ma350Day = movingAverage.ma350Day((length(movingAverage.ma350Day) - minVal)+1:length(movingAverage.ma350Day));
        plot(data1, movingAverage.ma350Day);
    end
    if movingAverage.ma1400Day ~= -1
        minVal = min(length(data1), length(movingAverage.ma1400Day));
        data1 = data1((length(data1) - minVal)+1:length(data1));
        movingAverage.ma1400Day = movingAverage.ma1400Day((length(movingAverage.ma1400Day) - minVal)+1:length(movingAverage.ma1400Day));
        plot(data1, movingAverage.ma1400Day);
    end
    
    if thickness ~= 0
        switch nargin
            case 9
                s = scatter(data1, data2, thickness,'filled');
            case 10
                s = scatter(data1, data2, thickness, data3, 'filled');
        end
    end
    
    color = '0.083, 0.083, 0.083';
    set(0, 'defaultfigurecolor', color)
    set(gca, 'Color', color)
    set(gcf, 'Color', color)
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
    if RiskPlot == 1
        nexttile
    
        plot(data1, data3);
        a = area(data1, data3);
        a(1).FaceColor = [162, 162, 162]./ 256;
        a(1).EdgeColor = [169, 205, 255] ./ 256;
        a.FaceAlpha = 0.25;

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
end