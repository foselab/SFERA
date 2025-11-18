# Signal Segmentation Developer Guide

This guide explains the architecture, logic, and extension points of the **signal segmentation module**.

---

## 1. Architecture Overview

All segmentation methods follow a **unified interface**:

```matlab
changePts = <SegmentationMethod>(y, opt)
```

- `y` : input signal (vector)  
- `opt` : object derived from `SegmentationOptions` containing algorithm-specific parameters  
- `changePts` : vector of indices of detected change points, always including the last sample

**Segmentation Methods:**

1. **Derivative-based**: detects sudden changes via the first derivative.  
2. **MATLAB built-in**: uses `findchangepts` to detect changes in mean.  
3. **Sliding-window**: computes a feature per window and detects large changes.  
4. **Uniform**: splits the signal into equal-length segments.

**Class hierarchy for options:**

```
segmentationOptions (abstract)
├── dySegmentationOptions
├── matlabSegmentationOptions
├── swSegmentationOptions
└── uniformSegmentationOptions
```

---

## 2. Base Class: `segmentationOptions`

- Abstract class: no properties by itself  
- Purpose: enforce a **uniform interface** for passing parameters to segmentation functions  
- Every new segmentation method should define its own options class derived from this base.

```matlab
classdef (Abstract) segmentationOptions
    % Base class for all segmentation options
end
```

---

## 3. Concrete Options Classes

| Class | Description | Key Properties |
|-------|-------------|----------------|
| `dySegmentationOptions` | Derivative-based | `thresholdMultiplier`, `minDistanceFraction` |
| `matlabSegmentationOptions` | Built-in MATLAB `findchangepts` | `statistic`, `maxChangeFraction` |
| `swSegmentationOptions` | Sliding-window | `metric`, `winLenFraction`, `overlap` |
| `uniformSegmentationOptions` | Uniform split | `perc` |

**Example instantiation:**

```matlab
opt = swSegmentationOptions();
opt.metric = 'rms';
opt.winLenFraction = 0.1;
opt.overlap = 5;
changePts = swSegmentation(y, opt);
```

---

## 4. Function Logic Overview

### 4.1 Derivative-based

- Compute first derivative: `dy = diff(y)`  
- Threshold candidate change points: `th = opt.thresholdMultiplier * std(dy)`  
- Enforce minimum distance: `minDist = floor(length(y) * opt.minDistanceFraction)`  

### 4.2 MATLAB Built-in

- Use `findchangepts` with `MaxNumChanges = floor(length(y) * opt.maxChangeFraction)`  

### 4.3 Sliding-window

- Split signal into windows of length `winLen = floor(length(y) * opt.winLenFraction)`  
- Compute `metric` per window  
- Detect windows where `abs(diff(feature)) > 2*std(feature)`  
- Map window index back to signal index  

### 4.4 Uniform

- Compute segment length: `step = round(length(y) * opt.perc / 100)`  
- Generate change points as multiples of `step`  
- Ensure last sample is included

---

## 5. Extending the Module

### Adding a new segmentation method

1. Create a new **options class** derived from `segmentationOptions`  

```matlab
classdef mySegmentationOptions < segmentationOptions
    properties
        myParam = 1.0; % default value
    end
end
```

2. Implement the segmentation function:

```matlab
function changePts = mySegmentation(y, opt)
    % Your custom segmentation logic
end
```

3. Follow the pattern:
    - Always accept `y` and `opt` as inputs  
    - Return `changePts` including last sample  
    - Document thresholds, metrics, or parameters in the options class

---

## 6. Developer Notes

- **Thresholds and multipliers**: almost all methods use thresholds based on the standard deviation or fraction of signal length. Adjust these to tune sensitivity.  
- **Windowing**: sliding-window segmentation is highly configurable via `winLenFraction` and `overlap`.  
- **Consistency**: always return a column vector of change points and include `length(y)` as the last point.  
- **Scalability**: new segmentation methods can reuse existing `SegmentationOptions` design for consistency.

---

## 7. Example Workflow

```matlab
% 1. Create options object
opt = dySegmentationOptions();
opt.thresholdMultiplier = 3;

% 2. Segment signal
changePts = dySegmentation(y, opt);

% 3. Plot results
plot(y); hold on;
xline(changePts, '--r');
```

