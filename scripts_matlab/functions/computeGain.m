function methodData = computeGain(methodData)
%
% COMPUTEGAIN Compute antenna gain and array factor for a given array 
% configuration and given excitation weights.
%
%     The computation is based on the element model given in 3GPP TR 36.873.
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

% Read parameters
nAntennas           = methodData.nAntennas;
spacingLambda       = methodData.spacingLambda;
weightsA            = methodData.weightsA;
weightsB            = methodData.weightsB;
elementPointDirDeg  = methodData.elementPointDirDeg;
elementHpbwDeg      = methodData.elementHpbwDeg;
anglesDeg           = methodData.anglesDeg;

% Compute steering vector
steeringVec = exp((linspace(0, nAntennas-1, nAntennas).'...
  + (nAntennas-1)/2)*1i*2*pi*spacingLambda*sind(anglesDeg(:).'));

% Compute array factors
if length(weightsA) == nAntennas
  arrayFactorA = abs(weightsA.'*steeringVec(1:nAntennas,:)).^2;
  arrayFactorB = abs(weightsB.'*steeringVec(1:nAntennas,:)).^2;
  arrayFactorTotal = arrayFactorA + arrayFactorB;
else
  error('Wrong weight vector length!');
end

% Radiation pattern of an element
elementGainFunctionDb = inline('-min(12*( (x-offset)./hpbw).^2, 30)', 'x', 'offset', 'hpbw');
elementPatternDb = 8 + elementGainFunctionDb(anglesDeg, elementPointDirDeg, elementHpbwDeg);
elementPattern = 10.^(elementPatternDb/10);

% Compute antenna gains (normalized for EIRP plots)
gainA = 1/(2*nAntennas) * arrayFactorA .* elementPattern;
gainB = 1/(2*nAntennas) * arrayFactorB .* elementPattern;
gainTotal = 1/(2*nAntennas) * arrayFactorTotal .* elementPattern;

% Convert gains to dB
gainADb = 10*log10(gainA);
gainBDb = 10*log10(gainB);
gainTotalDb = 10*log10(gainTotal);

% Determine HPBW
iAngle = find(gainTotal>=0.5*max(gainTotal));
totalHpbw = angle(max(iAngle)) - angle(min(iAngle));

% Pass the results outside
methodData.gainADb = gainADb;
methodData.gainBDb = gainBDb;
methodData.gainTotalDb = gainTotalDb;
methodData.elementPatternDb = elementPatternDb;
methodData.totalHpbw = totalHpbw;
methodData.arrayFactorA = arrayFactorA;
methodData.arrayFactorB = arrayFactorB;
methodData.arrayFactorTotal = arrayFactorTotal;
end