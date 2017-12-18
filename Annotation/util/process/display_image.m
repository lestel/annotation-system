function [I,I_serials,I_name,I_label,I_label_str]=display_image(data_name,strPath,study_serials,pos)
load(data_name);
serials=study_serials;
I_serials=find(study_serials==pos);
I_name=f_name{pos,1};
I=imread(fullfile(strPath,I_name));
I_label=f_label(pos);
I_label_str=label_invert_str(I_label);

