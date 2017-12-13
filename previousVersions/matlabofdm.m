%% Generate givens 
M = 4;                 % Modulation alphabet
k = log2(M);           % Bits/symbol
numSC = 128;           % Number of OFDM subcarriers
cpLen = 32;            % OFDM cyclic prefix length
maxBitErrors = 100;    % Maximum number of bit errors
maxNumBits = 1e7;      % Maximum number of bits transmitted

%% QPSK modulation 

qpskMod = comm.QPSKModulator('BitInput',true);
qpskDemod = comm.QPSKDemodulator('BitOutput',true);

%% ofdm modulation 

ofdmMod = comm.OFDMModulator('FFTLength',numSC,'CyclicPrefixLength',cpLen);
ofdmDemod = comm.OFDMDemodulator('FFTLength',numSC,'CyclicPrefixLength',cpLen);

%% channel 
channel = comm.AWGNChannel('NoiseMethod','Variance', ...
    'VarianceSource','Input port');
%% error?
errorRate = comm.ErrorRate('ResetInputPort',true);

%% 
ofdmDims = info(ofdmMod);


numDC = ofdmDims.DataInputSize(1);
frameSize = [k*numDC 1];

EbNoVec = (0:10)';
snrVec = EbNoVec + 10*log10(k) + 10*log10(numDC/numSC);

berVec = zeros(length(EbNoVec),3);
errorStats = zeros(1,3);


for m = 1:length(EbNoVec)
    snr = snrVec(m);

    %while errorStats(2) <= maxBitErrors && errorStats(3) <= maxNumBits
        dataIn = randi([0,1],frameSize);              % Generate binary data
        qpskTx = qpskMod(dataIn);                     % Apply QPSK modulation
        txSig = ofdmMod(qpskTx);                      % Apply OFDM modulation
%         powerDB = 10*log10(var(txSig));               % Calculate Tx signal power
%         noiseVar = 10.^(0.1*(powerDB-snr));           % Calculate the noise variance
   % end

end