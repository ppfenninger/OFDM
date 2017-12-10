M = 4;                 % Modulation alphabet
k = log2(M);           % Bits/symbol
numSC = 128;           % Number of OFDM subcarriers
cpLen = 32;            % OFDM cyclic prefix length
maxBitErrors = 100;    % Maximum number of bit errors
maxNumBits = 1e7;      % Maximum number of bits transmitted


for m = 1:length(EbNoVec)
    snr = snrVec(m);

        rxSig = channel(txSig,noiseVar);              % Pass the signal through a noisy channel
        qpskRx = ofdmDemod(rxSig);                    % Apply OFDM demodulation
        dataOut = qpskDemod(qpskRx);                  % Apply QPSK demodulation
        errorStats = errorRate(dataIn,dataOut,0);     % Collect error statistics

    berVec(m,:) = errorStats;                         % Save BER data
    errorStats = errorRate(dataIn,dataOut,1);         % Reset the error rate calculator
end

berTheory = berawgn(EbNoVec,'psk',M,'nondiff');
% 
% figure
% semilogy(EbNoVec,berVec(:,1),'*')
% hold on
% semilogy(EbNoVec,berTheory)
% legend('Simulation','Theory','Location','Best')
% xlabel('Eb/No (dB)')
% ylabel('Bit Error Rate')
% grid on
% hold off