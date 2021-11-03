function methodData = computeSpectralEfficiency(methodData)
%
% COMPUTESPECTRALEFFICIENCY Compute average spectral efficiency for a given 
% array configuration and given excitation weights.
%
%     The computation is based on the element model given in 3GPP TR 36.873,
%     and a simple pathloss model with pathloss exponent.
%     Sngle-sector deployment is assumed, the spectral efficiency is 
%     averaged over a number of user equipment locations within a sector.
%
%     Inputs:     struct methodData = struct of method parameters
%     Outputs:    struct methodData = struct of method parameters
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

nAngles = 720;        % sector angle grid resolution
setorAngles = linspace(-60, 60, nAngles);
ueDistanceMinM = 25;  % white hole radius
ueDistanceMaxM = 300; % cell radius
gammaDb = 57;         % all extra losses
nUeLocations = 1e4;   % number of locations to avg over

% Compute pathlosses
ueDistancesM = ueDistanceMinM...
  + sqrt(rand(1, nUeLocations))*(ueDistanceMaxM-ueDistanceMinM);
uePathlossesDb = -( 22*log10(ueDistancesM) );

% Get linear-scale values
snrs = [10.^(methodData.snrsDb/10)]';
gamma = 10.^(gammaDb/10);
uePathlosses = datasample(10.^(uePathlossesDb/10), nUeLocations);

% Get antenna pattern within the sector
methodData.anglesDeg = setorAngles;
methodData = computeGain(methodData);
ueGains = datasample(10.^(methodData.gainTotalDb/10), nUeLocations);

% Compute spectral efficiencies
ueSes = log2( 1 + gamma * snrs * (uePathlosses.*ueGains) );
ueAvgSes = mean(ueSes, 2);

% Pass the results outside
methodData.ueAvgSes = ueAvgSes;
end
