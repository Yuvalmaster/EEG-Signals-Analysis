function [ED]=Salt_bridge_detection(File_name)

% Load Data
Data=readmatrix(File_name);
N_samples = length(Data(:,1));
Fs = 128;                       % [Hz]
Ts = 1/Fs;                      % [Sec]
Tmax=(N_samples-1)*Ts;          % [Sec]
t3 = 0:Ts:Tmax;                 % Time Vector    

% Extract data for each electrode
Values_AF3 = Data(:,1);
Values_F7 = Data(:,2);
Values_F3 = Data(:,3);
Values_FC5 = Data(:,4);
Values_T7 = Data(:,5);
Values_P7 = Data(:,6);
Values_O1 = Data(:,7);
Values_O2 = Data(:,8);
Values_P8 = Data(:,9);
Values_T8 = Data(:,10);
Values_FC6 = Data(:,11);
Values_F4 = Data(:,12);
Values_F8 = Data(:,13);
Values_AF4 = Data(:,14);

% Referance between signals
signal1=abs(Values_AF3-Values_F7);
signal2=abs(Values_F7-Values_F3);
signal3=abs(Values_F3-Values_FC5);
signal4=abs(Values_FC5-Values_T7);
signal5=abs(Values_T7-Values_P7);
signal6=abs(Values_P7-Values_O1);
signal7=abs(Values_O1-Values_O2);
signal8=abs(Values_O2-Values_P8);
signal9=abs(Values_P8-Values_T8);
signal10=abs(Values_T8-Values_FC6);
signal11=abs(Values_FC6-Values_F4);
signal12=abs(Values_F4-Values_F8);
signal13=abs(Values_F8-Values_AF4);


% Signals Vector
Signals=[signal1 signal2 signal3 signal4 signal5 signal6 signal7 signal8 signal9 signal10 signal11 signal12 signal13];
E_names={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
ED=[];
for i=1:length(Signals(1,:))    
    %Find Variance
    ED = [ED var(Signals(:,i),1)];
        
end

% Normalize ED - Find saltbridge via ED 
ED = normalize(ED,'range'); %ED_thresh <=0.1

%Plot data 
Electrodes=[Values_AF3 Values_F7 Values_F3 Values_FC5 Values_T7 Values_P7 Values_O1 Values_O2 Values_P8 Values_T8 Values_FC6 Values_F4 Values_F8 Values_AF4];
for i=1:length(Signals(1,:))

    if ED(i)<=0.5 % SVM
        %Plots
        if min(Signals(:,i))<100 % Detects only signals with difference lower than 100[mv]
            salt_bridge_loc=find(Signals(:,i)<100); % Locate salt bridge occurances
            salt_bridge = Signals(salt_bridge_loc,i);
            salt_bridge_time=t3(salt_bridge_loc); % Time vector
            figure; plot(salt_bridge_time,salt_bridge); %Plot signal
            hold on; plot(salt_bridge_time,Electrodes(salt_bridge_loc,i)); plot(salt_bridge_time,Electrodes(salt_bridge_loc,i+1)); % Plot each electrode
            legend(append(char(E_names(i)),' - ',char(E_names(i+1)),' Signal'),append(char(E_names(i)),' Electrode Signal'),append(char(E_names(i+1)),' Electrode Signal')); 
            xlabel('time [Sec]'); ylabel('Amplitude [mV]'); grid on;
            
            title(append(char(E_names(i)),' - ',char(E_names(i+1)),' Signal - Salt bridge DETECTED'));
        
        else
        %Plots
        figure; plot(t3,abs(Electrodes(:,i)-Electrodes(:,i+1))); %Plot signal
        hold on; plot(t3,Electrodes(:,i)); plot(t3,Electrodes(:,i+1)); % Plot each electrode
        legend(append(char(E_names(i)),' - ',char(E_names(i+1)),' Signal'),append(char(E_names(i)),' Electrode Signal'),append(char(E_names(i+1)),' Electrode Signal')); 
        xlabel('time [Sec]'); ylabel('Amplitude [mV]'); grid on;
        
        title(append(char(E_names(i)),' - ',char(E_names(i+1)),' Signal - No Salt bridge '));
        end
    else
        %Plots
        figure; plot(t3,abs(Electrodes(:,i)-Electrodes(:,i+1))); %Plot signal
        hold on; plot(t3,Electrodes(:,i)); plot(t3,Electrodes(:,i+1)); % Plot each electrode
        legend(append(char(E_names(i)),' - ',char(E_names(i+1)),' Signal'),append(char(E_names(i)),' Electrode Signal'),append(char(E_names(i+1)),' Electrode Signal')); 
        xlabel('time [Sec]'); ylabel('Amplitude [mV]'); grid on;
        
        title(append(char(E_names(i)),' - ',char(E_names(i+1)),' Signal - No Salt bridge '));
    end

end
end