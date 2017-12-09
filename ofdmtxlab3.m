%% Define constants
lengthCP = 16;
numFreqBins = 64;
lengthWN = 64; % no cyclic prefix
numWNRepeats = 3; % lenthWN is repeated this many times
lengthKnownData = 64; % without CP
numKnownDataRepeats = 4; 
numDataBins = 10;

%% make the initial bits
txDataBits = zeros(1, numDataBins*lengthWN/2); 
counter = 1; 
for i = 1:length(txDataBits);
    if i <= (10 + counter)*counter
        txDataBits(i) = 0;
    elseif i<= 10*counter + 9
        txDataBits(i) = 1; 
    else % last one bit, counter goes up
        txDataBits(i) = 1;
        counter = counter + counter;
    end
end
txDataBits = [txDataBits, fliplr(txDataBits)]; 

%% and the known data before hand
txKnownDataWorkspace = load('knowndatalab.mat');
txKnownData = txKnownDataWorkspace.known;
txDataNoCP = [txKnownData, txDataBits];

%% make it a matrix and add the CP
txDataNoCP = 2*txDataNoCP - 1; % translates from 0 and 1 to -1 and 1
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
