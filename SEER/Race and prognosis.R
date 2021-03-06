rm(list=ls())
library(rio)
library(tidyverse)
library(survival)
library(rms)
library(survminer)
library(cmprsk)
library(splines)
library(htmlTable)
library(forestmodel)
source('~/Rcode/statistics/Table1.R')
source('~/Rcode/statistics/HR.R')
stomach<-import('~/data/SEER/gastric--2020-12-19.xlsx')
mytheme<-theme(
  axis.title=element_text(family="serif",size=12,face="bold"),
  axis.text=element_text(family="serif",size=12,face="bold"),
  panel.grid.major = element_line(colour=NA),
  panel.grid.minor = element_blank(),
  panel.background=element_rect(fill=NA),
  axis.line = element_line(color='black'),
  legend.title = element_text(family='serif',size=12),
  legend.text = element_text(family = 'serif',size=10),
  legend.key = element_blank(),
  #legend.background = element_rect(colour = 'black')
  
)
#cut-off is 0.59 according to the softwale X-tile
stomach2<-stomach%>%transmute(ID=`Patient ID`,
                              Age=`Age at diagnosis`,
                              Age_group=factor(ifelse(Age>=60,2,1),levels=c(1,2),labels=c('<60','>=60')),
                              Race=factor(Race,levels=c(1,2,3),labels=c('Black','White','Others')),
                              Sex=factor(Sex,levels=c(1,2),labels=c('Male','Female')),
                              time,status,status2,
                              stage=factor(Stage,levels=c(1,2,3),labels=c('locaized','regional','Distant')),
                              Grade=factor(Grade,levels=c(1,2),labels=c('I/II','III/IV')),
                              Surgery=factor(surergy,levels=c(1,2),labels=c('No','Yes')),
                              Radiation=factor(Radiation,levels=c(1,2),labels=c('No','Yes')),
                              Chemotherapy=factor(`Chemotherapy recode (yes, no/unk)`,levels=c(1,2),labels=c('No','Yes')),
                              tumor_size=factor(ifelse(size_group<=1,1,ifelse(size_group<=4,2,3)),levels=c(1,2,3),labels=c('<=2','>2-5','>5')),
                              meta=factor(meta,levels=c(1,2),labels=c('No','Yes')),
                              T=factor(T,levels=c(1,2,3,4),labels=c('T1','T2','T3','T4')),
                              N=factor(N,levels=c(1,2,3,4),labels=c('N0','N1','N2','N3')),
                              M=factor(M,levels=c(1,2),labels=c('M0','M1')),
                              Marital=factor(Marital,levels=c(1,2,3),labels=c('Married','Divorced/Separated/Widowed','Single')),
                              Primary_Site=factor(Primary_Site,levels=c(0,1,2),labels=c('Others','Noncardia','Cardia')),
                              Correa=factor(Correa,levels = c(0,1,2),labels=c('Others','Diffuse','intestinal')),
                              pos_lN_rate,Ln_group=factor(ifelse(pos_lN_rate<=0.59,1,2),levels=c(1,2),labels=c('<=0.59','>=6.0')),
                              stage_cli1=factor(Stage_cli1,levels=c(1,2,3,4),labels=c('I','II','III','IV')),
                              stage_cli2=factor(Stage_cli3,levels=c(1,2,3),labels=c('I','II/III','IV')),
                              Race2=factor(Race2,levels=c(1,2,3,4),labels=c('White','Black','Asian or Pacific Islander','American Indian/Alaska Native'))
)%>%filter(time>1,Surgery=="Yes")
#########病理特征在种族中的分布情况
make.table(dat=stomach2,
           strat        = "Race2",
           cat.rmstat   = c("row"),
           cat.varlist  = c("Age_group","Sex","stage","Grade","Radiation","Chemotherapy","Primary_Site",
                            "tumor_size","meta","T","N","Marital","Correa",'Ln_group','stage_cli1'),
           cat.ptype    = c("chisq"),
           output       = "html"
)
####K-M曲线
kms<-survfit(Surv(time,status)~Race2,data=stomach2)
ggsurvplot(kms,stomach2,pval = T, break.x.by = 30,legend.title="Race",    
           risk.table = T,legend.labs =
             c("White", "Black",'Asian or Pacific Islander','American Indian/Alaska Native'),xlab = "Time in months",risk.table.height = 0.25,
           ggtheme = mytheme,palette =c("#E7B800", "#2E9FDF",'#FF6600','#FF0033'),risk.table.title='No.at Risk',
           tables.theme=clean_theme(),title='Overall Survial')
##Noncardia
kms2<-survfit(Surv(time,status)~Race2,data=subset(stomach2,Primary_Site=="Noncardia"))
ggsurvplot(kms2,subset(stomach2,Primary_Site=="Noncardia"),pval = T, break.x.by = 30,legend.title="Race",    
           risk.table = T,legend.labs =
             c("White", "Black",'Asian or Pacific Islander','American Indian/Alaska Native'),xlab = "Time in months",risk.table.height = 0.25,
           ggtheme = mytheme,palette =c("#E7B800", "#2E9FDF",'#FF6600','#FF0033'),risk.table.title='No.at Risk',
           tables.theme=clean_theme(),title='Overall Survial')
#Cardia
kms3<-survfit(Surv(time,status)~Race2,data=subset(stomach2,Primary_Site=="Cardia"))
ggsurvplot(kms3,subset(stomach2,Primary_Site=="Cardia"),pval = T, break.x.by = 30,legend.title="Race",    
           risk.table = T,legend.labs =
             c("White", "Black",'Asian or Pacific Islander','American Indian/Alaska Native'),xlab = "Time in months",risk.table.height = 0.25,
           ggtheme = mytheme,palette =c("#E7B800", "#2E9FDF",'#FF6600','#FF0033'),risk.table.title='No.at Risk',
           tables.theme=clean_theme(),title='Overall Survial')




































