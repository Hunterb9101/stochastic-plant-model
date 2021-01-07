% ShowSpread: Shows the basic spread function for a plant.
addpath('./..');

invasive = Plant("InvasivePlant", "TestFun", .75, "g", 1);

xlim([0, model_dims(1)])
ylim([0, model_dims(2)])
daspect([1 1 1])

b = spreadBasic(50, 25, invasive, 100, 25);
filledCircle(50, 25, 25, 'r', .25);
filledCircle(50, 25, .75, 'r', 1);

for i = b
    i.plot();
end