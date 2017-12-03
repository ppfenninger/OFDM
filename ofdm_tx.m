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

%frequency mirroring 
mirroreddata = [paralleldata, fliplr(paralleldata(:,2:end))];

%ifft here
%IN TIME DOMAIN NOW 
pardatafreq = ifft(mirroreddata'); %Need a transpose because ifft does it per column and we need it per row

%cyclic prefix 
fulldata = cyclicprefix4(pardatafreq'); %with cyclic prefix added in front
[r,col] = size(fulldata); 

%concatenate all the rows of the matrix 
txserial = reshape(fulldata', 1, []);

%pseudo random noise for autocorrelation 
prn = wgn(10000,1, 1); 
 
txdata =[prn', txserial];
plot(txdata);
write_usrp_data_file(txdata); %saves into tx.dat