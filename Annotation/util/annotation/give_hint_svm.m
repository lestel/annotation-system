function str=give_hint_svm(fea,f_label,study_serials,user_label_record1,latiao_value,stand_serial)

pos_labeled=intersect(find(isnan(user_label_record1)==0),find(user_label_record1~=-1));%��������������������ȷ��ע���������
pos_now=ceil(latiao_value+1);%�����������
pos_labeled(pos_labeled==pos_now)=[];%��������������������ȷ��ע��������ţ��ڸ����У�����������������


f_label(f_label==-1)=0;
user_label_record=[f_label(stand_serial,1)',user_label_record1(1,pos_labeled)]; %��������������������ȷ��ע��������label����������������  
fea_labeled_serial=[stand_serial',study_serials(pos_labeled)];%��������������������ȷ��ע��������ţ����������ݼ��У�����������������

fea_labeled=fea(fea_labeled_serial,:);%��������������������ȷ��ע�����������������ݼ��У�����������������
fea_now=fea(study_serials(pos_now),:);%�����������������������ݼ��У�

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



