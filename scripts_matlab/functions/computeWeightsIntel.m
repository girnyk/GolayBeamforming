function weights = computeWeightsIntel(nAntennas, spacingLambda, p, c)
%
% COMPUTEWEIGHTSINTEL Compute phase-only excitation weights based on the 
% broadener function method.
%
%     The computation is based on the method proposed by Intel in
%     contribution 3GPP R1-1611929, available at:
%     https://www.3gpp.org/ftp/tsg_ran/WG1_RL1/TSGR1_87/Docs/R1-1611929.zip
%
%     Inputs:     scalar nAntennas = array size
%                 scalar spacingLambda = antenna spacing in wavelengths
%                 scalars p, c = optimization parameters
%     Outputs:    vec weights = vector of excitation weights
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

% Base DFT beam
arrayPointDirDeg = 90;      % good pointing direction candidate
weightsDft = exp( 2i*pi * (0:(nAntennas-1)).'...
  *spacingLambda * sind(arrayPointDirDeg) );

% Compute broadener function from 3GPP R1-1611929
iAntenna = [0 :nAntennas-1].';
broadener = abs( 4*pi*c * ( 1/(2*(nAntennas-1))...
  +(iAntenna-nAntennas/2)/(nAntennas-1) ).^p );

% Beamforming weights
weights  = exp(1i*broadener) .* weightsDft;
end