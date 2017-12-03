%create binary of siddhartan's report 
s = '';
str = importdata('ofdmtext.txt');
for x = 1:length(str.textdata)
   s = strcat(s, str.textdata(x));
end
dataraw = stringToBits(s{1});

%translate from 0,1 to -1, 1
dataflipped = dataraw -ones(1,length(dataraw));
data = dataraw + dataflipped; 

%make it into parallel arrays 
spmatrix16 = zeros(ceil(length(data)/16), 16);
paralleldata = serialtoParallel_16(data);

%ifft here
%IN TIME DOMAIN NOW 
pardatafreq = ifft(paralleldata.'); %Need a transpose because ifft does it per column and we need it per row

%perhaps upsample to a square train
pardatafreq_up = repelem(pardatafreq, 1, 100); 

%cyclic prefix 
fulldata = cyclicprefix4(pardatafreq_up.'); %with cyclic prefix added in front

%serial to parallel and cosines 
%each column has a different cosine 
startfreq =2490000000;
endfreq = 2492000000;
cosmult = (endfreq - startfreq)/21;
cosinefreqs = zeros(1,20); 

%so we have each cosine frequency
for i=1:20
    cosinefreqs(i) = cosmult*i;
end

symbolrate = 1000; %we defined this, can be higher 
txdatamatrix = zeros(size(fulldata)); 

for b = 1:20
    txdatamatrix(:,b) = tx_cos(fulldata(:,b), cosinefreqs(:,b), symbolrate);
end

check= fft(sum(txdatamatrix,2));
plot(linspace(-2*pi, 2*pi, length(check)), real(fftshift(check))); 
title('Data to tx, without white noise')
xlabel('Frequency (unknown units)');
ylabel('Amplitude (unknown units)');

%pseudo random noise for autocorrelation 
prn = wgn(10000,1, 1); 

%now squish them all together 
txdata =[prn; sum(txdatamatrix,2)];

% stem(txdata);

% plot(xcorr(real(txdata), real(txdata))); 
write_usrp_data_file(txdata);

