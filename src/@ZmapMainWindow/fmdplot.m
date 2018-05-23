function fmdplot(obj, tabgrouptag)
    
    myTab = findOrCreateTab(obj.fig, tabgrouptag, 'FMD');
    
    delete(myTab.Children);
    ax=axes(myTab);
    ylabel(ax,'Cum # events');
    xlabel(ax,'Magnitude');
    
    if isempty(obj.catalog)
        return
    end
    
    %mainax=obj.map_axes;
    bdiff2(obj.catalog,false,ax);
    legend(ax,'show')
    if isempty(ax.UIContextMenu)
        c = uicontextmenu(obj.fig);
        ax.UIContextMenu = c;
    end
    addLegendToggleContextMenuItem(ax.UIContextMenu,'bottom','above');
end
