% File: expDivergenceOptions.m
classdef expDivergenceOptions < options
    %EXPDIVERGENCEOPTIONS Options for exponential fitting

    properties
        % --- Parameters bounds ---
        lb double = [-Inf, -Inf, -Inf];
        ub double = [Inf, Inf, Inf];

        % --- Initial guesses ---
        params0 double = [1, 1, -0.00001]

        % --- Optimization parameters ---
        tolFun double = 1e-6;
        maxIter double = 1000;

        % --- Plot options ---
        showPlot logical = false;
    end

    methods
        function obj = expDivergenceOptions(varargin)
            if nargin > 0
                for i = 1:2:numel(varargin)
                    if isprop(obj, varargin{i})
                        obj.(varargin{i}) = varargin{i+1};
                    else
                        warning('Unknown property: %s', varargin{i});
                    end
                end
            end
        end
    end

end

