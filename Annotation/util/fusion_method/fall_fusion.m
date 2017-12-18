%{
clc
clear
sample_num=20;
rank_num=3;
rank=rank_generate(sample_num,rank_num);
choose_block=[5;2;20];
%}


function [new_rank,choose_serial]=fall_fusion(rank,choose_num,choose_block)
default_choose_block=nan(size(rank,1)-1,1);
for i=1:size(rank,1)-1
    
default_choose_block(i,1)=choose_num+i-1;
end

if (nargin<3)
    
choose_block=default_choose_block;
elseif isempty(choose_block)==1
choose_block=default_choose_block;

    
    
end

[c1,c2]=sort(choose_block,'descend');
rest=rank;
for i=1:length(choose_block)
    rank_tmp=rest(2:end,:);
    stand=rank_tmp(c2(i),:);
    [~,p2]=sort(stand,'ascend');
    rest=rest(:,p2(1:c1(i)));
end
choose_serial=rest(1,:);
new_rank=[];
