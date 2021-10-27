# Efficient Cell-Specific Beamforming for Large Antenna Arrays
This repository contains the codes for producing the figures from the following paper:
M. A. Girnyk and S. O. Petersson, "[Efficient Cell-Specific Beamforming for Large Antenna Arrays](https://ieeexplore.ieee.org/abstract/document/9540836)," *IEEE Transactions on Communications*, To appear. 

## Abstract
We propose an efficient method for designing broad beams with spatially flat array factor and efficient power utilization for cell-specific coverage in communication systems equipped with large antenna arrays. To ensure full power efficiency, the method is restricted to phase-only weight manipulations. Our framework is based on the discovered connection between dual-polarized beamforming and polyphase Golay sequences. Exploiting this connection, we propose several methods for array expansion from smaller to larger sizes, while preserving the radiation pattern. In addition, to fill the gaps in the feasible array sizes, we introduce the concept of ϵ-complementarity that relaxes the requirement on zero side lobes of the sum aperiodic autocorrelation function of a sequence pair. Furthermore, we develop a modified Great Deluge algorithm (MGDA) that finds ϵ-complementary pairs of arbitrary length, and hence enables broad beamforming for arbitrarily-sized uniform linear arrays. We also discuss the extension of this approach to two-dimensional uniform rectangular arrays. Our numerical results demonstrate the superiority of the proposed approach with respect to existing beam-broadening methods.

## Preprint 
A preprint of the article available at https://arxiv.org/pdf/2110.05214.pdf. 

## Software requirements
The codes have been developed in Matlab 2015a and do not require additional packages. They generate all the result figures from the paper (with the exception of those showing measured radiation patterns of a real antennas).

## License
This code is licensed under the Apache-2.0 license. If you use this code in any way for research that results in a publication, please cite the above paper.

