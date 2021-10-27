% =========================================================================
%
% Cell-specific beamforming for large antenna arrays
%
% Dual polarization, Golay pairs and epsilon-complementarity
% Two-dimensional plots
%
% Max Girnyk
% Stockholm, 2021-10-27
%
% =========================================================================
%
% This Matlab script produces results used in the following paper:
%
% M. A. Girnyk and S. O. Petersson, "Efficient Cell-Specific Beamforming
% for Large Antenna Arrays," IEEE Transactions on Communicatinos, To appear
%
% Paper URL:          https://arxiv.org/abs/2110.05214
%
% Version:            1.0 (modified 2021-10-27)
%
% License:            This code is licensed under the Apache-2.0 license. 
%                     If you use this code in any way for research that
%                     results in a publication, please cite the above paper
%
% =========================================================================

function PlotResults2d

% Clear and close everything
clear all; clc; close all;

% Add paths to functions
addpath(genpath(strcat(pwd, '/functions')));

% Define path for storing figures
figPath = [pwd, '/../figures/'];
filename = 'plotArrayFactor';

% Define parameters =======================================================

% Sample zenith/azimuth-grid
anglesZenith  =  0:5:180;
anglesAzimuth = -270:5:-90;

spacingHorizontalLambda = 0.5;
spacingVerticalLambda   = 0.5;

saveAsFig = false;
saveAsPng = true;


% Pick horizontal weight vectors
weightsAHorizontal = exp(1i*[0, 0.9719, 1.8304, 4.9751, 0.162, 3.3382, 1.198].');
weightsBHorizontal = exp(1i*[0, 1.7538, 0.8581, 2.2056, 1.1222, 5.7473, 4.4064].');

% Pick vertical expanders
weightsAVertical = [1i, -1].';
weightsBVertical = [1, -1i].';

% Compute excitation weights ==============================================

fprintf( 'Compute beamforming weights... ' );


% Horizontal expansion
[weightAHorTmp, weightBHorTmp] =...
  performExpansion1d(weightsAHorizontal, weightsBHorizontal, 1);

% Vertical expansion
[weightAVerTmp, weightBVerTmp] =...
  performExpansion1d(weightsAVertical, weightsBVertical, 3);

% Combining vector weights into beamforming matrices
weightsA = [weightAVerTmp*weightAHorTmp.';...
  -flip(conj(weightBVerTmp))*weightBHorTmp.'];
weightsB = [weightBVerTmp*weightAHorTmp.';...
  flip(conj(weightAVerTmp))*weightBHorTmp.'];

% Antenna array configuration
nAntennasVertical = size(weightsA, 1);
nAntennasHorizontal = size(weightsA, 2);


fprintf( 'DONE!\n');
fprintf( 'Array configuration:  %dx%d\n', nAntennasVertical, nAntennasHorizontal);


% Compute array factor ====================================================

fprintf( 'Compute array factor... ' );


% Compute steering vectors
steeringVecHor = exp((linspace(0, nAntennasHorizontal-1, nAntennasHorizontal).'...
  + (nAntennasHorizontal-1)/2)*1i*2*pi*spacingHorizontalLambda*sind(anglesAzimuth(:).'));
steeringVecVer = exp((linspace(0, nAntennasVertical-1, nAntennasVertical).'...
  + (nAntennasVertical-1)/2)*1i*2*pi*spacingVerticalLambda*sind(anglesZenith(:).'));

% Compute array factor
nAnglesZenith = length(anglesZenith);
nAnglesAzimuth = length(anglesAzimuth);
arrayFactor = NaN(nAnglesZenith, nAnglesAzimuth);
for iZenith = 1:nAnglesZenith
  for iAzimuth = 1:nAnglesAzimuth
    steeringMat = kron(steeringVecHor(:, iAzimuth).', steeringVecVer(:, iZenith));
    arrayFactor(iZenith, iAzimuth) =...
      abs(trace(weightsA.'*steeringMat))^2 + abs(trace(weightsB.'*steeringMat))^2;
  end
end

fprintf( 'DONE!\n');


% Plot and save figures ===================================================

fprintf( 'Plot figure... ' );


% Plot the figure
fig = figure;
[phi, theta] = meshgrid(pi/180*anglesAzimuth, pi/180*(90-anglesZenith));
[x, y, z] = sph2cart(phi, theta, arrayFactor/max(max(arrayFactor)));
plotPatternSphere = surf(x, y, z, 'FaceColor', 'red', 'FaceAlpha', 1);
plotPatternSphere.EdgeColor = 'k';

% Set axes and styles
xlabel('$x$', 'interpreter', 'latex')
ylabel('$y$', 'interpreter', 'latex')
zlabel('$z$', 'interpreter', 'latex')
axis equal

ax = gca;
set(gca, 'xtick', [-1:0.5:0])
set(gca, 'ytick', [-1:0.5:1])
set(gca, 'ztick', [-1:0.5:1])
grid(ax, 'on')
set(gca, 'xlim', [-1, 0])
set(gca, 'ylim', [-1, 1])
set(gca, 'zlim', [-1, 1])

set(fig, 'Units', 'Inches');
pos = get(fig, 'Position');
set(fig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [ceil(pos(3)), ceil(pos(4))])

camlight right;
set(gcf, 'color', 'w');

  
% Save the figure
if saveAsFig
  savefig(fig, [figPath, filename,...
    num2str(nAntennasVertical), 'x', num2str(nAntennasHorizontal), '.fig']);
end
if saveAsPng
  print(fig, '-dpng', '-r300', [figPath, filename,...
    num2str(nAntennasVertical), 'x', num2str(nAntennasHorizontal), '.png']);
end


fprintf( 'DONE!\n.' );


end