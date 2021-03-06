rm(list=ls())
library(rio)
library(tidyverse)
library(table1)
library(ggpubr)
library(DT)
library(forestmodel)
library(patchwork)
##2020-7-06
#数据读取
source('~/Rcode/screening/gastric_screening2019/stomach_data.R')
source('~/Rcode/statistics/OR.R')#
#基本分布

#不同cut-off值的阳性率
pos<-pepsinogen%>%transmute(PG_pos1=factor(ifelse(PG1<=70 & PGR<=3,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos2=factor(ifelse(PG1<=50 & PGR<=2,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos3=factor(ifelse(PG1<49,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos4=factor(ifelse(PGR<1.3,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos5=factor(ifelse(PGR<1.6,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos6=factor(ifelse(PGR<2.5,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos7=factor(ifelse(PGR<2.9,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos8=factor(ifelse(PGR<=3,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos9=factor(ifelse(PG1<20,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos10=factor(ifelse(PG1<17,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos11=factor(ifelse(PG1<25,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos12=factor(ifelse(PG1<30,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos13=factor(ifelse(PG1<17 & PGR<1.6,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos14=factor(ifelse(PG1<20 & PGR<2.9,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos15=factor(ifelse(PG1<50 & PGR<2,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       PG_pos16=factor(ifelse(PG1<70 & PGR<2,1,0),levels=c(0,1),labels=c('阴性','阳性')),
                       年龄分组=case_when(
                         between(年龄,40,49)~1,
                         between(年龄,50,59)~2,
                         between(年龄,60,69)~3,
                         年龄>=70~4
                       ),年龄分组=factor(年龄分组,levels=c(1,2,3,4),labels=c('40-49','50-59','60-69','>=70'))
                       性别
                       )

summary(pos)
#不同cut-off标准的阳性率与年龄







#性别和年龄
table1(~性别+年龄分组+年龄分组2 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('性别','年龄分组','年龄分组2'),y='PG_pos',data=pepsinogen)
logit(x='性别',y='PG_pos',data=pepsinogen)
logit(x='年龄分组2',y='PG_pos',data=pepsinogen)
logit(x=c('年龄分组','性别','吸烟1','饮酒','BMI_group','油炸',"咖啡",'就业状况','糖尿病','高血压','高血脂','冠心病','幽门螺杆菌感染史','消化性溃疡'),y='PG_pos',data=pepsinogen)

#年龄与萎缩率的限制性立方样条
dd <- datadist(pepsinogen) 
options(datadist='dd')
fit<- lrm(PG_pos ~ rcs(年龄,4) + 性别,data=pepsinogen) 
#dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
fit=update(fit)
RR<-Predict(fit, 年龄,fun=exp,ref.zero = TRUE) ####预测HR值
ggplot()+geom_line(data=RR, aes(年龄,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
  geom_ribbon(data=RR, aes(年龄,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
  labs(title = "RCS", x="age", y="RR (95%CI)") 
anova(fit)
#性别分层年龄
table1(~年龄分组 | PG_pos,data=subset(pepsinogen,性别=='Female'),render.categorical=my.render.cat)
chisq.test(with(subset(pepsinogen,性别=='Female'),table(PG_pos,年龄分组)))
logit(x='年龄分组',y='PG_pos',data=subset(pepsinogen,性别=='Female'))
#Male
table1(~年龄分组 | PG_pos,data=subset(pepsinogen,性别=='Male'),render.categorical=my.render.cat)
chisq.test(with(subset(pepsinogen,性别=='Male'),table(PG_pos,年龄分组)))
logit(x='年龄分组',y='PG_pos',data=subset(pepsinogen,性别=='Male'))
#
table1(~性别+年龄分组 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('性别','年龄分组'),y='PG_pos1',data=pepsinogen)
#
table1(~性别+年龄分组 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('性别','年龄分组'),y='PG_pos2',data=pepsinogen)
#家庭收入、教育水平、婚姻、就业状况、血型
table1(~家庭收入+教育+婚姻+就业状况+血型 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables1,y='PG_pos',data=pepsinogen)
#
table1(~家庭收入+教育+婚姻+就业状况+血型 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables1,y='PG_pos1',data=pepsinogen)
#
table1(~家庭收入+教育+婚姻+就业状况+血型 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables1,y='PG_pos2',data=pepsinogen)
#logit
logit(x=c('家庭收入'),y='PG_pos',data=pepsinogen)
logit(x=variables1,y='PG_pos',data=subset(pepsinogen,性别=='Female'))
logit(x='血型2',y='PG_pos',data=subset(pepsinogen,性别=='Female'))
##矫正性别和年龄
logit(x=variables1,y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','家庭收入'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','教育'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','婚姻'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','就业状况'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','血型'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','血型1'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','血型2'),y='PG_pos',data=pepsinogen)
logit(x=c('血型1'),y='PG_pos',data=pepsinogen)
#多因素矫正
logit(x=c('性别','年龄分组','BMI_group','吸烟1','饮酒','糖尿病','家庭收入'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','吸烟1','饮酒','糖尿病','教育'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','吸烟1','饮酒','糖尿病','婚姻'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','吸烟1','饮酒','糖尿病','就业状况'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','吸烟1','饮酒','糖尿病','血型'),y='PG_pos',data=pepsinogen)


#癌症家族史
table1(~胃癌家族史 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x='胃癌家族史',y='PG_pos',data=pepsinogen)
logit(x=c('胃癌家族史','BMI_group','性别','年龄分组','吸烟1',
          '就业状况','饮酒','糖尿病','咖啡','油炸','偏酸'),y='PG_pos',data=pepsinogen)


##血型
#
with(pepsinogen,table(血型,PG_pos))
with(pepsinogen,round(prop.table(table(血型,PG_pos),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型,PG_pos))
#
with(pepsinogen,table(血型1,PG_pos))
with(pepsinogen,round(prop.table(table(血型1,PG_pos),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型1,PG_pos))
#
with(pepsinogen,table(血型2,PG_pos))
with(pepsinogen,round(prop.table(table(血型2,PG_pos),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型2,PG_pos))
##
#
with(pepsinogen,table(血型,PG_pos1))
with(pepsinogen,round(prop.table(table(血型,PG_pos1),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型,PG_pos1))
#
with(pepsinogen,table(血型1,PG_pos1))
with(pepsinogen,round(prop.table(table(血型1,PG_pos1),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型1,PG_pos1))
#
with(pepsinogen,table(血型2,PG_pos1))
with(pepsinogen,round(prop.table(table(血型2,PG_pos1),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型2,PG_pos1))
##
#
with(pepsinogen,table(血型,PG_pos2))
with(pepsinogen,round(prop.table(table(血型,PG_pos2),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型,PG_pos2))
#
with(pepsinogen,table(血型1,PG_pos2))
with(pepsinogen,round(prop.table(table(血型1,PG_pos2),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型1,PG_pos2))
#
with(pepsinogen,table(血型2,PG_pos2))
with(pepsinogen,round(prop.table(table(血型2,PG_pos2),margin = 1),4)*100)
with(pepsinogen,chisq.test(血型2,PG_pos2))

###饮食、饮茶、饮酒、饮食偏好
#
table1(~饮酒+喝茶+鲜奶+酸奶+咖啡+碳酸饮料+果味饮料+茶味饮料+蔬菜+水果+谷类+肉类+鸡蛋+
         水产品+薯类+杂粮+豆类+
坚果+大蒜+菌类+油炸+烧烤+熏制+腌制+酱制+晒制+偏咸+偏辣+偏烫+偏酸+偏甜+偏硬 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables4,y='PG_pos',data=pepsinogen)
logit(x=variables4,y='PG_pos',data=pepsinogen)
#
table1(~饮酒+喝茶+鲜奶+酸奶+咖啡+蔬菜+水果+谷类+鸡蛋+杂粮+豆类+
         坚果+大蒜+菌类+油炸+烧烤+熏制+腌制+酱制 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables9,y='PG_pos1',data=pepsinogen)
#
table1(~饮酒+喝茶+鲜奶+酸奶+咖啡+蔬菜+水果+谷类+鸡蛋+杂粮+豆类+
         坚果+大蒜+菌类+油炸+烧烤+熏制+腌制+酱制 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables9,y='PG_pos2',data=pepsinogen)
##
variables9<-c('','','','','','','')
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','喝茶'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','鲜奶'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','酸奶'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','碳酸饮料'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','果味饮料'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','茶味饮料'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','蔬菜'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','水果'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','谷类'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','肉类'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','水产品'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','鸡蛋'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','杂粮'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','薯类'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','豆类'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','坚果'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','大蒜'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','菌类'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','油炸'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','烧烤'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','熏制'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','酱制'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','晒制'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','腌制'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','熏制'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','晒制'),y='PG_pos',data=pepsinogen)

logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','偏咸'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','偏辣'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','偏烫'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','偏甜'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','偏硬'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸'),y='PG_pos',data=pepsinogen)


#油炸
table1(~油炸 | PG_pos,data=subset(pepsinogen,性别=='Female'),render.categorical=my.render.cat)
chisq(x='油炸',y='PG_pos',data=subset(pepsinogen,性别=='Female'))
table1(~油炸 | PG_pos,data=subset(pepsinogen,性别=='Male'),render.categorical=my.render.cat)
chisq(x='油炸',y='PG_pos',data=subset(pepsinogen,性别=='Male'))
forest_model(glm(PG_pos~油炸,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~油炸+性别+年龄分组,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~油炸+性别+年龄分组+BMI_group+吸烟1+饮酒+就业状况+被动吸烟1+糖尿病,data=pepsinogen2,family = 'binomial'))

forest_model(glm(PG_pos~蔬菜,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~咖啡+性别+年龄分组,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~+性别+年龄分组+BMI_group+吸烟1+饮酒+就业状况+被动吸烟1+糖尿病+教育,data=pepsinogen2,family = 'binomial'))
summary(glm(PG_pos~油炸+性别+年龄分组+BMI_group+吸烟1+饮酒+就业状况+被动吸烟1+糖尿病+教育+吸烟1*油炸,data=pepsinogen2,family = 'binomial'))

#
pepsinogen%>%filter(PG_pos3!='正常')%>%group_by(PG_pos3,油炸)%>%summarise(n=n())%>%group_by(PG_pos3)%>%mutate(per=n/sum(n))%>%filter(油炸=='是')

summary(glm(油炸~PG_pos3,data=pepsinogen2,family = 'binomial'))
summary(glm(油炸~as.numeric(PG_pos3),data=subset(pepsinogen2,性别=='Female'),family = 'binomial'))
library(DescTools)
CochranArmitageTest(table(pepsinogen$油炸,pepsinogen$PG_pos3))
CochranArmitageTest(with(subset(pepsinogen,性别=='Female'),table(油炸,PG_pos3)))
CochranArmitageTest(with(subset(pepsinogen,性别=='Female' & PG_pos3!='正常'),table(油炸,PG_pos3)))

###运动相关因素
#
table1(~运动+跑步+静态时间+手机使用时间 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables5,y='PG_pos',data=pepsinogen)
logit(x=variables5,y='PG_pos',data=pepsinogen)
#
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','运动'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','跑步'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','静态时间'),y='PG_pos',data=pepsinogen)
logit(x=c('饮酒','性别','年龄分组','就业状况','吸烟1','糖尿病','咖啡','油炸','偏酸','手机使用时间'),y='PG_pos',data=pepsinogen)

#
table1(~运动+跑步+静态时间+手机使用时间 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables5,y='PG_pos1',data=pepsinogen)
#
table1(~运动+跑步+静态时间+手机使用时间 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables5,y='PG_pos2',data=pepsinogen)

##跑步
forest_model(glm(PG_pos~跑步,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~跑步+性别+年龄分组,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~性别+年龄分组+BMI_group+吸烟1+饮酒+就业状况+被动吸烟1+糖尿病,data=pepsinogen2,family = 'binomial'))





###吸烟

table1(~吸烟2+被动吸烟1+吸烟3 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('吸烟2','被动吸烟1','吸烟3'),y='PG_pos',data=pepsinogen)

#
table1(~吸烟2+被动吸烟1 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('吸烟2','被动吸烟1'),y='PG_pos1',data=pepsinogen)
#
table1(~吸烟2+被动吸烟1 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('吸烟2','被动吸烟1'),y='PG_pos2',data=pepsinogen)

forest_model(glm(PG_pos~吸烟1,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~吸烟1+性别+年龄分组,data=pepsinogen,family = 'binomial'))
forest_model(glm(PG_pos~吸烟1+性别+年龄分组+BMI_group+饮酒+就业状况+被动吸烟1+糖尿病,data=pepsinogen2,family = 'binomial'))
##OR
logit(x=c('吸烟1'),y='PG_pos',data=pepsinogen)
logit(x=c('吸烟2'),y='PG_pos',data=pepsinogen)
logit(x=c('被动吸烟2'),y='PG_pos',data=pepsinogen)
logit(x=c('吸烟3'),y='PG_pos',data=pepsinogen)
#性别、年龄矫正
logit(x=c('性别','年龄分组','吸烟1'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','吸烟2'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','吸烟3'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','被动吸烟2'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','被动吸烟1'),y='PG_pos',data=pepsinogen)
#多因素矫正
logit(x=c('性别','年龄分组','BMI_group','就业状况','饮酒','糖尿病','油炸','吸烟1'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','饮酒','糖尿病','油炸','吸烟2'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','饮酒','糖尿病','油炸','吸烟3'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','饮酒','糖尿病','油炸','被动吸烟2'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','饮酒','糖尿病','油炸','被动吸烟1'),y='PG_pos',data=pepsinogen)



###BMI

table1(~BMI_group+BMI_group2 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('BMI_group','BMI_group2'),y='PG_pos',data=pepsinogen)
#
table1(~BMI_group+BMI_group2 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('BMI_group','BMI_group2'),y='PG_pos1',data=pepsinogen)
#
table1(~BMI_group+BMI_group2 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('BMI_group','BMI_group2'),y='PG_pos2',data=pepsinogen)
##性别、年龄矫正
logit(x=c('性别','年龄分组','BMI_group'),y='PG_pos',data=pepsinogen)
summary(glm(PG_pos~性别+年龄+relevel(BMI_group2,ref='正常'),data=pepsinogen,family='binomial'))
##多因素矫正
logit(x=c('性别','年龄分组','就业状况','饮酒','糖尿病','吸烟1','咖啡','油炸','偏酸','BMI_group'),y='PG_pos',data=pepsinogen)
#限制性立方样条
fit<- lrm(PG_pos ~ rcs(BMI,4) + 性别+年龄分组,data=pepsinogen) 
#dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
fit=update(fit)
RR<-Predict(fit, BMI,fun=exp,ref.zero = TRUE) ####预测HR值
ggplot()+geom_line(data=RR, aes(BMI,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
  geom_ribbon(data=RR, aes(BMI,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
  theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
  labs(title = "RCS", x="BMI", y="RR (95%CI)") 
anova(fit)




###基础疾病史
table1(~糖尿病+高血压+高血脂+冠心病+幽门螺杆菌感染史+消化性溃疡 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('糖尿病','高血压','高血脂','冠心病','幽门螺杆菌感染史','消化性溃疡'),y='PG_pos',data=pepsinogen)
#
table1(~糖尿病+高血压+高血脂+冠心病 | PG_pos1,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('糖尿病','高血压','高血脂','冠心病'),y='PG_pos1',data=pepsinogen)
#
table1(~糖尿病+高血压+高血脂+冠心病 | PG_pos2,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('糖尿病','高血压','高血脂','冠心病'),y='PG_pos2',data=pepsinogen)

##性别、年龄矫正
table1(~糖尿病+高血压+高血脂+冠心病+幽门螺杆菌感染史+消化性溃疡+Barrett食管+萎缩性胃炎+食管或胃上皮内瘤变+
         胃息肉+胃肠上皮化生+残胃+胃粘膜不典型增生| PG_pos,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('糖尿病','高血压','高血脂','冠心病','幽门螺杆菌感染史','消化性溃疡','Barrett食管',
          '萎缩性胃炎','食管或胃上皮内瘤变','胃息肉','胃肠上皮化生','残胃','胃粘膜不典型增生'),y='PG_pos',data=pepsinogen)
logit(x=c('糖尿病','高血压','高血脂','冠心病','幽门螺杆菌感染史','消化性溃疡','Barrett食管',
          '萎缩性胃炎','食管或胃上皮内瘤变','胃息肉','胃肠上皮化生','残胃','胃粘膜不典型增生'),y='PG_pos',data=pepsinogen)


####根据PG1与PGR将人群分为正常、一般萎缩、重度萎缩
#性别和年龄
pepsinogen%>%group_by(PG_pos4)%>%summarise(n=n(),mean=mean(年龄),sd=sd(年龄))
kruskal.test(年龄~PG_pos4,data=pepsinogen)
table1(~性别+年龄分组 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('性别','年龄分组'),y='PG_pos4',data=pepsinogen)
#性别分层
table1(~性别+年龄分组 | PG_pos4,data=subset(pepsinogen,性别=='Female'),render.categorical=my.render.cat)
chisq(x=c('性别','年龄分组'),y='PG_pos4',data=pepsinogen)
table1(~性别+年龄分组 | PG_pos4,data=subset(pepsinogen,性别=='Male'),render.categorical=my.render.cat)
chisq(x=c('性别','年龄分组'),y='PG_pos4',data=pepsinogen)

#家庭收入、教育水平、婚姻、就业状况、血型
table1(~家庭收入+教育+婚姻+就业状况+血型 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables1,y='PG_pos4',data=pepsinogen)
###吸烟
table1(~吸烟1+被动吸烟1 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('吸烟2','被动吸烟2'),y='PG_pos4',data=pepsinogen)
#
table1(~吸烟3 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('吸烟3'),y='PG_pos4',data=pepsinogen)

###性别分层

table1(~吸烟2+被动吸烟1 | PG_pos4,data=subset(pepsinogen,性别=='Female'),render.categorical=my.render.cat)
chisq(x=c('吸烟2','被动吸烟1'),y='PG_pos4',data=subset(pepsinogen,性别=='Female'))
table1(~吸烟2+被动吸烟1 | PG_pos4,data=subset(pepsinogen,性别=='Male'),render.categorical=my.render.cat)
chisq(x=c('吸烟2','被动吸烟1'),y='PG_pos4',data=subset(pepsinogen,性别=='Male'))
##血型
with(subset(pepsinogen,血型1!='不详'),table(血型1,PG_pos4))
with(subset(pepsinogen,血型1!='不详'),round(prop.table(table(血型1,PG_pos4),margin = 2),4)*100)
with(subset(pepsinogen,血型1!='不详'),chisq.test(血型1,PG_pos4))
#
with(subset(pepsinogen,血型2!='不详'),table(血型2,PG_pos4))
with(subset(pepsinogen,血型2!='不详'),round(prop.table(table(血型2,PG_pos4),margin = 2),4)*100)
with(subset(pepsinogen,血型2!='不详'),chisq.test(血型2,PG_pos4))

###饮食、饮茶、饮酒、饮食偏好
table1(~饮酒+喝茶+鲜奶+酸奶+咖啡+蔬菜+水果+谷类+鸡蛋+杂粮+豆类+
         坚果+大蒜+菌类+油炸+烧烤+熏制+腌制+酱制 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables9,y='PG_pos4',data=pepsinogen)
#性别分层
table1(~饮酒+喝茶+鲜奶+酸奶+咖啡+蔬菜+水果+谷类+鸡蛋+杂粮+豆类+
         坚果+大蒜+菌类+油炸+烧烤+熏制+腌制+酱制 | PG_pos4,data=subset(pepsinogen,性别=='Female'),render.categorical=my.render.cat)
chisq(x=variables9,y='PG_pos4',data=subset(pepsinogen,性别=='Female'))
table1(~饮酒+喝茶+鲜奶+酸奶+咖啡+蔬菜+水果+谷类+鸡蛋+杂粮+豆类+
         坚果+大蒜+菌类+油炸+烧烤+熏制+腌制+酱制 | PG_pos4,data=subset(pepsinogen,性别=='Male'),render.categorical=my.render.cat)
chisq(x=variables9,y='PG_pos4',data=subset(pepsinogen,性别=='Male'))

##性别、年龄矫正
logit(x=c(variables4,'大蒜',variables8),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','饮酒'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','喝茶'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','鲜奶'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','酸奶'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','咖啡'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','蔬菜'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','水果'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','谷类'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','鸡蛋'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','杂粮'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','豆类'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','大蒜'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','坚果'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','菌类'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','油炸'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','烧烤'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','熏制'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','腌制'),y='PG_pos',data=pepsinogen)
logit(x=c('性别','年龄分组','BMI_group','就业状况','糖尿病','吸烟1','酱制'),y='PG_pos',data=pepsinogen)








###运动相关因素
table1(~运动+跑步+静态时间+手机使用时间 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=variables5,y='PG_pos4',data=pepsinogen)
#性别分层
table1(~运动+跑步+静态时间+手机使用时间 | PG_pos4,data=subset(pepsinogen,性别=='Female'),render.categorical=my.render.cat)
chisq(x=variables5,y='PG_pos4',data=subset(pepsinogen,性别=='Female'))
table1(~运动+跑步+静态时间+手机使用时间 | PG_pos4,data=subset(pepsinogen,性别=='Male'),render.categorical=my.render.cat)
chisq(x=variables5,y='PG_pos4',data=subset(pepsinogen,性别=='Male'))

###BMI
pepsinogen%>%group_by(PG_pos4)%>%summarise(n=n(),mean=mean(BMI),sd=sd(BMI))
kruskal.test(BMI~PG_pos4,data=pepsinogen)
table1(~BMI_group+BMI_group2 | PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('BMI_group','BMI_group2'),y='PG_pos4',data=pepsinogen)

fit<- lrm(PG_pos ~ rcs(BMI,4),data=pepsinogen) 
#dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
#fit=update(fit)
RR<-Predict(fit, BMI,fun=exp,ref.zero = TRUE) ####预测HR值
ggplot()+geom_line(data=RR, aes(BMI,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
  geom_ribbon(data=RR, aes(BMI,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
  theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
  labs(title = "RCS", x="BMI", y="RR (95%CI)") 
anova(fit)


####疾病史
table1(~糖尿病+高血压+高血脂+冠心病+幽门螺杆菌感染史+消化性溃疡+Barrett食管+萎缩性胃炎+食管或胃上皮内瘤变+
         胃息肉+胃肠上皮化生+残胃| PG_pos4,data=pepsinogen,render.categorical=my.render.cat)
chisq(x=c('糖尿病','高血压','高血脂','冠心病','幽门螺杆菌感染史','消化性溃疡'),y='PG_pos4',data=pepsinogen)

###女性生理与生育相关因素(初潮年龄+绝经+哺乳月份+流产+人工流产+)
table1(~初潮年龄分组+初潮年龄+绝经年龄+绝经+哺乳+哺乳月份+流产+人工流产+哺乳时间分组+首次生育年龄分组+初次生育年龄 | PG_pos,data=pepsinogen,render.categorical=my.render.cat)
 chisq(x=variables10,y='PG_pos',data=pepsinogen)
 fit<- lrm(PG_pos ~ rcs(初潮年龄,4) + 年龄分组,data=subset(pepsinogen,性别=="Female")) 
 #dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
 #fit=update(fit)
 RR<-Predict(fit, 初潮年龄,fun=exp,ref.zero = TRUE) ####预测HR值
 ggplot()+geom_line(data=RR, aes(初潮年龄,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
   geom_ribbon(data=RR, aes(初潮年龄,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
   theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
   labs(title = "RCS", x="age", y="RR (95%CI)") 
 anova(fit)
#
 fit<- lrm(PG_pos ~ rcs(哺乳月份,4) + 年龄分组,data=subset(pepsinogen,性别=="Female")) 
 #dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
 #fit=update(fit)
 RR<-Predict(fit, 哺乳月份,fun=exp,ref.zero = TRUE) ####预测HR值
 ggplot()+geom_line(data=RR, aes(哺乳月份,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
   geom_ribbon(data=RR, aes(哺乳月份,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
   theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
   labs(title = "RCS", x="age", y="RR (95%CI)") 
 anova(fit)
#
 fit<- lrm(PG_pos ~ rcs(哺乳月份,4) + 年龄分组,data=subset(pepsinogen,性别=="Female")) 
 #dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
 #fit=update(fit)
 RR<-Predict(fit, 哺乳月份,fun=exp,ref.zero = TRUE) ####预测HR值
 ggplot()+geom_line(data=RR, aes(哺乳月份,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
   geom_ribbon(data=RR, aes(哺乳月份,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
   theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
   labs(title = "RCS", x="age", y="RR (95%CI)") 
 anova(fit)
#首次生育年龄
 fit<- lrm(PG_pos ~ rcs(初次生育年龄,4) + 年龄分组,data=subset(pepsinogen,性别=="Female")) 
 #dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
 #fit=update(fit)
 RR<-Predict(fit, 初次生育年龄,fun=exp,ref.zero = TRUE) ####预测HR值
 ggplot()+geom_line(data=RR, aes(初次生育年龄,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
   geom_ribbon(data=RR, aes(初次生育年龄,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
   theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
   labs(title = "RCS", x="age", y="RR (95%CI)") 
 anova(fit)
#
forest_model(glm(PG_pos~雌激素影响时间+哺乳+首次生育年龄分组+雌激素代替治疗+口服避孕药,data=subset(pepsinogen,性别=="Female" & 绝经=="是"),family = 'binomial'))


##胃萎缩与胃癌前病变/胃癌的关系
gastric<-import('~/data/胃癌及癌前病变.xlsx')
gastric2<-inner_join(gastric,pepsinogen,by='ID')
gastric2%>%filter(!is.na(type))%>%transmute(type=factor(type,levels=c('胃癌','异型增生','肠上皮化生','萎缩性胃炎')),PG_pos4)%>%group_by(type,PG_pos4)%>% 
  summarise(count=n()) %>% 
  mutate(perc=round((count/sum(count))*100,2))%>%
  ggplot(aes(x = type, y = perc, fill =PG_pos4)) +
  geom_bar(stat="identity", width = 0.7) +
  theme_minimal(base_size = 14)+geom_text(aes(label=perc),position = position_stack(vjust = 0.5))+
  labs(x='',y=' ',fill='PG_pos')+scale_x_discrete(labels=c('cancer','dysplasia','intestinal metaplasia','Atrophic gastritis'))+
  scale_fill_discrete(labels=c('Healthy','Mild-moderate','Severe'))+coord_flip()



###与肿瘤标志物
#PG2
fit<- lrm(PG_pos ~ rcs(PG2,4) +年龄分组+ 性别+饮酒+吸烟1,data=pepsinogen) 
#dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
#fit=update(fit)
RR<-Predict(fit, PG2,fun=exp,ref.zero = TRUE) ####预测HR值
ggplot()+geom_line(data=RR, aes(PG2,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
  geom_ribbon(data=RR, aes(PG2,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
  theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
  labs(title = "RCS", x="PG2", y="RR (95%CI)") 
anova(fit)
##
logit(x='PG2_range',y='PG_pos',data=pepsinogen)



##CA125
fit<- lrm(PG_pos ~ rcs(CA125,4) +年龄分组,data=pepsinogen) 
summary(lrm(PG_pos ~ CA125_pos +年龄分组,data=pepsinogen))
#dd$limits$age[2] <- 50 ###这里是设置参考点，也就是HR为1的点，常见的为中位数或者临床有意义的点 
#fit=update(fit)
RR<-Predict(fit,CA125,fun=exp,ref.zero = TRUE) ####预测HR值
ggplot()+geom_line(data=RR, aes(CA125,yhat),linetype="solid",size=1,alpha = 0.7,colour="red")+
  geom_ribbon(data=RR, aes(CA125,ymin = lower, ymax = upper),alpha = 0.1,fill="red")+
  theme_classic()+geom_hline(yintercept=1, linetype=2,size=1)+ 
  labs(title = "RCS", x="AFP", y="RR (95%CI)") 
anova(fit)





