clc; clf;

model_dims = [100, 100];  % 100 meters by 100 meters

riiTable = [
    0.000, 0.250;
    0.250, 0.000
    ];

test = Plant("TestPlant", "TestFun", .75, "g", 1);
test2 = Plant("TestPlant2", "TestFun2", 1, "r", 1);
test.riiTable.data = riiTable;

a = [PlantObj(0, 0, test), PlantObj(0, 1, test2), PlantObj(1, -1, test2)];
for i = a
    i.plot();
end

xlim([-4, 4])
ylim([-4, 4])
axis equal