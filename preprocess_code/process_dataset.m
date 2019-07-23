% Process Dataset
%% Get root folder with data
fdir='../../Alexander McGirr - iGluSnFR_CSD_Cohort4_3/';

%% Denoise all data in root folder
dataset=denoise_dataset(fdir);

for i=1:length(dataset) % For every folder
    load(fullfile(dataset(i).folder,dataset(i).names{1})); % load first file
    % Do averaging if more than file in the folder
    data_ave=zeros(size(data,1),size(data,2),size(data,3),length(dataset(i).names));
    data_ave(:,:,:,1)=data; clear data
    for j=2:length(dataset(i).names)
        load(fullfile(dataset(i).folder,dataset(i).names{j}));
        data_ave(:,:,:,j)=data; clear data
    end
    data_ave=mean(data_ave,4); data=data_ave; clear data_ave;
    if length(dataset(i).names)>1
        save(fullfile(dataset(i).folder,'average_data.mat'),'data');
    end

    %% Align data to Allen + get inverse atlas
    load('atlas.mat')
    tform = align_recording_to_allen(max(data,[],3)); % align <-- input any function of data here
    invT=pinv(tform.T); % invert the transformation matrix
    invT(1,3)=0; invT(2,3)=0; invT(3,3)=1; % set 3rd dimension of rotation artificially to 0
    invtform=tform; invtform.T=invT; % create the transformation with invtform as the transformation matrix
    maskwarp=imwarp(atlas,invtform,'interp','nearest','OutputView',imref2d(size(data(:,:,1)))); % setting the 'OutputView' is important
    maskwarp=round(maskwarp);
    
    %% Plot the warped atlas
    figure; imagesc(maskwarp); axis image
    
    %% Save the warped atlas
    atlas=maskwarp;
    save(fullfile(dataset(i).folder,'warped_atlas.mat'),'atlas','areanames','invtform');
end
