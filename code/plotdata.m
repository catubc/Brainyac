% plotdata.m
% Here we are visualizing frames of the widefield video in a "for loop"

% Load the data
path = '/Users/shreyasaxena/Dropbox/Documents/Labwork/Columbia/Data/Cat/BRAINYAC_data/Brainyac/data/widefield_spontaneous/widefield_data.mat';
load(path);

fs = 150;

figure; % open a new figure
colormap spring % replace with any other colormap
for i=1:500
    imagesc(data(:,:,i)); % plot data
    axis image; % rescale axes
    caxis([-20 20]); % constrain axes
    colorbar; % show colorbar
    set(gca,'fontsize',20);
    title(round(i/fs,3));
    pause; % pause after every image
end