function [tt1,tt2]=timesel(var1)
    % timesel.m                       Alexander Allmann
    % function to select time intervalls for further examination
    % Last change                  8/95
    
    % works on newt2
    
    global newt2 ccum tiplo2 ho statime cum fontsz
    
    report_this_filefun(mfilename('fullpath'));
    
    %timeselection with mouse in cumulative number plot
    if var1==1 || var1==4
        messtext=...
            ['To select a time window for further examination'
            'Please select the start- and endtime of the    '
            'sequence with the LEFT mouse button            '];
        zmap_message_center.set_message('Time Selection ',messtext);
        if var1==1
            figure(ccum)
        else
            figure(cum)
        end
        ax = gca;
        hold on
        seti = uicontrol('Style','text','Units','normal',...
            'Position',[.4 .01 .2 .05],...
            'String','Select Time 1 ','FontSize',fontsz.m,'FontWeight','bold', 'ForegroundColor',[.2 0 .8]);
        % XLim=get(tiplot2,'Xdata');
        
        [M1b, ~, ~] = ginput_datetime(ax,1);
        tt1 = M1b;
        plot(tt1,0,'o');
        seti.String = 'Select Time 2';
        %pause(1)
        M2b = [];
        set(gcf,'Pointer','cross')
        [M2b, ~, ~] = ginput_datetime(ax,1);
        plot(M2b,0,'o')
        tt2= M2b;
        delete(seti)
        if tt1>tt2     % if start and end time are switched
            tt3=tt2;
            tt2=tt1;
            tt1=tt3;
        end
        % build new catalog newt2
        if ~isempty(statime)
            error('statime comes from where?');
            ll=newt2.Date>tt1 & newt2.Date<statime+tt2/365;
            tt1=statime+tt1/365;
            tt2=statime+tt2/365;
        else
            ll=newt2.Date>tt1 & newt2.Date<tt2;
        end
        newt2=newt2.subset(ll);
        ho ='noho';
    end
end