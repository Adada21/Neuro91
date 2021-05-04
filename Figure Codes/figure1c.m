function figure1c(subject_nr,channel_nr,t_before_ms,t_after_ms)

% usage:
% figure1c(subject_nr,channel_nr,t_before_ms,t_after_ms)
%
% subject_nr = subject number
% init_exp = initial expeirment session
% finit_exp = final experiment session
% t_before_ms = time before stimulus onset (ms)
% t_after_ms = time after stimulus onset (ms)

%[code_dir,data_dir,temp_dir,gdat_dir]=get_environment_variables;
program_name='figure1c';
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



% Object number for each trial
objects=p_all(:,3);

% List objects of objects in order no duplicates and returns indicies of
% the values
objects_list=sort3(objects);

% Get total number of objects (25 total)
n_objects=length(objects_list);

% Find columns/indices where time is in 50-300ms post stimulus interval
t_indicies = find(t>=50 & t<300);


% get color for each category
[plot_colors,plot_colors_symbol,plot_colors_dashed,plot_colors_v,plot_colors_va]=get_n_colors_text(7);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot with all the data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
hs=subplot(2,2,1); hold on;
%title(txtgeneral);

% create matrix(n_objects x 3) to sort beforre plotting bar graph
% Column 1 obj_cat 
% Column 2 mean, 
% Column 3 ste_d,
% Column 3
% Loop through each object; will loop 25 times
unsorted_graph = zeros(n_objects,3);

for i=1:n_objects
    
    % Keep Track of Current Object
    curr_object=objects_list(i);
    
    % Get index of  trials where the object is the current object
    indicies_in=find(objects==curr_object);
    
    % Get Raw Dat When we are in current object and in 50-300ms post
    % stimulus interval
    %Returns all the data in relevant object trial and relevant time
    d=rawdata(indicies_in,t_indicies);

    % Find Min IFP in each row (trial)
    min_d = min(d,[],2);
    
    % Find Max IFP in each row (trial)
    max_d = max(d,[],2);
    
    % Get range of signal
    range_d = max_d-min_d;
    
    % Get mean of range accross trials
    mean_d = mean(range_d);
    
    % Add mean to matrix
    unsorted_graph(i,2) = mean_d;
    
    % Get standard deviation
    std_d = std(range_d);
    
    % Get standard error
    n=length(indicies_in);
    ste_d=std_d/sqrt(n);
    
    % Add standarrd error to matrix
    unsorted_graph(i,3) = ste_d;
   
    % FIND CATEGORY OF EACH OBJECT
    obj_cat = groups(indicies_in);

    % Will be the same since its same object so we can use the first
    % element
    curr_group = obj_cat(1);
    % Add group to matrix
    unsorted_graph(i,1) = curr_group;
   

end

% Sort unsorted_graph by mean IFP ascending order
% Find index sorted graph by mean
[~, index_sort] = sort(unsorted_graph(:,2));

% Create new sorted graph matrix
sorted_graph = unsorted_graph(index_sort,:);

% Graph sorted graph
for i=1:n_objects
    
    % Values for graph
    obj_cat_sort = sorted_graph(i,1);
    mean_d_sort = sorted_graph(i,2);
    ste_d_sort = sorted_graph(i,3);
    
    % Get Colors
    ct1=plot_colors{obj_cat_sort};
    ct2=plot_colors_symbol{obj_cat_sort};
    ct3=plot_colors_va(obj_cat_sort,:);
    
    % Plot Graph
    b=bar(i,mean_d_sort,ct1);
    
    %Get Error Bars
    pe=errorbar(i, mean_d_sort, ste_d_sort, ct2);
    set(pe,'MarkerSize',1);
    set(pe,'Color',ct3);
    set(pe,'LineWidth',0.25); 
    
end
    
xlabel('Object number');
ylabel('IFP response (microV)');



