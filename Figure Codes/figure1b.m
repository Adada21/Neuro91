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
program_name='figure1b';
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

% object categories Indexes into array and gets the column with object
% category info
groups=p_all(:,5);

% list of object categories IN ORDER NO DUPLICATES
groups_list=sort3(groups);

% number of groups total (5)
n_groups=length(groups_list);

% Number of object number
objects=p_all(:,3);

% List objects of objects in order no duplicates and returns indicies of
% the values
objects_list=unique(objects);

% Find columns/indices where of first 600ms
t_indicies = find(t>=0 & t<=600);

% get color for each category
[plot_colors,plot_colors_symbol,plot_colors_dashed,plot_colors_v,plot_colors_va]=get_n_colors_text(7);

% get y scale for plots
[min_y,max_y]=get_scale_data_1b(rawdata,objects);

if (min_y==max_y) 
    txt=sprintf('error min_y=max_y please check rawdata and/or groups');
    disp(txt);
    return; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot with all the data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);


%title(txtgeneral);

%data=[] NEED TO SORT DATA
% Loop through each object; will loop 25 times
for i=1:n_groups
    
    % Keep Track of current group
    curr_group=groups_list(i);
    
    % Get objects in each group
    group_indices = find(groups == curr_group);
    
    % Get objects of current group 
    sub_objects = objects(group_indices,:);
    
    % Object numbers in current group
    sub_object_list = unique(sub_objects);
    
    % Get total number of objects (25 total)
    n_sub_objects=length(sub_object_list);
    
    % Loop thorugh each object and graph plot
    for j=1:n_sub_objects
        
        % Keep track of current object
        curr_object=sub_object_list(j);
        
        % Get Trials with currrent object
        object_indices = find(objects==curr_object);
        
        % Get data of current object
        d= rawdata(object_indices,t_indicies);
        
        % Get mean resposne across time points for each object
        mean_d=mean(d);
        
        % Get time
        t=1:size(d,2);
        t=t*1000/f_s;
        
        % Get Colorrs
        ct1=plot_colors{curr_group};
        
        % Creat object placeholder since object number missing 
        % values between 1-25
        obj_order= find(objects_list == curr_object);

        % Create subplot
        plot_ax(obj_order)=subplot(5, 5, obj_order);
        
        % Plot
        p=plot(t,mean_d,ct1);
        
        % Set boundaries
        ylim([min_y max_y]);
        xlim([0 600]);
        xticks([]);
        yticks({});
        
    end
    
end

% Clean up plot
% Get total number of objects (25 total)
n_objects=length(objects_list);
for i =1:n_objects
    pos = get(plot_ax(i), 'Position');
    pos(1) = pos(1) * .80;
    pos(2) = pos(2) * .80;
    set(plot_ax(i), 'Position', pos);
    set(plot_ax(i),'Visible','off')
end
%FINISH SORTING DATA
%final=sort(data);
%bar(final);
set(plot_ax(21),'Visible','on');
set(plot_ax(21),'box','off');
set(plot_ax(21),'Color','none')
set( get(plot_ax(21),'XLabel'), 'String', '600ms');
set( get(plot_ax(21),'YLabel'), 'String', '200 microV');
set(plot_ax(21),'XColor','k','YColor','k');


