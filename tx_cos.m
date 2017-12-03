function res = tx_cos(bin, cosmult, symbolrate) %bin = column
    time = length(bin)/symbolrate; %how much time we have to transmit
    cossig = cos(2*pi*cosmult*linspace(0,length(time), length(bin))); %cosine for that 
   %plot(cossig);
    signal = bin'.*cossig; 
    res = signal;
end

%serial to parallel and cosines 
%each column has a different cosine 
% startfreq =2490000000;
% endfreq = 2492000000;
% cosmult = (endfreq - startfreq)/(col +1);
% cosinefreqs = zeros(1,col); 
% 
% %so we have each cosine frequency
% for i=1:col
%     cosinefreqs(i) = cosmult*i;
% end


% for b = 1:col
%     txdatamatrix(:,b) = tx_cos(fulldata(:,b), cosinefreqs(:,b), symbolrate);
% end
% txdatamatrix = zeros(size(fulldata)); 
% 
% summedtx = sum(txdatamatrix,2);
