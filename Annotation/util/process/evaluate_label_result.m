


function [test_record,Pacc,Tacc,Cacc,de_number,al_number,ttt,report]=evaluate_label_result(mat,mode_choose,study_serials,study_serials_serial,test_serials,user_label_record,start_time,classification_rule,option,overlap)
   
ttt=etime(clock,start_time);
label=mat(study_serials,2);
if classification_rule==2
   true_label=label';
   true_label(true_label==-1)=0;
end

study_serials_serial_reverse=fliplr(study_serials_serial);
order=study_serials(study_serials_serial_reverse);

test=mat(test_serials,:);
train_tmp=mat(order,:);

train_tmp(:,2)=user_label_record(study_serials_serial_reverse)';

pos=intersect(find(isnan(train_tmp(:,2))==0),find(train_tmp(:,2)~=-1));
train=train_tmp(pos,:);
   if isempty(train)==1
   Cacc=0;
   else
   net=svmtrain(train(:,2),train(:,3:end),'-q -t 2 -s 0 -c 1 -g 1');
   [~,evaluation,~]=svmpredict(test(:,2),test(:,3:end),net);
   Cacc=evaluation(1);
   end
   
user_given_label=user_label_record(study_serials_serial_reverse);
true_given_label=true_label(study_serials_serial_reverse);

al_number=length(user_given_label); 
de_number=length(find(user_given_label~=-1));

Pacc=length(find((user_given_label-true_given_label)==0))/de_number*100;
Tacc=length(find((user_given_label-true_given_label)==0))/al_number*100;

cc=['================='];
   c1=['usetime = ',num2str(ttt),' sec;'];
   c2=['Browse ',num2str(al_number),' label;'];
   c3=['Complete ',num2str(de_number),' label;'];
    
   c4=['Part accuracy = ',num2str(Pacc),'%;'];
   c5=['Totally accuracy = ',num2str(Tacc),'%;'];
   c6=['Classification accuracy = ',num2str(Cacc),'%;'];
   report={'Report:';cc;c1;cc;c2;cc;c3;cc;c4;cc;c5;cc;c6};
   
   
if length(option)==1&&option>=1&&fix(option)==option
   if floor(al_number/option)~=0
      if overlap==0
         gacc=nan(1,floor(al_number/option));   
         for i=1:floor(al_number/option)
              st=(i-1)*option+1;
              ft=i*option;
              gacc(1,i)=length(find((user_given_label(st:ft)-true_given_label(st:ft))==0))/option*100;
         end
         %axis([0 length(gacc)*option+1 -20 120])
         plot((1:length(gacc))*option,gacc,'*r','LineWidth',4);
         xlabel('Label number'); 
         ylabel('Every batch acuracy'); 
  
      elseif overlap==1
         gacc=nan(1,al_number-option+1);
          for i=1:al_number-option+1
              st=i;
              ft=i+option-1;
              gacc(1,i)=length(find((user_given_label(st:ft)-true_given_label(st:ft))==0))/option*100;
          end
          %axis([0 length(gacc)+option -20 120])
          plot((1:length(gacc))+option-1,gacc,'*r','LineWidth',4);
          xlabel('Label number'); 
          ylabel('Every batch acuracy'); 
       end
       
   else
   gacc=nan;    
   I=imread('cover3.png');
   imshow(I)
   text(0.25,0.5,'the number of labeled samples is too few');
   end
   gacc=nan;     
end
switch mode_choose   
    case 1
        mode_name='None';
    case 2    
        mode_name='Review';
    case 3
        mode_name='test_No';
        mode_pos=1;
    case 4  
        mode_name='test_AL';
        mode_pos=2;
    case 5
        mode_name='exam_No';
        mode_pos=3;
    case 6    
        mode_name='exam_AL';
        mode_pos=4;
    case 7
        mode_name='exam_AD';
        mode_pos=5;
    case 8  
        mode_name='exam_AL_AD'; 
        mode_pos=6;
end
   test_record.mode_pos=mode_pos;
   test_record.mode_name=mode_name;
   test_record.usetime=ttt;
   test_record.classification_acc=Cacc;
   test_record.part_acc=Pacc;
   test_record.totall_acc=Tacc;
   test_record.number=[de_number,al_number];
   
   test_record.user_given_label=user_given_label;
   test_record.true_given_label=true_given_label;
   
   test_record.trend_acc=gacc;
   