% drap a colormap of variance, S1 orinetation onto topography
report_this_filefun(mfilename('fullpath'));

j = colormap;
% check if mapping toolbox and topo map exists
if ~license('test','map_toolbox')
    errordlg('It seems like you do not have the mapping toolbox installed - plotting topography will not work without it, sorry');
    return
end

if ~exist('tmap', 'var'); tmap = 0; end
[xx, yy] = size(tmap);
if xx*yy < 30
    errordlg('Please create a topomap first, using the options from the seismicty map window');
    return
end

def = {'1','1','5',num2str(min(min(re3)),4),num2str(max(max(re3)),4) };

tit ='Topo map input parameters';
prompt={ 'Longitude label spacing in degrees ',...
    'Latitude label spacing in degrees ',...
    'Topo data-aspect (steepness) ',...
    ' Minimum datavalue (cmin)',...
    ' maximum datavalue cmap',...

    };
ni2 = inputdlg(prompt,tit,1,def);

l = ni2{1}; dlo= str2double(l);
l = ni2{2}; dla= str2double(l);
l = ni2{3}; dda= str2double(l);
l = ni2{4}; mic= str2double(l);
l = ni2{5}; mac= str2double(l);

% use this for setting water levels to one color
%l = isnan(tmap);
%tmap(l) = 1;

ButtonName=questdlg('Set water to zero?', ...
    ' Question', ...
    'Yes','No','no');


switch ButtonName
    case 'Yes'
        l= tmap< 0.1;
        tmap(l) = 0;
end % switch



l = re3 < mic;
re3(l) = mic ;
l = re3 > mac;
re3(l) = mac;

[lat,lon] = meshgrat(tmap,tmapleg);
%lat = xx; lon = yy;
[X , Y]  = meshgrid(gx,gy);

ren = interp2(X,Y,re3,lon,lat);

mi = min(min(ren));
l =  isnan(ren);
ren(l) = mi-20;

%start figure
figure_w_normalized_uicontrolunits('pos',[50 100 800 600])

hold on; axis off
axesm('MapProjection','eqaconic','MapParallels',[],...
    'MapLatLimit',[s4 s3],'MapLonLimit',[s2 s1])

meshm(ren,tmapleg,size(tmap),tmap);

daspectm('m',dda);
tightmap
view([0 90])
camlight; lighting phong
set(gca,'projection','perspective');


%pl = plotm(faults(:,2),faults(:,1),'k');
%set(pl,'LineWidth',1,'MarkerSize',14,...
%    'MarkerFaceColor','k','MarkerEdgeColor','k')


% pl = plotm(coastline(:,2),coastline(:,1),'w');
% set(pl,'LineWidth',2,'MarkerSize',14,...
%     'MarkerFaceColor','w','MarkerEdgeColor','k')
%
%pl = plotm(maepi(:,2),maepi(:,1),'hw');
%set(pl,'LineWidth',1,'MarkerSize',14,...
%    'MarkerFaceColor','w','MarkerEdgeColor','k')
%zdatam(handlem('allline'),max(max(tmap))) % keep line on surface

%j = jet;
%j = j(64:-1:1,:);
j = [ [ 0.9 0.9 0.9 ] ; j];
caxis([ mic*0.99 mac*1.01 ]);

colormap(j); brighten(0.1);
axis off;

if ~exist('colback', 'var'); colback = 1; end

if colback == 2  % black background
    set(gcf,'color','k')
    setm(gca,'ffacecolor','k')
    setm(gca,'fedgecolor','w','flinewidth',3);

    % change the labels if needed
    setm(gca,'mlabellocation',dlo)
    setm(gca,'meridianlabel','on')
    setm(gca,'plabellocation',dla)
    setm(gca,'parallellabel','on')
    setm(gca,'Fontcolor','w','Fontweight','bold','FontSize',12,'Labelunits','dm')

    h5 = colorbar;
    set(h5,'position',[0.8 0.35 0.01 0.3],'TickDir','out','Ycolor','w','Xcolor','w',...
        'Fontweight','bold','FontSize',12);
    set(gcf,'Inverthardcopy','off');

else % white background
    set(gcf,'color','w')
    setm(gca,'ffacecolor','w')
    setm(gca,'fedgecolor','k','flinewidth',3);

    % change the labels if needed
    setm(gca,'mlabellocation',dlo)
    setm(gca,'meridianlabel','on')
    setm(gca,'plabellocation',dla)
    setm(gca,'parallellabel','on')
    setm(gca,'Fontcolor','k','Fontweight','bold','FontSize',12,'Labelunits','dm')

    h5 = colorbar;
    set(h5,'position',[0.8 0.35 0.01 0.3],'TickDir','out','Ycolor','k','Xcolor','k',...
        'Fontweight','bold','FontSize',12);
    set(gcf,'Inverthardcopy','off');

end










