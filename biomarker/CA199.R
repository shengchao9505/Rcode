rm(list=ls())
library(ggstatsplot)
library(car)
#读取数据
source('~/Rcode/biomarker/data.R')
biomarker2<-biomarker%>%filter(!is.na(CA199))
biomarker3<-biomarker2%>%filter(CA199<=quantile(CA199,0.75)+IQR(CA199))
#---------------------------------------------------------------------------------------
#年龄(分别做一次剔除异常值和不剔除异常值的情况)
biomarker3%>%transmute(CA199=log(CA199),age=age,age_group=age_group)%>%
  ggscatterstats(                                            # dataframe from which variables are taken
    x = age,                                                  # predictor/independent variable 
    y = CA199,                                                  # dependent variable
    xlab = "age",                 # label for the x-axis
    ylab = "log(CA199)",                                     # label for the y-axis
    point.alpha = 0.7,
    point.size = 4,
    point.color = "grey50",
    #marginal = TRUE,                                             # show marginal distribution 
    #marginal.type = "density",                                   # type of plot for marginal distribution
    #centrality.para = "mean",                                    # centrality parameter to be plotted
    #margins = "both",                                            # marginal distribution on both axes
    xfill = "#CC79A7",                                           # fill for marginals on the x-axis
    yfill = "#009E73",                                           # fill for marginals on the y-axis
    xalpha = 0.5,                                                # transparency for the x-axis marginals
    yalpha = 0.75,                                               # transparency for the y-axis marginals
    xsize = 1,                                                   # size for the x-axis marginals
    ysize = 1,
    type='pearson',
    # type='spearman',
    nboot=5,                                           # type of linear association
    title = "Relationship between CA199 and age(Drop the outlier records)",
    #title = "Relationship between CA199 and age(Drop the missing records)",
    messages = FALSE,bf.message = FALSE
  )
#吸烟1
leveneTest(log(CA199)~factor(smoking),data=biomarker2)
plot.smoking1<-biomarker3%>%transmute(CA199=log(CA199),smoking=factor(smoking,labels=c('Never','Current','Former')))%>%
  ggbetweenstats(
    x = smoking,
    y =CA199,
    ylab='log(CA199)',
    xlab='smoking',
    nboot = 10,#type='np',
    messages = FALSE,bf.message=FALSE,
    pairwise.comparisons = TRUE, # display results from pairwise comparisons
    pairwise.display = "significant", # display only significant pairwise comparisons
    pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    title = "Relationship between CA199 and smoking(Drop the outlier records)"
    #title = "Relationship between AFP and smoking(Drop the missing records)",
    
  )  
#吸烟2
plot.smoking<-biomarker2%>%transmute(CA199=log(CA199),smoking=factor(smoking,labels=c('Never','Current','Former')))%>%
  ggbetweenstats(
    x = smoking,
    y =CA199,
    ylab='log(CA199)',
    xlab='smoking',
    nboot = 10,#type='np',
    messages = FALSE,bf.message=FALSE,
    pairwise.comparisons = TRUE, # display results from pairwise comparisons
    pairwise.display = "significant", # display only significant pairwise comparisons
    pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    #title = "Relationship between AFP and smoking(Drop the outlier records)",
    title = "Relationship between CA199 and smoking(Drop the missing records)",
    
  )   
combine_plots(
  plot.smoking,plot.smoking1,
  nrow = 2,
  labels = c("(a)", "(b)"),
  title.text = " ",
  caption.text = " ",
  title.size = 14,
  caption.size = 12
)

#BMI
biomarker3%>%transmute(CA199=log(CA199),bmi=bmi)%>%
  ggscatterstats(                                            # dataframe from which variables are taken
    x = bmi,                                                  # predictor/independent variable 
    y = CA199,                                                  # dependent variable
    xlab = "BMI",                 # label for the x-axis
    ylab = "log(CA199)",                                     # label for the y-axis
    point.alpha = 0.7,
    point.size = 4,
    point.color = "grey50",
    #marginal = TRUE,                                             # show marginal distribution 
    #marginal.type = "density",                                   # type of plot for marginal distribution
    #centrality.para = "mean",                                    # centrality parameter to be plotted
    #margins = "both",                                            # marginal distribution on both axes
    xfill = "#CC79A7",                                           # fill for marginals on the x-axis
    yfill = "#009E73",                                           # fill for marginals on the y-axis
    xalpha = 0.5,                                                # transparency for the x-axis marginals
    yalpha = 0.75,                                               # transparency for the y-axis marginals
    xsize = 1,                                                   # size for the x-axis marginals
    ysize = 1,
    #type='pearson',
    type='spearman',
    nboot=5,                                           # type of linear association
    title = "Relationship between AFP and  BMI(Drop the outlier records)",
    #title = "Relationship between CA199 and BMI(Drop the missing records)",
    messages = FALSE,bf.message = FALSE
  )
plot.bmi1<-biomarker3%>%transmute(CA199=log(CA199),bmi_group=factor(bmi_group,labels = c('Lower','Normal','overweight','besity')))%>%
  ggbetweenstats(
    x = bmi_group,
    y =CA199,
    ylab='log(CA199)',
    xlab='BMI',
    nboot = 10,
    messages = FALSE,bf.message=FALSE,
    pairwise.comparisons = TRUE, # display results from pairwise comparisons
    pairwise.display = "significant", # display only significant pairwise comparisons
    pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    title = "Relationship between CA199 and smoking(Drop the outlier records)"
    #title = "Relationship between AFP and smoking(Drop the missing records)",
    
  )  
plot.bmi2<-biomarker2%>%transmute(CA199=log(CA199),bmi_group=factor(bmi_group,labels = c('Lower','Normal','overweight','besity')))%>%
  ggbetweenstats(
    x = bmi_group,
    y =CA199,
    ylab='log(CA199)',
    xlab='BMI',
    nboot = 10,
    messages = FALSE,bf.message=FALSE,
    pairwise.comparisons = TRUE, # display results from pairwise comparisons
    pairwise.display = "significant", # display only significant pairwise comparisons
    pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    #title = "Relationship between CA199 and smoking(Drop the outlier records)",
    title = "Relationship between AFP and smoking(Drop the missing records)",
    
  )   
combine_plots(
  plot.bmi1,plot.bmi2,
  nrow = 1,
  labels = c("(a)", "(b)"),
  title.text = " ",
  caption.text = " ",
  title.size = 14,
  caption.size = 12
)

#饮酒(饮酒使AFP升高)
plot.alcohol1<-biomarker2%>%transmute(CA199=log(CA199),alcohol=factor(alcohol,labels=c('NO','YES')))%>%
  ggbetweenstats(
    x = alcohol,
    y =CA199,
    ylab='log(CA199)',
    xlab='alcohol',
    nboot = 10,
    messages = FALSE,
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    title = "Relationship between CA199 and alcohol(Drop the missing records)",
  )
plot.alcohol2<-biomarker3%>%transmute(CA199=log(AFP),alcohol=factor(alcohol,labels=c('NO','YES')))%>%
  ggbetweenstats(
    x = alcohol,
    y =CA199,
    ylab='log(CA199)',
    xlab='alcohol',
    nboot = 10,
    messages = FALSE,
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    title = "Relationship between CA199 and alcohol(Drop the outlier records)",
  ) 
combine_plots(
  plot.alcohol1,plot.alcohol2,
  nrow = 1,
  labels = c("(a)", "(b)"),
  title.text = " ",
  caption.text = " ",
  title.size = 14,
  caption.size = 12
)


#疾病史(糖尿病，高血压，高血脂，冠心病，偏头疼)(偏头疼有意义)(剔除异常值)
biomarker3%>%transmute(CA199=log(CA199),
                       Diabetes=factor(Disea28,labels=c('NO','YES')),
                       Hypertension=factor(Disea29,labels=c('NO','YES')),
                       Hyperlipidemia=factor(Disea30,labels=c('NO','YES')),
                       Coronarry=factor(Disea31,labels=c('NO','YES')),
                       Migraine=factor(Disea33,labels=c('NO','YES')))%>%
  pivot_longer(cols=c('Diabetes','Hypertension','Hyperlipidemia','Coronarry','Migraine'),names_to='disea',values_to = 'levels')%>%
  grouped_ggbetweenstats(
    x = levels,
    y = CA199,
    grouping.var = disea,
    xlab = "levels",
    ylab = "log(CA199)",
    k = 2,type='np',
    nboot = 10,
    partial = FALSE, # partial omega or omega?
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    ggstatsplot.layer = FALSE,
    messages = FALSE,bf.message = FALSE,
    # arguments relevant for ggstatsplot::combine_plots
    title.text = "The relationship between CA199 and Disease(Drop outlier records)",
    nrow = 3,
  )
#剔除缺失值
biomarker2%>%transmute(CA199=log(CA199),
                       Diabetes=factor(Disea28,labels=c('NO','YES')),
                       Hypertension=factor(Disea29,labels=c('NO','YES')),
                       Hyperlipidemia=factor(Disea30,labels=c('NO','YES')),
                       Coronarry=factor(Disea31,labels=c('NO','YES')),
                       Migraine=factor(Disea33,labels=c('NO','YES')))%>%
  pivot_longer(cols=c('Diabetes','Hypertension','Hyperlipidemia','Coronarry','Migraine'),names_to='disea',values_to = 'levels')%>%
  grouped_ggbetweenstats(
    x = levels,
    y = CA199,
    grouping.var = disea,
    xlab = "levels",
    ylab = "log(CA199)",
    k = 2,type='np',
    nboot = 10,
    partial = FALSE, # partial omega or omega?
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    ggstatsplot.layer = FALSE,
    messages = FALSE,bf.message = FALSE,
    # arguments relevant for ggstatsplot::combine_plots
    title.text = "The relationship between CA199 and Disease(Drop missing records)",
    nrow = 3,
  )
##肝病与CA199的关系
biomarker2%>%transmute(CA199=log(CA199),
                       polyp=factor(Disea7,labels=c('NO','YES')),
                       Gallstones=factor(Disea8,labels=c('NO','YES')),
                       Fattyliver=factor(Disea9,labels=c('NO','YES')),
                       Cirrhosis=factor(Disea10,labels=c('NO','YES')),
                       HepatitisB=factor(Disea11,labels=c('NO','YES')),
                       HepatitisC=factor(Disea12,labels=c('NO','YES')))%>%
  pivot_longer(cols=c('polyp','Gallstones','Fattyliver','Cirrhosis','HepatitisB','HepatitisC'),names_to='disease',values_to = 'levels')%>%
  grouped_ggbetweenstats(
    x = levels,
    y = CA199,
    grouping.var = disease,
    xlab = "levels",
    ylab = "log(CA199)",
    k = 2,type='np',
    nboot = 10,
    partial = FALSE, # partial omega or omega?
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    ggstatsplot.layer = FALSE,
    messages = FALSE,bf.message = FALSE,
    # arguments relevant for ggstatsplot::combine_plots
    title.text = "The relationship between AFP and liver Disease(Drop missing records)",
    #title.text = "The relationship between CA199 and liver Disease(Drop outlier records)",
    nrow = 3,
  )
#2019年乙肝检查阳性与阴性比较
plot.hbsag1<-biomarker2%>%transmute(CA199=log(CA199),HBsAg=factor(HBsAg_group,labels=c('NO','YES')))%>%
  ggbetweenstats(
    x = HBsAg,
    y =CA199,
    ylab='log(CA199)',
    xlab='HBsAg',
    nboot = 10,
    messages = FALSE,
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    title = "Relationship between CA199 and HBsAg(Drop the missing records)",
  ) 
plot.hbsag2<-biomarker3%>%transmute(CA199=log(CA199),HBsAg=factor(HBsAg_group,labels=c('NO','YES')))%>%
  ggbetweenstats(
    x = HBsAg,
    y =CA199,
    ylab='log(CA199)',
    xlab='HBsAg',
    nboot = 10,
    messages = FALSE,
    #pairwise.comparisons = TRUE, # display results from pairwise comparisons
    #pairwise.display = "significant", # display only significant pairwise comparisons
    #pairwise.annotation = "p.value", # annotate the pairwise comparisons using p-values
    #p.adjust.method = "fdr", # adjust p-values for multiple tests using this method
    ggtheme = ggthemes::theme_tufte(),
    package = "ggsci",
    palette = "default_jco",
    title = "Relationship between CA199 and HBsAg(Drop the outlier records)",
  ) 
combine_plots(
  plot.hbsag1,plot.hbsag2,
  nrow = 1,
  labels = c("(a)", "(b)"),
  title.text = " ",
  caption.text = " ",
  title.size = 14,
  caption.size = 12
)
#afp分类
biomarker2%>%transmute(CA199=factor(CA199_pos,labels=c('Negative','Positive')),HBsAg=HBsAg_group)%>%
  ggpiestats(
    x = CA199,
    y = HBsAg,
    title = " ", # title for the entire plot
    caption = " ", # caption for the entire plot
    legend.title = "Positive?", # legend title
    bf.message = FALSE,
    ggtheme = ggplot2::theme_grey(), # changing plot theme
    palette = "category10_d3", # choosing a different color palette
    package = "ggsci", # package to which color palette belongs
    stat.title = "Association test: ", # title for statistical test
    k = 3, # decimal places in result
    perc.k = 1, # decimal places in percentage labels
    nboot = 10, # no. of bootstrap sample for effect size CI
    messages = FALSE
  ) + # further modification with `ggplot2` commands
  ggplot2::theme(plot.title = ggplot2::element_text(
    color = "black",
    size = 14,
    hjust = 0
  ))
#####肝脏超声复查结果等与AFP的关系


