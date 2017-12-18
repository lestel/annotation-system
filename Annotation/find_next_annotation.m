%{
option.choose_strategies=8;
option.fuision_strategies=1;
option.fuision_array=1;
name='HOGandlabel.mat';
study_serials=2:788;
initial_serials=[780,790,2000,710];
user_label_record=nan(1,length(study_serials));
study_serials_serial=[];
method=0;
[one_serials,study_serials_serial,user_label_record]=find_next_annotation(name,study_serials,initial_serials,study_serials_serial,user_label_record,option,method);
%}






function  [one_serials,study_serials_serial,user_label_record]=find_next_annotation(name,study_serials,initial_serials,study_serials_serial,user_label_record,option,method)
%study_serials_serial  在study_serial 的位置 不断长度加1 加在最前
%one_serials           在整个train的位置 恒为1
%user_label_record     study_serial的标注 永远等于study serial 长度




load(name);
f_label(f_label==-1)=0;
study_serials_all=[study_serials,initial_serials];
fea=f_hog(study_serials_all,:);
true_label=f_label(study_serials_all,:);
na=study_serials_all';
label=[user_label_record';f_label(initial_serials,1)];

initial_serials_serials=(length(study_serials)+1):(length(study_serials)+length(initial_serials));
train_sample=[na,label,fea];
pic_num=length(study_serials);
pos1=find(user_label_record~=-1);
pos2=find(isnan(user_label_record)~=1);
pos=intersect(pos1,pos2);
study_serials_serial2=pos;

now_labeled_serial_serial=[study_serials_serial2,initial_serials_serials];

unlabeled_serial_serial=setdiff(1:pic_num,study_serials_serial);
if method==1
[choose_part_serials_serial_serial,~,~]=hybird_active_choose_sample_w(option.choose_strategies,train_sample,now_labeled_serial_serial,unlabeled_serial_serial,1,option.fuision_strategies,option.fuision_array);
else
   choose_part_serials_serial_serial=1; 
end
choose_part_serials_serial=unlabeled_serial_serial(1,choose_part_serials_serial_serial); 

study_serials_serial=[choose_part_serials_serial,study_serials_serial];
user_label_record(1,choose_part_serials_serial)=-1;
one_serials=study_serials(choose_part_serials_serial);

