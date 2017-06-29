% collect res
clear resu
ind=1;
if exist('bls','var')
    resu(ind).data=bls;
    resu(ind).name='b-value map (WLS)';
    resu(ind).lab='b-value';
    ind=ind+1;
end

if exist('bml','var')
    resu(ind).data=bml;
    resu(ind).name='b(max likelihood) map';
    resu(ind).lab='b-value';
    ind=ind+1;
end

if exist('oldl','var')
    resu(ind).data=oldl;
    resu(ind).name='Magnitude of completness map';
    resu(ind).lab='Mcomp';
    ind=ind+1;
end

if exist('Prmap','var')
    resu(ind).data=Prmap;
    resu(ind).name='Goodness of fit to power law map';
    resu(ind).lab='%';
    ind=ind+1;
end

if exist('re3','var')
    resu(ind).data=re3;
    resu(ind).name='last re3';
    resu(ind).lab='  ';
    ind=ind+1;
end


%frame=[s2 s1 s4 s3];
figure_w_normalized_uicontrolunits(map);
frame=[get(gca,'XLim') get(gca,'Ylim')];


s=1
if ind==1
    resu=1
    gx=1
    gy=1
    s=2
end

% gtopo30 DEM directory
global pgdem
pgdem = fullfile(hodi, 'dem', 'globedem');
% pgdem='c:\ZMAP6\dem\globedem';
global pgt30
pgt30 = fullfile(hodi, 'dem', 'gtopo30');
% pgt30='c:\ZMAP6\dem\gtopo30';
global psloc
psloc = [hodi];
% psloc='c:\ZMAP6';

cd(psloc)
topo(frame,a,faults,coastline,resu,gx,gy,s);
