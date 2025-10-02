clc
clearvars

modelName = 'Ebike'; 

%Load model
load_system(modelName);

faults = Simulink.fault.findFaults(modelName);
nf = length(faults);

startTime = 10;
endTime = 20;

for i = 1:nf
    if faults(i).IsActive
        % --- Simulation with fault off ---
        Simulink.fault.enable(faults(i).ModelElement,false);
        simIn2  = Simulink.SimulationInput(modelName);
        simOut2 = sim(simIn2);

        % --- Simulation with fault ON ---
        Simulink.fault.enable(faults(i).ModelElement,true);
        simIn1  = Simulink.SimulationInput(modelName);
        simOut1 = sim(simIn1);
        
        % --- Estraction logged signals ---
        t  = simOut1.logsout{1}.Values.Time;
        y1 = simOut1.logsout{1}.Values.Data; 
        y2 = simOut2.logsout{1}.Values.Data;
        
        % --- Difference ---
        yDiff = y1 - y2;

        % --- Time window ---
        idxStart = find(t >= startTime, 1, 'first'); 
        idxEnd   = find(t <= endTime, 1, 'last');   
        yWin = yDiff(idxStart:idxEnd);
        tWin = t(idxStart:idxEnd); 


        % --- Cleaning signal ---
        % [y, idx] = cleanSignal(yWin, 'adaptive');

        % --- Compute changing points ---
        changePts = swSegmentation(yWin, tWin);


        % --- create segments ---
        segments = cell(length(changePts)-1,1);
        for k = 1:length(segments)
            segments{k} = yWin(changePts(k):changePts(k+1)-1);
        end


        % === 3. Analysis ===
        N = length(segments);
        result = cell(N, 2);
        
        for k = 1:N
            seg = segments{k};
            [isDiv, howDiv] = isDivergent(seg);
            result{k,1} = isDiv;
            result{k,2} = howDiv;
        end
    end
end
        
       


