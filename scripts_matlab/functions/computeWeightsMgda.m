function [weightsA, weightsB] = computeWeightsMgda(nAntennas, varargin)
%
% COMPUTEWEIGHTSMGDA Compute an polyphase epsilon-complementary pair of 
% sequences/weight vectors of a given length.
%
%     Inputs:     scalar nAntennas = length of the desired sequences
%                 (scalar epsilon = tolerance to AACF sidelobes)
%                 (bool verbose = show intermediary output?)
%                 (scalar phaseScaling = scaling of the step size - alpha)
%                 (scalar nIterationsMax = max number of iterations for stopping)
%                 (scalar nUnsuccessfulItersMax = max number of iterations for
%                 invoking zoom out exploration - d_max)
%                 (scalar rainIntensity = speed of flooding - V)
%     Outputs:    vecs [weightsA, weightsB] = obtained pair of sequences
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

% Default parameter values
epsilon               = 0.01;
verbose               = true;
phaseScaling          = 0.99;
nIterationsMax        = 1e4;
nUnsuccessfulItersMax = 1e3;
rainIntensity         = 0.5;

% Read optional parameters
try
  epsilon               = varargin{1};
  verbose               = varargin{2};
  phaseScaling          = varargin{3};
  nIterationsMax        = varargin{4};
  nUnsuccessfulItersMax = varargin{5};
  rainIntensity         = varargin{6};
end

% Initialize parameters
nPhases = 2*nAntennas;
phase = rand(nPhases,1)*2*pi;
dPhase = 2*pi*rand(nPhases,1);
nUnsuccessfulAlts = 0;
waterLevel = utilityFunction(phase);
utility = utilityFunction(phase);
onLand = (utility >= waterLevel);
nTrials = 0;  
iteration = 0;
nUnsuccessfulIters = 0;

if verbose
  fprintf('Phases: %g, \n', phase);
  fprintf('Phase increments: %g, \n', dPhase);
  fprintf('Water level: %g,\n', waterLevel);
  fprintf('On land: %d,\n', onLand);
end

fprintf( 'Start MGDA optimization...\n' );
fprintf( '==========================\n' );

% Run MGDA
while (abs(utility) > epsilon) && (iteration < nIterationsMax)
  
  % Zooming-in local exploration
  nDrySteps = 0;
  utilityOld = utility;
  phasePerm = randperm(nPhases);
  for i = 1:nPhases
    n = phasePerm(i);
    phase(n) = phase(n) + dPhase(n);
    utility = utilityFunction(phase);
    onLand = (utility >= waterLevel);
    
    % Increase water level
    if onLand
      waterVolume = rainIntensity*abs(waterLevel-utility);
      waterLevel = waterLevel + waterVolume;
      nDrySteps = nDrySteps + 1;
    else
      dPhase(n) = -dPhase(n);
      phase(n) = phase(n) + dPhase(n);
    end
    utility = computeUtilityFunction(phase);
    onLand = (utility >= waterLevel);
    
  end
  
  if utility == utilityOld
    nTrials = nTrials + 1;
  end
  if nTrials > 1
    nDrySteps = 0;
  end
  if nDrySteps == 0
    nUnsuccessfulAlts = nUnsuccessfulAlts + 1;
    if nUnsuccessfulAlts  > 1
      for n = 1:nPhases
        dPhase(n) = phaseScaling*dPhase(n);
      end
    end
  else
    nUnsuccessfulAlts = 0;
  end
  
  % Zooming-out global exploration
  if nUnsuccessfulIters >= nUnsuccessfulItersMax
    dPhase = -2*pi*rand(nPhases, 1);
    phase = phase + dPhase;
    waterLevel = computeUtilityFunction(phase);
    utility = computeUtilityFunction(phase);
    onLand = (utility >= waterLevel);
    nUnsuccessfulIters = 0;
  end
  
  nUnsuccessfulIters = nUnsuccessfulIters + 1;
  iteration = iteration + 1;
  
  if verbose
    fprintf('Interation #%d,\n', iteration);
    fprintf('Unsuccessul iterations: %g,\n', nUnsuccessfulIters);
    fprintf('Utility value: %g,\n', utility);
    fprintf('Water level: %g,\n', waterLevel);
    fprintf('On land: %d,\n', onLand);
    fprintf('Number of dry steps: %g,\n', nDrySteps);
    fprintf( '==========================\n' );
  end
  
end

% Report optimization results
if onLand
  weight = exp(1i*phase);
  weightsA = floor(1e4*weight(1:floor(nPhases/2)))*1e-4;
  weightsB = floor(1e4*weight(floor(nPhases/2)+1:end))*1e-4;
  fprintf('Done!\n');
  if verbose
    fprintf('Optimal weights:\n');
    fprintf('weights_A: \n');
    fprintf('%g \n', weightsA);
    fprintf('weights_B: \n');
    fprintf('%g \n', weightsB);
  end
else
  fprintf('Drowned in water :( \n');
end

end

function utility = computeUtilityFunction(phase)
% COMPUTEUTILITYFUNCTION Compute the utility function in (46)

% Reconstruct weights from phases
weight = exp(1i*phase);
lWeight = length(weight);
weightA = weight(1:floor(lWeight/2));
weightB = weight(floor(lWeight/2)+1:end);

% Compute AACFs
aacfA = xcorr(weightA);
aacfB = xcorr(weightB);
aacfSum = aacfA + aacfB;
aacfSidelobes = aacfSum;

% Compute utility function
lAacf = length(aacfSum);
aacfSidelobes(ceil(lAacf/2)) = [];
utility = -max(abs(aacfSidelobes));
end