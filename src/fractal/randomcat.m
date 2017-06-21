%
% Input window for the random catalogue parameters. Called from
% startfd.m.%
%
%disp('fractal/codes/randomcat.m');
%
%
% Creates the input window
%
figure_w_normalized_uicontrolunits('Units','pixel','pos',[300 100 350 500 ],'Name','Parameters','visible','off',...
    'NumberTitle','off','MenuBar','none','Color',[c1 c2 c3],'NextPlot','new');
axis off;

input1 = uicontrol('Style','edit','Position',[.70 .91 .22 .04],...
    'Units','normalized','String',num2str(numran),...
    'Callback','numran=str2double(get(input1,''String'')); set(input1,''String'',num2str(numran));');

input2 = uicontrol(,'Style','popupmenu','Position',[.57 .80 .40 .06],...
    'Units','normalized','String','Random in a box|Sier. Gasket 2D|Sier. Gasket 3D|Real with normal error',...
    'Value',1,'Callback','distr=(get(input2,''Value'')); set(input2,''Value'',distr); actdistr;');

input3 = uicontrol('Style','edit','Position',[.70 .53 .22 .04],...
    'Units','normalized','String',num2str(long1),'enable','on',...
    'Callback','long1=str2double(get(input3,''String'')); set(input3,''String'',num2str(long1));');

input4 = uicontrol('Style','edit','Position',[.70 .46 .22 .04],...
    'Units','normalized','String',num2str(long2),'enable','on',...
    'Callback','long2=str2double(get(input4,''String'')); set(input4,''String'',num2str(long2));');

input5 = uicontrol('Style','edit','Position',[.70 .39 .22 .04],...
    'Units','normalized','String',num2str(lati1),'enable','on',...
    'Callback','lati1=str2double(get(input5,''String'')); set(input5,''String'',num2str(lati1));');

input6 = uicontrol('Style','edit','Position',[.70 .32 .22 .04],...
    'Units','normalized','String',num2str(lati2),'enable','on',...
    'Callback','lati2=str2double(get(input6,''String'')); set(input6,''String'',num2str(lati2));');

input7 = uicontrol('Style','edit','Position',[.70 .25 .22 .04],...
    'Units','normalized','String',num2str(dept1),'enable','on',...
    'Callback','dept1=str2double(get(input7,''String'')); set(input7,''String'',num2str(dept1));');

input8 = uicontrol('Style','edit','Position',[.70 .18 .22 .04],...
    'Units','normalized','String',num2str(dept2),'enable','on',...
    'Callback','dept2=str2double(get(input8,''String'')); set(input8,''String'',num2str(dept2));');

input9 = uicontrol('Style','edit','Position',[.74 .75 .18 .04],...
    'Units','normalized','String',num2str(stdx),'enable','off',...
    'Callback','stdx=str2double(get(input9,''String'')); set(input9,''String'',num2str(stdx));');

input10 = uicontrol('Style','edit','Position',[.74 .69 .18 .04],...
    'Units','normalized','String',num2str(stdy),'enable','off',...
    'Callback','stdy=str2double(get(input10,''String'')); set(input10,''String'',num2str(stdy));');

input11 = uicontrol('Style','edit','Position',[.74 .63 .18 .04],...
    'Units','normalized','String',num2str(stdz),'enable','off',...
    'Callback','stdz=str2double(get(input11,''String'')); set(input11,''String'',num2str(stdz));');



tx1 = text('EraseMode','normal', 'Position',[0 1.01 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Number of random events: ');

tx2 = text('EraseMode','normal', 'Position',[0 .89 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Distribution: ');

tx3 = text('EraseMode','normal', 'Position',[0 .53 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Longitude 1 [deg]: ');

tx4 = text('EraseMode','normal', 'Position',[0 .445 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Longitude 2 [deg]: ');

tx5 = text('EraseMode','normal', 'Position',[0 .36 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Latitude 1 [deg]: ');

tx6 = text('EraseMode','normal', 'Position',[0 .275 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Latitude 2 [deg]: ');

tx7 = text('EraseMode','normal', 'Position',[0 .19 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Minimum depth [km]: ');

tx8 = text('EraseMode','normal', 'Position',[0 .105 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Maximum depth [km]: ');

tx9 = text('EraseMode','normal', 'Position',[0 .81 0 ], 'Rotation',0, 'color', 'w',...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Std. deviation in longitude [km]: ');

tx10 = text('EraseMode','normal', 'Position',[0 .74 0 ], 'Rotation',0,'color', 'w',...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Std. deviation in latitude [km]: ');

tx11 = text('EraseMode','normal', 'Position',[0 .66 0 ], 'Rotation',0,'color', 'w',...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Std. deviation in depth [km]: ');




close_button=uicontrol('Style','Pushbutton',...
    'Position',[.60 .02 .20 .07 ],...
    'Units','normalized','Callback','close;zmap_message_center.set_info('' '','' '');done','String','Cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .02 .20 .07 ],...
    'Units','normalized',...
    'Callback','close;think; if distr == [6], rndsph = ''distr3a''; dorand; else dorand; end',...
    'String','Go');



set(gcf,'visible','on');
watchoff;
