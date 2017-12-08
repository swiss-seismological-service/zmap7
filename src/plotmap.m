function plotmap() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    % plot a lambert map,  based on current axes
    ax=gca;
    figure
    lonlims=get(ax,'XLim'); lonrange=lonlims(2)-lonlims(1);
    latlims=get(ax,'YLim'); latrange=latlims(2)-latlims(1);
    ax2=axesm('MapProjection','lambert','MapLatLimit',latlims,'MapLonLimit',lonlims);
    framem
    
    if lonrange < 5
        lonbasis=.5; % example.
    elseif lonrange < 30
        lonbasis=ceil(lonrange/10);
    else
        lonbasis=10;
    end
     if latrange < 5
        latbasis=.5; % example.
    elseif latrange < 30
        latbasis=ceil(latrange/10);
    else
        latbasis=10;
    end
    
    setm(ax2,'MLineLocation',lonbasis/2, 'PLineLocation',latbasis/2); % degrees for grid lines
    setm(ax2,'Grid','on')
    setm(ax2,'MeridianLabel','on','ParallelLabel','on');
    setm(ax2,'PLabelLocation',lonbasis,'MLabelLocation',latbasis);  % degrees for labeling
    setm(ax2,'LabelFormat','signed','LabelUnits','degrees'); % 'dm','dms'
    setm(ax2,'MLabelRound',-1,'PLabelRound',-1);
    ZG=ZmapGlobal.Data;
    copyobj(ZG.features('coastline'),ax2);
    copyobj(ZG.features('borders'),ax2);
    copyobj(ZG.features('faults'),ax2);
    copyobj(ZG.features('lakes'),ax2);
    %copyobj(ZG.features('rivers'),ax2);
    
    
    % add earthquakes from main map
    qs=findobj(mainmap('axes'),'-regexp','Tag','mapax_part.+');
    %symbs=['+o*v^><s'];
    for n=1:numel(qs)
        h=plotm(qs(n).YData,qs(n).XData,'.','Color',qs(n).Color .* [.6],...
            'DisplayName',qs(n).DisplayName,...
            'ZData',qs(n).ZData);
        set(h,'MarkerSize',get(h,'MarkerSize')/1.5);
    end
    set(gca,'ZDir','reverse');
    srf=findobj(ax,'Type','Surface');
    cm=colormap(ax);
    pcolorm(srf.YData,srf.XData,srf.ZData,'CData',srf.CData)
    colormap(cm);
    colorbar;
    title(ax.Title.String);
    
end
    


    function no_longer_valid()
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    figurefigure
    
    
    l  = get(h1,'XLim');
    s1 = l(2); s2 = l(1);
    l  = get(h1,'YLim');
    s3 = l(2); s4 = l(1);
    
    cl =  get(h1,'Clim');
    
    m_proj('lambert','long',[s2 s1],'lat',[s4 s3]);
    
    cstep = abs(cl(2) - cl(1))/50;
    [m,c] = m_contourf(gx,gy,re4,(cl(1):cstep:cl(2)));
    set(c,'LineStyle','none');
    
    hold on
    
    if ~isempty(coastline)
        lico = m_line(coastline(:,1),coastline(:,2),'color','k');
    end
    
    if ~isempty(faults)
        lifa = m_line(faults(:,1),faults(:,2),'color','k');
    end
    
    
    m_grid('box','on','linestyle','none','tickdir','out','color','k','LineWidth',1.5,...
        'fontsize',10,'fontname','Helveticabold');
    hold on
    shading flat
    caxis([cl(1) cl(2)]);
    
    
    
    hold on
    
    set(gcf,'Color','w')
    
    vx =  (cl(1):cstep:cl(2));
    v = [vx ; vx]; v = v';
    rect = [0.93 0.4 0.015 0.25];
    axes('position',rect)
    pcolor((1:2),vx,v)
    shading flat
    set(gca,'XTickLabels',[])
    set(gca,'FontSize',10,'FontWeight','normal',...
        'LineWidth',1.0,'YAxisLocation','right',...
        'Box','on','SortMethod','childorder','TickDir','out')
end
