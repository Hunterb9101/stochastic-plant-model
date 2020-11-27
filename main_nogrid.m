clc; clf;

% Model Parameters
model_dims = [100, 100];  % 100 meters by 100 meters
riiTable = [
    0.000, 0.250;
    0.250, 0.000
    ];

% Plot settings
xlim([0, model_dims(1)])
ylim([0, model_dims(2)])
daspect([1 1 1])

invasive = Plant("InvasivePlant", "SPREAD-FUNCTION", .75, "g", 1);
native = Plant("NativePlant", "SPREAD-FUNCTION", 1, "r", 1);
invasive.riiTable.data = riiTable; 

for i = b
    %i.plot();
end