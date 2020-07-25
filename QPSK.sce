clear;
clf;
fm=1; //Modulating wave frequency
dt=0.001;
t=0:dt:2;
m=sin(2*%pi*fm*t); //Modulating wave
//*********************Level Converter Block******************//
N=length(t);
modulating_signal=zeros(1:N);
for i =1:N
 if(m(i)>0) then
 modulating_signal(i)=1; //Modulating square wave
 else
 modulating_signal(i)=-1; //Modulating square wave
 end
end
//*******************Carrier wave generator***************//
fc=fm*10; //Carrier wave frequency
Ac=4.25;
oddSample=1:2:N;
evenSample=2:2:N;
carrier_odd=Ac*sin(2*%pi*fc*dt*oddSample); //Carrier wave 1 with odd samples
carrier_even=Ac*cos(2*%pi*fc*dt*evenSample); //Carrier wave 2 with even samples
//****************Modulated signal generator*****************//
modulated_signal=zeros(1:N);
for i=1:N
 if modulo(i,2)==0 then
    modulated_signal(i) =modulating_signal(i).*carrier_even(i/2);
 else
    modulated_signal(i) = modulating_signal(i).*carrier_odd(i/2+1);
 end
end
//******Addition of Gaussian Noise in Transmitted signal******//
r=rand(modulated_signal,"uniform");
hp=ffilt("hp",100,(fm)*dt);
filtered=filter(hp,1,r);
noiseVariance=0.1;
noise = sqrt(noiseVariance)*rand(1,length(modulated_signal));
//Generation of noise
qpsk=noise+modulated_signal; //Transmitted signal
//**********************Received signal**********************//
dm=zeros(1:N); //Received signal
for i=1:N
 if modulo(i,2)==0 then
 //disp(i);
20
 dm(i)=qpsk(i).*carrier_even(i/2);
 else
 dm(i)=qpsk(i).*carrier_odd(i/2+1);
 end
end
//*********************Demodulation Block*******************//
demodulated_signal=zeros(1:N);
for i=1:N
 demodulated_signal(i)=(dm(i)*dt); //demodulated signal
end
//*************************Decision Block********************//
final_signal=zeros(1:N);
for i=1:N
 if (demodulated_signal(i)>0) then
 final_signal(i)=1; //Output of decision block
 else
 final_signal(i)=-1;//Output of decision block
 end
end
//**********************Bit Error Probability****************//
count=0;
for i=1:N
 if final_signal(i)==modulating_signal(i) then
 count=count;
21
 else
 count=count+1;
 end
end
disp(count);
disp(count/N); //Displaying the value of bit error probability
//****************************Plots**************************//
//Modulating signal
subplot(421);
plot(t,modulating_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Modulating signal", "fontsize", 4);
//carrier wave 1
subplot(422);
plot(carrier_odd);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Odd carrier Signal", "fontsize", 4);
//carrier wave 2
subplot(423);
plot(carrier_even);
22
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Even carrier signal", "fontsize", 4);
//Modulated signal
subplot(424);
plot(modulated_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Modulated signal", "fontsize", 4);
//Transmitted signal with noise
subplot(425);
plot(qpsk);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("signal with noise", "fontsize", 4);
//Received signal
subplot(426);
plot(dm);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
23
title("Received signal", "fontsize", 4);
//Demodulated Signal
subplot(427);
plot(demodulated_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Demodulated signal", "fontsize", 4);
//Signal from decision box
subplot(428);
plot(final_signal);
xgrid(3);
xlabel("time","fontsize",2);
ylabel("amplitude","fontsize",2);
title("Final signal from decision box", "fontsize", 4);
