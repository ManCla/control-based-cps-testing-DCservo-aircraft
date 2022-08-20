
addpath('model/');

test_results = sim('DCservo.slx').data;

plot(test_results)
