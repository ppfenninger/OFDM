%create binary of siddhartan's report 

workspacewn = load('wn.mat');
prn = workspacewn.ans; 
prn = prn./5.7; % make noise smaller
lengthcp = 16; 
numfreqcarriers = 64;

s = '';
str = importdata('ofdmtext.txt');
for x = 1:length(str.textdata)
   % s = strcat(s, str.textdata(x)); 
   stringcell = str.textdata(x);
   s = s + stringcell{1};
end

datarawinput = stringToBits(s{1});

%known data
% preset = load('knowndata.mat');
% knowndata = preset.known;
% % knowndata = knowndata(1:64000);
% dataraw = [knowndata' , datarawinput];
% 
% %translate from 0,1 to -1, 1
% dataflipped = dataraw -ones(1,length(dataraw));
% data = dataraw + dataflipped; 
% 
% %make it into parallel arrays 
% spmatrix16 = zeros(ceil(length(data)/numfreqcarriers), numfreqcarriers);
% paralleldata = serialtoParallel(data, numfreqcarriers);
% 
% %frequency mirroring 
% % mirroreddata = [paralleldata, fliplr(paralleldata(:,2:end))];
% 
% %ifft here
% %IN TIME DOMAIN NOW 
% pardatafreq = ifft(paralleldata.'); %Need a transpose because ifft does it per column and we need it per row
% 
% %cyclic prefix 
% fulldata = cyclicprefix(pardatafreq.', lengthcp); %with cyclic prefix added in front
% [r,col] = size(fulldata); 
% 
% %concatenate all the rows of the matrix 
% txserial = reshape(fulldata.', 1, []);
% 
% %pseudo random noise for autocorrelation 
% txdata =[prn.', txserial];
% z = zeros(1, 10000);
% % lotsaones = 0.7.*ones(1,10000);
% morenoise = wgn(1,10000,1);
% txdatawithzeros = [txdata, z];
% % txdatatesting = [3.*prn.',z,txserial,z, 3.*prn.']; 
% %plot(real(txdatatesting));
% write_usrp_data_file(txdatawithzeros, 'tx.dat'); %saves into tx.dat