function [test_result,diff,need_type] = svm_application(test,net,need_type)
[test_result,evaluation,diff0]=svmpredict(test(:,2),test(:,3:end),net);
[w,b]=svm_wb_caculate(net);
diff1=nan(size(diff0,1),size(diff0,2));
for i=1:size(diff0,2)
    diff1(:,i)=diff0(:,i)/(w(1,i));
end
diff1=diff0;
need_type=need_type*1;
type_num=length(need_type);
if type_num==1
diff_matrix=1;
else
diff_matrix=zeros(2,type_num*(type_num-1)/2);

t=1;
for i=1:type_num-1
    for j=i+1:type_num
       diff_matrix(1,t)=need_type(i);
       diff_matrix(2,t)=need_type(j);
       t=t+1;
    end
end
end
diff=nan(size(diff1,1),1);
for i=1:size(diff1,1)
    C_P=find(diff_matrix(1,:)==test_result(i,1));
    C_N=find(diff_matrix(2,:)==test_result(i,1));
    if isempty(C_P)==1
        C_P_V=[];
    else
        C_P_V=diff1(i,C_P)*1;
    end
     if isempty(C_N)==1
        C_N_V=[];
     else
        C_N_V=diff1(i,C_N)*-1;
    end
diff(i,1)=mean([C_P_V,C_N_V]);

end
diff=abs(diff);
%%%���Ƕ����diff�Ƕ�ά���� ������������12,13,23
%%diffԽ��Խ������