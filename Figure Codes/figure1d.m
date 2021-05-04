function figure1d(subject_nr,channel_nr,t_before_ms,t_after_ms)
 %usage:
% figure1d(subject_nr,channel_nr,t_before_ms,t_after_ms)
%
% subject_nr = subject number
% init_exp = initial expeirment session
% finit_exp = final experiment session
% t_before_ms = time before stimulus onset (ms)
% t_after_ms = time after stimulus onset (ms)

%[code_dir,data_dir,temp_dir,gdat_dir]=get_environment_variables;
program_name='figure1d';
program_version=1;

default_params;

%%%%%%%%%%%%%%%%%%%%%%%%
% loading all the data %
%%%%%%%%%%%%%%%%%%%%%%%%

% time used as input because that's the way files are stored
if (verbose)
    txt=sprintf('\nloading the data for subject_nr=%d t_before_ms=%.0f t_after_ms=%.0f',subject_nr,t_before_ms,t_after_ms);
    disp(txt);
end
[t,p_all,d_all,expid]=load_data_v2(gdat_dir,subject_nr,t_before_ms,t_after_ms);
if (isempty(d_all))
    txt=sprintf('error! %s v%d: d_all is empty',program_name,program_version);
    disp(txt);
    return;
end

% get data for a specific channel
rawdata=d_all{channel_nr};
%rawdata is stored in [trials, timepoints]

% object categories (indexes into array and gets the column with object
% category info)
groups=p_all(:,5);

% Make list of gorups
groups_list=sort3(groups);

% Number of groups
n_groups=length(groups_list);

% Number of trials
n_trials=length(groups);

% Find columns/indices where time is in 50-300ms post stimulus interval
t_indicies = find(t>=50 & t<300);

% Get trials of pref category (4)
pref_indicies = find(groups==4);

% get color for each category
[plot_colors,plot_colors_symbol,plot_colors_dashed,plot_colors_v,plot_colors_va]=get_n_colors_text(7);

% get x scale for plots
[min_x,max_x]=get_scale_data1d(t,rawdata,groups);              

if (min_x==max_x) 
    txt=sprintf('error min_x=max_x please check rawdata and/or groups');
    disp(txt);
    return; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot with all the data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
hs=subplot(2,2,1); hold all;
%title(txtgeneral);

% create matrix for preferred category (4) and all other objects not 4, 5
% objects per category
%col 1 = ifp response across each trial
%d_pref_cat = zeros(n_trials,1);
d_pref_cat=[];

%plot for other categories
%col 1 = ifp for other_group1 etc.. 
%d_other_cat=zeros(n_trials,n_groups-1);
d_other_cat=[];


for i=1:2
    if i == 1
        % get data of Pref. Group
        d = rawdata(pref_indicies,t_indicies);
    else
        % Get data from other trials
        indicies_in=find(groups~=4);
        % data from other groups
        d=rawdata(indicies_in,t_indicies);
    end

    % Find Min IFP in each row (trial)
    min_d = min(d,[],2);
    
    % Find Max IFP in each row (trial)
    max_d = max(d,[],2);
    
    % Get range of signal
    range_d = max_d-min_d;
    
 
    % Plot distribution of range
     N = histcounts(range_d,n_trials,'Normalization', 'probability');
     plot(N);
     mean_d=mean(range_d);
     
    
end



% Plot other 
%plot(prop_d_other_cat); 

% Axis
xlim([min_x max_x]); 
xlabel('IFP responnse (microV)');
ylabel('Proportion');





    


