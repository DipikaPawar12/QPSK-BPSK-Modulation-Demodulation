clear;
clf;
fm=1;
dt=0.001;
T=2;
t=0:dt:T;
T=2;
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
fc=10;

Acarrier=1:0.5:15;
nle=length(Acarrier);
pb=zeros(1:nle);
eb=zeros(1:nle);
for j=1:nle
    Ac=Acarrier(j);
    eb(j)=Ac*Ac/(2*T);

    //ms=ms*sqrt(eb(j));
    c=Ac*cos(2*%pi*fc*t);
    phi=sqrt(2/T)*c;
    psk=c.*ms;
    
    noiseVariance=0.1;
    noise = sqrt(noiseVariance)*rand(1,length(psk));
    trasig=psk+noise;
    dm=(trasig).*phi;
    
    //Integration
    z=zeros(1:N);
    for i=1:N
        z(i)=(dm(i)*dt);
    end
    
    //Comparision
    dms=zeros(1:N);
    N=length(t);
    f=0;
    
    //Peak detactor calculation
    for i = 1:N
        if (i==N-1) then 
            //disp(z(i));
        end
        if (z(i)>0 )then
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
    pb(j)=count/N;
   // disp(count);
    disp(count/N);
end
//plot(Acarrier,pb); pb-->amp
plot(eb,pb);
xgrid(3);
xlabel("Eb", "fontsize", 2);
ylabel("Bit error rate", "fontsize", 2);
title("Bit error probability curve for BPSK with noise","fontsize",4);
