biomarker<-import('~/data/biomark2017-2019(剔除自身癌).sav')
biomarker<-biomarker%>%transmute(ID_BLAST=ID_BLAST,Year=Year,
  AFP=AFP,CA199=CA199,HBsAg=HBsAg,
  AFP_pos=factor(ifelse(AFP>7,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  CA199_pos=factor(ifelse(CA199>27,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  HBsAg_pos=HBsAg_base_pos,
  liver_sim=ifelse(CATPFath==24 | CATPMoth==24 | CATPBrot==24 | Catpbrot1==24 |Catpbrot2==24 |
                     CATPSist==24 | Catpsist1==24 | Catpsist2==24 | CATPChil==24 |   Catpchil1==24 | Catpchil2==24,1,0),
  liver_sim=factor(ifelse(is.na(liver_sim),0,liver_sim),levels=c(0,1),labels=c('否','是')),
  gastric_sim=ifelse(CATPFath==16 | CATPMoth==16 | CATPBrot==16 | Catpbrot1==16 |Catpbrot2==16 |
                       CATPSist==16 | Catpsist1==16 | Catpsist2==16 | CATPChil==16 |  Catpchil1==16 | Catpchil2==16,1,0),
  gastric_sim=factor(ifelse(is.na(gastric_sim),0,gastric_sim)),
  sex_risk=factor(sex_check,levels=c(1,2),labels=c('男','女')),
  age_risk=ifelse(age<=49,'0',ifelse(age>=60,'2','1')),
  age_risk=factor(age_risk,levels = c(0,1,2),labels = c('<49','50-60','>60')), 
  marriage_risk=case_when(
    marriag==1 ~ 1,
    marriag==2 ~ 2,
    marriag==3  | marriag==4 ~ 3
  ),
  marriage_risk=factor(marriage_risk,levels = c(1,2,3),labels=c('已婚','未婚','离婚或丧偶')),
  education_risk=case_when(
    educati==1 | educati==2  ~ 1,
    educati==3 ~ 2,
    educati==4 | educati==5 | educati==6 ~ 3,
  ),
  education_risk=factor(education_risk,levels=c(1,2,3),labels=c('小学及以下','初中','高中及以上')),
  income_risk=factor(income,levels = c(1,2,3,4),labels=c('<3000','3000-4999','5000-9999','>10000')),
  employm_risk=factor(employm,levels=c(1,2,3,4),labels=c('在业','离退休','失业/下岗/待业','家务/无业')),
  blood_risk=factor(bloodtp,levels = c(1,2,3,4,5),labels=c('A','B','O','AB','不详')),
  smk_risk=factor(smoking,levels=c(1,2,3),labels=c('从不吸烟','目前仍在吸烟','以前吸烟')),
  occupat_risk=factor(occupat,levels=c(1,2,3,4,5,6,7,8),labels=c('机关/企事业单位负责人','专业技术人员',
                                                                 '办事人员和相关人员','商业/服务业人员',
                                                                 '农林牧渔水利业生产人员','生产运输设备操作人员',
                                                                 '军人','其它')),
  psmk_risk=case_when(
    passivesmk==1 | is.na(passivesmk)~ 0,
    passivesmk==2 & psmkyrs<10 ~ 1,
    passivesmk==2 & psmkyrs>=10 ~ 2,
  ),
  psmk_risk=factor(psmk_risk,levels=c(0,1,2),labels=c('否','是且<=10年','是且>10年')),
  BMI2=10000*weight/(height*height),
  BMI_risk=case_when(
    BMI2<24 & BMI2>=18.5 ~ 0,#正常
    BMI2<18.5 ~ 1,#偏瘦
    BMI2<28 & BMI2>=24 ~ 2,#超重
    BMI2>=28 ~ 3#肥胖
  ),
  BMI_risk=relevel(factor(BMI_risk,levels = c(0,1,2,3),labels=c('正常','偏瘦','超重','肥胖')),ref='正常'),
  #饮食
  alcohol_risk=factor(ifelse(alcohol==2 & !is.na(alcohol),1,0)),#饮酒
  tea_risk=factor(ifelse(tea==2 & !is.na(tea),1,0)),#饮茶
  yogurt_risk=factor(ifelse(yogurt==2 & !is.na(yogurt),1,0)),#酸奶
  coffee_risk=factor(ifelse(coffee==2 & !is.na(coffee),1,0)),#coffee
  veget_risk=factor(ifelse(veget==2 & !is.na(veget),1,0)),#蔬菜
  fruit_risk=factor(ifelse(fruit==2 & !is.na(fruit),1,0)),#水果
  grain_risk=factor(ifelse(grain==2 & !is.na(grain),1,0)),#谷类
  egg_risk=factor(ifelse(egg==2 & !is.na(egg),1,0)),#鸡蛋
  cereal_risk=factor(ifelse(cereal==2 & !is.na(cereal),1,0)),#杂粮
  beans_risk=factor(ifelse(beans==2 & !is.na(beans),1,0)),#豆类
  nuts_risk=factor(ifelse(nuts==2 & !is.na(nuts),1,0)),#坚果
  fungus_risk=factor(ifelse(fungus==2 & !is.na(fungus),1,0)),#菌类  
  #饮食偏好
  salty_risk=factor(ifelse(salty==2 & !is.na(salty),1,0)),
  salted_risk=factor(ifelse(salted==2 & !is.na(salted),1,0)),
  fried_risk=factor(ifelse(fried==2 & !is.na(fried),1,0)),#油炸
  barbecued_risk=factor(ifelse(barbecued==2 & !is.na(barbecued),1,0)),#烧烤
  smked_risk=factor(ifelse(smked==2 & !is.na(smked),1,0)),#熏制
  #体育锻炼
  exercise_risk=factor(ifelse(exercise==2 & !is.na(exercise),1,0)),
  jog_risk=factor(ifelse(jog==2 & !is.na(jog),1,0)),#快走
  taichi_risk=factor(ifelse(taichi==2 & !is.na(taichi),1,0)),#太极
  fitdance_risk=factor(ifelse(fitdance==2 & !is.na(fitdance),1,0)),#广场舞
  yoga_risk=factor(ifelse(yoga==2 & !is.na(yoga),1,0)),#瑜伽
  swim_risk=factor(ifelse(swim==2 & !is.na(swim),1,0)),#游泳
  run_risk=factor(ifelse(run==2 & !is.na(run),1,0)),#跑步
  ball_risk=factor(ifelse(ball==2 & !is.na(ball),1,0)),#球类
  apparatus_risk=factor(ifelse(apparatus==2 & !is.na(apparatus),1,0)),#器械
  #静态时间
  sedentaryh_risk=case_when(
    sedentaryh==1 ~ 1,
    sedentaryh==2 ~ 2,
    sedentaryh==3 |sedentaryh==4  ~3
  ),
  sedentaryh_risk=factor(sedentaryh_risk,levels=c(1,2,3),labels=c('少于3小时','3-6小时','>=7')),
  #手机使用时间
  cellphoneh_risk=case_when(
    cellphoneh==1 ~ 1,
    cellphoneh==2 ~ 2,
    cellphoneh==3 | cellphoneh==3 ~ 3,
  ),
  cellphoneh_risk=factor(cellphoneh_risk,levels=c(1,2,3),labels=c('少于3小时','3-6小时','7小时及以上')),
  #基础性疾病
  disea7_risk=factor(ifelse(Disea7==2 & !is.na(Disea7) & Year==2019,1,0)),#胆囊息肉
  disea8_risk=factor(ifelse(Disea8==2 & !is.na(Disea8) & Year==2019,1,0)),#胆结石
  disea9_risk=factor(ifelse(Disea9==2 & !is.na(Disea9),1,0)),#脂肪肝
  disea10_risk=factor(ifelse(Disea10==2 & !is.na(Disea10),1,0)),#肝硬化
  disea11_risk=factor(ifelse(Disea11==2 & !is.na(Disea11),1,0)),#慢性乙型肝炎
  disea12_risk=factor(ifelse(Disea12==2 & !is.na(Disea12),1,0)),#慢性丙型肝炎
  disea13_risk=factor(ifelse(Disea13==2 & !is.na(Disea13),1,0)),#血吸虫病感染史
  disea28_risk=factor(ifelse(Disea28==2 & !is.na(Disea28),1,0)),#糖尿病
  disea29_risk=factor(ifelse(Disea29==2 & !is.na(Disea29),1,0)),#高血压
  disea30_risk=factor(ifelse(Disea30==2 & !is.na(Disea30),1,0)),#高血脂
  disea31_risk=factor(ifelse(Disea31==2 & !is.na(Disea31),1,0)),#冠心病
  disea32_risk=factor(ifelse(Disea32==2 & !is.na(Disea32),1,0)),#中风
  #职业暴露
  cadmium_risk=factor(ifelse(cadmium==2 & !is.na(cadmium),1,0)),#镉
  asbestos_risk=factor(ifelse(asbestos==2 & !is.na(asbestos),1,0)),#石棉
  nickel_risk=factor(ifelse(nickel==2 & !is.na(nickel),1,0)),#镍
  arsenic_risk=factor(ifelse(arsenic==2 & !is.na(arsenic),1,0)),#砷
  radon_risk=factor(ifelse(radon==2 & !is.na(radon),1,0)),#氡
  chloroethy_risk=factor(ifelse(chloroethy==2 & !is.na(chloroethy),1,0)),#氯乙烯
  Xray_risk=factor(ifelse(Xray==2 & !is.na(Xray),1,0)),#X射线
  benzene_risk=factor(ifelse(benzene==2,1,0)),#苯
  #结局
  CA=factor(ifelse(CA==1,1,0),levels = c(0,1),labels=c('Negative','Positive')),CA_type=CA_type,
  #CA_liver=ifelse(CA_type=='肝癌',1,0)
  
)%>%transmute(ID_BLAST=ID_BLAST,AFP=AFP,CA199=CA199,HBsAg=HBsAg,AFP_pos=AFP_pos,CA199_pos=CA199_pos,HBsAg_pos=HBsAg_pos,
              肝癌家族史=liver_sim,胃癌家族史=gastric_sim,性别=factor(sex_risk),Year=Year,
              年龄=age_risk,就业状况=employm_risk,BMI=BMI2,BMI_group=BMI_risk,收入=income_risk,职业=occupat_risk,
              偏咸=salty_risk,腌制=salted_risk,饮酒=alcohol_risk,喝茶=tea_risk,酸奶=yogurt_risk,
              吸烟=smk_risk,被动吸烟=factor(psmk_risk),婚姻=marriage_risk,教育=education_risk,
              血型=blood_risk,蔬菜=veget_risk,水果=fruit_risk,谷类=grain_risk,鸡蛋=egg_risk,
              杂粮=cereal_risk,豆类=beans_risk,坚果=nuts_risk,菌类=fungus_risk,油炸=fried_risk,
              烧烤=barbecued_risk,熏制=smked_risk,
              运动=exercise_risk,快走=jog_risk,太极=taichi_risk,广场舞=fitdance_risk,瑜伽=yoga_risk,游泳=swim_risk,跑步=run_risk,球类=ball_risk,器械=apparatus_risk,
              静态时间=factor(sedentaryh_risk),手机使用时间=cellphoneh_risk,
              胆囊息肉=disea7_risk,胆结石=disea8_risk,脂肪肝=disea9_risk,肝硬化= disea10_risk,慢性乙型肝炎=disea11_risk,慢性丙型肝炎=disea12_risk,血吸虫病感染史=disea13_risk,
              糖尿病=disea28_risk,高血压=disea29_risk,高血脂=disea30_risk,冠心病=disea31_risk,中风=disea32_risk,
              镉=cadmium_risk,石棉=asbestos_risk,镍=nickel_risk,砷=arsenic_risk,氡=radon_risk,
              氯乙烯=chloroethy_risk,X射线=Xray_risk,
              CA=CA,CA_type=CA_type,
              CA_liver=ifelse(CA_type=='肝癌',1,0)
)
