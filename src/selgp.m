sreport_this_filefun(mfilename('fullpath'));

messtext=...
    ['To select a polygon for a grid.       '
    'Please use the LEFT mouse button of   '
    'or the cursor to the select the poly- '
    'gon. Use the RIGTH mouse button for   '
    'the final point.                      '
    'Mac Users: Use the keyboard "p" more  '
    'point to select, "l" last point.      '
    '                                      '];
zmap_message_center.set_message('Select Polygon for a grid',messtext);

hold on
ax = findobj('Tag','main_map_ax');
[x,y, mouse_points_overlay] = select_polygon(ax);
zmap_message_center.set_info('Message',' Thank you .... ')

figure_w_normalized_uicontrolunits(map)

plos2 = plot(x,y,'b-');        % plot outline
sum3 = 0.;
pause(0.3)

%create a rectangular grid
xvect=[min(x):dx:max(x)];
yvect=[min(y):dy:max(y)];
gx = xvect;
gy= yvect;
tmpgri=zeros((length(xvect)*length(yvect)),2);
n=0;
for i=1:length(xvect)
    for j=1:length(yvect)
        n=n+1;
        tmpgri(n,:)=[xvect(i) yvect(j)];
    end
end
%extract all gridpoints in chosen polygon
XI=tmpgri(:,1);
YI=tmpgri(:,2);

ll = polygon_filter(x,y, XI, YI, 'inside');
%grid points in polygon
newgri=tmpgri(ll,:);

% plot the grid points
figure_w_normalized_uicontrolunits(map)
pl = plot(newgri(:,1),newgri(:,2),'+k','era','normal');
set(pl,'MarkerSize',8,'LineWidth',1)
drawnow
