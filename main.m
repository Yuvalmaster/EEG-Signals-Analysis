clc ; clear all ; close all ;
mainpath = pwd;

addpath(strcat(mainpath,'\Functions'))

file_name={strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.06.36+02.00.md.csv'),...
           strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.09.03+02.00.md.csv'),...
           strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.17.37+02.00.md.csv'),...
           strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.19.33+02.00.md.csv')};

N_samples = [9589,9295,9316,9155];

file_name_latency = {strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.06.36+02.00_intervalMarker.csv'),...
                     strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.09.03+02.00_intervalMarker.csv'),...
                     strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.17.37+02.00_intervalMarker.csv'),...
                     strcat(mainpath,'\Data\EPOCX_132453_2021.11.28T12.19.33+02.00_intervalMarker.csv')};

[AF3, F7, F3, FC5, T7, P7, O1, O2, P8, T8, FC6, F4, F8, AF4, Latency_mat, timestamp]=...
Load_data(char(file_name(1)),char(file_name_latency(1)),N_samples(1));

[Std_Alpha_Open  ,...
 Std_Beta_Open   ,...
 Std_Theta_Open  ,...
 Std_Delta_Open  ,...
 Std_Alpha_closed,...
 Std_Beta_closed ,...
 Std_Theta_closed,...
 Std_Delta_closed] = EEG_filtering(AF3,F7,F3,FC5,T7,P7,O1,O2,P8,T8,FC6,F4,F8,AF4,N_samples(1),timestamp,Latency_mat);

[ED] = Salt_bridge_detection(strcat(mainpath,'\Data\Data1.txt'));