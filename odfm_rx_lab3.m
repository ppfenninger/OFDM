% this is the code for recieving data

%% data conditions
disp('data conditions');

% Read in variables
rawInput = read_usrp_data_file('rx.dat'); 
% getting known white noise from data file
knownWhiteNoiseWorkSpace = load('wnlab.mat'); % this is a workspace that has the whitenoise
knownWN = knownWhiteNoiseWorkSpace.wn; % this is the known white noise

lengthKnownWN = length(knownWN); 
numWNRep = 3;
lengthCP = 16; 
numFreqBins = 64; %number of frequency carriers
numKnownSymbols = 4; % known data length is numKnownSymbols*numFreqBins 

%% find the approximate start of the known white noise
disp('find ~start of noise');
% threshold = mean(abs(real(rawInput(1:1000))))*100; % average value of noise - want to know when it gets above this
threshold = 0.1;
startpoint = 1; 
% for i = 1:length(rawInput)
%     if abs(rawInput(i)) > threshold
%         startpoint = i - 200; % takes 200 points back from the start of the whitenoise
%         break; % we don't need to keep going
%     end
% end
rawInputWithoutBlip = rawInput(startpoint:end); 

%% find start of white noise using xcorr
disp('xcorr white noise');

[r, lag] = xcorr(real(rawInputWithoutBlip), [knownWN, knownWN, knownWN]); % getting a list of lags and correlation values
sorted = sortrows([lag.', abs(r)], -2); % sorting the correlation values from highest to lowest (-2 sorts the second column in descending order)
highestCorrLocation = abs(sorted(1,1)); % taking the locaiton of the highest correlation value

rxData = rawInputWithoutBlip((highestCorrLocation + numWNRep*lengthKnownWN + 1):end); % only keeps things before the white noise

%% calculate channel response using known data
disp('calculate channel with known');
knownData = rxData(1:(numKnownSymbols*(numFreqBins + lengthCP))); % this is the known data that we send before the actual data
parKnownDataWithCP = serialtoParallel(knownData, (lengthCP + numFreqBins)); %turning it into a matrix with lengthCP + numFreqBins columns
parKnownData = parKnownDataWithCP(:, (lengthCP + 1):end); % removed the columns that contain the CP
freqKnownData = fft(parKnownData.').'; % put fftshift here if you want it fftshift(fft(parKnownData.')).'
rxKnownData = reshape(freqKnownData.', 1, []); 

% load known data
txKnownDataWorkspace = load('knowndatalab.mat');
txKnownData = txKnownDataWorkspace.known; % transpose it because we screwed up making known data
txKnownData = 2.*txKnownData - 1; % converts from 0 and 1 to -1 and 1

% now we estimate the channel response
% H = abs(rxKnownData./txKnownData); % finds the channel
H = abs(rxKnownData);
parH = serialtoParallel(H, numFreqBins); 
channelResponse = sum(parH, 1)./numKnownSymbols; % The average of every set of frequency bins

% plot(real(rxKnownData));
% plot(real(channelResponse)); 

%% Recover data - time domain 
disp('Recovery time');
data = rxData((numKnownSymbols*(numFreqBins + lengthCP) + 1):end);
parDataWithCP = serialtoParallel(data, (lengthCP + numFreqBins));
parData = parDataWithCP(:,(lengthCP + 1):end);

freqParData = fft(parData.').'; % get into the frequency domain 

%% Frequency domain recovery 
disp('Freq recovery');
parEstimateData = zeros(size(freqParData));

for x = 1:numFreqBins
    parEstimateData(:,x) = freqParData(:,x)./channelResponse(x);
end

estimateData = reshape(parEstimateData.', 1, []);
estimateData = estimateData(1:640);

%% demodulation 
disp('demod');
%for each data point, estimate the bit

estimateBits = zeros(size(estimateData));
for w = 1:length(estimateData)
    if estimateData(w) >= 0
        estimateBits(w) = 1; 
    else
        estimateBits(w) = 0; 
    end
end

% estimateBits = pskdemod(estimateData,64);

string = bitsToString(estimateBits);
% string2 = bitsToString(datarawinput);

%% Bit error rate 
disp('how wrong are we');
sumerrors = 0; 
txDataBits = load('txDataBits.mat');
txDataBits = txDataBits.txDataBits;
for w = 1:length(txDataBits)
   if estimateBits(w) ~= txDataBits(w)
       sumerrors = sumerrors +1;
   end
end

biterrorrate = 100*sumerrors/length(txDataBits);
disp(biterrorrate);