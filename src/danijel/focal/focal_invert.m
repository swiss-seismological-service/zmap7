function [ax,ay,az] = focal_invert(ax,ay,az)
    %  Original routines from FPSpack.f - Gasperini and Vannucci, Computer & Geosciences, 2003
    % invert vector
    %
    %     usage:
    %     utility routine for internal use only
    %
    
    ax = -ax;
    ay = -ay;
    az = -az;
end