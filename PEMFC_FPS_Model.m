function [augSys,eig_Aug,epsilon,TS_size] = PEMFC_FPS_Model
% Model definition for PEMFC-FPS system.
% OUTPUT: augSys -> Augmented PEMFC-FPS state-space model
%         eigAug -> Eigenvalues of the augmented model 

% PEMFC state-space matrices
A_PEM = [-6.3091 0 -10.954 0 83.7446 0 0 24.0587;...
		 0 -161.08 0 0 51.5292 0 -18.026 0;...
		-18.786 0 -46.314 0 275.659 0 0 158.374;...
		0 0 0 -17.351 193.937 0 0 0;...
		1.2996 0 2.9693 0.3977 -38.702 0.1057 0 0;...
		16.6424 0 38.0252 5.0666 -479.38 0 0 0;...
		0 -450.39 0 0 142.208 0 -80.947 0;...
		2.0226 0 4.6212 0 0 0 0 -51.211];
B_PEM = [0 0 0 3.9467 0 0 0 0 ]';
C_PEM = [0 0 0 5.0666 -116.45 0 0 0; 0 0 0 0 1 0 0 0; 12.9699 10.3235 -0.5693 0 0 0 0 0];

% FPS state-space matrices
A_FPS = [-0.074 0 0 0 0 0 -3.53 1.0748 0 1e-6;...
		0 -1.468 -25.3 0 0 0 0 0 2.5582 13.911;...
		0 0 -156 0 0 0 0 0 0 33.586;...
		0 0 0 -124.5 212.63 0 112.69 112.69 0 0;...
		0 0 0 0 -3.333 0 0 0 0 0;...
		0 0 0 0 0 -32.43 32.304 32.304 0 0;...
		0 0 0 0 0 331.8 -344 -341 0 9.9042;...
		0 0 0 221.97 0 0 -253.2 -254.9 0 32.526;...
		0 0 2.0354 0 0 0 1.8309 1.214 -0.358 -3.304;...
		0.0188 0 8.1642 0 0 0 5.6043 5.3994 0 -13.61];
B_FPS = [0 0 0 0 0.12 0 0 0 0 0;
		0 0 0 0 0 0.1834 0 0 0 0]';
C_FPS = [1 0 0 0 0 0 0 0 0 0; 0 0.994 -0.088 0 0 0 0 0 0 0];

% Augmented system
A_aug = [A_PEM zeros(8,10); zeros(10,8) A_FPS];
B_aug = [B_PEM zeros(8,1); B_FPS];
C_aug = [C_PEM zeros(3,10); zeros(2,8) C_FPS];

% Create augmented system struct
augSys.A = A_aug;
augSys.B = B_aug;
augSys.C = C_aug;

%% Eigenvalue separation used to define the time-scales

% Calculate eigenvalues of the system
eig_Aug = eig(A_aug);
abs_Eig = abs(eig_Aug);

% Sort magnitude of eigenvalues
abs_EigSort = sort(abs_Eig);

% Evaluate epsilon based on separation (arbitrary)
epsilon.eps1 = abs_EigSort(9)/abs_EigSort(10);
epsilon.eps2 = abs_EigSort(9)/abs_EigSort(16);

% Define time-scale sizes vector
TS_size = [9, 6, 3];



