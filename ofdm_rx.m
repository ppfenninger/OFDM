%%ofdm receive 

%call read_usrp_data_file 
%have something called rx.dat
rxinputwn = read_usrp_data_file(); 

[r, lag] = xcorr(real(rxinputwn), real(rxinputwn));
sorted = sortrows([lag', r], -2); 
highestcorr = sorted(1,1);
%start point of data to end
rxdata = rxinputwn((highestcorr+10001): end); %cutting off the 10,000 white noise points 
rxdata = rxdata'; 
figure 
% plot(rxdata); 
title('Received without white noise');

%carrier freq offset 
%ignore, pretend perfect. will wire clocks together 

%%%%%%%%%%%%%IN TIME%%%%%%%%%%%%%%

%deal with sampling

%serial to parallel 
sym_rate = 10; 
sym_period = 1/sym_rate;
par_rx = serialtoParallel(rxdata, 35); %because time in TX is 35 data points long

%remove CP
par_rx_nocp = par_rx(:,5:end); %removed the cp 

%fft
frequency_rx = fft(par_rx_nocp')'; 

%phase track 

%parallel to serial 
%cut off the second half of the frequency data stream 
freq_rxcut = frequency_rx(:,1:16);
rxserial = reshape(freq_rxcut', 1, []);

%demod from (1,-1) to (1,1)
rxserialbits = zeros(1,length(rxserial)); 
%for each data point: 
for w = 1:length(rxserial)
    if rxserial(w) >=0
        rxserialbits(w) = 1; 
    else
        rxserialbits(w) = 0; 
    end
end

string = bitsToString(rxserialbits);