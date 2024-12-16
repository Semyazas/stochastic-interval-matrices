% Function that adds paths to MATLAB path.

function start_stochm()
    % Get the full path of the current file
    fullPath = which("start_stochm");
    
    % Extract the directory part of the full path
    [path, ~, ~] = fileparts(fullPath);

    % Add subdirectories to the MATLAB path
    addpath(fullfile(path, 'irreducibility'))
    addpath(fullfile(path, 'stationary_distribution'))
    addpath(fullfile(path, 'bounds'))
    addpath(fullfile(path, 'experiments'))
    addpath(fullfile(path, 'reccurence_transience'))

    fprintf('Paths added successfully.\n');
end