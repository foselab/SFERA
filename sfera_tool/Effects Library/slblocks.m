function blkStruct = slblocks
%SLBLOCKS Define Simulink library block for Effects Library
%
%   This function defines the block library "Effects Library" for
%   Simulink. It allows Simulink to recognize and display the library
%   and its blocks in the Simulink Library Browser.
%
%   The library includes custom blocks such as:
%       - isRunge: checks if a method is of Runge type
%       - isPermOscillating: checks if a system is permanently oscillating
%       - (other blocks implemented in 'functions' folder)
%
%   The 'functions' folder is automatically added to MATLAB path
%   so that all custom blocks are available in the library.

    % Define library name shown in Simulink Library Browser
    blkStruct.Name = 'Effects Library'; 

    % Function to open the library when double-clicked
    blkStruct.OpenFcn = 'mweffectlib'; 

    % Mask display (icon) shown in the library
    blkStruct.MaskDisplay = 'disp(''mweffectlib'')';

    % Add automatically 'functions' folder (and subfolders) to MATLAB path
    addpath(genpath(fullfile(fileparts(mfilename('fullpath')), 'functions')));
end