% plotdata.m
% Here we are visualizing frames of the widefield video in a "for loop"

figure; % open a new figure
colormap summer % replace with any other colormap
for i=1:100
    imagesc(data(:,:,i)); % plot data
    axis image; % rescale axes
    caxis([-20 20]); % constrain axes
    colorbar; % show colorbar
    pause; % pause after every image
end