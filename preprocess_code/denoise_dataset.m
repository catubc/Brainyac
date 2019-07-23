function dataset=denoise_dataset(fdir,recompute)

if nargin<1
    error('Please provide root folder with dataset')
end
if nargin<2, recompute=0; end % re-denoises already denoised files
dataset=dir(strcat(fdir,'/**/*.mat'));

%% Set parameters
SVD_method = 'randomized';
maxlag = 5;
confidence = 0.99;
mean_threshold_factor=1.5;
snr_threshold = 1.6;

addpath('./matlab_utils/');

%% Denoise data
for i=1:length(dataset)
    if strcmp(dataset(i).name(end-12:end),'_denoised.mat'), continue; end
    if exist(fullfile(dataset(i).folder,strcat(dataset(i).name(1:end-4),'_denoised.mat')),'file') && ~recompute, continue; end
    if strcmp(dataset(i).name,'warped_atlas.mat'), continue; end
    if strcmp(dataset(i).name,'average_data.mat'), continue; end
    fname = fullfile(dataset(i).folder,dataset(i).name);
    data = load(fname); data=data.data;
    datadims=size(data);
    data = reshape(data,datadims(1)*datadims(2),datadims(3));
    
    [U, s, V] = compute_svd(data,SVD_method,500); Vt=V';
    % Determine which components to keep using an autocorrelations test
    ctid = choose_rank(Vt,maxlag,confidence,mean_threshold_factor);
    idx = find(ctid(1, :) == 1);
    fprintf('\tInitial Rank : %d\n',length(idx));
    Ured = U(:,idx);
    sred = s(idx,idx);
    Vtred = sred*Vt(idx,:);

    % Further remove those components that have low snr
    if size(Vtred,2)>256
        high_snr_components = (std(Vtred,[],2)./noise_level(Vtred) > snr_threshold);
        num_low_snr_components = sum(~high_snr_components);
        fprintf('\t# low snr components: %d \n',num_low_snr_components);
        Vtred = Vtred(high_snr_components,:);
        Ured  = Ured(:,high_snr_components);
    end

    denoised_data=reshape(Ured*Vtred,datadims(1),datadims(2),datadims(3));
    data=denoised_data;
    save(fullfile(dataset(i).folder,strcat(dataset(i).name(1:end-4),'_denoised.mat')),'data','-v7.3');
end

dataset_denoised=dir(strcat(fdir,'/**/*_denoised.mat'));

%% Puts all files in the same folder under one index in the struct
dataset=struct; doneindices=[]; indexfolder=1;

for i=1:length(dataset_denoised)
    if ismember(i,doneindices), continue; end
    indexfile=1;
    dataset(indexfolder).folder=dataset_denoised(i).folder; 
    dataset(indexfolder).names=cell(1);
    dataset(indexfolder).names{indexfile}=dataset_denoised(i).name;
    for j=i+1:length(dataset_denoised)
        if strcmp(dataset_denoised(i).folder,dataset_denoised(j).folder)
            indexfile=indexfile+1;
            dataset(indexfolder).names{indexfile}=dataset_denoised(j).name;
            doneindices=[doneindices;j];
        end
    end
    indexfolder=indexfolder+1;
end