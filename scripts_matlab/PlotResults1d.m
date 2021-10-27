% =========================================================================
%
% Cell-specific beamforming for large antenna arrays
%
% Dual polarization, Golay pairs and epsilon-complementarity
% One-dimensional plots
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

function PlotResults1d

% Clear and close everything
clear all; clc; close all;

% Add paths to functions
addpath(genpath(strcat(pwd, '/functions')));

% Define path for storing figures
figPath = [pwd, '/../figures/'];

% Define parameters =======================================================
nAntennas = 7;                      % number of antennas
nAngles = 720;                      % plotting grid resolution
anglesDeg = linspace(-90, 90, nAngles); % angle grid in degrees
spacingLambda = 0.5;                % antenna spacing in wavelengths
elementHpbwDeg = 90;                % half-power beamwidth of an element
elementPointDirDeg = 0;             % pointing direction of an element
arrayPointDirDeg = 0;               % pointing direction of the array
snrsDb = -10:10;                    % signal-to-noise ratio range


fprintf( 'Determine plots and cases... ' );


% Specify figures to plot =================================================
figData = {};

% Figure 3a: Aperiodic autocorrelation function ---------------------------
figData{end+1} = {};
figData{end}.filename               = 'plotAacf';
figData{end}.methodsToPlot          = {'GOLAY'};
figData{end}.plotType               = 'AACF';
figData{end}.includePolarizations   = true;
figData{end}.location               = 'South';
figData{end}.xlim                   = [-nAntennas+1, nAntennas-1];
figData{end}.ylim                   = [-5, 2*nAntennas+1];
figData{end}.xlabel                 = 'Lag, $\tau$';
figData{end}.ylabel...
  = 'AACF, $\mathrm{Re} \{R_{\mathbf{w}_A}(\tau) + R_{\mathbf{w}_B}(\tau)\}$';
figData{end}.xtick                  = [-nAntennas+1:2: nAntennas-1];
figData{end}.ytick                  = [-5:5:2*nAntennas+1];
figData{end}.saveAsFig              = false;
figData{end}.saveAsPdf              = true;
figData{end}.saveAsEmf              = false;


% Figure 3b: Array factor -------------------------------------------------
figData{end+1} = {};
figData{end}.filename               = 'plotArrayFactor';
figData{end}.methodsToPlot          = {'GOLAY'};
figData{end}.plotType               = 'ARRAY_FACTOR';
figData{end}.includePolarizations   = true;
figData{end}.location               = 'North';
figData{end}.xlim                   = [-90, 90];
figData{end}.ylim                   = [0, 20];
figData{end}.xlabel                 = 'Azimuth angle, $\phi$ [deg]';
figData{end}.ylabel                 = 'Array factor, $|A(\phi)|^2$';
figData{end}.xtick                  = [-90:30:90];
figData{end}.ytick                  = [0:5:20];
figData{end}.saveAsFig              = false;
figData{end}.saveAsPdf              = true;
figData{end}.saveAsEmf              = false;


% Figure 4: Beam pattern --------------------------------------------------
figData{end+1} = {};
figData{end}.filename               = 'plotBeamPattern';
figData{end}.methodsToPlot          = {'GOLAY', 'INTEL', 'QIAO', 'DFT', 'ELEMENT'};
figData{end}.plotType               = 'BEAM_PATTERN';
figData{end}.includePolarizations   = false;
figData{end}.location               = 'NorthEast';
figData{end}.xlim                   = [-90, 90];
figData{end}.ylim                   = [-15, 20];
figData{end}.xlabel                 = 'Azimuth angle, $\phi$ [deg]';
figData{end}.ylabel                 = 'EIRP [dBW]';
figData{end}.xtick                  = [-90:30:90];
figData{end}.ytick                  = [-15:5:20];
figData{end}.saveAsFig              = false;
figData{end}.saveAsPdf              = true;
figData{end}.saveAsEmf              = false;


% Figure 5: Spectral efficiency -------------------------------------------
figData{end+1} = {};
figData{end}.filename               = 'plotSpectralEfficiency';
figData{end}.methodsToPlot          = {'GOLAY', 'INTEL', 'QIAO', 'DFT', 'ELEMENT'};
figData{end}.plotType               = 'SPECTRAL_EFFICIENCY';
figData{end}.includePolarizations   = false;
figData{end}.location               = 'NorthWest';
figData{end}.xlim                   = [-10, 10];
figData{end}.ylim                   = [0, 8];
figData{end}.xlabel                 = 'Signal-to-noise ratio, $\rho$ [dB]';
figData{end}.ylabel                 = 'Average spectral efficiency, $C(\rho)$ [bps/Hz]';
figData{end}.xtick                  = [-10:5:10];
figData{end}.ytick                  = [0:1:8];
figData{end}.saveAsFig              = false;
figData{end}.saveAsPdf              = true;
figData{end}.saveAsEmf              = false;


% Specify methods of interest =============================================
methodData = {};

% Method 1: Epsilon-complementary beam ------------------------------------
methodData{end+1} = {};
methodData{end}.name                = 'GOLAY';
methodData{end}.legendName          = 'Proposed method';
methodData{end}.nAntennas           = nAntennas;
methodData{end}.spacingLambda       = spacingLambda;
methodData{end}.elementHpbwDeg      = elementHpbwDeg;
methodData{end}.elementPointDirDeg  = elementPointDirDeg;
methodData{end}.arrayPointDirDeg    = arrayPointDirDeg;
methodData{end}.anglesDeg           = anglesDeg;
methodData{end}.snrsDb              = snrsDb;
methodData{end}.lineColor           = [1, 0, 0];
methodData{end}.lineStyle           = '-';
methodData{end}.markerType          = 'none';
methodData{end}.markerSize          = 6;
methodData{end}.lineWidth           = 1.2;

% Per-polarization weights
methodData{end}.weightsA...
  = exp(1i*[0, 0.9719, 1.8304, 4.9751, 0.162, 3.3382, 1.198].');
methodData{end}.weightsB...
  = exp(1i*[0, 1.7538, 0.8581, 2.2056, 1.1222, 5.7473, 4.4064].');

% epsilon = 0.02 *nAntennas;
% [weightsA, weightsB] = computeWeightsMgda(nAntennas, epsilon, false);
% methodData{end}.weightsA = weightsA;
% methodData{end}.weightsB = weightsB;


% Method 2: Phase-tapering beam -------------------------------------------
methodData{end+1} = {};
methodData{end}.name                = 'INTEL';
methodData{end}.legendName          = 'Phase taper [12]';
methodData{end}.nAntennas           = nAntennas;
methodData{end}.spacingLambda       = spacingLambda;
methodData{end}.elementHpbwDeg      = elementHpbwDeg;
methodData{end}.elementPointDirDeg  = elementPointDirDeg;
methodData{end}.arrayPointDirDeg    = arrayPointDirDeg;
methodData{end}.anglesDeg           = anglesDeg;
methodData{end}.snrsDb              = snrsDb;
methodData{end}.lineColor           = [0, 0, 1];
methodData{end}.lineStyle           = '--';
methodData{end}.markerType          = 'none';
methodData{end}.markerSize          = 6;
methodData{end}.lineWidth           = 1.2;

% Compute weights via 3GPP R1-1611929
p = 3; c = 24;                % optimized broadener parameters
weightsIntel = computeWeightsIntel(methodData{end}.nAntennas,...
  methodData{end}.spacingLambda, p, c);

% Per-polarization weights
methodData{end}.weightsA  = weightsIntel;
methodData{end}.weightsB  = weightsIntel;

% Method 3: Amplitude-tapering beam ---------------------------------------
methodData{end+1} = {};
methodData{end}.name                = 'QIAO';
methodData{end}.legendName          = 'Ampl. taper [7]';
methodData{end}.nAntennas           = nAntennas;
methodData{end}.spacingLambda       = spacingLambda;
methodData{end}.elementHpbwDeg      = elementHpbwDeg;
methodData{end}.elementPointDirDeg  = elementPointDirDeg;
methodData{end}.arrayPointDirDeg    = arrayPointDirDeg;
methodData{end}.anglesDeg           = anglesDeg;
methodData{end}.snrsDb              = snrsDb;
methodData{end}.lineColor           = [0, 0.5, 0];
methodData{end}.lineStyle           = '-.';
methodData{end}.markerType          = 'none';
methodData{end}.markerSize          = 6;
methodData{end}.lineWidth           = 1.2;

% Weights obtained via Qiao et al., "Broadbeam for massive MIMO systems"
% (https://arxiv.org/abs/1503.06882)
weightsQiao = ...
  [-0.1042 + 0.0116i
  0.0073 + 0.4530i
  1.0000 + 0.0000i
  -0.0167 - 0.8769i
  1.0000 + 0.0000i
  0.0073 + 0.4530i
  -0.1042 + 0.0116i];

% Per-polarization weights
methodData{end}.weightsA  = weightsQiao;
methodData{end}.weightsB  = weightsQiao;


% Method 4: DFT beam ------------------------------------------------------
methodData{end+1} = {};
methodData{end}.name                = 'DFT';
methodData{end}.legendName          = 'DFT beam';
methodData{end}.nAntennas           = nAntennas;
methodData{end}.spacingLambda       = spacingLambda;
methodData{end}.elementHpbwDeg      = elementHpbwDeg;
methodData{end}.elementPointDirDeg  = elementPointDirDeg;
methodData{end}.arrayPointDirDeg    = arrayPointDirDeg;
methodData{end}.anglesDeg           = anglesDeg;
methodData{end}.snrsDb              = snrsDb;
methodData{end}.lineColor           = [0, 0, 0];
methodData{end}.lineStyle           = '-';
methodData{end}.markerType          = 'none';
methodData{end}.markerSize          = 6;
methodData{end}.lineWidth           = 1;

weightsDft = exp( 2i*pi * (0:(methodData{end}.nAntennas-1)).'...
  *methodData{end}.spacingLambda * sind(methodData{end}.arrayPointDirDeg) );

% Per-polarization weights
methodData{end}.weightsA  = weightsDft;
methodData{end}.weightsB  = weightsDft;


% Method 5: Element pattern -----------------------------------------------
methodData{end+1} = {};
methodData{end}.name                = 'ELEMENT';
methodData{end}.legendName          = 'Element';
methodData{end}.nAntennas           = 1;
methodData{end}.spacingLambda       = spacingLambda;
methodData{end}.elementHpbwDeg      = elementHpbwDeg;
methodData{end}.elementPointDirDeg  = elementPointDirDeg;
methodData{end}.arrayPointDirDeg    = arrayPointDirDeg;
methodData{end}.anglesDeg           = anglesDeg;
methodData{end}.snrsDb              = snrsDb;
methodData{end}.lineColor           = [0, 0.7461, 1];
methodData{end}.lineStyle           = '-';
methodData{end}.markerType          = 'none';
methodData{end}.markerSize          = 6;
methodData{end}.lineWidth           = 1;

% Per-polarization weights (normalized for EIRP plots)
methodData{end}.weightsA = sqrt(1/nAntennas);
methodData{end}.weightsB = sqrt(1/nAntennas);


fprintf( 'DONE!\n' );
fprintf( 'Plot figures... ' );


% Plot and save figures ===================================================

% Loop over the figures
nFigs = length(figData);
for iFig = 1:nFigs
  fig = figure;
  hold all; grid on; box off;
  
  % Change default fonts
  set(0,'DefaultAxesFontName', 'Times');
  set(0,'DefaultAxesFontSize', 12);
  set(0,'DefaultTextFontname', 'Times');
  set(0,'DefaultTextFontSize', 12);
  
  % Loop over the methods
  nMethods = length(figData{iFig}.methodsToPlot);
  for iMethod = 1 : nMethods
    
    % Get index of the current method
    [~, methodIdx] = find(strcmp(cellfun(@(x) x.name, methodData, 'uni', 0),...
      figData{iFig}.methodsToPlot{iMethod}));
    
    % Get data to plot
    switch(figData{iFig}.plotType)
      case 'AACF'
        methodData{methodIdx} = computeAacf(methodData{methodIdx});
        xData = methodData{methodIdx}.lags;
        yDataTotal = real(methodData{methodIdx}.aacfTotal);
        if figData{iFig}.includePolarizations
          yDataA = real(methodData{methodIdx}.aacfA);
          yDataB = real(methodData{methodIdx}.aacfB);
        end
      case 'ARRAY_FACTOR'
        methodData{methodIdx} = computeGain(methodData{methodIdx});
        xData = methodData{methodIdx}.anglesDeg;
        yDataTotal = methodData{methodIdx}.arrayFactorTotal;
        if figData{iFig}.includePolarizations
          yDataA = methodData{methodIdx}.arrayFactorA;
          yDataB = methodData{methodIdx}.arrayFactorB;
        end
      case 'BEAM_PATTERN'
        methodData{methodIdx} = computeGain(methodData{methodIdx});
        xData = methodData{iMethod}.anglesDeg;
        yDataTotal = methodData{iMethod}.gainTotalDb;
        if figData{iFig}.includePolarizations
          yDataA = methodData{iMethod}.gainADb;
          yDataB = methodData{iMethod}.gainBDb;
        end
      case 'SPECTRAL_EFFICIENCY'
        methodData{methodIdx} = computeSpectralEfficiency(methodData{methodIdx});
        xData = methodData{iMethod}.snrsDb;
        yDataTotal = methodData{iMethod}.ueAvgSes;
        if figData{iFig}.includePolarizations
          yDataA = NaN(size(methodData{iMethod}.snrsDb));
          yDataB = NaN(size(methodData{iMethod}.snrsDb));
        end
    end
    
    % Plot curves
    plot(xData, yDataTotal,...
      'LineWidth', methodData{methodIdx}.lineWidth,...
      'LineStyle', methodData{methodIdx}.lineStyle,...
      'color', methodData{methodIdx}.lineColor,...
      'Marker', methodData{methodIdx}.markerType,...
      'MarkerSize', methodData{methodIdx}.markerSize,...
      'DisplayName', methodData{methodIdx}.legendName);
    if figData{iFig}.includePolarizations
      plot(xData, yDataA,...
        'LineWidth', methodData{methodIdx}.lineWidth,...
        'LineStyle', methodData{methodIdx}.lineStyle, ...
        'color', [0.6758, 0.8438, 0.8984], 'Marker', '.',...
        'MarkerSize', methodData{methodIdx}.markerSize,...
        'DisplayName', [ methodData{methodIdx}.legendName, ', Polarization A' ]);
      plot(xData, yDataB,...
        'LineWidth', methodData{methodIdx}.lineWidth,...
        'LineStyle', methodData{methodIdx}.lineStyle, ...
        'color', [1, 0.6445 , 0], 'Marker', '.',...
        'MarkerSize', methodData{methodIdx}.markerSize,...
        'DisplayName', [ methodData{methodIdx}.legendName, ', Polarization B' ]);
    end
  end
  
  % Put text on the figure
  legend(gca, 'show', 'Location', figData{iFig}.location);
  ylim(figData{iFig}.ylim);
  xlim(figData{iFig}.xlim);
  set(gca, 'xtick', figData{iFig}.xtick);
  set(gca, 'ytick', figData{iFig}.ytick);
  xlabel(figData{iFig}.xlabel, 'interpreter', 'latex');
  ylabel(figData{iFig}.ylabel, 'interpreter', 'latex');
  
  % Resize the figure
  set(fig, 'Units', 'Inches');
  pos = get(fig, 'Position');
  set(fig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
    'PaperSize', [ceil(pos(3)), ceil(pos(4))]);
  
  % Save the figure
  if figData{iFig}.saveAsFig
    savefig(fig, [figPath, figData{iFig}.filename,...
      num2str(nAntennas), '.fig']);
  end
  if figData{iFig}.saveAsPdf
    print(fig, '-dpdf', [figPath, figData{iFig}.filename,...
      num2str(nAntennas), '.pdf']);
  end
  if figData{iFig}.saveAsEmf
    print(fig, '-dmeta', [figPath, figData{iFig}.filename,...
      num2str(nAntennas), '.emf']);
  end
  
end


fprintf( 'DONE!\n.' );


end