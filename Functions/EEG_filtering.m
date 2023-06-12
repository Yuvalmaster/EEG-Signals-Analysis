function [Std_Alpha_Open,Std_Beta_Open, Std_Theta_Open,Std_Delta_Open,Std_Alpha_closed,Std_Beta_closed,Std_Theta_closed,Std_Delta_closed]=...
         EEG_filtering(AF3,F7,F3,FC5,T7,P7,O1,O2,P8,T8,FC6,F4,F8,AF4,N_samples,timestamp,Latency_mat)

    %% Q1
    Ts=mean(diff(timestamp));       % [Sec]
    Fs=1/Ts;                        % [Hz]
    Tmax=(N_samples-1)*Ts;          % [Sec]
    t1 = 0:Ts:Tmax;                 % Time Vector    

    %Filter Electrodes
    Signals=[AF3 F7 F3 FC5 T7 P7 O1 O2 P8 T8 FC6 F4 F8 AF4];
    E_names={'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
    Std_Alpha_Open=[];
    Std_Beta_Open=[];
    Std_Theta_Open=[];
    Std_Delta_Open=[];
    Std_Alpha_closed=[];
    Std_Beta_closed=[];
    Std_Theta_closed=[];
    Std_Delta_closed=[];

    for i=1:length(Signals(1,:))
        %% Q1.1
        
        % Filter each electrode with zero phase filtering, using BPF
        signal=Signals(:,i);
        Filtered = bandpass(signal,[1,30],Fs,'ImpulseResponse','auto'); % Cutting required frequencies 

        %Plot data
        figure;
        subplot(2,1,1); plot(t1,signal); hold on; plot(t1,Filtered);
        legend(append(char(E_names(i)),' Electrode Signal'),append(char(E_names(i)),' Filtered Electrode Signal')); 
        xlabel('time [Sec]'); ylabel('Amplitude [µV]'); grid on;
        title(append(char(E_names(i)),' Electrode Signal: Time Domain'));

        subplot(2,1,2); [pxx1,f1] = pwelch(signal,[],[],[],Fs,'power'); plot(f1,pow2db(pxx1)); 
        hold on; [pxx2,f2] = pwelch(Filtered,[],[],[],Fs,'power'); plot(f2,pow2db(pxx2));
        legend(append(char(E_names(i)),' Electrode Signal'),append(char(E_names(i)),' Filtered Electrode Signal')); 
        xlabel('frequency [Hz]'); ylabel('Amplitude [dB]'); grid on;       
        title(append(char(E_names(i)),' Electrode Signal: Frequency Domain'));
       
        %% Q1.2
        
        % Determine starting time of Open eyes segment
        starting_time_open = Latency_mat(1,1);
        [~,loc_starting_time_open] = min(abs(t1-starting_time_open));
        t2 = t1(loc_starting_time_open-1):Ts:t1(loc_starting_time_open-1)+Latency_mat(1,2);
        Open_signal = signal(loc_starting_time_open-1:(loc_starting_time_open-1+length(t2)-1));

        % Filtering out brain waves
        Delta_wave_Open = bandpass(Open_signal,[1,4],Fs,'ImpulseResponse','auto');
        Theta_wave_Open = bandpass(Open_signal,[4,7],Fs,'ImpulseResponse','auto');
        Alpha_wave_Open = bandpass(Open_signal,[7,12],Fs,'ImpulseResponse','auto');
        Beta_wave_Open  = bandpass(Open_signal,[12,30],Fs,'ImpulseResponse','auto');

        % Plot data
        figure;
        subplot(4,1,1); plot(t2,Delta_wave_Open); grid on;
        title(append(char(E_names(i)),': Delta Wave - Open eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        subplot(4,1,2); plot(t2,Theta_wave_Open); grid on;
        title(append(char(E_names(i)),': Theta Wave - Open eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        subplot(4,1,3); plot(t2,Alpha_wave_Open); grid on;
        title(append(char(E_names(i)),': Alpha Wave - Open eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        subplot(4,1,4); plot(t2,Beta_wave_Open); grid on;
        title(append(char(E_names(i)),': Beta Wave - Open eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
       
        % Save std and mean per wave 
        Std_Alpha_Open=[Std_Alpha_Open std(Alpha_wave_Open)];
        Std_Beta_Open=[Std_Beta_Open std(Beta_wave_Open)];
        Std_Theta_Open=[Std_Theta_Open std(Theta_wave_Open)];
        Std_Delta_Open=[Std_Delta_Open std(Delta_wave_Open)];
        
        %% Q1.3 

        % Determine starting time of Closed eyes segment
        starting_time_closed = Latency_mat(2,1);
        [~,loc_starting_time_closed] = min(abs(t1-starting_time_closed));
        t2 = t1(loc_starting_time_closed-1):Ts:t1(loc_starting_time_closed-1)+Latency_mat(2,2);
        Closed_signal = signal(loc_starting_time_closed-1:(loc_starting_time_closed-1+length(t2)-1));
        
        % Filter out brain waves
        Delta_wave_Closed = bandpass(Closed_signal,[1,4],Fs,'ImpulseResponse','auto');
        Theta_wave_Closed = bandpass(Closed_signal,[4,7],Fs,'ImpulseResponse','auto');
        Alpha_wave_Closed = bandpass(Closed_signal,[7,12],Fs,'ImpulseResponse','auto');
        Beta_wave_Closed = bandpass(Closed_signal,[12,30],Fs,'ImpulseResponse','auto');
        
        % Plot Data
        figure;
        subplot(4,1,1); plot(t2,Delta_wave_Closed); grid on;
        title(append(char(E_names(i)),': Delta Wave - Closed eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        subplot(4,1,2); plot(t2,Theta_wave_Closed); grid on;
        title(append(char(E_names(i)),': Theta Wave - Closed eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        subplot(4,1,3); plot(t2,Alpha_wave_Closed); grid on;
        title(append(char(E_names(i)),': Alpha Wave - Closed eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        subplot(4,1,4); plot(t2,Beta_wave_Closed); grid on;
        title(append(char(E_names(i)),': Beta Wave - Closed eyes')); xlabel('time [Sec]'); ylabel('Amplitude [µV]');
        
        % Save std and mean per wave 
        Std_Alpha_closed=[Std_Alpha_closed std(Alpha_wave_Closed)];
        Std_Beta_closed =[Std_Beta_closed std(Beta_wave_Closed)];
        Std_Theta_closed=[Std_Theta_closed std(Theta_wave_Closed)];
        Std_Delta_closed=[Std_Delta_closed std(Delta_wave_Closed)];

    end
end
