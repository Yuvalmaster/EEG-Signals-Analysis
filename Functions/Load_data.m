function [AF3, F7, F3, FC5, T7, P7, O1, O2, P8, T8, FC6, F4, F8, AF4, Latency_mat, timestamp]=...
         Load_data(file_name,file_name_latency,N_samples)

    %% Load Data
    Latency_mat = readmatrix(file_name_latency);
    %Time stamp
    timestamp = csvread(file_name,2, 0,[2,0,N_samples+1,0]);
    
    %Extract deta for each electrode
    Values_AF3 = csvread(file_name,2, 3,[2,3,N_samples+1,3]);
    Values_F7 = csvread(file_name,2, 4,[2,4,N_samples+1,4]);
    Values_F3 = csvread(file_name,2, 5,[2,5,N_samples+1,5]);
    Values_FC5 = csvread(file_name,2, 6,[2,6,N_samples+1,6]);
    Values_T7 = csvread(file_name,2, 7,[2,7,N_samples+1,7]);
    Values_P7 = csvread(file_name,2, 8,[2,8,N_samples+1,8]);
    Values_O1 = csvread(file_name,2, 9,[2,9,N_samples+1,9]);
    Values_O2 = csvread(file_name,2, 10,[2,10,N_samples+1,10]);
    Values_P8 = csvread(file_name,2, 11,[2,11,N_samples+1,11]);
    Values_T8 = csvread(file_name,2, 12,[2,12,N_samples+1,12]);
    Values_FC6 = csvread(file_name,2, 13,[2,13,N_samples+1,13]);
    Values_F4 = csvread(file_name,2, 14,[2,14,N_samples+1,14]);
    Values_F8 = csvread(file_name,2, 15,[2,15,N_samples+1,15]);
    Values_AF4 = csvread(file_name,2, 16,[2,16,N_samples+1,16]);
    
    %Baseline the Signals around 0 [µv]
    AF3=Values_AF3-mean(Values_AF3);
    F7=Values_F7-mean(Values_F7);
    F3=Values_F3-mean(Values_F3);
    FC5=Values_FC5-mean(Values_FC5);
    T7=Values_T7-mean(Values_T7);
    P7=Values_P7-mean(Values_P7);
    O1=Values_O1-mean(Values_O1);
    O2=Values_O2-mean(Values_O2);
    P8=Values_P8-mean(Values_P8);
    T8=Values_T8-mean(Values_T8);
    FC6=Values_FC6-mean(Values_FC6);
    F4=Values_F4-mean(Values_F4);
    F8=Values_F8-mean(Values_F8);
    AF4=Values_AF4-mean(Values_AF4);

end
