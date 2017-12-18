%{

load('HOGandlabel.mat');
fea=f_hog;
stand_serial=[664,1846,647,1586,3073,2830,2355,2621];
study_serials=[2012:2024];
user_label_record=[0,0,0,0,0,0,1,1,1,1,1,1,nan];
latiao_value=12;
strPath='D:\work\DOCTOR_WORK\ALG\matlab\Annotation\data\all';
[I1,I2,I3,I4,str]=give_hint_3nn(fea,f_name,f_label,strPath,study_serials,user_label_record,latiao_value,stand_serial);
subplot(2,2,1);
imshow(I1.pic);title(I1.name);
subplot(2,2,2);imshow(I2.pic);title(I2.name);
subplot(2,2,3);imshow(I3.pic);title(I3.name);
subplot(2,2,4);imshow(I4.pic);title(I4.name);
%}
%{
load('HOGandlabel.mat');
fea=[1,0;2,0;3,0;4,0;5,0;6,0;7,0;8,0;9,0;10,0;11,0;12,0;13,0];

study_serials=[1:13];
user_label_record=[0,0,0,0,0,0,1,1,1,1,1,1,nan];
latiao_value=6;
stand_serial=[];
strPath='D:\work\DOCTOR_WORK\ALG\matlab\Annotation\data\all';
[I1,I2,I3,I4,str]=give_hint_3nn(fea,f_name,f_label,strPath,study_serials,user_label_record,latiao_value,stand_serial)
subplot(2,2,1);imshow(I1.pic);title(I1.name);
subplot(2,2,2);imshow(I2.pic);title(I2.name);
subplot(2,2,3);imshow(I3.pic);title(I3.name);
subplot(2,2,4);imshow(I4.pic);title(I4.name);
disp(str);
%}





function [I1,I2,I3,I4,str]=give_hint_3nn(fea,f_name,f_label,strPath,study_serials,user_label_record1,latiao_value,stand_serial)


pos_labeled=intersect(find(isnan(user_label_record1)==0),find(user_label_record1~=-1));%该组所有数据中已有明确标注的样本序号
pos_now=ceil(latiao_value+1);%待测样本序号
pos_labeled(pos_labeled==pos_now)=[];%该组所有数据中已有明确标注的样本序号（在该组中），不包括待测样本

f_label(f_label==-1)=0;
user_label_record=[f_label(stand_serial,1)',user_label_record1(1,pos_labeled)]; %该组所有数据中已有明确标注的样本的label，不包括待测样本  
fea_labeled_serial=[stand_serial',study_serials(pos_labeled)];%该组所有数据中已有明确标注的样本序号（在整个数据集中），不包括待测样本

fea_labeled=fea(fea_labeled_serial,:);%该组所有数据中已有明确标注的样本（在整个数据集中），不包括待测样本
fea_now=fea(study_serials(pos_now),:);%待测样本特征（在整个数据集中）

defaultI=imread('cover3.png');
%%最近临
sstr=[' with ',num2str(length(stand_serial)),'+',num2str(length(user_label_record)-length(stand_serial)), ' samples',];
if isempty(fea_labeled_serial)==1
   I1.pic=defaultI;I1.name='';
   I2.pic=defaultI;I2.name='';
   I3.pic=defaultI;I3.name='';
   I4.pic=defaultI;I4.name='';
   str='Impossible to judge by KNN';
elseif length(fea_labeled_serial)==1
   dist=nan(length(fea_labeled_serial),1);
   for i=1:length(fea_labeled_serial)
       dist(i,1)=pdist([fea_labeled(i,:);fea_now]);
   end
   [p1,p2]=sort(dist);
   pos1=fea_labeled_serial(p2(1));
   label1=user_label_record(p2(1));
   GUESS=0;
   if label1==1
      str1='no mass';
      GUESS=GUESS+1;
   else
      str1='mass';    
      GUESS=GUESS-1;
   end
   I1.pic=imread(fullfile(strPath,f_name{pos1}));I1.name=['1 th near:',str1,' dist= ',num2str(p1(1))];
   I2.pic=defaultI;I2.name='';
   I3.pic=defaultI;I3.name='';
   I4.pic=defaultI;I4.name='';
   if GUESS==1
   str='Slightly possible is No Mass by KNN';
   elseif GUESS==-1
   str='Slightly possible is Mass by KNN';    
   end

elseif length(fea_labeled_serial)==2
   dist=nan(length(fea_labeled_serial),1);
   for i=1:length(fea_labeled_serial)
       dist(i,1)=pdist([fea_labeled(i,:);fea_now]);
   end
   [p1,p2]=sort(dist);
   pos1=fea_labeled_serial(p2(1));
   label1=user_label_record(p2(1));
   
   pos2=fea_labeled_serial(p2(2));
   label2=user_label_record(p2(2));
   GUESS=0;
   if label1==1
      str1='no mass';
      GUESS=GUESS+1;
   else
      str1='mass';
      GUESS=GUESS-1;
   end
   
   if label2==1
      str2='no mass';
      GUESS=GUESS+1;
   else
      str2='mass';    
      GUESS=GUESS-1;
   end
   I1.pic=imread(fullfile(strPath,f_name{pos1}));I1.name=['1 th near:',str1,' dist= ',num2str(p1(1))];
   I2.pic=imread(fullfile(strPath,f_name{pos2}));I2.name=['2 th near:',str2,' dist= ',num2str(p1(2))];
   I3.pic=defaultI;I3.name='';
   I4.pic=defaultI;I4.name='';
   if GUESS==2
   str='Slightly possible is No Mass by KNN';
   elseif GUESS==-2
   str='Slightly possible is Mass by KNN'; 
   elseif GUESS==0;
   str='Hard to judge by KNN';     
   end
   
elseif length(fea_labeled_serial)==3   
   
   dist=nan(length(fea_labeled_serial),1);
   for i=1:length(fea_labeled_serial)
       dist(i,1)=pdist([fea_labeled(i,:);fea_now]);
   end
   [p1,p2]=sort(dist);
   pos1=fea_labeled_serial(p2(1));
   label1=user_label_record(p2(1));
   
   pos2=fea_labeled_serial(p2(2));
   label2=user_label_record(p2(2));
   
   pos3=fea_labeled_serial(p2(3));
   label3=user_label_record(p2(3));
   GUESS=0;
   if label1==1
      str1='no mass';
      GUESS=GUESS+1;
   else
      str1='mass';  
      GUESS=GUESS-1;
   end
   
   if label2==1
      str2='no mass';
      GUESS=GUESS+1;
      
   else
      str2='mass'; 
      GUESS=GUESS-1;
   end
   
   if label3==1
      str3='no mass';
      GUESS=GUESS+1;
   else
      str3='mass';   
      GUESS=GUESS-1;
   end
   I1.pic=imread(fullfile(strPath,f_name{pos1}));I1.name=['1 th near:',str1,' dist= ',num2str(p1(1))];
   I2.pic=imread(fullfile(strPath,f_name{pos2}));I2.name=['2 th near:',str2,' dist= ',num2str(p1(2))];
   I3.pic=imread(fullfile(strPath,f_name{pos3}));I3.name=['3 th near:',str3,' dist= ',num2str(p1(3))];
   I4.pic=defaultI;I4.name='';
   if GUESS==1
   str='Slightly possible is No Mass by KNN';
   elseif GUESS==-1
   str='Slightly possible is Mass by KNN'; 
   elseif GUESS==3
   str='Most possible is No Mass by KNN';
   elseif GUESS==-3
   str='Most possible is Mass by KNN'; 
   end
 elseif length(fea_labeled_serial)==4   
   
   dist=nan(length(fea_labeled_serial),1);
   for i=1:length(fea_labeled_serial)
       dist(i,1)=pdist([fea_labeled(i,:);fea_now]);
   end
   [p1,p2]=sort(dist);
   pos1=fea_labeled_serial(p2(1));
   label1=user_label_record(p2(1));
   
   pos2=fea_labeled_serial(p2(2));
   label2=user_label_record(p2(2));
   
   pos3=fea_labeled_serial(p2(3));
   label3=user_label_record(p2(3));
   
      
   pos4=fea_labeled_serial(p2(4));
   label4=user_label_record(p2(4));
   GUESS=0;
   if label1==1
      str1='no mass';
      GUESS=GUESS+1;
   else
      str1='mass'; 
      GUESS=GUESS-1;
   end
   
   if label2==1
      str2='no mass';
      GUESS=GUESS+1;
   else
      str2='mass'; 
      GUESS=GUESS-1;
   end
   
   if label3==1
      str3='no mass';
      GUESS=GUESS+1;
   else
      str3='mass';   
      GUESS=GUESS-1;
   end
   
  if label4==1
      str4='no mass';
   else
      str4='mass';    
   end
   I1.pic=imread(fullfile(strPath,f_name{pos1}));I1.name=['1 th near:',str1,' dist= ',num2str(p1(1))];
   I2.pic=imread(fullfile(strPath,f_name{pos2}));I2.name=['2 th near:',str2,' dist= ',num2str(p1(2))];
   I3.pic=imread(fullfile(strPath,f_name{pos3}));I3.name=['3 th near:',str3,' dist= ',num2str(p1(3))];
   I4.pic=imread(fullfile(strPath,f_name{pos4}));I4.name=['4 th near:',str4,' dist= ',num2str(p1(4))];  
   if GUESS==1
   str='Slightly possible is No Mass by KNN';
   elseif GUESS==-1
   str='Slightly possible is Mass by KNN'; 
   elseif GUESS==3
   str='Most possible is No Mass by KNN';
   elseif GUESS==-3
   str='Most possible is Mass by KNN'; 
   end
elseif length(fea_labeled_serial)>4   
   dist=nan(length(fea_labeled_serial),1);
   for i=1:length(fea_labeled_serial)
       dist(i,1)=pdist([fea_labeled(i,:);fea_now]);
   end
   [p1,p2]=sort(dist);
   pos1=fea_labeled_serial(p2(1));
   label1=user_label_record(p2(1));
   
   pos2=fea_labeled_serial(p2(2));
   label2=user_label_record(p2(2));
   
   pos3=fea_labeled_serial(p2(3));
   label3=user_label_record(p2(3));
   tmp=nan(1,4);
   GUESS=0;
   if label1==1
      str1='no mass';
      tmp(1,1)=1;
      GUESS=GUESS+1;
   else
      str1='mass';  
      tmp(1,1)=0;
      GUESS=GUESS-1;

   end
   
   if label2==1
      str2='no mass';
      tmp(1,2)=1;
      GUESS=GUESS+1;
     
   else
      str2='mass';
      tmp(1,2)=0;  
      GUESS=GUESS-1;
   end
   
   if label3==1
      str3='no mass';
      tmp(1,3)=1;
      GUESS=GUESS+1;
      
   else
      str3='mass';  
      tmp(1,3)=0;
      GUESS=GUESS-1;
   end
   
   I1.pic=imread(fullfile(strPath,f_name{pos1}));I1.name=['1 th near:',str1,' dist= ',num2str(p1(1))];
   I2.pic=imread(fullfile(strPath,f_name{pos2}));I2.name=['2 th near:',str2,' dist= ',num2str(p1(2))];
   I3.pic=imread(fullfile(strPath,f_name{pos3}));I3.name=['3 th near:',str3,' dist= ',num2str(p1(3))];
   if GUESS==1
   str='Slightly possible is No Mass by KNN';
   elseif GUESS==-1
   str='Slightly possible is Mass by KNN'; 
   elseif GUESS==3
   str='Most possible is No Mass by KNN';
   elseif GUESS==-3
   str='Most possible is Mass by KNN'; 
   end
   
   iii=4;
   %pos4=fea_labeled_serial(p2(iii));
   label4=user_label_record(p2(iii));
   if label4==1
      %str4='no mass';
      tmp(1,4)=1;
      
   else
      %str4='mass';  
      tmp(1,4)=0;
   end
       c_tmp=length(unique(tmp));
   while(length(unique(tmp))==1&&iii<length(fea_labeled_serial))
         %pos4=fea_labeled_serial(p2(iii));
         iii=iii+1;
         label4=user_label_record(p2(iii));
         if label4==1
            %str4='no mass';
            tmp(1,4)=1;
         else
            %str4='mass';  
            tmp(1,4)=0;
         end
         
   end
   if length(unique(tmp))==1
      iii=4;
  
   end
     pos4=fea_labeled_serial(p2(iii));
     label4=user_label_record(p2(iii));
     if label4==1
        str4='no mass';
        
        
     else
        str4='mass';  
     end
      if c_tmp~=1
      I4.pic=imread(fullfile(strPath,f_name{pos4}));I4.name=['4 th near:',str4,' dist= ',num2str(p1(4))];  
      else
      I4.pic=imread(fullfile(strPath,f_name{pos4}));I4.name=['other near:',str4,' dist= ',num2str(p1(iii))];
      end
   
   
end

 str=[str,sstr];

    
    
   
    