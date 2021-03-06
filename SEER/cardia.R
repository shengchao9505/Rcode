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
stomach<-import('~/data/noncardia.xlsx')
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
stomach2<-stomach%>%transmute(
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
  surgery_type=`RX Summ--Surg Prim Site (1998+)`
)%>%filter(time>1,surgery_type<=52,surgery_type>=50)
###Cardia gastric cancer patients undergoing surgery
##Nomogram for noncardia gastric cancer
#univariate cox 
variables<-c("Age_group","Race","Sex","stage","Grade","Radiation","Chemotherapy",
             "tumor_size","meta","T","N","Marital","Correa")
cox(x=variables,y='Surv(time,status)',data=stomach2)
cox.model<-coxph(Surv(time,status)~Age_group+Race+Sex+stage+Grade+Surgery+Radiation+Chemotherapy+tumor_size+
                   meta+T+N+Marital+Ln_group,data=stomach2)
step(cox.model,direction = 'backward')
cox.model2<-coxph(Surv(time,status)~Age_group+Sex+Grade+Surgery+Chemotherapy+tumor_size+
                    meta+T+N+Marital+Ln_group,data=stomach.noncardia)
summary(cox.model)
summary(cox.model2)
#
step(cox.model,direction = 'both')
#make nomogram
ddist<-datadist(stomach2)
options(datadist='ddist')
cox2<-cph(Surv(time,status)~Age_group + Race + Sex +stage+Grade + Chemotherapy + meta + T + N + 
            Marital + Ln_group,data=stomach2,surv=T,x=T,y=T) 
surv<-Survival(cox2)
sur_3_year<-function(x)surv(1*12*3,lp=x)
sur_5_year<-function(x)surv(1*12*5,lp=x)
nom_sur <- nomogram(cox2,fun=list(sur_3_year,sur_5_year),lp= F,funlabel=c('3-Year Survival','5-Year survival'),maxscale=100,fun.at=c('0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1'))
plot(nom_sur,xfrac=0.25)
####治疗方式对贲门癌预后的影响










