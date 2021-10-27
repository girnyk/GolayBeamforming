% =========================================================================
%
% Cell-specific beamforming for large antenna arrays
%
% Dual polarization, Golay pairs and epsilon-complementarity
% Measurement plots
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

function PlotResultsMeas

% Clear and close everything
clear all; clc; close all;

% Add paths to data
addpath(genpath(strcat(pwd, '\..\data')));

% Define path for storing figures
figPath = [pwd, '\..\figures\'];
dataPath = [pwd, '\..\data\'];


fprintf( 'Determine plots and cases... ' );


% Specify figures to plot =================================================
figData = {};

% Figure 7b: Deviation in realized gain between subarrays and average subarray
figData{end+1} = {};
figData{end}.casename               = 'CdfMeasSubarray';
figData{end}.plotType               = 'CDF';
figData{end}.location               = 'NorthWest';
figData{end}.color1                 = [0, 0, 1];
figData{end}.color2                 = [1, 0, 0];
figData{end}.legendName1            = 'Polarization A';
figData{end}.legendName2            = 'Polarization B';
figData{end}.xlim                   = [-2, 2];
figData{end}.ylim                   = [0, 1];
figData{end}.xlabel                 = 'Deviation from mean gain [dB]';
figData{end}.ylabel                 = 'C.d.f.';
figData{end}.xtick                  = [-2:2];
figData{end}.ytick                  = [0:0.2:1];
figData{end}.saveAsFig              = false;
figData{end}.saveAsPdf              = true;
figData{end}.saveAsEmf              = false;

% Figure 8b: Deviation in realized gain between the entire array and average subarray
figData{end+1} = {};
figData{end}.casename               = 'CdfMeasArray';
figData{end}.plotType               = 'CDF';
figData{end}.location               = 'off';
figData{end}.color1                 = [0, 0.5, 0];
figData{end}.legendName1            = 'Entire array';
figData{end}.xlim                   = [-2, 2];
figData{end}.ylim                   = [0, 1];
figData{end}.xlabel                 = 'Deviation from mean gain [dB]';
figData{end}.ylabel                 = 'C.d.f.';
figData{end}.xtick                  = [-2:2];
figData{end}.ytick                  = [0:0.2:1];
figData{end}.saveAsFig              = false;
figData{end}.saveAsPdf              = true;
figData{end}.saveAsEmf              = false;

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
  
  load([dataPath, 'data', figData{iFig}.casename, '.mat']);
  
  % Plot curves
  switch(figData{iFig}.casename)
    case 'CdfMeasSubarray'
      plot(deviationPolA, cdfPolA,...
        'color', figData{iFig}.color1,...
        'DisplayName', figData{iFig}.legendName1);
      plot(deviationPolB, cdfPolB,...
        'color', figData{iFig}.color2,...
        'DisplayName', figData{iFig}.legendName2);
      legend(gca, 'show', 'Location', figData{iFig}.location);
    case 'CdfMeasArray'
      plot(deviationArray, cdfArray,...
        'color', figData{iFig}.color1);
  end
  
  % Put text on the figure
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
    savefig(fig, [figPath, 'plot', figData{iFig}.casename, '.fig']);
  end
  if figData{iFig}.saveAsPdf
    print(fig, '-dpdf', [figPath, 'plot', figData{iFig}.casename, '.pdf']);
  end
  if figData{iFig}.saveAsEmf
    print(fig, '-dmeta', [figPath, 'plot', figData{iFig}.casename, '.emf']);
  end
  
end


fprintf( 'DONE!\n' );


end