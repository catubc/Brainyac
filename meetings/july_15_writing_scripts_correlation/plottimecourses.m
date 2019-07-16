% plottimecourses.m
% Here, we plot the timecourses of two (or more) pixels together
% We then plot the same timecourses against each other
% We will then calculate correlations!

T = 500; % how many time points to plot?
x = (1:T)/150; % time axis in seconds

y = squeeze(data(113,47,1:T)); % motor region
f = squeeze(data(38,103,1:T)); % visual region

y2 = squeeze(data(90,39,1:T)); % motor region pixel 2
% replace f with y2 in the following to see two motor region pixels

% Plotting against time
figure;
plot(x,y,'.-b',x,f,'.-r'); 
set(gca,'fontsize',20);
xlabel('Time (s)');
ylabel('Fluorescence');

% Plotting against each other
figure;
plot(y,f,'ok');
set(gca,'fontsize',20);
xlabel('Motor Region Fluorescence');
ylabel('Visual Region Fluorescence');

% Calculating Correlations
% Next time!