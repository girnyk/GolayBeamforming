function methodData = computeAacf(methodData)
%
% COMPUTEAACF Compute the sum aperiodic autocorrelation function of a pair
% of sequences/weight vectors.
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

% Get parameters
nAntennas = methodData.nAntennas;
weightsA = methodData.weightsA;
weightsB = methodData.weightsB;

% Compute AACF
lags = [-nAntennas+1:nAntennas-1];
aacfA = xcorr(weightsA);
aacfB = xcorr(weightsB);
aacfTotal = aacfA + aacfB;

% Pass the results outside
methodData.lags = lags;
methodData.aacfA = aacfA;
methodData.aacfB = aacfB;
methodData.aacfTotal = aacfTotal;
end