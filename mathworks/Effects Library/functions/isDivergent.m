
function [isDiv, howDiv] = isDivergent(y, customFunc, params0)
%
%   DESCRIPTION:
%   isDivergent(y, customFunc, params0) analyzes the signal y to determine if it exhibits any form 
%   of divergence or convergence pattern. If a custom function is provided, it will be 
%   used to check for divergence instead of the default analysis methods.
%
%   INPUTS:
%     y         - (Required) The input signal, represented as a vector of numerical values.
%     customFunc - (Optional) A user-defined function, specified either as a function handle 
%                  or a string with the function name. The function should accept y as input 
%                  and return [isDiv, howDiv] to indicate if y diverges and specify its type.
%                  ex. str = '@(params, x) params(1)*x+params(2)'
%     params0   - Initialization of the parameters of the custom
%                 function to be estimated. Required if the customFunc if passed.
%
%   OUTPUTS:
%     isDiv     - A logical or integer value indicating if divergence was detected.
%                 1 (or true) indicates divergence, while 0 (or false) indicates no divergence.
%     howDiv    - A string describing the type of convergence or divergence observed in y.
%                 If divergence is detected, howDiv specifies the type (e.g., 'Exponential 
%                 Divergence', 'Permanent Oscillations', etc.). If no divergence is detected, 
%                 howDiv returns 'No divergence detected'.
%
%   EXAMPLES:
%     % Without a custom function:
%     [isDiv, howDiv] = isDivergent(y);
%
%     % With a custom function:
%     customFunc = @(y) deal(1, 'Custom divergence detected');
%     [isDiv, howDiv] = isDivergent(y, customFunc);
%
%   NOTE:
%     If a custom function is provided, it will be used for divergence checking instead of
%     the default internal methods (isExpDivergent, isPermOscillating, isDampOscillating, 
%     isDivOscillating).
%

   % Convert customFunc to a function handle if it is a string
    if nargin > 1
         % Check if params0 is provided when customFunc is used
        if isempty(params0)
            error('params0 must be provided when customFunc is used.');
        end
        if ischar(customFunc)
            customFunc = str2func(customFunc);
        elseif ~isa(customFunc, 'function_handle')
            error('customFunc must be a function handle or a string representing a function name');
        end
        % Call the custom function
        isDiv = isGenericDiv(y, customFunc, params0);
        if isDiv
            howDiv  = 'Divergent according to the custom function.';
        else
            howDiv  = 'Not divergent according to the custom function.';
        end
        return;
    end
    
    % Default analysis methods if no custom function is provided
    if isExpDivergent(y)
        isDiv = 1;
        howDiv = 'Exponential Divergence';    
    elseif isPermOscillating(y)
         isDiv = 1;
         howDiv = 'Permanent Oscillations';
    elseif isDampOscillating(y)
         isDiv = 1;
         howDiv = 'Damped Oscillations';
    elseif isDivOscillating(y)
        isDiv = 1;
        howDiv = 'Divergent Oscillations';
    elseif isCubicRadix(y)
        isDiv = 1;
        howDiv = 'Cubic Radix Trend';
    elseif isMultiSinusoids(y,3)
       isDiv = 1;
       howDiv = 'Sum of Sinusoids';
    elseif isArcTanDivergent(y)
        isDiv = 1;
        howDiv = 'Arctangent Trend';
    elseif isFifthRadix(y)
        isDiv = 1;
        howDiv = 'Fifth Radix Trend';
    elseif isRunge(y)
        isDiv = 1;
        howDiv = 'Runge Trend';
    else
        isDiv = 0;
        howDiv = 'No divergence detected';
    end
end




