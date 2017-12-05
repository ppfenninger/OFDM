%%ofdm receive 

%%%%%%%%%%%%%IN FREQUENCY%%%%%%%%%%%%%%

%call read_usrp_data_file 
rxinputwn = read_usrp_data_file('rxchannel.dat'); 

%add in the known noise 
workspacewn = load('wn.mat');
prn = workspacewn.prn; 

%cross correlate with the known noise to find start point 
[r, lag] = xcorr(real(rxinputwn), prn);
sorted = sortrows([lag', r], -2); 
highestcorr = sorted(1,1);

%start point of transmitted data to end
rxdata = rxinputwn((highestcorr+10001): end); %cutting off the 10,000 white noise points 
rxdata = rxdata';  

%carrier freq offset 
%ignore, pretend perfect. will wire clocks together 

%%%%%%%%%%%%%IN TIME%%%%%%%%%%%%%%

%serial to parallel 
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

%demod from (1,-1) to (1,0)
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