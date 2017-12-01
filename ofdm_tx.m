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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  write_usrp_data_file( x )
% Write the complex signal into a file tx.dat, suitable for usrp 
% transmission you will need to make sure the program used for
% transmitting the data (e.g. tx_samples_from_file) is set to read 
% floating point numbers e.g.use the command line option --format float  
% for tx_samples_from_file
% and "complex" for gnuradio companion file sink

    tmp = zeros(2*length(x),1);
    tmp(1:2:end) = real(x);
    tmp(2:2:end) = imag(x);

    f1 = fopen('tx.dat', 'w');
    fwrite(f1, tmp, 'float32');
    fclose(f1);

end

function res = tx_cos(bin, cosmult, symbolrate) %bin = column
    time = length(bin)/symbolrate; %how much time we have to transmit
    cossig = cos(2*pi*cosmult*linspace(0,length(time), length(bin))); %cosine for that 
   %plot(cossig);
    signal = bin'.*cossig; 
    res = signal;
end

function res = cyclicprefix4(k)
    %make matrix of last 4 columns 
    x(:,1:4) = k(:,13:16);
    x(:,5:20) = k;
    res = x;
end

function res = serialtoParallel_16(x) % make the matrix of data, prepped for cyclic prefix
    for i= 1:length(x) 
        columns = ceil(i/16); %row
        rows = mod(i, 16); %need to see which spot in the row we are at (column)
        if rows == 0 %mod so the 0th is the 16th element
            rows = 16; 
        end
        spmatrix16(columns, rows)= x(i); %trust me
    end
    res = spmatrix16;
end

function res = stringToBits(S)
    v = zeros([1, length(S)]);
    
    for i = 1:length(S)
        chars=dec2bin(S(i), 8);
        for j = 1:8
            if chars(j) == '1'
                v((i-1)*8 + j) = 1;
            else
                v((i-1)*8 + j) = 0; 
            end
        end
    end
    res = v;
end

