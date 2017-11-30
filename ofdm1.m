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

%cyclic prefix 
fulldata = cyclicprefix4(pardatafreq.'); %with cyclic prefix added in front

%serial to parallel and cosines 
%each column has a different cosine
%:,colnumber
startfreq =2490000000;
endfreq = 2492000000;
cosmult = (endfreq - startfreq)/21;
% bin = zeros(size(fulldata));
cosinefreqs = zeros(1,20); 

%so we have each cosine frequency
for i=1:20
    cosinefreqs(i) = cosmult*i + startfreq;
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

