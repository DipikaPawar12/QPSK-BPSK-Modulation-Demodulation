
clear;
clf;
fm=1;
dt=0.001;
T=2
t=0:dt:T;
m=sin(2*%pi*fm*t);
N=length(t);
ms=zeros(1:N);
for i =1:N
    if(m(i)>0) then
        ms(i)=1;
    else
        ms(i)=-1;
    end 
end

fc=fm*10;
oddSample=1:2:N;
evenSample=2:2:N;
Acarrier=1:10;
nle=length(Acarrier);
pb=zeros(1:nle);
eb=zeros(1:nle);
for j=1:nle
    Ac=Acarrier(j);
    eb(j)=Ac*Ac/(2*T);

    odd=Ac*sin(2*%pi*fc*dt*oddSample);
    even=Ac*cos(2*%pi*fc*dt*evenSample);
    
    mds=zeros(1:N);
    for i=1:N
        if modulo(i,2)==0 then
            //disp(i);
            mds(i)=ms(i).*even(i/2);
        else
            mds(i)=ms(i).*odd(i/2+1);
        end
    end
    //qpsk=ms.*odd+ms.*even;
    
    r=rand(mds,"uniform");
    hp=ffilt("hp",100,(fm)*dt);
    filtered=filter(hp,1,r);
    noiseVariance=0.1;
    noise = sqrt(noiseVariance)*rand(1,length(mds));
    qpsk=noise+mds;
    
    dm=zeros(1:N);
    for i=1:N
        if modulo(i,2)==0 then
            //disp(i);
            dm(i)=qpsk(i).*even(i/2);
        else
            dm(i)=qpsk(i).*odd(i/2+1);
        end
    end
    
    integrate=zeros(1:N);
    for i=1:N
        integrate(i)=(dm(i)*dt);
    end
    
    dms=zeros(1:N);
    for i=1:N
      if (integrate(i)>0 )then
            dms(i)=1;
        else
            dms(i)=-1;
        end
    end
    
    count=0;
    for i=1:N
        if dms(i)==ms(i) then
            count=count;
        else
            count=count+1;
            end
    end
    //disp(count);
    pb(j)=count/N;
    disp(pb(j));
end
//plot(Acarrier,pb); pb-->amp
plot(eb,pb);
xgrid(3);
xlabel("Eb", "fontsize", 2);
ylabel("Bit error rate", "fontsize", 2);
title("Bit error probability curve for QPSK with noise","fontsize",4);
