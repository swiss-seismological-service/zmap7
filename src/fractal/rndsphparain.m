function rndsphparain() % autogenerated function wrapper
%
% Input window for the random catalogue parameters in spherical geometry.
% Called from startfd.m.
%
%
%disp('fractal/codes/rndsphparain.m');
%
%
% Creates the input window
%
 % turned into function by Celso G Reyes 2017
 
ZG=ZmapGlobal.Data; % used by get_zmap_globals
figure_w_normalized_uicontrolunits('Units','pixel','pos',[150 100 350 350 ],'Name','Parameters for the sphere','visible','off',...
    'NumberTitle','off','Color',color_fbg,'NextPlot','new');
axis off;

input1 = uicontrol('Style','edit','Position',[.70 .90 .22 .06],...
    'Units','normalized','String',num2str(radiusx),...
    'callback',@callbackfun_001);

input2 = uicontrol('Style','edit','Position',[.70 .8 .22 .06],...
    'Units','normalized','String',num2str(radiusy),...
    'callback',@callbackfun_002);

input3 = uicontrol('Style','edit','Position',[.70 .7 .22 .06],...
    'Units','normalized','String',num2str(radiusz),...
    'callback',@callbackfun_003);

input4 = uicontrol('Style','edit','Position',[.70 .6 .22 .06],...
    'Units','normalized','String',num2str(centerx),...
    'callback',@callbackfun_004);

input5 = uicontrol('Style','edit','Position',[.70 .5 .22 .06],...
    'Units','normalized','String',num2str(centery),...
    'callback',@callbackfun_005);

input6 = uicontrol('Style','edit','Position',[.70 .4 .22 .06],...
    'Units','normalized','String',num2str(centerz),...
    'callback',@callbackfun_006);



tx1 = text('EraseMode','normal', 'Position',[0 1.00 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Radius of sphere in x [deg]: ');

tx2 = text('EraseMode','normal', 'Position',[0 .88 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Radius of sphere in y [deg]: ');

tx3 = text('EraseMode','normal', 'Position',[0 .76 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Radius of sphere in z [km]: ');

tx4 = text('EraseMode','normal', 'Position',[0 .64 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Center Coordinate x [deg]: ');

tx5 = text('EraseMode','normal', 'Position',[0 .515 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Center Coordinate y [deg]: ');

tx6 = text('EraseMode','normal', 'Position',[0 .39 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String','Center Coordinate z [km]: ');


close_button=uicontrol('Style','Pushbutton',...
    'Position',[.60 .10 .25 .10 ],...
    'Units','normalized','callback',@callbackfun_007,'String','Cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .10 .25 .10 ],...
    'Units','normalized',...
    'callback',@callbackfun_008,...
    'String','Go');



set(gcf,'visible','on');
watchoff;

function callbackfun_001(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  radiusx = str2double(input1.String);
   input1.String=num2str(radiusx);
end
 
function callbackfun_002(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  radiusy = str2double(input2.String);
   input2.String=num2str(radiusy);
end
 
function callbackfun_003(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  radiusz = str2double(input3.String);
   input3.String=num2str(radiusz);
end
 
function callbackfun_004(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  centerx = str2double(input4.String);
   input4.String=num2str(centerx);
end
 
function callbackfun_005(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  centery=str2double(input5.String);
   input5.String=num2str(centery);
end
 
function callbackfun_006(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  centerz=str2double(input6.String);
   input6.String=num2str(centerz);
end
 
function callbackfun_007(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  close;
  zmap_message_center.set_info(' ',' ');
  done;
end
 
function callbackfun_008(mysrc,myevt)
  % automatically created callback function from text
  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  close;
  think;
   rndsph = 'distr3b';
   dorand;
end
 
end
