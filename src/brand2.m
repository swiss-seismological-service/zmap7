function brand2(catalog) % autogenerated function wrapper
    %  brand2  calculates synthetic b distributions based on
    %  a random permutation of original magnitude values,
    %  it then compares it to original b map using bvalmapt
    %                                                 Ram�n Z��iga 9/2000
    %                          Operates on a
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    % first create a new catalog with original data changing the year values
    
    lengtha = catalog.Count;
    conca = copy(catalog);
    conca.Date = conca.Date + 500;  % add 500 to years to make it a consecutive sequence
    
    % now change magnitudes by a random permutation
    conca.Magnitude = conca.Magnitude(randperm(lengtha));  % permuted magnitudes

    catalog = catalog.cat(conca);
    
    minnu = 40;  % minimum number of events in each period
    t4 = catalog.Date(end)
    t3 = catalog.Date(lengtha+1);
    t2 = catalog.Date(lengtha);
    t1 = catalog.Date(1);
    cb_go(~,~);
   %{
    
    zdlg = ZmapDialog();
    zdlg.AddBasicHeader('Automatically estimate magn. of completeness?');
    zdlg.AddBasicCheckbox('hndl2','Weighted LS - automatic Mcomp',true,[],'weighted least squares');
    zdlg.AddBasicCheckbox('hndl1','Max likelihood - automatic Mcomp',true,[],'maximum likelihood');
    zdlg.AddGridParameters()
    zdlg.AddEventSelectionParameters();
   
    [res,okPressed]=zdlg.Create('Inputs');
    %}
    
    %stri = [  ' Synthetic b map comparison for ' name  ];
    % make the interface
    %
    %{
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off',...
        'NextPlot','new', ...
        'units','points',...
        'Visible','off', ...
        'Position',[ ZG.wex+200 ZG.wey-200 450 250]);
    axis off
    labelList2={'Weighted LS - automatic Mcomp','Weighted LS - no automatic Mcomp'};
    labelPos = [0.2 0.7  0.6  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList2,...
        'callback',@callbackfun_001);
    
    
    
    labelList={'Maximum likelihood - automatic Mcomp','Maximum likelihood  - no automatic Mcomp'};
    labelPos = [0.2 0.8  0.6  0.08];
    hndl1=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList,...
        'callback',@callbackfun_002);
    
    
    % creates a dialog box to input grid parameters
    %
    freq_field=uicontrol('Style','edit',...
        'Position',[.60 .50 .22 .10],...
        'Units','normalized','String','5',...num2str(ra),...
        'callback',@callbackfun_003);
    
    freq_field2=uicontrol('Style','edit',...
        'Position',[.60 .40 .22 .10],...
        'Units','normalized','String','0.1',...num2str(dx),...
        'callback',@callbackfun_004);
    
    freq_field3=uicontrol('Style','edit',...
        'Position',[.60 .30 .22 .10],...
        'Units','normalized','String','0.2',...num2str(dy),...
        'callback',@callbackfun_005);
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .15 .12 ],...
        'Units','normalized','callback',@callbackfun_006,'String','Cancel');
    
    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'callback',@callbackfun_007,...
        'String','Go');
    
    text(...
        'Position',[0.20 1.0 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.l ,...
        'FontWeight','bold',...
        'String','Automatically estimate magn. of completeness?   ');
    txt3 = text(...
        'Position',[0.30 0.64 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.l ,...
        'FontWeight','bold',...
        'String',' Grid Parameter');
    txt5 = text(...
        'Position',[0. 0.42 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in x (dx) in deg:');
    
    txt6 = text(...
        'Position',[0. 0.32 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in y (dy) in deg:');
    
    txt1 = text(...
        'Position',[0. 0.53 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m,...
        'FontWeight','bold',...
        'String','Constant Radius in km:');
    set(gcf,'visible','on');
    watchoff
    %}
    
    function callbackfun_001(mysrc,myevt)
        

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb2=hndl2.Value;
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb1=hndl1.Value;
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ra=str2double(freq_field.String);
        freq_field.String=num2str(ra);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dx=str2double(freq_field2.String);
        freq_field2.String=num2str(dx);
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dy=str2double(freq_field3.String);
        freq_field3.String=num2str(dy);
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        
    end
    
    function cb_go(~,~)
        ZG.inb1=hndl1.Value;
        ZG.inb2=hndl2.Value;
        close;
        ZG.newt2 = catalog;
        warningdlg('this needs updating...');
        bvalmapt(ZmapAnalysisPkg('newt2'));
    end
    
end
