%% Define constants
lengthCP = 16;
numFreqBins = 64;
lengthWN = 64; % no cyclic prefix
numWNRepeats = 3; % lenthWN is repeated this many times
lengthKnownData = 64; % without CP
numKnownDataRepeats = 4; 
numDataBins = 10;
numDataSections = 2;
startBad = 30;
endBad = 35;

%% make the initial bits
counter = 1;  
txBitsWorkspace = load('txDataBits.mat'); 
txDataBits = txBitsWorkspace.txDataBits; 
% txDataBits = round(rand(1, 64)); 
% txDataBits = repelem(txDataBits, 10); 

%% and the known data before hand
txKnownDataWorkspace = load('knowndatalab.mat');
txKnownData = txKnownDataWorkspace.known;

txDataNo33 = serialtoParallel(txDataBits, (startBad - 1) + (numFreqBins - endBad));
txDataNo33 = [txDataNo33(:, 1:(startBad - 1)), ones(ceil(length(txDataBits)/((startBad - 1) + (numFreqBins - endBad))), (endBad - startBad + 1)), txDataNo33(:, (startBad):(end))]; 
txDataNo33 = reshape(txDataNo33.', 1, []);
txDataNo33 = txDataNo33(1:numFreqBins*numDataBins);
txDataNoCP = []; %[txKnownData, txDataBits(1:length(txDataBits)/2), txKnownData, txDataBits((length(txDataBits)/2 + 1):end)];
for i = 1:numDataSections
    txDataNoCP = [txDataNoCP, txKnownData, txDataNo33(((i-1)*length(txDataNo33)/numDataSections + 1):(i*length(txDataNo33)/numDataSections))]; %#ok<*AGROW>
end

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
