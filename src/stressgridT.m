% This subroutine assigns creates a grid with
% spacing dx,dy (in degreees). The size will
% be selected interactiVELY. The bvalue in each
% volume around a grid point containing ni earthquakes
% will be calculated as well as the magnitude
% of completness
%   Stefan Wiemer 1/95

report_this_filefun(mfilename('fullpath'));

global no1 bo1 inb1 inb2

if sel == 'in'
    % get the grid parameter
    % initial values
    %
    dx = 1.00;
    dy = 1.00 ;
    ni = 100;
    Nmin = 50;
    stan2 = NaN;
    stan = NaN;
    prf = NaN;
    av = NaN;

    % make the interface
    %
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','new', ...
        'units','points',...
        'Visible','off', ...
        'Position',[ wex+200 wey-200 850 250]);
    axis off
    labelList2=[' Automatic Mcomp (max curvature) | Fixed Mc (Mc = Mmin) | Automatic Mcomp (90% probability) | Automatic Mcomp (95% probability) | Best (?) combination (Mc95 - Mc90 - max curvature)'];
    labelPos = [0.2 0.8  0.6  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList2,...
        'Callback','inb2 =get(hndl2,''Value''); ');

    set(hndl2,'value',5);


    % creates a dialog box to input grid parameters
    %

    oldfig_button = uicontrol('BackGroundColor',[.60 .92 .84], ...
        'Style','checkbox','string','Plot in Current Figure',...
        'Position',[.78 .52 .20 .08],...
        'Units','normalized');

    set(oldfig_button,'value',1);


    freq_field=uicontrol('Style','edit',...
        'Position',[.30 .60 .12 .08],...
        'Units','normalized','String',num2str(ni),...
        'Callback','ni=str2double(get(freq_field,''String'')); set(freq_field,''String'',num2str(ni));set(tgl2,''value'',0); set(tgl1,''value'',1)');


    freq_field0=uicontrol('Style','edit',...
        'Position',[.30 .50 .12 .08],...
        'Units','normalized','String',num2str(ra),...
        'Callback','ra=str2double(get(freq_field0,''String'')); set(freq_field0,''String'',num2str(ra)) ; set(tgl2,''value'',1); set(tgl1,''value'',0)');

    freq_field2=uicontrol('Style','edit',...
        'Position',[.30 .40 .12 .08],...
        'Units','normalized','String',num2str(dx),...
        'Callback','dx=str2double(get(freq_field2,''String'')); set(freq_field2,''String'',num2str(dx));');

    freq_field3=uicontrol('Style','edit',...
        'Position',[.30 .30 .12 .080],...
        'Units','normalized','String',num2str(dy),...
        'Callback','dy=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(dy));');

    tgl1 = uicontrol('Style','radiobutton',...
        'string','Number of Events:',...
        'Position',[.05 .60 .2 .0800], 'Callback','set(tgl2,''value'',0)',...
        'Units','normalized');

    set(tgl1,'value',1);

    tgl2 =  uicontrol('Style','radiobutton',...
        'string','OR: Constant Radius',...
        'Position',[.05 .50 .2 .080], 'Callback','set(tgl1,''value'',0)',...
        'Units','normalized');

    create_grid =  uicontrol('Style','radiobutton',...
        'string','Calculate a new grid', 'Callback','set(load_grid,''value'',0), set(prev_grid,''value'',0)','Position',[.55 .55 .2 .080],...
        'Units','normalized');

    set(create_grid,'value',1);

    prev_grid =  uicontrol('Style','radiobutton',...
        'string','Reuse the previous grid', 'Callback','set(load_grid,''value'',0),set(create_grid,''value'',0)','Position',[.55 .45 .2 .080],...
        'Units','normalized');


    load_grid =  uicontrol('Style','radiobutton',...
        'string','Load a previously saved grid', 'Callback','set(prev_grid,''value'',0),set(create_grid,''value'',0)','Position',[.55 .35 .2 .080],...
        'Units','normalized');

    save_grid =  uicontrol('Style','checkbox',...
        'string','Save selected grid to file',...
        'Position',[.55 .22 .2 .080],...
        'Units','normalized');

    freq_field4 = uicontrol('Style','edit',...
        'Position',[.30 .20 .12 .080],...
        'Units','normalized','String',num2str(Nmin),...
        'Callback','Nmin=str2double(get(freq_field4,''String'')); set(freq_field4,''String'',num2str(Nmin));');


    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .15 .12 ],...
        'Units','normalized','Callback','close;done','String','Cancel');

    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'Callback',' inb1 =get(hndl2,''Value'');tgl1 =get(tgl1,''Value'');tgl2 =get(tgl2,''Value'');prev_grid = get(prev_grid,''Value'');create_grid = get(create_grid,''Value''); load_grid = get(load_grid,''Value''); save_grid = get(save_grid,''Value''); oldfig_button = get(oldfig_button,''Value''); close,sel =''ca'', stressgridT',...
        'String','Go');

    txt3 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.30 0.75 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.l ,...
        'FontWeight','bold',...
        'String',' Grid Parameter');
    txt5 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.1 0.4 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in x (dx) in deg:');

    txt6 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.1 0.3 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in y (dy) in deg:');

    txt7 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.1 0.18 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Min. No. of events > Mc:');




    set(gcf,'visible','on');
    watchoff

end   % if nargin ==0

% get the grid-size interactively and
% calculate the b-value in the grid by sorting
% thge seimicity and selectiong the ni neighbors
% to each grid point

if sel == 'ca'
    % get new grid if needed
    if load_grid == 1
        [file1,path1] = uigetfile(['*.mat'],'previously saved grid');
        if length(path1) > 1
            think
            load([path1 file1])
            plot(newgri(:,1),newgri(:,2),'k+')
        end
    elseif load_grid ==0  &&  prev_grid == 0
        selgp
        if length(gx) < 4  ||  length(gy) < 4
            errordlg('Selection too small! (Dx and Dy are in degreees! ');
            return
        end
    end

    if save_grid == 1
        grid_save =...
            [ 'zmap_message_center.set_info(''Saving Grid'',''  '');think;',...
            '[file1,path1] = uiputfile([my_dir fs ''eq_data'' fs ''*.mat''], ''Grid File Name?'') ;',...
            ' gs = [''save '' path1 file1 '' newgri dx dy gx gy xvect yvect tmpgri ll''];',...
            ' if length(file1) > 1, eval(gs),end , done']; eval(grid_save)
    end


    itotal = length(newgri(:,1));

    zmap_message_center.set_info(' ','Running... ');think
    %  make grid, calculate start- endtime etc.  ...
    %
    t0b = a(1,3)  ;
    n = a.Count;
    teb = a(n,3) ;
    tdiff = round((teb - t0b)*365/par1);
    loc = zeros(3,length(gx)*length(gy));

    % loop over  all points
    %
    i2 = 0.;
    i1 = 0.;
    bvg = [];
    allcount = 0.;
    wai = waitbar(0,' Please Wait ...  ');
    set(wai,'NumberTitle','off','Name','stress map grid - percent done');;
    drawnow
    %
    % overall b-value
    [bv magco stan av me mer me2,  pr] =  bvalca3(a,inb1,inb2);
    bo1 = bv; no1 = a.Count;
    cd /home/stefan/STRESS

    dnan = [NaN NaN NaN NaN NaN NaN NaN
        NaN NaN NaN NaN NaN NaN NaN];


    % loop over all points
    for i= 1:length(newgri(:,1))
        x = newgri(i,1);y = newgri(i,2);
        allcount = allcount + 1.;
        i2 = i2+1;

        % calculate distance from center point and sort wrt distance
        l = sqrt(((a.Longitude-x)*cos(pi/180*y)*111).^2 + ((a.Latitude-y)*111).^2) ;
        [s,is] = sort(l);
        b = a(is(:,1),:) ;       % re-orders matrix to agree row-wise

        if tgl1 == 0   % take point within r
            l3 = l <= ra;
            b = a.subset(l3);      % new data per grid point (b) is sorted in distanc
            rd = ra;
        else
            % take first ni points
            b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
            l2 = sort(l); rd = l2(ni);

        end


        %estimate the completeness and b-value
        newt2 = b;
        if length(b) >= Nmin  % enough events?


            l = b(:,3) < td;
            if length(b(l,3)) > Nmin;

                tmpi = [newt2(l,10:12)];
                fid = fopen('data2','w');
                str = ['Inversion data'];str = str
                fprintf(fid,'%s  \n',str');
                fprintf(fid,'%7.3f  %7.3f  %7.3f\n',tmpi');
                fclose(fid);
                unix('rm data2.slboot');
                unix(' ./slfast data2 ');
                load data2.slboot
                d0 = data2;
                l0 = length(tmpi(:,1));
            else
                d0 = dnan
            end


            l = b(:,3) >= td;
            if length(b(l,3)) > Nmin;

                tmpi = [newt2(l,10:12)];
                fid = fopen('data2','w');
                str = ['Inversion data'];str = str
                fprintf(fid,'%s  \n',str');
                fprintf(fid,'%7.3f  %7.3f  %7.3f\n',tmpi');
                fclose(fid);
                unix('rm data2.slboot  ');
                unix(' ./slfast data2 ');
                load data2.slboot
                d1 = data2;
                l1 = length(tmpi(:,1));

            else
                d1 = dnan;
            end



            bvg = [bvg ; d0(2,2:7) d0(1,1) d1(2,2:7) d1(1,1) l0 l1 ];
        end % if Nmin

        waitbar(allcount/itotal)
    end  % for newgr
    %save cnssgrid.mat
    %quit
    % save data
    %
    catSave3 =...
        [ 'zmap_message_center.set_info(''Save Grid'',''  '');think;',...
        '[file1,path1] = uiputfile(fullfile(hodi, ''eq_data'', ''*.mat''), ''Grid Datafile Name?'') ;',...
        ' sapa2 = [''save '' path1 file1 '' bvg gx gy dx dy par1 tdiff t0b teb a main faults mainfault coastline yvect xvect tmpgri ll Prmap''];',...
        ' if length(file1) > 1, eval(sapa2),end , done']; eval(catSave3)

    close(wai)
    watchoff


    view_stressmap



end

