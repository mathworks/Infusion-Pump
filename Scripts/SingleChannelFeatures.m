function TrainDataStats2 = SingleChannelFeatures(ChannelData,blocksize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Channel Data: matrix of data represent multiple experiment, rows: time
%   series length, columns: experiment sets
%   blocksize: time window for data analysis

statfuns = @(x)[max(x) mean(x) min(x) var(x) std(x)]; % Define Statistic Features Per Channel
numF = 5;                                             % Number of Features Per Channel
[numLen, numSet] = size(ChannelData);                 % number of rows is the length of the time series, number of columns is the number of data set of the experiment
numSeg = round(numLen/blocksize);                     % number of segmentation per experiement.
TrainDataStats1 = blockproc(ChannelData,[blocksize 1],@(block)statfuns(block.data));
TrainDataStats2 = zeros(numSeg*numSet,numF);
for i = 1: numSet
    TrainDataStats2((1:numSeg)+(i-1)*numSeg,1:numF) = TrainDataStats1(1:numSeg,(1:numF)+(i-1)*numF); 
end

end

