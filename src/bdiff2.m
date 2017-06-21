% Script: bdiff2
% Formerly : function  bdiff(newcat)
% This routine estimates the b-value of a curve automatically
% The b-value curve is differenciated and the point
% of the magnitude of completeness is marked. The b-value will be calculated
% using this point and the point half way toward the high
% magnitude end of the b-value curve.
%
% Stefan Wiemer 1/95
% last update: J.Woessner, 27.08.04

% Changes record:
% 02.06.03: Added choice of EMR-method to calculate Mc
% 06.10.03: Added choice of MBS-method to calculate Mc (fixed at 5)
%           Added bootstrap choice
% 28.07.04: Many changes: Now able to do computatios with all functions
%           available in calc_Mc

global cluscat mess  backcat fontsz ho xt3 bvalsum3  bval aw bw t1 t2 t3 t4; %bfig
global ttcat les n teb t0b cb1 cb2 cb3 cua b1 n1 b2 n2  ew si  S mrt bvalsumhold b;
global selt magco bvml avml bvls avls bv;
global hndl2 inpr1;
think
%zmap_message_center.set_info('  ','Calculating b-value...')
report_this_filefun(mfilename('fullpath'));

%%
%
% Create the input interface
%
% when run from timeplot.m selt=in and it an input menu is created
% this initiates a call back, where selt =  ca, and we go directly
% to the calculations, skipping the in put menu
%
%%

if selt == 'in'
    % Default value
    nBstSample = 100;
    fMccorr = 0;
    fBinning = 0.1;

    nPar = figure_w_normalized_uicontrolunits(...
        'Name','Mc Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'NextPlot','new', ...
        'units','points',...
        'Visible','off', ...
        'Position',[ 200 200 450 200]);
    axis off

    % Get list of Mc computation possibilities
    [labelList2] = calc_Mc;
    %labelList2=[' Automatic Mcomp (max curvature) | Fixed Mc (Mc = Mmin) | Automatic Mcomp (90% probability) | Automatic Mcomp (95% probability) | Best (?) combination (Mc95 - Mc90 - max curvature) | EMR-method | MBS-method | Specify Mc | Predefine Mc variable with time'];
    labelPos = [0.05 0.7  0.8  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList2,...
        'Callback','inb2 =get(hndl2,''Value''); ');

    set(hndl2,'value',1);

    % Editable fields
    field1 = uicontrol('Style','edit',...
        'Position',[.65 .56 .12 .1],...
        'Units','normalized','String',num2str(nBstSample),...
        'Callback','nBstSample=str2double(get(field1,''String'')); set(field1,''String'',num2str(nBstSample));');

    field2 =uicontrol('Style','edit',...
        'Position',[.65 .45 .12 .1],...
        'Units','normalized','String',num2str(fMccorr),...
        'Callback','fMccorr=str2double(get(field2,''String'')); set(field2,''String'',num2str(fMccorr)) ; set(hndl2,''value'',1);');


    %% Buttons
    bBst_button = uicontrol('Style','checkbox',...
        'string','Uncertianty by boostrapping',...
        'Position',[.05 .55 .4 .10],...
        'Units','normalized'); % 'Callback','set(wls_button,''value'',0)'

    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .15 .12 ],...
        'Units','normalized','Callback','close;done','String','Cancel');

    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'Callback',' inpr1 =get(hndl2,''Value'');bBst_button =get(bBst_button,''Value'');close;selt =''ca''; bdiff2',...
        'String','Go'); %wls_button =get(wls_button,''Value'');ml_button =get(ml_button,''Value'');

    %%%  Test fields
    txt1 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.47 0.6 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'String',' Bootstraps');

    txt2 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.47 0.5 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'String','Mc correction');

    txtTitle = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.2 0.9 0 ],...
        'Rotation',0 ,...
        'FontSize',12 ,...
        'FontWeight','bold',...
        'String','Maximum likelihood estimation');

    set(nPar,'visible','on');
    watchoff
end % selt = in

%%
% selt = ca after input menu is run and parameters have been set
%%

if selt == 'ca'

    %%
    %
    % check to see if figure exists
    % if does -- draw over
    % if it does not, create the window
    %
    %%

    [existFlag,figNumber]=figure_exists('Frequency-magnitude distribution',1);
    if existFlag
        % figure_w_normalized_uicontrolunits(bfig);
        bfig = figNumber;
    else
        bfig=figure_w_normalized_uicontrolunits(...                  %build figure for plot
            'Units','normalized','NumberTitle','off',...
            'Name','Frequency-magnitude distribution',...
            'MenuBar','none',...
            'visible','off',...
            'pos',[ 0.300  0.3 0.4 0.6]);

        ho = 'noho';
        
        matdraw

        options = uimenu('Label','ZTools');
        uimenu(options,'Label','Estimate recurrence time/probability', 'Callback','plorem');
        uimenu(options,'Label','Manual fit of b-value', 'Callback','bfitnew(newcat)');
        uimenu(options,'Label','Plot time series', 'Callback','newcat = newt2; timeplot');
        uimenu(options,'Label','Do not show discrete curve', 'Callback','delete(pl1)');
        uimenu(options,'Label','Save values to file', 'Callback',{@calSave9,xt3, bvalsum3});
    end % existflag

    maxmag = ceil(10*max(newt2.Magnitude))/10;
    mima = min(newt2.Magnitude);
    if mima > 0 ; mima = 0 ; end


    %%
    %
    % bval contains the number of events in each bin
    % bvalsum is the cum. sum in each bin
    % bval2 is number events in each bin, in reverse order
    % bvalsum3 is reverse order cum. sum.
    % xt3 is the step in magnitude for the bins == .1
    %
    %%

    [bval,xt2] = hist(newt2.Magnitude,(mima:0.1:maxmag));
    bvalsum = cumsum(bval); % N for M <=
    bval2 = bval(length(bval):-1:1);
    bvalsum3 = cumsum(bval(length(bval):-1:1));    % N for M >= (counted backwards)
    xt3 = (maxmag:-0.1:mima);

    backg_ab = log10(bvalsum3);

    if ho(1:2) == 'ho'
        axes(cua)
        disp('hold on')
        hold on
    else
        figure_w_normalized_uicontrolunits(bfig);delete(gca);delete(gca); delete(gca); delete(gca)
        rect = [0.22,  0.3, 0.65, 0.6];           % plot Freq-Mag curves
        axes('position',rect);
    end % ho

    %%
    % plot the cum. sum in each bin  %%
    %%

    pl =semilogy(xt3,bvalsum3,'sb');
    set(pl,'LineWidth',1.0,'MarkerSize',6,...
        'MarkerFaceColor','w','MarkerEdgeColor','k');
    hold on
    pl1 =semilogy(xt3,bval2,'^b');
    set(pl1,'LineWidth',1.0,'MarkerSize',4,...
        'MarkerFaceColor',[0.7 0.7 .7],'MarkerEdgeColor','k');

    %%
    % CALCULATE the diff in cum sum from the previous biin
    %%


    xlabel('Magnitude','FontWeight','bold','FontSize',fontsz.m)
    ylabel('Cumulative Number','FontWeight','bold','FontSize',fontsz.m)
    set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','normal',...
        'FontWeight','bold','LineWidth',1.0,'TickDir','out','Ticklength',[0.02 0.02],...
        'Box','on','Tag','cufi','color','w')

    cua = gca;

    %%
    % Estimate the b value
    %
    % calculates max likelihood b value(bvml) && WLS(bvls)
    %
    %%

    %% SET DEFAULTS TO BE ADDED INTERACTIVLY LATER
    Nmin = 10;

    bvs=newt2;
    b=newt2;

    %% enough events??
    if bvs.Count >= Nmin
        % Added to obtain goodness-of-fit to powerlaw value
        mcperc_ca3;

        [fMc] = calc_Mc(bvs, inpr1, fBinning, fMccorr);
        l = bvs.Magnitude >= fMc-(fBinning/2);
        if sum(l) >= Nmin
            [fMeanMag, fBValue, fStd_B, fAValue] =  calc_bmemag(bvs.subset(l), fBinning);
        else
            fMc = NaN; fBValue = NaN; fStd_B = NaN; fAValue= NaN;
        end
        % Set standard deviation ofa-value to NaN;
        fStd_A= NaN; fStd_Mc = NaN;

        % Bootstrap uncertainties
        if bBst_button == 1
            % Check Mc from original catalog
            l = bvs.Magnitude >= fMc-(fBinning/2);
            if sum(l) >= Nmin
                [fMc, fStd_Mc, fBValue, fStd_B, fAValue, fStd_A, vMc, mBvalue] = calc_McBboot(bvs, fBinning, nBstSample, inpr1, Nmin, fMccorr);
            else
                fMc = NaN; fStd_Mc = NaN; fBValue = NaN; fStd_B = NaN; fAValue= NaN; fStd_A= NaN;
            end
        else
            % Set standard deviation ofa-value to NaN;
            fStd_A= NaN; fStd_Mc = NaN;
        end % of bBst_button
    else
        fMc = NaN; fStd_Mc = NaN; fBValue = NaN; fStd_B = NaN; fAValue= NaN; fStd_A = NaN;
        fStdDevB = NaN;
        fStdDevMc = NaN;
    end% of if length(bvs) >= Nmin
    %%
    % calculate limits of line to plot for b value line
    %%
    % For ZMAP
    magco = fMc;
    index_low=find(xt3 < magco+.05 & xt3 > magco-.05);

    mag_hi = xt3(1);
    index_hi = 1;
    mz = xt3 <= mag_hi & xt3 >= magco-.0001;
    mag_zone=xt3(mz);

    y = backg_ab(mz);

    %%
    % PLOTS an 'x' in the point of Mc
    %%

    te = semilogy(xt3(index_low),bvalsum3(index_low)*1.5,'vb');
    set(te,'LineWidth',1.0,'MarkerSize',7)

    te = text(xt3(index_low)+0.2,bvalsum3(index_low)*1.5,'Mc');
    set(te,'FontWeight','bold','FontSize',fontsz.s,'Color','b')

    %%
    % Set to correct method, maximum like or least squares
    %%
    if bBst_button == 0
        sol_type = 'Maximum Likelihood Solution';
        bw=fBValue;%bvml;
        aw=fAValue;%avml;
        ew=fStd_B;%stanml;
        %     end
    else
        sol_type = 'Maximum Likelihood Estimate, Uncertainties by bootstrapping';
        bw=fBValue;
        aw=fAValue;
        ew=fStd_B;
    end %bBst_button
    %%
    % create and draw a line corresponding to the b value
    %%
    figure_w_normalized_uicontrolunits(bfig)
    %p = [ -1*bw aw];
    p = [ -1*bw aw];
    %[p,S] = polyfit(mag_zone,y,1);
    f = polyval(p,mag_zone);
    f = 10.^f;
    hold on
    ttm= semilogy(mag_zone,f,'r');                         % plot linear fit to backg
    set(ttm,'LineWidth',1.)
    std_backg = ew;      % standard deviation of fit

    %%
    % Error Bar Calculation -- call to pdf_calc.m
    %%

    %pdf_calc;
    set(gca,'XLim',[min(b.Magnitude)-0.5  max(b.Magnitude)+0.5])
    set(gca,'YLim',[0.9 length(b.Date+30)*2.5]);


    p=-p(1,1);
    p=fix(100*p)/100;
    tt1=num2str(bw,3);
    tt2=num2str(std_backg,1);
    tt4=num2str(bv,3);
    tt5=num2str(si,2);


    tmc=num2str(magco,2);

    rect=[0 0 1 1];
    h2=axes('position',rect);
    set(h2,'visible','off');

    a0 = aw-log10(years(max(b.Date)-min(b.Date)));


    if ho(1:2) == 'ho'
        set(pl,'LineWidth',1.0,'MarkerSize',8,...
            'MarkerFaceColor','k','MarkerEdgeColor','k','Marker','^');
        %set(pl3,'LineWidth',1.0,'MarkerSize',6,...
        %'MarkerFaceColor','c','MarkerEdgeColor','m','Marker','s');
        %   txt1=text(.16, .06,['b-value (w LS, M  >= ', num2str(M1b(1)) '): ',tt1, ' +/- ', tt2 ',a-value = ' , num2str(aw) ]);
        set(txt1,'FontWeight','normal','FontSize',fontsz.s,'Color','r')
    else
        if bBst_button == 0
            txt1=text(.16, .11,['b-value = ',tt1,' +/- ',tt2,',  a value = ',num2str(aw,3) ',  a value (annual) = ', num2str(a0,3)],'FontSize',fontsz.s);
            set(txt1,'FontWeight','normal')
            set(gcf,'PaperPosition',[0.5 0.5 4.0 5.5])
            text(.16, .14,sol_type,'FontSize',fontsz.s );
            text(.16, .08,['Magnitude of Completeness = ',tmc],'FontSize',fontsz.s);
        else
            txt1=text(.16, .11,['b-value = ',num2str(round(100*fBValue)/100),' +/- ',num2str(round(100*fStd_B)/100),',  a value = ',num2str(aw,3) ',  a value (annual) = ', num2str(a0,3)],'FontSize',fontsz.s);
            set(txt1,'FontWeight','normal')
            set(gcf,'PaperPosition',[0.5 0.5 4.0 5.5])
            text(.16, .14,sol_type,'FontSize',fontsz.s );
            text(.16, .08,['Magnitude of Completeness = ',tmc ' +/- ', num2str(round(100*fStd_Mc)/100)],'FontSize',fontsz.s);
        end
    end % ho

    set(gcf,'visible','on','Color','w');
    zmap_message_center.set_info('  ','Done')
    done

    if ho(1:2) == 'ho'
        % calculate the probability that the two distributins are differnt
        %l = newt2.Magnitude >=  M1b(1);
        b2 = str2double(tt1); n2 = M1b(2);
        n = n1+n2;
        da = -2*n*log(n) + 2*n1*log(n1+n2*b1/b2) + 2*n2*log(n1*b2/b1+n2) -2;
        pr = exp(-da/2-2);
        disp(['Probability: ',  num2str(pr)]);
        txt1=text(.60, .85,['p=  ', num2str(pr,2)],'Units','normalized');
        set(txt1,'FontWeight','normal','FontSize',fontsz.s)
        txt1=text(.60, .80,[ 'n1: ' num2str(n1) ', n2: '  num2str(n2) ', b1: ' num2str(b1)  ', b2: ' num2str(b2)]);
        set(txt1,'FontSize',8,'Units','normalized')
    end
end % selt == ca


