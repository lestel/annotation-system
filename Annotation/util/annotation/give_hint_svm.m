function str=give_hint_svm(fea,f_label,study_serials,user_label_record1,latiao_value,stand_serial)

pos_labeled=intersect(find(isnan(user_label_record1)==0),find(user_label_record1~=-1));%该组所有数据中已有明确标注的样本序号
pos_now=ceil(latiao_value+1);%待测样本序号
pos_labeled(pos_labeled==pos_now)=[];%该组所有数据中已有明确标注的样本序号（在该组中），不包括待测样本


f_label(f_label==-1)=0;
user_label_record=[f_label(stand_serial,1)',user_label_record1(1,pos_labeled)]; %该组所有数据中已有明确标注的样本的label，不包括待测样本  
fea_labeled_serial=[stand_serial',study_serials(pos_labeled)];%该组所有数据中已有明确标注的样本序号（在整个数据集中），不包括待测样本

fea_labeled=fea(fea_labeled_serial,:);%该组所有数据中已有明确标注的样本（在整个数据集中），不包括待测样本
fea_now=fea(study_serials(pos_now),:);%待测样本特征（在整个数据集中）

if length(user_label_record)<2
   str=['now SVM with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples can not give any hints'];
else
   net=svmtrain(user_label_record',fea_labeled,'-q -t 2 -s 0 -c 1 -g 1');
   [result,~,~]=svmpredict(nan,fea_now,net);
   if result==0
   type='mass';   
   elseif result==1
   type='no mass';
   end
   str=['now SVM with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples think it is ',type];
end



