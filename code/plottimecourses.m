% plottimecourses.m
% Here, we plot the timecourses of two (or more) pixels together
% We then plot the same timecourses against each other
% We will then calculate correlations!

T = 5000; % how many time points to plot?
fs = 150; % frames per second
x = (1:T)/fs; % time axis in seconds

y = squeeze(data(113,47,1:T)); % motor region
f = squeeze(data(38,103,1:T)); % visual region

y2 = squeeze(data(90,39,1:T)); % motor region pixel 2
% replace f with y2 in the following to see two motor region pixels

% Smooth both signals
y = smooth(y,20);
y2 = smooth(y2,20);

% Plotting against time
figure;
plot(x,y,'.-b',x,y2,'.-r'); 
set(gca,'fontsize',20);
xlabel('Time (s)');
ylabel('Fluorescence');
legend('Motor','Visual')

% Plotting against each other
figure;
plot(y,y2,'ok');
set(gca,'fontsize',20);
xlabel('Motor Region Fluorescence');
ylabel('Visual Region Fluorescence');

% Calculating Correlations
% Next time!
corrs = corrcoef(y,y2);
fprintf('Correlation : %f \n',corrs(1,2));
