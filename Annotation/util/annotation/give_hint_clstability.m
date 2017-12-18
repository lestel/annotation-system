function str=give_hint_clstability(fea,f_label,study_serials,user_label_record1,latiao_value,stand_serial)

pos_labeled=intersect(find(isnan(user_label_record1)==0),find(user_label_record1~=-1));%该组所有数据中已有明确标注的样本序号
pos_now=ceil(latiao_value+1);%待测样本序号
pos_labeled(pos_labeled==pos_now)=[];%该组所有数据中已有明确标注的样本序号（在该组中），不包括待测样本

user_label_record=[f_label(stand_serial,1)',user_label_record1(1,pos_labeled)]; %该组所有数据中已有明确标注的样本的label，不包括待测样本  
fea_labeled_serial=[stand_serial',study_serials(pos_labeled)];%该组所有数据中已有明确标注的样本序号（在整个数据集中），不包括待测样本


fea_labeled=fea(fea_labeled_serial,:);%该组所有数据中已有明确标注的样本（在整个数据集中），不包括待测样本
fea_now=fea(study_serials(pos_now),:);%待测样本特征（在整个数据集中）

n=length(fea_labeled_serial)+1;
if n<9
str=['now CL with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples can not give any hints'];
elseif n>30
str=['now CL with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples is too slow to give any hints'];
   
else    
a=n/2+3*sqrt(n)/2;

h = waitbar(0,'Please wait...');
result=nan(1,n-1);
for i=1:n-1
    tmp=user_label_record;
    if tmp(1,i)==1
       tmp(1,i)=0;
    elseif tmp(1,i)==0
       tmp(1,i)=1; 
    end
   net=svmtrain(tmp',fea_labeled,'-q -t 2 -s 0 -c 1 -g 1');
   [result(1,i),~,~]=svmpredict(nan,fea_now,net);
   waitbar(i/(n-1));
end
delete(h);
num1=length(find(result==1));
num0=length(find(result==0));

if num0>a&&num1>a
   str=['now CL with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples can not give any hints'];
elseif num0>a&&num1<=a
   type='mass';   
   str=['now CL with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples think it is ',type];
elseif num0<=a&&num1>a
   type='no mass';
   str=['now CL with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples think it is ',type];
elseif num0<=a&&num1<=a
   str=['now CL with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)),' samples are fused'];

end

end


