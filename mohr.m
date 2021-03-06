function [sigxp,sigyp,txpyp,sig1,sig2,tmax] = mohr(sigx,sigy,txy,theta)

%==========================================================================
%
%   Input:   sigx  - normal stress in x-direction
%            sigy  - normal stress in y-direction
%            txy   - shear stress in xy-plane
%            theta - stress transformation angle (in degrees)
%
%   Outputs: sigxp - transformed normal stress in x-direction
%            sigyp - transformed normal stress in y-direction
%            txpyp - transformed shear stress in xy-plane
%            sig1  - first principal normal stress
%            sig2  - second principal normal stress
%            tmax  - maximum in-plane shear stress
%
%   Convention: positive shear is pointing upwards
%
%==========================================================================

close all;

%==========================================================================
%  BEGIN ASSIGNMENT
%
%  Calculate the specified quantities using the variable names given; that 
%  is, enter the appropriate equations in place of the 0's. This may
%  require more that a single line of code in some cases or a system of
%  checks (hint for the angles). Introduce any intermediate variables and
%  calculations necesssary, but store the end result in the given
%  variables.
%
%==========================================================================

% Transformation equations
sigxp = (sigx+sigy)/2 + (sigx-sigy)/2 * cos(2*theta) + txy*sin(2*theta);      % Calculate transformed normal stress in x-direction
sigyp = (sigx+sigy)/2 - (sigx-sigy)/2 * cos(2*theta) - txy*sin(2*theta);      % Calculate transformed normal stress in y-direction
txpyp = (sigy-sigx)/2 * sin(2*theta) + txy*cos(2*theta);      % Calculate transformed shear stress in xy-plane

% Principal stresses and angles, maximum shear stress and angles
sig_avg = (sigx+sigy)/2;    % Calculate average normal stress
tmax = (((sigx-sigy)/2)^2 + txy^2)^0.5;       % Calculate maximum in-plane shear stress
sig1 = sig_avg + tmax;       % Calculate maximum normal stress (principal stress 1)
sig2 = sig_avg - tmax;       % Calculate minimum normal stress (principal stress 2)
tp1 =  atan(2*txy/(sigx-sigy)) / 2;       % Calculate rotation angle (in degrees) to principal 
                % stress 1 
  pi = 3.14159;
tp2 =  tp1 + pi/2;       % Calculate rotation angle (in degrees) to principal 
                % stress 2 
ts1 =  tp1 + pi/4;       % Calculate rotation angle (in degrees) to maximum shear 
                % stress 1 
ts2 =  tp2 + pi/4;       % Calculate rotation angle (in degrees) to maximum shear 
                % stress 2 

%==========================================================================
%   END ASSIGNMENT
%==========================================================================



%==========================================================================
%           Visualization
%==========================================================================
set(0,'Units','pixels')             % Resize window
h = get(0,'ScreenSize');
figure('Position',h)

subplot(2,2,1)                      % Original stress state
rectangle('Position',[0,0,2,2]);
hold on;
quiver(1,1,0.8,0,0,'k')
quiver(1,1,0,0.8,0,'k')
axis equal;
if (txy > 0)
    quiver(2.1,0,0,2,0,'r');
    quiver(0,2.1,2,0,0,'r');
    quiver(-0.1,2,0,-2,0,'r');
    quiver(2,-0.1,-2,0,0,'r');
elseif (txy < 0)
    quiver(2.1,2,0,-2,0,'r');
    quiver(2,2.1,-2,0,0,'r');
    quiver(-0.1,0,0,2,0,'r');
    quiver(0,-0.1,2,0,0,'r');
end
if (sigx > 0)
    quiver(2.1,1,1,0,0,'b');
    quiver(-0.1,1,-1,0,0,'b');
elseif (sigx < 0)
    quiver(3.1,1,-1,0,0,'b');
    quiver(-1.1,1,1,0,0,'b');
end
if (sigy > 0)
    quiver(1,2.1,0,1,0,'b');
    quiver(1,-0.1,0,-1,0,'b');
elseif (sigy < 0)
    quiver(1,3.1,0,-1,0,'b');
    quiver(1,-1.1,0,1,0,'b');
end
set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',12)
title('Original stress state')
xlabel({['\sigma_x = ' num2str(sigx) ', \sigma_y = ' num2str(sigy) ...
        ', \tau_{xy} = ' num2str(txy)]; '';['For \theta = ' ...
        num2str(theta) '^{\o}: \sigma_{x\prime} = ' num2str(sigxp) ...
        ', \sigma_{y\prime} = ' num2str(sigyp) ...
        ', \tau_{x\primey\prime} = ' num2str(txpyp)]})
text(2.5,1.1,'\sigma_x')
text(1.1,2.5,'\sigma_y')
text(2.2,2,'\tau_{xy}')
text(1.8,1.1,'x')
text(1.1,1.8,'y')

subplot(2,2,2)                      % Mohr's circle
theta = linspace(0,2*pi,100);
r = ones(1,100)*tmax;
[x,y] = pol2cart(theta,r);
x = x + sig_avg;
plot(x,y);
hold on;
plot(sigx,txy,'r*',sigy,-txy,'r*')
plot([sigx,sigy],[txy,-txy],'k')
quiver(sig_avg,0,1.2*tmax,0,0,'k')
quiver(sig_avg,0,0,1.2*tmax,0,'k')
axis equal;
set(gca,'FontWeight','bold','FontSize',12)
title('Mohr\primes circle')
xlabel(['\sigma_{avg} = ' num2str(sig_avg) ', R = ' num2str(tmax)])
text(sig_avg+1.1*tmax,0.05*tmax,'\sigma')
text(sig_avg+0.05*tmax,-1.1*tmax,'\tau')
text(sig_avg,0.05*tmax,'\sigma_{avg}')

subplot(2,2,3)                      % Principal stress state
RMp = [cosd(tp1) -sind(tp1); sind(tp1) cosd(tp1)];
C = [ 2, 0;
      2, 2;
      0, 2;
      0, 0;
      2.1, 1;
      3.1, 1;
     -0.1, 1;
     -1.1, 1;
      1, 2.1;
      1, 3.1;
      1, -0.1;
      1, -1.1;
      1,1;
      1,1.8;
      1,1;
      1.8,1  ];
b =RMp*C';
x = [b(1,1:4), b(1,1)];
y = [b(2,1:4), b(2,1)];
plot(x,y,'k')
hold on;
quiver(b(1,13),b(2,13),0.8,0,0,'--k')
quiver(b(1,15),b(2,15),0,0.8,0,'--k')
quiver(b(1,13),b(2,13),b(1,14)-b(1,13),b(2,14)-b(2,13),0,'k');
quiver(b(1,15),b(2,15),b(1,16)-b(1,15),b(2,16)-b(2,15),0,'k');
axis equal;
if (sig1 > 0)
    quiver(b(1,5),b(2,5),b(1,6)-b(1,5),b(2,6)-b(2,5),0,'b');
    quiver(b(1,7),b(2,7),b(1,8)-b(1,7),b(2,8)-b(2,7),0,'b');
elseif (sig1 < 0)
    quiver(b(1,6),b(2,6),b(1,5)-b(1,6),b(2,5)-b(2,6),0,'b');
    quiver(b(1,8),b(2,8),b(1,7)-b(1,8),b(2,7)-b(2,8),0,'b');
end
if (sig2 > 0)
    quiver(b(1,9),b(2,9),b(1,10)-b(1,9),b(2,10)-b(2,9),0,'b');
    quiver(b(1,11),b(2,11),b(1,12)-b(1,11),b(2,12)-b(2,11),0,'b');
elseif (sig2 < 0)
    quiver(b(1,10),b(2,10),b(1,9)-b(1,10),b(2,9)-b(2,10),0,'b');
    quiver(b(1,12),b(2,12),b(1,11)-b(1,12),b(2,11)-b(2,12),0,'b');
end
set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',12)
title(['Principal stresses in element rotated \theta_{p1} = ' ...
        num2str(tp1) '^{\o}'])
xlabel(['\sigma_1 = ' num2str(sig1) ', \sigma_2 = ' num2str(sig2) ...
        ', \theta_{p1} = ' num2str(tp1) '^{\o}, \theta_{p2} = ' ...
        num2str(tp2) '^{\o}'])

subplot(2,2,4)                      % Maximum shear stress state
RMs = [cosd(ts1) -sind(ts1); sind(ts1) cosd(ts1)];
C = [ 2, 0;
      2, 2;
      0, 2;
      0, 0;
      2.1, 1;
      3.1, 1;
     -0.1, 1;
     -1.1, 1;
      1, 2.1;
      1, 3.1;
      1, -0.1;
      1, -1.1;
      2.1, 0;
      2.1, 2;
       0,2.1;
       2,2.1;
      -0.1,2;
     -0.1, 0;
      2,-0.1;
      0,-0.1; 
      1,1;
      1,1.8;
      1,1;
      1.8,1  ]; 
b =RMs*C';
x = [b(1,1:4), b(1,1)];
y = [b(2,1:4), b(2,1)];
plot(x,y,'k')
hold on;
quiver(b(1,21),b(2,21),0.8,0,0,'--k')
quiver(b(1,23),b(2,23),0,0.8,0,'--k')
quiver(b(1,21),b(2,21),b(1,22)-b(1,21),b(2,22)-b(2,21),0,'k');
quiver(b(1,23),b(2,23),b(1,24)-b(1,23),b(2,24)-b(2,23),0,'k');
axis equal;
quiver(b(1,13),b(2,13),b(1,14)-b(1,13),b(2,14)-b(2,13),0,'r');
quiver(b(1,15),b(2,15),b(1,16)-b(1,15),b(2,16)-b(2,15),0,'r');
quiver(b(1,17),b(2,17),b(1,18)-b(1,17),b(2,18)-b(2,17),0,'r');
quiver(b(1,19),b(2,19),b(1,20)-b(1,19),b(2,20)-b(2,19),0,'r');
if (sig_avg > 0)
    quiver(b(1,5),b(2,5),b(1,6)-b(1,5),b(2,6)-b(2,5),0,'b');
    quiver(b(1,7),b(2,7),b(1,8)-b(1,7),b(2,8)-b(2,7),0,'b');
    quiver(b(1,9),b(2,9),b(1,10)-b(1,9),b(2,10)-b(2,9),0,'b');
    quiver(b(1,11),b(2,11),b(1,12)-b(1,11),b(2,12)-b(2,11),0,'b');
elseif (sig_avg < 0)
    quiver(b(1,6),b(2,6),b(1,5)-b(1,6),b(2,5)-b(2,6),0,'b');
    quiver(b(1,8),b(2,8),b(1,7)-b(1,8),b(2,7)-b(2,8),0,'b');
    quiver(b(1,10),b(2,10),b(1,9)-b(1,10),b(2,9)-b(2,10),0,'b');
    quiver(b(1,12),b(2,12),b(1,11)-b(1,12),b(2,11)-b(2,12),0,'b');
end
set(gca,'XTick',[],'YTick',[],'FontWeight','bold','FontSize',12)
title(['Maximum shear stress in element rotated \theta_{s1} = ' ...
        num2str(ts1) '^{\o}'])
xlabel(['\sigma_{avg} = ' num2str(sig_avg) ', \tau_{max} = ' ...
        num2str(tmax) ', \theta_{s1} = ' num2str(ts1) ...
        '^{\o}, \theta_{s2} = ' num2str(ts2) '^{\o}'])
