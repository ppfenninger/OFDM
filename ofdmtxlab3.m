%% Define constants
lengthCP = 16;
numFreqBins = 64;
lengthWN = 64; % no cyclic prefix
numWNRepeats = 3; % lenthWN is repeated this many times
lengthKnownData = 64; % without CP
numKnownDataRepeats = 4; 
numDataBins = 10;

%% make the initial bits
counter = 1;  
txBitsWorkspace = load('txDataBits.mat'); 
txDataBits = txBitsWorkspace.txDataBits; 
% txDataBits = round(rand(1, 64)); 
% txDataBits = repelem(txDataBits, 10); 

%% and the known data before hand
txKnownDataWorkspace = load('knowndatalab.mat');
txKnownData = txKnownDataWorkspace.known;
txDataNoCP = [txKnownData, txDataBits(1:length(txDataBits)/2), txKnownData, txDataBits((length(txDataBits)/2 + 1):end)];

%% make it a matrix and add the CP
txDataNoCP = (2*txDataNoCP - 1); % translates from 0 and 1 to -1 and 1
txParDataNoCP = serialtoParallel(txDataNoCP, numFreqBins);

txFreqDataNoCP = ifft(txParDataNoCP.').';
txFreqData = cyclicprefix(txFreqDataNoCP, lengthCP); 

txDataSerial = reshape(txFreqData.', 1, []); 

%% add white noise in front
txKnownWNWorkspace = load('wnlab.mat');
txKnownWN = txKnownWNWorkspace.wn;

txFullWN = [];
for k = 1:numWNRepeats
    txFullWN = [txFullWN, txKnownWN];
end

txFullData = [txFullWN, txDataSerial]; 

write_usrp_data_file(txFullData, 'txlab.dat'); 
