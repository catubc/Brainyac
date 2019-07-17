% plotaveragetimecourse

%% Load data and atlas (change paths if necessary)
% load data
load('/Users/shreyasaxena/Dropbox/Documents/Labwork/Columbia/Data/Cat/BRAINYAC_data/Brainyac/data/widefield_spontaneous/widefield_data.mat')
% load atlas
load('/Users/shreyasaxena/Dropbox/Documents/Labwork/Columbia/Data/Cat/BRAINYAC_data/iGlusnfr/Cohort6_DC2/baseline/warped_atlas.mat');

%% Visualize the atlas
figure;
imagesc(atlas);
axis image

%% Visualize the region that is secondary motor cortex, right hand side 
% (hint: look at 'areanames')
regionindex = -21;
% alternative to above (see what happens if you type areanames.MOs1_R in your command window).
regionindex = areanames.MOs1_R; 
% visualize the region
figure;
imagesc(atlas == regionindex);
axis image
%% find x and y indices for all pixels in that region
[xindex,yindex] = find(atlas == regionindex);
disp(atlas(xindex(1),yindex(1)))

% plot the time course for one pixel in that region
T = 5000; % how many time points to plot?
fs = 150; % frames per second
x = (1:T)/fs; % time axis in seconds
y = squeeze(data(xindex(1),yindex(1),1:T)); 
figure;
plot(x,y); 
title('Timecourse for one pixel in that region')
set(gca,'fontsize',20);

% plot the time course for all pixels in that region, on the same plot
figure;
for j=1:length(xindex)
    y = squeeze(data(xindex(j),yindex(j),1:T)); 
    plot(x,y);hold on;
end
title('Timecourse for all pixels in that region')
set(gca,'fontsize',20);
%% calculate the mean time course for one time point
t=1; % which time point?
y_t=zeros(length(xindex),1); % initialize the vector - fill it with zeros
for j=1:length(xindex) % for all pixels / indices in that region
    y_t(j)=data(xindex(j),yindex(j),t); % fill each column of the vector with the data from each pixel
end
y_ave=mean(y_t); % take the mean, i.e. sum(y)/number of elements in y
disp(y_ave) % this is the average for the timepoint t=1

%% plot the mean time course for all time points
y_ave=zeros(T,1); % initialize mean time course
for t=1:T % we do this once for each time point
    % the following is exactly like above
    y_t=zeros(length(xindex),1);
    for j=1:length(xindex)
        y_t(j)=data(xindex(j),yindex(j),t);
    end
    y_ave(t)=mean(y_t);
end
figure;
plot(x,y_ave,'.-k'); % woohoo!
set(gca,'fontsize',20)
title(getarea(areanames,regionindex),'Interpreter', 'none');
