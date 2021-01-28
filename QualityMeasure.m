clear all; close all; clc;
Img=imread('I23.BMP');
Iblur=imgaussfilt(Img,11.33);
Igray=rgb2gray(Img);

Iblur1=rgb2gray(Iblur);
I1=double(Iblur1)/255;

I=double(Igray)/255;
[M,N] = size(Igray); 

[cA,cH,cV,cD] = dwt2(I1,'haar'); %wavelet transform 

EM=zeros(M/2,N/2);
EM=sqrt((cH.^2) + (cV.^2)); 

count=0.0;
for k=1:1:M/2
   for l=1:1:N/2
       count=EM(k,l)+count;
   end
end
Edge=zeros(M/2,N/2);
th= count / (2*N*M); % 1 / (2^1 *N*M) ,J=2

for k=1:1:M/2
  for l=1:1:N/2
      if EM(k,l)<th;
      Edge(k,l)=0;
      else
      Edge(k,l)=EM(k,l);
      end
  end
end
DCT=dct2(Edge);
A_DCT=zeros(M/2,N/2);

for k=1:1:M/2
   for l=1:1:N/2
        A_DCT(k,l)=abs(DCT(k,l));
   end
end

dct_count=0.0;
for k=1:1:M/2
   for l=1:1:N/2
      dct_count=(A_DCT(k,l)*255)+dct_count;
   end
end
NSize=(M/2)*(N/2);
a=NSize / (dct_count);

for k=1:1:M/2
    for l=1:1:N/2
        h(k,l)=a*exp((-a).*(A_DCT(k,l))); %pdf  
    end
end

H=histogram(A_DCT,'Normalization','probability','DisplayStyle','stairs'); %AQ_DCT histogram 
hold on;
H1=histogram(h,'Normalization','probability','DisplayStyle','stairs'); %pdf histogram

a_plot=[0.1329 0.2417 0.4722 0.5206 0.9288 2.5623];
SD=[0 0.9 1.7 1.85 2.85 11.33];

%QUANTIZED
Q=[16  11  10  16  24  40  51  61;
    12  12  14  19  26  58  60  55;
    14  13  16  24  40  57  69  56;
    14  17  22  29  51  87  80  62;
    18  22  37  56  68  109 103 77;
    24  35  55  64  81  104 113 92;
    49  64  78  87  103 121 120 101;
    72  92  95  98  112 100 103 99];
AQ_DCT=zeros(M/2,N/2);

dct_blocks = zeros(M/2,N/2);

for i = 1:8:M/2         
    for j = 1:8:N/2
        dct_blocks(i:(i+7),j:(j+7))= (A_DCT(i:(i+7),j:(j+7)));
    end
end
 
for i=1:8:M/2
    for j=1:8:N/2
        AQ_DCT(i:(i+7),j:(j+7)) = round(dct_blocks(i:(i+7),j:(j+7))./Q);
    end
end
 

histog = zeros(1,256);
for x = 1 : 1 : M/2
   for y = 1 : 1 : N/2
      histog (AQ_DCT(x,y) + 1 ) = histog ((AQ_DCT(x,y)) + 1 ) + 1;   % yi kümesi için AQ_DCT histogram
   end
end

a_dct_count=0.0;
for k=1:1:1
   for l=1:1:256
      a_dct_count =  ((AQ_DCT(k,l)*255) * histog(k,l)) + a_dct_count;
   end
end
ay=1 / (a_dct_count);
BQM1=1 - (1 / (ay));

J=2;
for j=1:1:J
    BQM=(2^(J-j)*BQM1)/3;
end

figure;imshow(Img);title('Original');
figure;imshow(Iblur);title('Blur');
figure;imshow(Edge);title('Edge Map');
figure;imshow(A_DCT);title('Absoult DCT');
figure;plot(SD,a_plot); xlabel('SD');ylabel('a');
