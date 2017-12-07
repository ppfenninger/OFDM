%%ofdm receive 

%%%%%%%%%%%%%IN FREQUENCY%%%%%%%%%%%%%%

%call read_usrp_data_file 
rxinputwn = read_usrp_data_file('rxchannel.dat'); 
%add in the known noise 
workspacewn = load('wn.mat');
prn = workspacewn.ans; 

%cross correlate with the known noise to find start point 
[r, lag] = xcorr(real(rxinputwn), prn);
sorted = sortrows([lag.', r], -2); 
highestcorr = sorted(1,1);

%find the channel
%get to the fft of of the recieved known signal
rxknown = rxinputwn((highestcorr+10001): (highestcorr+10001+349));
par_rxknown = serialtoParallel(rxknown, 35); %because time in TX is 35 data points long
par_rxknown_nocp = par_rxknown(:,5:end); %removed the cp 
frequency_rxknown = fft(par_rxknown_nocp.').'; 
freq_rxknowncut = frequency_rxknown(:,1:16);
rxknownserial = reshape(freq_rxknowncut.', 1, []);
%load known tx
workspacetxknown = load('knowndata.mat');
txknownserial = workspacetxknown.known.'; 
txknownserial = 2*txknownserial -1; %convert from 1 0 to 1 -1

%average over every 16 of the channel
H = rxknownserial ./ txknownserial;
par_h = serialtoParallel(H, 16);
channelresponse = sum(par_h,1)./10;
% figure
% plot(real(H), 'm')
% hold on
% plot(real(channelresponse), 'k*')


%start point of transmitted data to end
rxdata = rxinputwn((highestcorr+10001+350): end); %cutting off the 10,000 white noise points 
rxdata = rxdata.';  

%carrier freq offset 
%ignore, pretend perfect. will wire clocks together 

%%%%%%%%%%%%%IN TIME%%%%%%%%%%%%%%

%serial to parallel 
par_rx = serialtoParallel(rxdata, 35); %because time in TX is 35 data points long

%remove CP
par_rx_nocp = par_rx(:,5:end); %removed the cp 

%fft
frequency_rx = fft(par_rx_nocp.').'; 

%phase track 

%parallel to serial 
%cut off the second half of the frequency data stream 
freq_rxcut = frequency_rx(:,1:16);
rx_corrected = zeros(size(freq_rxcut));

%divide out channel
for y = 1:16
   rx_corrected(:,y) = freq_rxcut(:,y)./channelresponse(y);  
end

rxserial = reshape(rx_corrected.', 1, []);

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
string2 = bitsToString(datarawinput);
%bit error rate 
sumerrors = 0; 

for w = 1:length(datarawinput)
    if rxserialbits(w) ~= datarawinput(w)
        sumerrors = sumerrors +1; 
    end
end

biterrorrate = 100* sumerrors/length(dataraw);