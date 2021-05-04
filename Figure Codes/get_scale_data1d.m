function [min_x,max_x]=get_scale_data_1b(t, rawdata,groups)

% usage:
% [min_mean_d,max_mean_d]=get_scale_from_rawdata(rawdata,groups);

% get scale 
max_x=-1000000;min_x=1000000;


t_indicies = find(t>=50 & t<300);

% From figure 1c
for i=1:2
    if i == 1
        % get data from pref group
        indices_in=find(groups==4);
    else
        % get data from other group
        indices_in=find(groups~=4);
    end
    d=rawdata(indices_in,t_indicies);
    min_d = min(d,[],2);
    max_d = max(d,[],2);
    range_d = max_d-min_d;
    mean_d = mean(range_d);
    n_indices_in=length(indices_in);
    std_d=std(range_d);
    se_d=std_d/sqrt(n_indices_in);
    
    max_mean_d=max(mean_d+se_d);min_mean_d=min(mean_d-se_d);
    if (max_mean_d>max_x) max_x=max_mean_d; end
    if (min_mean_d<min_x) min_x=min_mean_d; end
    %keyboard;
end

max_x=ceil(max_x/100)*100;
min_x=floor(min_x/100)*100;