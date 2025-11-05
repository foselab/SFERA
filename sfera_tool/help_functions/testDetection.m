clc
clearvars

% This is a file used for testing and debugging.
y = load('signals.mat');
diff = y.yWin{1,6};
diff_clean = cleanSignal(diff);

t = 1: length(diff_clean);

%plot(t,diff_clean);
isDiv = exp2(diff_clean);