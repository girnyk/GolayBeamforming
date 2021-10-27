function [weightsA, weightsB] = performExpansion1d(weightsA, weightsB, expansionFactor)
%
% PERFORMEXPANSION1D Compute excitation weights for an expanded array
% obtained by expansion of a protoarray, while preserving radiation pattern
% of the latter.
%
%     The computation is based on the element model given in 3GPP TR 36.873,
%     and a simple pathloss model with pathloss exponent.
%     Sngle-sector deployment is assumed. The spectral efficiency is 
%     averaged over a number of user equipment locations.
%
%     Inputs:     vecs [weightsA, weightsB] = excitation weights of a protoarray
%                 expansionFactor scalar = number of expansions performed
%     Outputs:    vecs [weightsA, weightsB] = excitation weights of the expanded array
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

if (expansionFactor>0)
  for iter = 1:expansionFactor
    % Get protoarray weights
    weightsAtmp = weightsA;
    weightsBtmp = weightsB;
    
    % Stack weights according to (18)
    weightsA = [weightsAtmp; -flip(conj(weightsBtmp))];
    weightsB = [weightsBtmp;  flip(conj(weightsAtmp))];
  end
end
end