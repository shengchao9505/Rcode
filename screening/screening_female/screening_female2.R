rm(list=ls())
library(forestmodel)
#基线数据准备
source('~/Rcode/statistics/PersoID_inf.R')
source('~/Rcode/screening/screening_female/screening_female_data.R')
#剔除
screening3<-screening2%>%filter(出生年份>=1943 & 出生年份<=1979 & !is.na(初潮年龄) & !is.na(绝经) & !is.na(生育) & !is.na(教育))
screening4<-screening3%>%filter(CA>-1 | is.na(CA))
#######################################################################################################################################
#分析异常值与基础数据描述
#总数据82344人，剔除患有自身癌症的还剩81305人
#分析生理生育相关变量缺失值和异常值
#summary(screening3)
str(screening3)
with(screening3,table(出生年份))#剔除出生年份总人数<100人的年份

#初潮年龄
with(screening3,table(初潮年龄));with(screening3,summary(初潮年龄))#缺失230个
#绝经及绝经年龄
#with(screening,summary(menopause));with(screening,table(menopause))#缺失133,未绝经19103，绝经63092
with(screening3,summary(绝经))#未绝经人数18915，绝经人数62081
with(screening3,table(绝经,is.na(绝经年龄)))#绝经年龄缺失2294
with(screening3,table(绝经年龄));with(screening3,summary(绝经年龄))#
with(screening3,table(绝经年龄,绝经))
with(screening3,mean(绝经年龄,na.rm=T));with(screening3,sd(绝经年龄,na.rm=T))
# 生育及生育次数、初次生育年龄(77984人生育，2999人未生育,275人生育次数缺失)
with(screening3,summary(生育));with(screening3,table(生育))#缺失16个
screening3[which(is.na(screening3$生育) & !is.na(screening3$生育次数)),c('生育','生育次数')]
with(screening3,table(生育,is.na(生育次数)))#生育次数缺失275人
with(screening3,table(生育次数))
with(screening3,table(生育次数,生育))
screening3[which(is.na(screening3$生育) & !is.na(screening3$初次生育年龄)),c('生育','生育次数','初次生育年龄')]
with(screening3,table(生育,is.na(初次生育年龄)))#初次生育年龄缺失353人
#哺乳及哺乳时间(67753人哺乳,13230人未哺乳，哺乳月份缺失853人)
with(screening3,summary(哺乳));with(screening3,table(哺乳))
screening3[which(is.na(screening3$哺乳) & !is.na(screening3$哺乳月份)),c('哺乳','哺乳月份')]
with(screening3,table(哺乳,is.na(哺乳月份)))#哺乳月份缺失853人
with(screening3,table(哺乳月份))
with(screening3,table(哺乳月份,哺乳))
##流产及人工流产、自然流产
with(screening3,table(流产));with(screening3,summary(流产))#流产43746，未流产37212,流产缺失25个
screening3[which(is.na(screening3$流产) & !is.na(screening3$人工流产次数)),c('流产','人工流产次数','自然流产次数')]
screening3[which(is.na(screening3$流产) & !is.na(screening3$自然流产次数)),c('流产','人工流产次数','自然流产次数')]
with(screening3,table(人工流产))
with(screening3,table(自然流产))
with(screening3,table(人工流产次数,人工流产))
with(screening3,table(自然流产次数,自然流产))
with(screening3,table(人工流产,is.na(人工流产次数)))#缺失41人
with(screening3,table(自然流产,is.na(自然流产次数)))#缺失4人
####其他变量
#BMI
#BMI
summary(screening3$BMI);table(screening3$BMI分组)#缺失328人
ggboxplot(data=screening3,y='BMI',add='jitter')
#婚姻
summary(screening3$婚姻);table(screening3$婚姻)#缺失328人
round(prop.table(table(screening3$婚姻))*100,2)


#基线相关描述------------------------------------------------------------------------------------------------
#基线描述
table1::table1(~初筛年龄+出生年份分组+地区+教育+BMI+BMI分组+初潮年龄分组+初潮年龄+绝经+
                 绝经年龄分组+绝经年龄+生育+生育次数分组+生育次数+首次生育年龄分组+初次生育年龄+
                 哺乳+哺乳时间分组+哺乳月份+流产情况分组+流产+人工流产+自然流产+人工流产次数+绝育手术+子宫摘除术+卵巢摘除术 ,data=screening3,render.categorical=my.render.cat)

screening3%>%filter(!is.na(绝经年龄))%>%group_by(绝经年龄分组)%>%summarise(n=n())%>%mutate(p=round(n/sum(n)*100,4))
#生育次数
delivertime<-c(2990,56731,17366,3320,284,275)
round(delivertime/sum(delivertime)*100,2)
#初次生育年龄
age2<-c(459,3949,9387,19961,20436,23431,353)
sum(age2)
round(age2/sum(age2)*100,2)
#哺乳时间
breedtime<-c(10229,4617,33544,16268,6608,5857,853)
sum(breedtime)
round(breedtime/sum(breedtime)*100,2)
##生理生育相关因素的时间分布
table1::table1(~ 初潮年龄+绝经+绝经年龄+生育+生育次数+初次生育年龄+
                 哺乳+哺乳月份+流产+人工流产+人工流产次数 | 出生年份分组 ,data=screening3,render.categorical=my.render.cat)

#教育，地区，年份
with(subset(screening3,地区=='市区'),table(出生年份分组,教育))
with(subset(screening3,地区=='市区'),prop.table(table(出生年份分组,教育),margin = 2))
with(subset(screening3,地区=='郊区'),table(出生年份分组,教育))
with(subset(screening3,地区=='郊区'),prop.table(table(出生年份分组,教育),margin = 2))

#趋势性分析######-------------------------------------------------------------------------------------------------############
#初潮年龄
#初潮年龄与出生年份:14.9-13.4
a<-screening3%>%group_by(出生年份)%>%summarise(n=n(),mean=mean(初潮年龄))
print(a,n=37)
screening3%>%group_by(出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(min(screening3$出生年份),max(screening3$出生年份),5))+mytheme+labs(y='初潮年龄(均值)',title='初潮年龄\n(n=80974)')


#初潮年龄与出生年份(教育水平分层)
with(screening3,table(is.na(出生年份),is.na(教育)))
with(screening3,table(出生年份,教育))
with(subset(screening3,出生年份<=1972 & 出生年份>=1944),table(is.na(出生年份),is.na(教育)))
#plot(去除分层后人数不足100的年份)；1944-1972
screening3%>%filter(出生年份<=1972,出生年份>=1944)%>%group_by(教育,出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1944,1972,5))+mytheme+labs(y='初潮年龄(均值)',title='教育水平分层\n(n=72623)' )


#初潮年龄与出生年份(地区分层)
with(screening3,table(is.na(初潮年龄),is.na(地区)))#79927
with(screening3,table(出生年份,地区))#1944-1978
with(subset(screening3,出生年份<=1975 & 出生年份>=1944),table(is.na(出生年份),is.na(地区)))
screening3%>%filter(出生年份>=1944,出生年份<=1975)%>%group_by(出生年份,地区)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1944,1975,5))+mytheme+labs(y='初潮年龄(均值)',title='地区分层\n(n=76656)')

##初潮年龄与出生年份(教育水平分层,地区分面)、
with(screening3,table(出生年份,教育))#1944-1978
with(subset(screening3,地区=="市区"),table(出生年份,教育))
with(subset(screening3,地区=="郊区"),table(出生年份,教育))
#人数
with(subset(screening3,地区=='市区'),table(is.na(出生年份),is.na(教育)))#65063
with(subset(screening3,地区=='郊区'),table(is.na(出生年份),is.na(教育)))#14855
region<-c('市区\n(n=65063)','郊区\n(n=14855)')
names(region)<-c('市区','郊区')
screening3%>%filter(初潮年龄>7,!is.na(教育),出生年份<=1975)%>%group_by(地区,教育,出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean,color=教育,linetype=教育))+
  geom_smooth(method='loess',se=FALSE)+facet_wrap(.~地区,nrow=1,labeller = labeller(地区=region))+
  scale_x_continuous(breaks = seq(1945,1975,5))+mytheme+labs(y='初潮年龄(均值)')
#初潮年龄<=12岁比例的时间趋势
#screening3%>%filter(!is.na(初潮年龄))%>%transmute(初潮年龄异常=ifelse(初潮年龄<=12,1,0),出生年份)%>%group_by(出生年份,初潮年龄异常)%>%summarise(n=n())%>%
#  group_by(出生年份)%>%mutate(percent=n/sum(n))%>%filter(初潮年龄异常==1)%>%
#  ggplot(aes(x=出生年份,y=percent))+geom_point(shape=15,size=5)+geom_line()+mytheme+labs(y='初潮年龄异常(%)')


#生育次数
with(screening3,summary(生育年份))
with(screening3,table(is.na(生育年份),is.na(生育次数)))#77451人
with(subset(screening3,!is.na(生育次数)),table(生育年份))#1965-2011
with(subset(screening3,生育年份<=2011 & 生育年份>=1965),table(is.na(生育年份),is.na(生育次数)))#77027
screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(生育次数,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+#geom_point()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='生育次数(均值)',title='生育次数\n(n=77027)')


#生育次数与生育年份(地区分层)
with(screening3,summary(生育年份))
with(screening3,table(is.na(生育年份),is.na(地区)))#77451人
with(subset(screening3,!is.na(生育次数)),table(生育年份,地区))#1965-2011
with(subset(screening3,生育年份<=2001 & 生育年份>=1968),table(is.na(生育年份),is.na(生育次数)))#72821
screening3%>%filter(生育年份<=2001,生育年份>=1968)%>%group_by(生育年份,地区)%>%summarise(mean=mean(生育次数,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+#geom_point()+
  scale_x_continuous(breaks = seq(1968,2011,5))+mytheme+labs(y='生育次数(均值)',title='地区分层\n(n=72821)')


#生育次数与生育年份(教育分层)
with(screening3,summary(教育))
with(subset(screening3,!is.na(生育次数)),table(生育年份,教育))#1968-1995
with(subset(screening3,生育年份<=1995 & 生育年份>=1968 & !is.na(生育次数)),table(is.na(生育年份),is.na(教育)))
#with(subset(screening3,生育年份<=1995 & 生育年份>=1968),table(is.na(生育年份),is.na(生育次数)))
screening3%>%filter(生育年份<1995,生育年份>=1968)%>%group_by(生育年份,教育)%>%summarise(mean=mean(生育次数,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+
  scale_x_continuous(breaks = seq(1968,1995,5))+mytheme+labs(y='生育次数(均值)',title='教育分层\n(n=65850)')
##合并教育和地区
ggarrange(birth_region,birth_educat)



#生育次数与生育年份(教育分层,地区分面)

#screening3%>%filter(生育年份<2011,生育年份>=1965,!is.na(教育))%>%group_by(地区,生育年份,教育)%>%summarise(mean=mean(生育次数,na.rm=TRUE))%>%
#  ggplot(aes(x=生育年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+facet_wrap(.~地区,nrow=1)+
#  mytheme+labs(y='生育次数(均值)',title='教育分层\n(n=75987)')





#初次生育年龄
with(screening3,table(is.na(生育年份),is.na(初次生育年龄)))#77623
with(subset(screening3,!is.na(初次生育年龄)),table(生育年份))#1965-2011
screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='初次生育年龄(均值)',title='初次生育年龄\n(n=77623)')
#不拟合
screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_line(colour='blue')+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='初次生育年龄(均值)',title='初次生育年龄\n(n=77623)')


#初次生育年龄与生育年份(地区分层)
with(subset(screening3,!is.na(地区)),table(is.na(生育年份),is.na(初次生育年龄)))#77623
with(subset(screening3,!is.na(初次生育年龄)),table(生育年份,地区))#1968-2001
with(subset(screening3,!is.na(初次生育年龄) & 生育年份<=2001 & 生育年份>=1968),table(!is.na(生育年份),!is.na(地区)))#72979
screening3%>%filter(生育年份<=2001,生育年份>=1968)%>%group_by(生育年份,地区)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1960,2019,5))+mytheme+labs(y='初次生育年龄(均值)',title='地区分层\n(n=72979)')



#初次生育年龄与生育年份(教育分层)
with(subset(screening3,!is.na(教育)),table(is.na(生育年份),is.na(初次生育年龄)))#77623
with(subset(screening3,!is.na(初次生育年龄)),table(生育年份,教育))#1968-1997
with(subset(screening3,!is.na(初次生育年龄) & 生育年份<=1997 & 生育年份>=1968),table(!is.na(生育年份),!is.na(教育)))#68728

screening3%>%filter(生育年份<1998,生育年份>=1968)%>%group_by(生育年份,教育)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1968,1998,5))+mytheme+labs(y='初次生育年龄(均值)')

#合并教育与地区
ggarrange(age_region,age_educati)



#初次生育年龄与生育年份(教育分层,地区分面)
#screening3%>%filter(生育年份<2011,生育年份>=1965)%>%filter(!is.na(教育))%>%group_by(地区,教育,生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
#  ggplot(aes(x=生育年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+facet_wrap(.~地区,nrow=1)+
#  scale_x_continuous(breaks = seq(1960,2019,5))+mytheme+labs(y='初次生育年龄(均值)')


#哺乳时间
with(screening3,table(is.na(生育年份),is.na(哺乳月份)))#66401
with(subset(screening3,!is.na(哺乳月份)),table(生育年份))#1966-2010

with(subset(screening3,生育年份<2011 & 生育年份>=1966),table(is.na(生育年份),is.na(哺乳月份)))#65899
screening3%>%filter(生育年份<2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='哺乳月份(均值)',title='哺乳月份\n(n=65899)')




#哺乳月份与生育年份(地区分层)
with(subset(screening3,!is.na(地区)),table(is.na(生育年份),is.na(哺乳月份)))#66401
with(subset(screening3,!is.na(哺乳月份)),table(生育年份,地区))#1968-2001
with(subset(screening3,生育年份<2002  & 生育年份>1967),table(is.na(生育年份),is.na(哺乳月份)))#62543

screening3%>%filter(生育年份<2002,生育年份>1967)%>%group_by(生育年份,地区)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1967,2002,5))+mytheme+labs(y='哺乳月份(均值)',title='地区分层\n(n=62543)')
  

#哺乳月份与生育年份(教育分层)
with(subset(screening3,!is.na(教育)),table(is.na(生育年份),is.na(哺乳月份)))#66401
with(subset(screening3,!is.na(哺乳月份)),table(生育年份,教育))#1968-2001
with(subset(screening3,生育年份<1997  & 生育年份>1967),table(is.na(生育年份),is.na(哺乳月份)))#57672
screening3%>%filter(生育年份<1997,生育年份>1967)%>%group_by(生育年份,教育)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1967,1997,5))+mytheme+labs(y='哺乳月份(均值)',title='教育分层\n(n=57672)')



#合并教育与地区
ggarrange(breed_region,breed_educati)





#哺乳月份与生育年份(教育分层,地区分面)
#screening3%>%filter(!is.na(教育),生育年份<2011,生育年份>=1965)%>%group_by(地区,教育,生育年份)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
#  ggplot(aes(x=生育年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+facet_wrap(.~地区,nrow=1)+mytheme+
#  scale_x_continuous(breaks = seq(1960,2019,5))+labs(y='哺乳月份(均值)')


#流产情况


#流产率与出生年份
with(subset(screening3,!is.na(流产)),table(出生年份))#1943-1979
screening3%>%filter(!is.na(流产),出生年份<=1979,出生年份>=1943)%>%group_by(出生年份,流产)%>%summarise(n=n())%>%group_by(出生年份)%>%
  mutate(percent=n/sum(n))%>%filter(流产=='是')%>%ggplot(aes(x=出生年份,y=percent))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1943,1979,5))+mytheme+labs(y='流产率')

#流产率与出生年份(地区分层)
screening3%>%filter(!is.na(流产),出生年份<=1979,出生年份>=1943)%>%group_by(地区,出生年份,流产)%>%summarise(n=n())%>%group_by(出生年份,地区)%>%
  mutate(percent=n/sum(n))%>%filter(流产=='是')%>%ggplot(aes(x=出生年份,y=percent,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+
  scale_x_continuous(breaks = seq(1943,1979,5))+mytheme+labs(y='流产率')
#人工流产率与出生年份(地区分层)
with(subset(screening3,!is.na(人工流产)),table(出生年份))#1943-1979

screening3%>%filter(!is.na(人工流产),出生年份<=1979,出生年份>=1943)%>%group_by(地区,出生年份,人工流产)%>%summarise(n=n())%>%group_by(出生年份,地区)%>%
  mutate(percent=n/sum(n))%>%filter(人工流产=='是')%>%ggplot(aes(x=出生年份,y=percent,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+
  scale_x_continuous(breaks = seq(1943,1979,5))+mytheme+labs(y='人工流产率')


#绝经年龄
#绝经年龄与出生年份
with(screening3,table(is.na(出生年份),is.na(绝经年龄)))#59768
with(subset(screening3,!is.na(绝经年龄)),table(出生年份,is.na(绝经年龄)))#1943-1971
with(screening3,prop.table(table(出生年份,绝经),margin = 1))#1943-1963
with(subset(screening3,出生年份<=1963 & 出生年份>=1943),table(is.na(出生年份),is.na(绝经年龄)))#52553

screening3%>%filter(出生年份<=1963 & 出生年份>=1943)%>%group_by(出生年份)%>%summarise(mean=mean(绝经年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+
  scale_x_continuous(breaks = seq(1943,1963,5))+mytheme+labs(y='绝经年龄(均值)',title='绝经年龄\n(n=56244)')



#绝经年龄与出生年份(地区分层)
#with(subset(screening3,绝经年龄>39 & 出生年份<=1970 & 地区=='市区'),table(is.na(出生年份),is.na(绝经年龄)))#48965
#with(subset(screening3,绝经年龄>39 & 出生年份<=1970 & 地区=='郊区'),table(is.na(出生年份),is.na(绝经年龄)))#9473
#region<-c('市区\n(n=65063)','郊区\n(n=14855)')
#names(region)<-c('市区','郊区')
#在所有的出生队列中，郊区女性的平均绝经年龄比农村的要晚2.4个月
with(subset(screening3,!is.na(地区)),table(is.na(出生年份),is.na(绝经年龄)))#59768
with(subset(screening3,!is.na(绝经年龄)),table(出生年份,地区))#1944-1968
with(subset(screening3,!is.na(绝经年龄 & 地区=="市区")),prop.table(table(出生年份,绝经),margin = 1))#1944-1964
with(subset(screening3,!is.na(绝经年龄 & 地区=="郊区")),prop.table(table(出生年份,绝经),margin = 1))#1944-1964

with(subset(screening3,出生年份<=1964  & 出生年份>=1944),table(is.na(出生年份),is.na(绝经年龄)))#54310

screening3%>%filter(出生年份<=1964 & 出生年份>=1944)%>%group_by(出生年份,地区)%>%summarise(mean=mean(绝经年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean,color=地区,linetype=地区))+geom_smooth(method='loess',se=FALSE)+
  scale_x_continuous(breaks = seq(1944,1964,5))+mytheme+labs(y='绝经年龄(均值)',title='地区分层\n(n=54310)')
#绝经年龄与出生年份(教育分层)
with(subset(screening3,!is.na(教育)),table(is.na(出生年份),is.na(绝经年龄)))#59768
with(subset(screening3,!is.na(绝经年龄)),table(出生年份,教育))#1944-1967
with(subset(screening3,!is.na(绝经年龄 & 地区=="小学及以下")),prop.table(table(出生年份,绝经),margin = 1))#1944-1963
with(subset(screening3,!is.na(绝经年龄 & 地区=="初中")),prop.table(table(出生年份,绝经),margin = 1))#1944-1964
with(subset(screening3,!is.na(绝经年龄 & 地区=="高中及以上")),prop.table(table(出生年份,绝经),margin = 1))#1944-1964

with(subset(screening3,出生年份<=1959  & 出生年份>=1944),table(is.na(出生年份),is.na(绝经年龄)))#52280

screening3%>%filter(出生年份<=1959  & 出生年份>=1944)%>%group_by(出生年份,教育)%>%summarise(mean=mean(绝经年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean,color=教育,linetype=教育))+geom_smooth(method='loess',se=FALSE)+
  scale_x_continuous(breaks = seq(1944,1963,5))+mytheme+labs(y='绝经年龄(均值)',title='教育分层\n(n=40073)')


#生理生育因素与BMI的关系性研究#-------------------------------------------------------------------------------------------
#初潮与BMI

screening3%>%group_by(初潮年龄)%>%summarise(n=n(),BMI=mean(BMI,na.rm=T))
screening3%>%filter(地区=="市区",初潮年龄<20)%>%group_by(初潮年龄)%>%summarise(n=n(),BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=初潮年龄,y=BMI))+geom_smooth(method='lm')+geom_point(shape=15,size=5)+scale_y_continuous(limits = c(23,27))+
  mytheme+labs(y='BMI',title='初潮年龄')#+stat_cor(method='spearman')+geom_line()
summary(lm(BMI~初潮年龄,data=subset(screening3,地区=="市区" &  初潮年龄<20)))#有意义


screening3%>%group_by(出生年份分组2,初潮年龄)%>%summarise(BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=初潮年龄,y=BMI))+geom_point(shape=15,size=5)+geom_smooth(method='lm')+
  facet_wrap(.~出生年份分组2,scales = 'free')+
  mytheme+labs(y='BMI',title='初潮年龄')+stat_cor()
screening3%>%group_by(教育,初潮年龄)%>%summarise(BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=初潮年龄,y=BMI))+geom_point(shape=15,size=5)+geom_smooth(method='lm')+
  facet_wrap(.~教育,scales = 'free')+
  mytheme+labs(y='BMI',title='初潮年龄')+stat_cor()
screening3%>%group_by(绝经,初潮年龄)%>%summarise(BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=初潮年龄,y=BMI))+geom_point(shape=15,size=5)+geom_smooth(method='lm')+
  facet_wrap(.~绝经,scales = 'free')+
  mytheme+labs(y='BMI',title='初潮年龄')+stat_cor(method='spearman')



summary(lm(BMI~初潮年龄,data=screening3))#无意义

summary(lm(BMI~I(初潮年龄^2),data=screening3))#无意义
summary(lm(BMI~初潮年龄+初筛年龄,data=screening3))#有意义
summary(lm(BMI~初潮年龄+教育,data=screening3))#有意义
summary(lm(BMI~初潮年龄+绝经,data=screening3))#有意义
forest_model(lm(BMI~初潮年龄+绝经+教育-1,data=screening3))

#绝经年龄与BMI

screening3%>%group_by(绝经年龄)%>%summarise(n=n(),BMI=mean(BMI,na.rm=T))
screening3%>%filter(出生年份<=1963,出生年份>=1945,绝经年龄>=50,子宫摘除术=="否",卵巢摘除术=="否")%>%group_by(绝经年龄)%>%summarise(BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=绝经年龄,y=BMI))+geom_smooth(method='lm')+geom_point(shape=15,size=5)+
  mytheme+labs(y='BMI',title='绝经年龄\n(n=46923)')+scale_y_continuous(limits = c(23,26))+stat_cor(method='spearman')

screening3%>%filter(出生年份<=1963,出生年份>=1945,绝经年龄>=50,子宫摘除术=="否",卵巢摘除术=="否")%>%group_by(绝经年龄)%>%summarise(BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=BMI,y=绝经年龄))+geom_smooth(method='lm')+geom_point(shape=15,size=5)+
  mytheme+labs(y='绝经年龄',title='绝经年龄\n(n=46923)')




summary(lm(BMI~绝经年龄,data=subset(screening3,绝经年龄>=50 &出生年份<=1963 & 出生年份>=1945 & 子宫摘除术=="否" & 卵巢摘除术=="否")))#有意义
summary(lm(绝经年龄~BMI,data=subset(screening3,绝经年龄>=50 &出生年份<=1963 & 出生年份>=1945 & 子宫摘除术=="否" & 卵巢摘除术=="否")))#有意义

#生育次数
screening3%>%group_by(生育次数)%>%summarise(n=n(),mean=mean(BMI,na.rm=T))
summary(lm(BMI~生育次数,data=screening3))#有意义

#初次生育年龄
a16<-screening3%>%filter(!is.na(初次生育年龄),初次生育年龄>=18,初次生育年龄<=40)%>%group_by(初次生育年龄)%>%summarise(n=n(),BMI=mean(BMI,na.rm=T))
print(a16,n=38)
screening3%>%filter(!is.na(初次生育年龄),初次生育年龄>=18,初次生育年龄<=40)%>%group_by(初次生育年龄)%>%summarise(BMI=mean(BMI,na.rm=T))%>%
  ggplot(aes(x=初次生育年龄,y=BMI))+geom_line()+geom_point(shape=15,size=5)+
  mytheme+labs(y='BMI',title='初次生育年龄')
summary(lm(BMI~初次生育年龄,data=screening3))#有意义


#平均哺乳时间与BMI
a17<-screening3%>%filter(!is.na(哺乳月份))%>%group_by(哺乳月份)%>%summarise(n=n(),BMI=mean(BMI,na.rm=T))
print(a17,n=58)

summary(lm(BMI~哺乳月份,data=screening3))#有意义
screening3%>%group_by(哺乳月份)%>%summarise(n=n(),BMI=mean(BMI,na.rm=T))%>%filter(n>50)%>%
  ggplot(aes(x=哺乳月份,y=BMI))+geom_line()+geom_point(shape=15,size=5)+
  mytheme+labs(y='BMI',title='哺乳月份')



####以乳腺癌为结局

screening4$CA_breast<-0
screening4$CA_breast[screening4$CA_type=='乳腺癌']<-1
table(screening4$CA_breast)
summary(glm(CA_breast~初潮年龄,data=subset(screening4,绝经=="是"),family = 'binomial'))
summary(glm(CA_breast~BMI分组,data=screening4,family = 'binomial'))
summary(glm(CA_breast~BMI,data=subset(screening4,绝经=="是"),family = 'binomial'))
summary(glm(CA_breast~BMI分组,data=screening4,family = 'binomial'))
summary(glm(CA_breast~绝经年龄,subset(screening4,绝经=="是"),family = 'binomial'))
##以Bi-rads为结局
screening4$breast_risk<-0
screening4$breast_risk[screening4$ultrBIRADS>=5]<-1
table(screening4$breast_risk)
summary(glm(breast_risk~初潮年龄,data=screening4,family = 'binomial'))
summary(glm(breast_risk~BMI,data=screening4,family = 'binomial'))
summary(glm(breast_risk~绝经年龄,data=screening4,family = 'binomial'))
##以乳腺组织构成为结局
#描述性分析
screening
with(screening4,summary(乳腺组织构成));with(screening4,table(乳腺组织构成))
kruskal.test(初潮年龄~乳腺组织构成,data=screening4)
summary(glm(初潮年龄~factor(乳腺组织构成),data=screening4))
summary(glm(BMI~factor(乳腺组织构成),data=screening4))
screening4$乳腺组织构成2<-ifelse(screening4$乳腺组织构成<=2,0,1)
table(screening4$乳腺组织构成2)
ggboxplot(data=subset(screening4,!is.na(乳腺组织构成)),x='乳腺组织构成',y='初潮年龄',add='jitter')
ggboxplot(data=subset(screening4,!is.na(乳腺组织构成2)),x='乳腺组织构成2',y='初潮年龄',add='jitter')
#BMI  
ggboxplot(data=subset(screening4,!is.na(乳腺组织构成)),x='乳腺组织构成',y='BMI',add='jitter')
ggboxplot(data=subset(screening4,!is.na(乳腺组织构成2)),x='乳腺组织构成2',y='BMI',add='jitter')
#以肿瘤标志物为结局
#初潮年龄与CA125
a<-screening%>%filter(agemenarch>9,agemenarch<21)%>%transmute(agemenarch=agemenarch,CA125=log(CA125))%>%group_by(agemenarch)%>%summarise(n=n(),mean=mean(CA125,na.rm=T))
print(a,n=21)
screening%>%filter(agemenarch>9,agemenarch<21)%>%transmute(agemenarch=agemenarch,CA125=log(CA125))%>%group_by(agemenarch)%>%summarise(mean=mean(CA125,na.rm=T))%>%
  ggplot(aes(x=agemenarch,y=mean))+geom_point()+geom_line()+mytheme


#mediation=BMI
med.fit<-lm(BMI~绝经年龄,data=screening4)
summary(med.fit)

out.fit<-lm(log(CA153)~BMI+绝经年龄,data=screening4)
summary(out.fit)

med.out <- mediate(med.fit, out.fit, treat = "绝经年龄", mediator = "BMI", sims = 100)
summary(med.out)

#初潮年龄


##<<<<<<<<<<<<<<<<<<<<<<<<<<<<<基于出生队列的女性生理生育因素与饮食因素的关联分析>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
table(screening2$出生年份)
#肉制品与初潮年龄
meat.plot<-screening3%>%group_by(出生年份,肉制品)%>%summarise(n=n())%>%group_by(出生年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(肉制品=="是")%>%
  ggplot(aes(x=出生年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='肉制品食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))
agemenarch.plot<-screening3%>%group_by(出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(min(screening3$出生年份),max(screening3$出生年份),5))+mytheme+labs(y='初潮年龄(均值)',title='基于出生队列的初潮年龄与肉制品食用率的相关分析\n(n=80974)')
ggplot2.two_y_axis(agemenarch.plot,meat.plot)
#肉制品与初次生育年龄
meat.plot2<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份,肉制品)%>%summarise(n=n())%>%group_by(生育年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(肉制品=="是")%>%
  ggplot(aes(x=生育年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='肉制品食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))

deliver.plot<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='初次生育年龄(均值)',title='基于出生队列的初次生育年龄与肉制品食用率的相关分析\n(n=77623)')
ggplot2.two_y_axis(deliver.plot,meat.plot2)
###肉制品与哺乳月份
breed.plot<-screening3%>%filter(生育年份<2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='哺乳月份(均值)',title='基于出生队列的平均哺乳时间与肉制品食用率的相关分析\n(n=65899)')
ggplot2.two_y_axis(breed.plot,meat.plot2)
##
#####鸡蛋与生理生育因素
#初潮
egg.plot<-screening3%>%group_by(出生年份,鸡蛋)%>%summarise(n=n())%>%group_by(出生年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(鸡蛋=="是")%>%
  ggplot(aes(x=出生年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='鸡蛋食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))
agemenarch.plot<-screening3%>%group_by(出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(min(screening3$出生年份),max(screening3$出生年份),5))+mytheme+labs(y='初潮年龄(均值)',title='基于出生队列的初潮年龄与鸡蛋食用率的相关分析\n(n=80974)')
ggplot2.two_y_axis(agemenarch.plot,egg.plot)
##初次生育年龄
egg.plot2<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份,鸡蛋)%>%summarise(n=n())%>%group_by(生育年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(鸡蛋=="是")%>%
  ggplot(aes(x=生育年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='鸡蛋食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))

deliver.plot<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='初次生育年龄(均值)',title='基于出生队列的初次生育年龄与鸡蛋食用率的相关分析\n(n=77623)')
ggplot2.two_y_axis(deliver.plot,egg.plot2)
#哺乳时间
breed.plot<-screening3%>%filter(生育年份<2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='哺乳月份(均值)',title='基于出生队列的平均哺乳时间与鸡蛋食用率的相关分析\n(n=65899)')
ggplot2.two_y_axis(breed.plot,egg.plot2)

##蔬菜
#初潮年龄
fruit.plot<-screening3%>%group_by(出生年份,蔬菜)%>%summarise(n=n())%>%group_by(出生年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(蔬菜=="是")%>%
  ggplot(aes(x=出生年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='蔬菜食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))
agemenarch.plot<-screening3%>%group_by(出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(min(screening3$出生年份),max(screening3$出生年份),5))+mytheme+labs(y='初潮年龄(均值)',title='基于出生队列的初潮年龄与蔬菜食用率的相关分析\n(n=80974)')
ggplot2.two_y_axis(agemenarch.plot,fruit.plot)
#初次生育年龄
fruit.plot2<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份,蔬菜)%>%summarise(n=n())%>%group_by(生育年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(蔬菜=="是")%>%
  ggplot(aes(x=生育年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='蔬菜食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))

deliver.plot<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='初次生育年龄(均值)',title='基于出生队列的初次生育年龄与蔬菜食用率的相关分析\n(n=77623)')
ggplot2.two_y_axis(deliver.plot,fruit.plot2)
#哺乳时间
breed.plot<-screening3%>%filter(生育年份<2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='哺乳月份(均值)',title='基于出生队列的平均哺乳时间与蔬菜食用率的相关分析\n(n=65899)')
ggplot2.two_y_axis(breed.plot,fruit.plot2)

###豆类
#初潮年龄
beans.plot<-screening3%>%group_by(出生年份,豆类)%>%summarise(n=n())%>%group_by(出生年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(豆类=="是")%>%
  ggplot(aes(x=出生年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='豆类食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))
agemenarch.plot<-screening3%>%group_by(出生年份)%>%summarise(mean=mean(初潮年龄,na.rm=TRUE))%>%
  ggplot(aes(x=出生年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(min(screening3$出生年份),max(screening3$出生年份),5))+mytheme+labs(y='初潮年龄(均值)',title='基于出生队列的初潮年龄与豆类食用率的相关分析\n(n=80974)')
ggplot2.two_y_axis(agemenarch.plot,beans.plot)

#初次生育年龄
beans.plot2<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份,豆类)%>%summarise(n=n())%>%group_by(生育年份)%>%mutate(percent=round(n/sum(n),2))%>%filter(豆类=="是")%>%
  ggplot(aes(x=生育年份,y=percent))+geom_point(color='red')+geom_smooth(method='loess',se=FALSE,color='red')+mytheme+labs(y='豆类食用率')+
  theme(axis.title.y = element_text(color = "red"),axis.line.y = element_line(color='red'),axis.text.y = element_text(color='red'))

deliver.plot<-screening3%>%filter(生育年份<=2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(初次生育年龄,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='初次生育年龄(均值)',title='基于出生队列的初次生育年龄与豆类食用率的相关分析\n(n=77623)')
ggplot2.two_y_axis(deliver.plot,beans.plot2)

#哺乳时间
breed.plot<-screening3%>%filter(生育年份<2011,生育年份>=1965)%>%group_by(生育年份)%>%summarise(mean=mean(哺乳月份,na.rm=TRUE))%>%
  ggplot(aes(x=生育年份,y=mean))+geom_smooth(method='loess',se=FALSE)+geom_point()+border()+
  scale_x_continuous(breaks = seq(1965,2011,5))+mytheme+labs(y='哺乳月份(均值)',title='基于出生队列的平均哺乳时间与豆类食用率的相关分析\n(n=65899)')
ggplot2.two_y_axis(breed.plot,beans.plot2)







