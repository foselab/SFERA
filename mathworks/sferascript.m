clc
clearvars

rng('default')

% --- Load signal ---
data = load('firstfault.mat');
y_data = data.actual_speed_fault.signals.values;

[y, idx] = cleanSignal(y_data, 'adaptive');


% --- Automatic segmentation, built-in function (1° method) ---
% changePts = matlabSegmentation(y);

% --- Automatic segmentation, derivative-based (2° method) ---
%changePts = dySegmentation(y);

% --- Automatic segmentation, sliding window (3° method) ---
%  changePts = swSegmentation(y, 'rms');

% --- Automatic segmentation, uniform (4° method) ---
changePts = uniformSegmentation(y, 20);

% --- create segments ---
segments = cell(length(changePts)-1,1);
for k = 1:length(segments)
    segments{k} = y(changePts(k):changePts(k+1)-1);
end

% --- Analisys ---
N = length(segments);
result = cell(N, 2);

for k = 1:N
    seg = segments{k};
    [isDiv, howDiv] = isDivergent(seg);
    result{k,1} = isDiv;
    result{k,2} = howDiv;
end

