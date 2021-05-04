function [min_y,max_y]=get_scale_data_1b(rawdata,objects)

% usage:
% [min_mean_d,max_mean_d]=get_scale_from_rawdata(rawdata,groups);

% get scale 
objects_list=sort3(objects);
max_y=-1000000;min_y=1000000;
n_objects=length(objects_list);

for curr_object_index=1:n_objects
    curr_object=objects_list(curr_object_index);
    indices_in=find(objects==curr_object);
    n_indices_in=length(indices_in);
    d=rawdata(indices_in,:);
    mean_d=mean(d);
    std_d=std(d);
    se_d=std_d/sqrt(n_indices_in);
    max_mean_d=max(mean_d+se_d);min_mean_d=min(mean_d-se_d);
    if (max_mean_d>max_y) max_y=max_mean_d; end
    if (min_mean_d<min_y) min_y=min_mean_d; end
    %keyboard;
end

max_y=ceil(max_y/10)*10;
min_y=floor(min_y/10)*10;

