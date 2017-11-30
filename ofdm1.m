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
spmatrix20 = zeros(ceil(length(data)/16), 20);
paralleldata = serialtoParallel_20(data);

%cyclic prefix 
fulldata = cyclicprefix4(paralleldata); %with cyclic prefix added in front

function res = cyclicprefix4(k); 
    %make matrix of last 4 columns 
    k(:,1:4) = k(:,17:20);
    res = k;
end

function res = serialtoParallel_20(x) % make the matrix of data, prepped for cyclic prefix
    for i= 1:length(x) 
        columns = ceil(i/16); %row
        rows = mod(i, 16); %need to see which spot in the row we are at (column)
        if rows == 0 %mod so the 0th is the 16th element
            rows = 16; 
        end
        spmatrix20(columns, rows+4)= x(i); %trust me
    end
    res = spmatrix20;
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

