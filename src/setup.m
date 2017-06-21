%  This subroutine "setup.m" allows the user to setup
%  the earthquake datafile, overlaying faults, mainshocks

report_this_filefun(mfilename('fullpath'));

% make the interface
%

if exist('par1') == 0
    par1 = 14
end

% This is the info window text
%
ttlStr='ZMAP Data Import                               ';
hlpStr1= ...
    ['                                                '
    'For fast and easy data access ZMAP uses the     '
    'internal matlab data format (*.mat) data files).'
    'Earthquakes catalogs as well as additional      '
    'information must first be loaded as and ASCII   '
    'file. Once this data is saved as a matlab *.mat '
    'file it can be reloaded directly into ZMAP.     '
    '                                                '
    'Several Data types can be integrated:           '
    ' EARTHQUAKE CATALOGS: You will need to supply   '
    ' formated ASCII file (e.g hypoellispe format) or'
    ' an ASCII files with the following information  '
    ' in columns sperated by at least one blanck:    '
    '                                                '
    '  lon lat year month day mag depth hour min     '
    '                                                '
    'Example: (California)                           '
    '-116.86 34.35 86 03 27 4.2 15.0 10 25           '
    'Please note the minus sign for W longitudes!    '
    'You chose the magnitude that you would like to  '
    'work with. Zmap works with decimales (0-100) in '
    'the minute position, not with degrees (0-60)!   '];
hlpStr2= ...
    ['COASTLINE DATA: ZMAP will plot coastlines and/or'
    'state borders on maps. You need to supply an    '
    'ascii datafile with columns seperated by at     '
    'least one blanck:                               '
    'lon  lat  (e.g. -116.86  34.34)                 '
    'A "lift pen" command can be initiade by the line'
    'Inf  Inf (Therefore you avoid connecting islands'
    ' etc.)                                          '
    '                                                '
    'FAULTS DATA: Faults data is imported in the same'
    'way as coastlines.                              '
    'SYMBOLS: Two type of symbols can be displayed on'
    'the seismicity maps: (1) Epicenters of large    '
    'earthquakes as + signs and (2) main faults as   '
    'thick lines. The input format is identical to   '
    'the above - note that you can seperate multiple '
    'main faults by "Inf Inf".                       ' ];
hlpStr3= ...
    ['The Clear button will remove existing data      '
    'or overlay symbols.                             '
    '                                                ' ];
% Find out of figure already exists
%
sa = 'of';
[existFlag,figNumber]=figure_exists('Import Data into ZMAP',1);
newMapWindowFlag=~existFlag;


% Set up the setup window Enviroment
%
if newMapWindowFlag
    loda = figure_w_normalized_uicontrolunits( ...
        'Name','Import Data into ZMAP',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','new', ...
        'Visible','off', ...
        'Position',[ fipo(3)-500 fipo(4)-400 winx-100 winy-100]);

    if term  > 1;   whitebg([c1 c2 c3]); end
    if term  == 1;   whitebg([1 1 1 ]); end


    te = text(0.1,0.99,'Load all the available data as ASCII files.\newlinePress <Save> to save the new catalog \newlineafter you have loaded all ASCII files!');
    set(te,'FontSize',fontsz.m);

    te1 = text(0.40,0.80,'Data ') ;
    set(te1,'FontSize',fontsz.m,'Color','r','FontWeight','bold')

    te2 = text(0.25,0.58,'Overlay Symbols') ;
    set(te2,'FontSize',fontsz.m,'Color','r','FontWeight','bold');

    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.01 .65 .30 .08 ],...
        'Units','normalized',...
        'Callback','in = ''noini'';in2 = 1;dataimpo',...
        'String','EQ Datafile');

    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.35 .65 .35 .08 ],...
        'Units','normalized',...
        'Callback','da = ''fo'';loadasci',...
        'String','EQ Datafile (+focal)');

    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.80 .65 .15 .08 ],...
        'Units','normalized',...
        'Callback','a = []; mainmap_overview();',...
        'String','Clear ');


    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.25 .45 .45 .08 ],...
        'Units','normalized',...
        'Callback','da=''ma'';loadasci',...
        'String','Mainshocks ');
    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.75 .45 .15 .08 ],...
        'Units','normalized',...
        'Callback','main  = []; mainmap_overview();',...
        'String','Clear ');


    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.25 .35 .45 .08 ],...
        'Units','normalized',...
        'Callback','da=''fa'';loadasci',...
        'String','Faults ');
    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.75 .35 .15 .08 ],...
        'Units','normalized',...
        'Callback','faults  = []; mainmap_overview();',...
        'String','Clear ');


    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.25 .25 .45 .08 ],...
        'Units','normalized',...
        'Callback','da=''mf'';loadasci',...
        'String','Mainrupture');
    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.75 .25 .15 .08 ],...
        'Units','normalized',...
        'Callback','mainfault  = []; mainmap_overview();',...
        'String','Clear ');


    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.25 .15 .45 .08 ],...
        'Units','normalized',...
        'Callback','da=''co'';loadasci',...
        'String','Coastline/Borders');
    uicontrol('BackGroundColor',[0.8 0.8 0.8]','Style','Pushbutton',...
        'Position',[.75 .15 .15 .08 ],...
        'Units','normalized',...
        'Callback','coastline  = []; mainmap_overview();',...
        'String','Clear ');


    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.75 .03 .15 .08 ],...
        'Units','normalized','Callback','close;welcome','String','cancel');

    save_button=uicontrol('Style','Pushbutton',...
        'Position',[.05 .03 .25 .08 ],...
        'Units','normalized',...
        'Callback','eval(calSave4);',...
        'String','Save as *.mat');

    infstri = 'Please enter information about |  the current dataset here:';

    calSave4 =...
        [ '  zmap_message_center.set_info(''Save Data'',''  '');think;',...
        '[file1,path1] = uiputfile(fullfile(hodi, ''eq_data'', ''*.mat''), ''Filename?'');',...
        ' sapa = [''save '' path1 file1 '' a faults mainfault coastline main infstri''];',...
        'eval(sapa) ; close(loda);mainmap_overview();done'];


    Info_button=uicontrol('Style','Pushbutton',...
        'Position',[.45 .03 .15 .08 ],...
        'Units','normalized',...
        'Callback','zmaphelp(ttlStr,hlpStr1,hlpStr2,hlpStr3)',...
        'String','Info');

    watchoff

end   %if figure exist
figure_w_normalized_uicontrolunits(loda)
set(gca,'box','off',...
    'SortMethod','childorder','TickDir','out','FontWeight','bold',...
    'visible','off','FontSize',fontsz.m,'Linewidth',1.2)

set(loda,'Visible','on');
