function ifp_plot_rawdata(subject_nr,channel_nr,t_before_ms,t_after_ms)

% usage: 
% ifp_plot_rawdata(subject_nr,channel_nr,t_before_ms,t_after_ms)
%
% subject_nr = subject number
% init_exp = initial expeirment session
% finit_exp = final experiment session
% t_before_ms = time before stimulus onset (ms)
% t_after_ms = time after stimulus onset (ms)

%[code_dir,data_dir,temp_dir,gdat_dir]=get_environment_variables;
program_name='ifp_plot_rawdata';
program_version=1;

default_params;

%%%%%%%%%%%%%%%%%%%%%%%%
% loading all the data %
%%%%%%%%%%%%%%%%%%%%%%%%

%Time used as input because that's the way files are stored
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
%d_all is 1 x 72 so 72 columns or channels and 1 row
rawdata=d_all{channel_nr};  
%rawdata gets the data in a specific channel from 1-72
%rawdata returns a matrix of trial (rows) by (time columns)


% object categories Indexes into arrow and gets the column with object
% category info
% Each row is a trial, but groups is the category
groups=p_all(:,5);                                                  

% list of object categories IN ORDER NO DUPLICATES; 5 total
groups_list=sort3(groups);   

% number of object categories
n_groups=length(groups_list);                                       

% get color for each category
[plot_colors,plot_colors_symbol,plot_colors_dashed,plot_colors_v,plot_colors_va]=get_n_colors_text(7);      

% get y scale for plots
[min_y,max_y]=get_scale_from_rawdata(rawdata,groups);              

if (min_y==max_y) 
    txt=sprintf('error min_y=max_y please check rawdata and/or groups');
    disp(txt);
    return; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot with all the data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
hs=subplot(2,2,1);hold on;
%title(txtgeneral);
add_stimulus_bar(0,200,min_y,max_y);

%% Loops through all categories and plots data of each group
for i=1:n_groups
    
    % Keep Track of current group
    curr_group=groups_list(i);
    
    % get index of particular trials that contaiin the group
    indices_in=find(groups==curr_group);
    
    % Gets Raw data in a trial
    d=rawdata(indices_in,:);
    
    % Take mean activity across time of each group 
    mean_d=mean(d);
    
    % Find std of raw data
    std_d=std(d);
    
    % Find standard error
    n=length(indices_in);
    ste_d=std_d/sqrt(n);
    
    % size returns number of elements in the 2nd dimension of d
    t=1:size(d,2);
    t=t*1000/f_s-t_before_ms;
    ct1=plot_colors{curr_group};
    ct2=plot_colors_symbol{curr_group};
    ct3=plot_colors_va(curr_group,:);
    p=plot(t,mean_d,ct1);
    
    %pe=errorbar(t,mean_d,ste_d,ct1);
    %keyboard;
    pe=errorbar(t(1:5:length(t)),mean_d(1:5:length(t)),ste_d(1:5:length(t)),ct2);
    set(pe,'MarkerSize',1);
    set(pe,'Color',ct3);
    set(pe,'LineWidth',0.25);
    
    %unclear what this does
    txt=sprintf('%d',n);
    ht=text(0.95*max(t),max_y*(1-i*0.07),txt);
    set(ht,'Color',ct1);
    %keyboard;
end
axis([min(t),max(t),min_y,max_y]);
set(hs,'TickDir','out');set(hs,'Box','Off');
xlabel('Time (ms)');
ylabel('IFP signal (microV)');
p=plot([0 0],[min_y max_y],'k--');
