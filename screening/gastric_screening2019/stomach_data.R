rm(list = ls())
pepsinogen<-import('~/data/pepsinogen2019.sav')
names(pepsinogen)<-tolower(names(pepsinogen))
pepsinogen<-pepsinogen%>%transmute(
  ID=id_blast,#name=name,
  AFP=afp,CA125=ca125,CA153=ca153,CA199=ca199,CEA=cea,HBsAg_pos=factor(ifelse(hbsag>0,1,0),levels = c(0,1),labels = c('阴性','阳性')),
  AFP_pos=factor(ifelse(AFP>7,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  CA199_pos=factor(ifelse(CA199>27,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  CEA_pos=factor(ifelse(CEA>5,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  CA125_pos=factor(ifelse(CA125>35,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  CA153_pos=factor(ifelse(CA153>25,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos=factor(ifelse(pg1<=70 & pgr<=3,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos1=factor(ifelse(pg1<=50 & pgr<=3,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos2=factor(ifelse(pg1<=30 & pgr<=2,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos3<-NA,
  PG_pos3[pg1<=70 & pgr<=3]<-2,
  PG_pos3[pg1<=50 & pgr<=3]<-3,
  PG_pos3[pg1<=30 & pgr<=2]<-4,
  PG_pos3[is.na(PG_pos3)]<-1,
  PG_pos3=factor(PG_pos3,levels=c(1,2,3,4),labels=c('正常','轻度萎缩','中度萎缩','重度萎缩')),
  PG_pos4<-NA,
  PG_pos4[pg1<=70 & pgr<=3]<-2,
  PG_pos4[pg1<=30 & pgr<=2]<-3,
  PG_pos4[is.na(PG_pos4)]<-1,
  PG_pos4=factor(PG_pos4,levels=c(1,2,3),labels=c('正常','一般萎缩','重度萎缩')),
  PG_pos5=factor(ifelse(pgr<=3,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos6=factor(ifelse(pg1<30,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos7=factor(ifelse(pg1<=70,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG_pos8=factor(ifelse(pg2>10,1,0),levels=c(0,1),labels=c('阴性','阳性')),
  PG1=pg1,PG2=pg2,PGR=pgr,
  PG1_range=case_when(
    PG1<20 ~ 1,
    between(PG1,20,70) ~ 2,
    between(PG1,70.01,199.9) ~ 3,
    PG1>=200 ~ 4
  ),
  PG1_range=factor(PG1_range,levels = c(1,2,3,4),labels=c('<20','20-70','70.01-199.99','≥200')),
  PG1_range1=case_when(
    PG1<40.2 ~ 1,
    PG1>=40.2 & PG1<51.1 ~ 2,
    PG1>=51.1 & PG1<63.9 ~ 3,
    PG1>=63.9 & PG1<81.9 ~ 4,
    PG1>=81.9 ~5
  ),
  PG1_range1=factor(PG1_range1,levels=c(1,2,3,4,5),labels=c('<40.2','40.2-51.0','51.1-63.8','63.9-81.8','>=81.9')),
  PG1_range2=case_when(
    PG1<43.4 ~ 1,
    PG1>=43.4 & PG1<57.0 ~ 2,
    PG1>=57.0 & PG1<76.5 ~ 3,
    PG1>=76.5 ~ 4
  ),
  PG1_range2=factor(PG1_range2,levels=c(1,2,3,4),labels=c('<43.4','43.4-56.9','57.0-76.5','>=76.5')),
  PG1_range3=case_when(
    PG1<30 ~ 1,
    PG1>=30 & PG1<=50.0 ~ 2,
    PG1>50.0 & PG1<=70.0 ~ 3,
    PG1>=70 ~ 4
  ),
  PG1_range3=factor(PG1_range3,levels=c(1,2,3,4),labels=c('<30','30-49.9','50-69.9','>=70')),

  PG2_range=case_when(
    PG2<6.51 ~ 1,
    PG2>=6.51 & PG2<9.8 ~ 2,
    PG2>=9.8 & PG2<15.3 ~ 3,
    PG2>=15.30 ~ 4
  ),
  PG2_range=factor(PG2_range,levels = c(1,2,3,4),labels=c('<6.5','6.51-9.79','9.8-15.29','>=15.30')),
  PG2_range2=case_when(
    PG2<6 ~ 1,
    PG2>=6 & PG2<8.4 ~ 2,
    PG2>=8.4 & PG2<11.7 ~ 3,
    PG2>=11.7 & PG2<16.8 ~ 4,
    PG2>=16.8 ~ 5
  ),
  PG2_range2=factor(PG2_range2,levels = c(1,2,3,4,5),labels=c('<6','6-8.39','8.4-11.69','11.7-16.8','>=16.8')),
  
  PG2_range3=factor(ifelse(PG2<=12,0,1),levels=c(0,1),labels=c('<=12','>12')),
  
  
  PGR_range=case_when(
    PGR<3 ~ 1,
    between(PGR,3,7) ~ 2,
    PGR>7 ~ 3
  ),
  PGR_range=factor(PGR_range,levels=c(1,2,3),labels=c('<3','3-7','>7')),
  PGR_range2=case_when(
    PGR<=3 ~ 1,
    PGR>3 & PGR<6 ~ 2,
    PGR>=6 & PGR<9  ~ 3,
    PGR>=9   ~ 4
  ),
  PGR_range2=factor(PGR_range2,levels=c(1,2,3),labels=c('<3','3-7','>7')),
  gastric_sim=ifelse(catpfath==16 | catpmoth==16  | catpbrot1==16 |catpbrot2==16 |
                        catpsist1==16 | catpsist2==16  | catpchil1==16 | catpchil2==16,1,0),
  gastric_sim=factor(ifelse(is.na(gastric_sim),0,gastric_sim),levels=c(0,1),labels=c('阴性','阳性')),
  age=age,
  age_risk=factor(ifelse(age<=49,0,ifelse(age>60,2,1)),levels=c(0,1,2),labels=c('<50','50-60','>60')),
  age_risk2=case_when(
    between(age,40,44) ~ 1,
    between(age,45,49) ~ 2,
    between(age,50,54) ~ 3,
    between(age,55,59) ~ 4,
    between(age,60,64) ~ 5,
    between(age,65,69) ~ 6,
    age>=70 ~ 7
  ),
  age_risk2=factor(age_risk2,levels=seq(7),labels=c('40-44','45-49','50-54','55-59',
                                                    '60-64','65-69','>=70')),
  age_risk3=case_when(
    between(age,40,49) ~ 1,
    between(age,50,59) ~ 2,
    between(age,60,69) ~ 3,
    age>=70 ~ 4
  ),
  age_risk3=factor(age_risk3,levels=seq(4),labels=c('40-49','50-59',
                                                    '60-69','>=70')),
  age_risk4=case_when(
    between(age,40,49) ~ 1,
    between(age,50,69) ~ 2,
    age>=70 ~ 3
  ),
  age_risk4=factor(age_risk4,levels=seq(3),labels=c('40-49','50-69',
                                                     '>=70')),
  sex_risk=factor(sex,levels=c(1,2),labels=c('Male','Female')),
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
  education_risk2=case_when(
    educati==1 | educati==2 | educati==3 | educati==4~ 1,
    educati==5 | educati==6 ~ 2,
  ),
  education_risk2=factor(education_risk2,levels=c(1,2),labels=c('≤12年','>12年')),
  
  area=factor(ifelse(insuran==3,1,0),levels=c(0,1),labels=c('农村','城市')),
  
  
  income_risk=factor(income,levels = c(1,2,3,4),labels=c('<3000','3000-4999','5000-9999','>10000')),
  employm_risk=factor(employm,levels=c(1,2,3,4),labels=c('在业','离退休','失业/下岗/待业','家务/无业')),
  blood_risk=factor(bloodtp,levels = c(1,2,3,4,5),labels=c('A','B','O','AB','不详')),
  blood_risk1=case_when(
    bloodtp==3 ~ 1,
    bloodtp==1 | bloodtp==2 | bloodtp==4 ~ 2 ,
    bloodtp==5 ~ 3
  ),
  blood_risk1=factor( blood_risk1,levels = c(1,2,3),labels=c('O','A/B/AB','不详')),
  blood_risk2=case_when(
    bloodtp==1 ~ 1,
    bloodtp==2 | bloodtp==3 | bloodtp==4 ~ 2 ,
    bloodtp==5 ~ 3
  ),
  blood_risk2=factor(blood_risk2,levels = c(1,2,3),labels=c('A','B/AB/O','不详')),
  smk_risk1=factor(smoking,levels=c(1,2,3),labels=c('从不吸烟','目前吸烟','过去吸烟')),
  smk_risk2=factor(ifelse(smoking>=2,1,0),levels=c(0,1),labels=c('从不吸烟','目前或过去吸烟')),
  psmk_risk2=case_when(
    passivesmk==1 ~ 0,
    passivesmk==2 & psmkyrs<10 ~ 1,
    passivesmk==2 & psmkyrs>=10 ~ 2,
  ),
  psmk_risk1=factor(passivesmk,levels=c(1,2),labels=c('否','是')),
  psmk_risk2=factor(psmk_risk2,levels=c(0,1,2),labels=c('否','是且<=10年','是且>10年')),
  BMI=10000*weight/(height*height),
  BMI_risk=case_when(
    BMI<24  ~ 1,#正常
    BMI>=24 & BMI<28 ~ 2,#超重
    BMI>=28 ~ 3#肥胖
  ),
  BMI_risk=factor(BMI_risk,levels = c(1,2,3),labels=c('正常','超重','肥胖')),
  BMI_risk2=case_when(
    BMI<18.5 ~ 1, #偏瘦
    BMI<24 & BMI>=18.5  ~ 2,#正常
    BMI<28 & BMI>=24 ~ 3,#超重
    BMI>=28 ~ 4#肥胖
  ),
  BMI_risk2=factor(BMI_risk2,levels = c(1,2,3,4),labels=c('偏瘦','正常',"超重",'肥胖')),
  BMI_risk3=case_when(
    BMI<18.5 ~ 1, #偏瘦
    BMI<24 & BMI>=18.5  ~ 2,#正常
    BMI<28 & BMI>=24 ~ 3,#超重
    BMI>=28 & BMI<30 ~ 4,#轻度肥胖
    BMI>=30 ~ 5#中-重度肥胖
    
  ),
  BMI_risk3=factor(BMI_risk3,levels = c(1,2,3,4,5),labels=c('偏瘦','正常',"超重",'轻度肥胖','中-重度肥胖')),
  cpd,smkyrs,
  包年=cpd*smkyrs/20,
  包年分组=factor(case_when(
    包年<10 ~ 1,
    between(包年,10,20) ~ 2,
    between(包年,20.01,30) ~ 3,
    between(包年,30.01,40) ~ 4,
    包年>40 ~ 5,
  )),
  包年分组=factor(包年分组,levels=c(1,2,3,4,5),labels=c('<10','-20','-30','-40','>=40')),
  包年分组2=factor(case_when(
    包年<20 ~ 1,
    between(包年,20,40) ~ 2,
    包年>40 ~ 3,
  )),
  吸烟3=case_when(
    smoking==1 ~ 1,
    smoking==3 ~ 2,
    smoking==2 & 包年分组2==1 ~ 3,
    smoking==2 & 包年分组2==2 ~ 4,
    smoking==2 & 包年分组2==3 ~ 5,
    ),
  吸烟3=factor(吸烟3,levels=c(1,2,3,4,5),labels=c('从不吸烟','过去吸烟','目前吸烟且包年<20','目前吸烟且包年20-40','目前吸烟且包年>40')),
  #BMI_risk=factor(ifelse(10000*weight/(height*height)<24,0,ifelse(10000*weight/(height*height)<28,1,2))),
  #饮食
  alcohol_risk=factor(ifelse(alcohol==2 & !is.na(alcohol),1,0),levels=c(0,1),labels=c('否','是')),#酒
  tea_risk=factor(ifelse(tea==2 & !is.na(tea),1,0),levels=c(0,1),labels=c('否','是')),#茶
  coffee_risk=factor(ifelse(coffee==2 & !is.na(coffee),1,0),levels=c(0,1),labels=c('否','是')),#咖啡
  milk_risk=factor(ifelse(milk==2 & !is.na(milk),1,0),levels=c(0,1),labels=c('否','是')),#鲜奶
  yogurt_risk=factor(ifelse(yogurt==2 & !is.na(yogurt),1,0),levels=c(0,1),labels=c('否','是')),#酸奶
  sodas_risk=factor(ifelse(sodas==2 & !is.na(sodas),1,0),levels=c(0,1),labels=c('否','是')),#碳酸饮料
  juice_risk=factor(ifelse(juice==2 & !is.na(juice),1,0),levels=c(0,1),labels=c('否','是')),#果汁果味饮料
  teadr_risk=factor(ifelse(teadr==2 & !is.na(teadr),1,0),levels=c(0,1),labels=c('否','是')),#茶味饮料
  veget_risk=factor(ifelse(veget==2 & !is.na(veget),1,0),levels=c(0,1),labels=c('否','是')),#蔬菜
  fruit_risk=factor(ifelse(fruit==2 & !is.na(fruit),1,0),levels=c(0,1),labels=c('否','是')),#水果
  grain_risk=factor(ifelse(grain==2 & !is.na(grain),1,0),levels=c(0,1),labels=c('否','是')),  #谷类
  meat_risk=factor(ifelse(meat==2 & !is.na(meat),1,0),levels=c(0,1),labels=c('否','是')),  #肉类
  egg_risk=factor(ifelse(egg==2 & !is.na(egg),1,0),levels=c(0,1),labels=c('否','是')),  #鸡蛋
  seafd_risk=factor(ifelse(seafd==2 & !is.na(seafd),1,0),levels=c(0,1),labels=c('否','是')),#水产品
  potato_risk=factor(ifelse(potato==2 & !is.na(potato),1,0),levels=c(0,1),labels=c('否','是')),#薯类
  cereal_risk=factor(ifelse(cereal==2 & !is.na(cereal),1,0),levels=c(0,1),labels=c('否','是')),  #杂粮
  beans_risk=factor(ifelse(beans==2 & !is.na(beans),1,0),levels=c(0,1),labels=c('否','是')),  #豆类
  nuts_risk=factor(ifelse(nuts==2 & !is.na(nuts),1,0),levels=c(0,1),labels=c('否','是')),  #坚果
  garlic_risk=factor(ifelse(garlic==2 & !is.na(garlic),1,0),levels=c(0,1),labels=c('否','是')),  #大蒜
  fungus_risk=factor(ifelse(fungus==2 & !is.na(fungus),1,0),levels=c(0,1),labels=c('否','是')),  #菌类
  fried_risk=factor(ifelse(fried==2 & !is.na(fried),1,0),levels=c(0,1),labels=c('否','是')),  #油炸
  barbecued_risk=factor(ifelse(barbecued==2 & !is.na(barbecued),1,0),levels=c(0,1),labels=c('否','是')),  #烧烤
  smked_risk=factor(ifelse(smked==2 & !is.na(smked),1,0),levels=c(0,1),labels=c('否','是')),  #熏制
  salted_risk=factor(ifelse(salted==2 & !is.na(salted),1,0),levels=c(0,1),labels=c('否','是')),  #腌制
  sauced_risk=factor(ifelse(sauced==2 & !is.na(sauced),1,0),levels=c(0,1),labels=c('否','是')),  #酱制
  dried_risk=factor(ifelse(dried==2 & !is.na(dried),1,0),levels=c(0,1),labels=c('否','是')),  #晒制
  salty_risk=factor(ifelse(salty==2 & !is.na(salty),1,0),levels=c(0,1),labels=c('否','是')),  #偏咸
  spicy_risk=factor(ifelse(spicy==2 & !is.na(spicy),1,0),levels=c(0,1),labels=c('否','是')),  #偏辣
  hot_risk=factor(ifelse(hot==2 & !is.na(hot),1,0),levels=c(0,1),labels=c('否','是')),  #偏烫
  sour_risk=factor(ifelse(sour==2 & !is.na(sour),1,0),levels=c(0,1),labels=c('否','是')),  #偏酸
  sweet_risk=factor(ifelse(sweet==2 & !is.na(sweet),1,0),levels=c(0,1),labels=c('否','是')),  #偏甜
  hard_risk=factor(ifelse(hard==2 & !is.na(hard),1,0),levels=c(0,1),labels=c('否','是')),  #偏咸
  
  #饮食习惯
  breakfast_risk=factor(ifelse(breakfast==2,1,0),levels=c(0,1),labels = c('否','是')),
  dalayeat_risk=factor(ifelse(dalayeat==2,1,0),levels=c(0,1),labels = c('否','是')),
  speedeat_risk=factor(speedeat,levels=c(1,2,3),labels = c('慢','适中','快')),
  outeat_risk=factor(ifelse(outeat>3,3,outeat),levels=c(1,2,3),labels = c('无或少于1次','1-7次','8次及以上')),
  
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
    cellphoneh==3 | cellphoneh==4 ~ 3,
  ),
  cellphoneh_risk=factor(cellphoneh_risk,levels=c(1,2,3),labels=c('少于3小时','3-6小时','7小时及以上')),
  #基础性疾病
  disea16_risk=factor(ifelse(disea16==2 & !is.na(disea16),1,0),levels=c(0,1),labels=c('否','是')),
  disea14_risk=factor(ifelse(disea14==2 & !is.na(disea14),1,0),levels=c(0,1),labels=c('否','是')),#食管或胃上皮内瘤变
  disea15_risk=factor(ifelse(disea15==2 & !is.na(disea15),1,0),levels=c(0,1),labels=c('否','是')),#十二指肠溃疡
  disea17_risk=factor(ifelse(disea17==2 & !is.na(disea17),1,0),levels=c(0,1),labels=c('否','是')),#萎缩性胃炎
  disea18_risk=factor(ifelse(disea18==2 & !is.na(disea18),1,0),levels=c(0,1),labels=c('否','是')),#胃溃疡
  disea19_risk=factor(ifelse(disea19==2 & !is.na(disea19),1,0),levels=c(0,1),labels=c('否','是')),#胃息肉
  disea20_risk=factor(ifelse(disea20==2 & !is.na(disea20),1,0),levels=c(0,1),labels=c('否','是')),#幽门螺杆菌感染史
  disea22_risk=factor(ifelse(disea22==2 & !is.na(disea22),1,0),levels=c(0,1),labels=c('否','是')),#胃粘膜异性增生
  disea23_risk=factor(ifelse(disea23==2 & !is.na(disea23),1,0),levels=c(0,1),labels=c('否','是')),#胃肠上皮化生
  disea24_risk=factor(ifelse(disea24==2 & !is.na(disea24),1,0),levels=c(0,1),labels=c('否','是')),#残胃
  disea28_risk=factor(ifelse(disea28==2 & !is.na(disea28),1,0),levels=c(0,1),labels=c('否','是')),#糖尿病
  disea29_risk=factor(ifelse(disea29==2 & !is.na(disea29),1,0),levels=c(0,1),labels=c('否','是')),#高血压
  disea30_risk=factor(ifelse(disea30==2 & !is.na(disea30),1,0),levels=c(0,1),labels=c('否','是')),#高血脂
  disea31_risk=factor(ifelse(disea31==2 & !is.na(disea31),1,0),levels=c(0,1),labels=c('否','是')),#冠心病
  disea32_risk=factor(ifelse(disea32==2 & !is.na(disea32),1,0),levels=c(0,1),labels=c('否','是')),#中风
  #职业暴露
  cadmium_risk=factor(ifelse(cadmium==2 & !is.na(cadmium),1,0)),#镉
  asbestos_risk=factor(ifelse(asbestos==2 & !is.na(asbestos),1,0)),#石棉
  nickel_risk=factor(ifelse(nickel==2 & !is.na(nickel),1,0)),#镍
  arsenic_risk=factor(ifelse(arsenic==2 & !is.na(arsenic),1,0)),#砷
  radon_risk=factor(ifelse(radon==2 & !is.na(radon),1,0)),#氡
  chloroethy_risk=factor(ifelse(chloroethy==2 & !is.na(chloroethy),1,0)),#氯乙烯
  Xray_risk=factor(ifelse(xray==2 & !is.na(xray),1,0)),#X射线
  benzene_risk=factor(ifelse(benzene==2,1,0)),#苯
  stress_risk=factor(ifelse(stress==2,1,0),levels=c(0,1),labels = c('否','是')),
  #女性生理生育因素
  初潮年龄=ifelse(agemenarch<quantile(agemenarch,0.001,na.rm = TRUE) | agemenarch>quantile(agemenarch,0.999,na.rm = TRUE),NA,agemenarch),
  绝经年龄=ifelse(agemenopau<quantile(agemenopau,0.001,na.rm = TRUE) | agemenopau>quantile(agemenopau,0.999,na.rm = TRUE),NA,agemenopau),
  绝经=factor(ifelse(!is.na(agemenopau) | menopause==2,2,1),levels = c(1,2),labels=c('否','是')),
  生育=factor(ifelse(delivertim>=1 | deliver==2 ,2,1),levels = c(1,2),labels=c('否','是')),
  生育次数=ifelse(delivertim<quantile(delivertim,0.1,na.rm = TRUE) | delivertim>quantile(delivertim,0.999,na.rm = TRUE),NA,delivertim),
  初次生育年龄=agefirdeli,
  哺乳=ifelse(!is.na(brstfedmth) | breastfeed==2,2,1),
  哺乳=factor(ifelse(is.na(哺乳),1,哺乳),levels=c(1,2),labels=c('否','是')),
  哺乳月份=ifelse(brstfedmth<quantile(brstfedmth,0.001,na.rm = TRUE) | brstfedmth>quantile(brstfedmth,0.99,na.rm = TRUE),NA,brstfedmth),
  流产=factor(ifelse(abortion==2 | !is.na(induabort) | !is.na(sponabort),2,1),levels = c(1,2),labels = c('否','是')),
  人工流产次数=ifelse(induabort<quantile(induabort,0.01,na.rm = TRUE) |  induabort>quantile(induabort,0.999,na.rm = TRUE),NA,induabort),
  自然流产次数=ifelse(sponabort<quantile(sponabort,0.01,na.rm = TRUE) |  sponabort>quantile(sponabort,0.999,na.rm = TRUE),NA,sponabort),
  人工流产=factor(ifelse(is.na(人工流产次数),1,2),levels = c(1,2),labels = c('否','是')),
  自然流产=factor(ifelse(is.na(自然流产次数),1,2),levels = c(1,2),labels = c('否','是')),
  流产情况分组=case_when(
    abortion==1 ~ 1,#无流产
    abortion==2 & !is.na(induabort) ~ 2,#有人工流产史
    abortion==2 & !is.na(sponabort) ~ 2,#有自然流产史
  ),
  绝育手术=factor(ifelse(is.na(sterilizat),1,sterilizat),levels = c(1,2),labels = c('否','是')),
  子宫摘除术=factor(ifelse(is.na(hysterecto),1,hysterecto),levels = c(1,2),labels = c('否','是')),
  卵巢摘除术=factor(ifelse(is.na(ovariectom),1,ovariectom),levels = c(1,2),labels = c('否','是')),
  口服避孕药=factor(oralcontra,levels=c(1,2),labels=c('否','是')),
  雌激素代替治疗=factor(hrt,levels=c(1,2),labels=c('否','是'))
)%>%transmute(ID=ID,PG1,PG2,PGR, PG1_range=PG1_range,PGR_range,PG2_range,PG1_range1,PG1_range2,PG2_range2, PG2_range3,#name=name,
              n=as.character(1:length(PG1)),AFP,CA125,CA153,CA199,CEA,HBsAg_pos,PG_pos3,PG_pos4,PG_pos5, PG_pos6,PG_pos7,PG_pos8,PG1_range3,PGR_range2,
              PG_pos=PG_pos,PG_pos1,PG_pos2,年龄=age,年龄分组3=age_risk3,AFP_pos,CA199_pos,CEA_pos,CA125_pos,CA153_pos,
              胃癌家族史=gastric_sim,
              #年龄、性别
              年龄分组=age_risk,年龄分组2=age_risk2,性别=sex_risk,年龄分组4=age_risk4,
              #人口学特征
              婚姻=marriage_risk,就业状况=employm_risk,教育年数=education_risk2,地址=area,
              教育=education_risk,血型=blood_risk,血型1=blood_risk1,血型2=blood_risk2,
              #吸烟
              吸烟1=smk_risk1,吸烟2=smk_risk2,吸烟3,被动吸烟1=psmk_risk1,被动吸烟2=psmk_risk2,包年,包年分组,包年分组2,cpd,smkyrs,
              #BMI
              BMI=BMI,BMI_group=BMI_risk,BMI_group2=BMI_risk2,BMI_risk3,
              #生活习惯
              每天早餐=breakfast_risk,准点吃饭=dalayeat_risk,吃饭速度=speedeat_risk,外出吃饭=outeat_risk,
              静态时间=factor(sedentaryh_risk),手机使用时间=cellphoneh_risk,手机使用时间=cellphoneh_risk,
              家庭收入=income_risk,
              #运动
              运动=factor(exercise_risk),快走=jog_risk,太极=taichi_risk,
              广场舞=fitdance_risk,瑜伽=yoga_risk,游泳=swim_risk,跑步=run_risk,球类=ball_risk,器械=apparatus_risk,
              #饮食
              饮酒=alcohol_risk,喝茶=tea_risk,鲜奶=milk_risk,酸奶=yogurt_risk,咖啡=coffee_risk,
              碳酸饮料=sodas_risk,果味饮料=juice_risk,茶味饮料=teadr_risk,
              蔬菜=veget_risk,水果=fruit_risk,谷类= grain_risk,肉类=meat_risk,鸡蛋=egg_risk,
              水产品=seafd_risk,薯类=potato_risk,杂粮=cereal_risk,豆类=beans_risk,坚果=nuts_risk,大蒜=garlic_risk,菌类=fungus_risk,
              油炸=fried_risk,烧烤=barbecued_risk,熏制=smked_risk,酱制=sauced_risk,腌制=salted_risk,酱制=sauced_risk,晒制=dried_risk,
              偏咸=salty_risk,偏辣=spicy_risk,偏烫=hot_risk,偏酸=sour_risk,偏甜=sweet_risk,偏硬=hard_risk,
              #疾病史
              食管或胃上皮内瘤变=disea14_risk,胃粘膜不典型增生=disea22_risk,十二指肠溃疡=disea15_risk,
              胃溃疡=disea18_risk,胃息肉=disea19_risk,幽门螺杆菌感染史=disea20_risk,
              消化性溃疡=factor(ifelse(十二指肠溃疡=='是' | 胃溃疡=='是',1,0),levels=c(0,1),labels=c('否','是')),
              萎缩性胃炎=disea17_risk,胃肠上皮化生=disea23_risk,Barrett食管=disea16_risk,
              残胃=disea24_risk,糖尿病=disea28_risk,高血压=disea29_risk,
              #胃病=factor(ifelse(幽门螺杆菌感染史=="是"  | 萎缩性胃炎=="是" | 胃肠上皮化生=="是" |
              #                    胃粘膜异性增生=="是",1,0),levels=c(0,1),labels=c('否','是')),
              高血脂=disea30_risk,冠心病=disea31_risk,中风=disea32_risk,
              #放射暴露
              镉=cadmium_risk,石棉=asbestos_risk,镍=nickel_risk,砷=arsenic_risk,氡=radon_risk,
              氯乙烯=chloroethy_risk,X射线=Xray_risk,苯=benzene_risk,
              重大精神创伤=stress_risk,
              #女性生理生育因素
              初潮年龄,绝经年龄,绝经,生育,生育次数,
              初次生育年龄,哺乳,哺乳月份,流产,人工流产次数,
              自然流产次数,人工流产,自然流产,绝育手术,子宫摘除术,卵巢摘除术,
              初潮年龄分组=factor
              (ifelse(初潮年龄<13,0,1),
                            levels = c(0,1),labels = c('<13岁','>=13岁')),
              生育次数分组=factor(ifelse(生育次数>2,1,0),levels = c(0,1),labels=c('<=2次','>2次')),
              
              首次生育年龄分组=factor(ifelse(初次生育年龄>=30,1,0),levels = c(0,1),labels = c('<30','>=30')) ,
              哺乳时间分组=case_when(
                哺乳==1 ~ 1,
                哺乳月份<=12 ~ 2,         
                哺乳月份>12 ~ 3
              ),
              哺乳时间分组=factor(哺乳时间分组,levels = c(1,2,3,4,5,6),labels = c('未哺乳','1-6','7-12','13-18','19-24','>24')),
              绝经年龄分组=case_when(
                绝经年龄<48 ~ 1,
                between(绝经年龄,48,50) ~ 2,
                between(绝经年龄,51,53) ~ 3,
                绝经年龄>=54~ 4,
              ),
              绝经年龄分组=factor(绝经年龄分组,levels=c(1,2,3,4),labels=c('<48','48-50','51-53','>=54')),
              口服避孕药,
              雌激素代替治疗,
              雌激素影响时间=绝经年龄-初潮年龄
)
pepsinogen2<-pepsinogen%>%filter(残胃!='是',萎缩性胃炎!='是',
                                   胃粘膜不典型增生!='是',胃肠上皮化生!="是",
                                   幽门螺杆菌感染史!='是',消化性溃疡!="是",
                                   ID!=31070517,ID!=31090525)
variables1<-c('家庭收入','教育','婚姻','就业状况','血型')
variables4<-c("饮酒","喝茶",'鲜奶',"酸奶",'咖啡','碳酸饮料','果味饮料','茶味饮料',
              "蔬菜","水果","谷类",'肉类',"鸡蛋",'水产品','薯类',"杂粮","豆类",'坚果','大蒜','菌类',
              '油炸','烧烤','熏制','腌制','酱制','晒制','偏咸','偏辣','偏烫','偏酸','偏甜','偏硬')
variables6<-c("十二指肠溃疡","幽门螺杆菌感染史",'残胃','胃息肉','胃溃疡')
variables7<-c("糖尿病","高血压","高血脂","冠心病")
variables8<-c("运动",'跑步','快走','太极','广场舞','瑜伽','游泳','球类','器械')
variables9<-c('静态时间','手机使用时间','每天早餐','准点吃饭','吃饭速度','外出吃饭')
variables10<-c("初潮年龄分组","绝经年龄分组","绝经","生育","生育次数分组","首次生育年龄分组",      
               "哺乳","哺乳时间分组","流产","人工流产次数","自然流产次数","人工流产","自然流产","绝育手术",          
               "子宫摘除术","卵巢摘除术")
#分层
#a=分层变量；b=因变量；c=自变量
PG_split<-function(a,b,c){
  x1<-pepsinogen[[a]]
  pepsinogen_split<-split(pepsinogen,x1)
  formula_uni<-as.formula(paste(b,'~', c)) 
  d<-lapply(pepsinogen_split, function(x)x%>%group_by(x[[c]])%>%summarise(n=n(),median=median(PG1,na.rm=TRUE),Q1=quantile(PG1,0.25,na.rm=TRUE),Q3=quantile(PG1,0.75,na.rm=TRUE))%>%
              transmute(水平=`x[[c]]`,频数=n,Median=paste0(median,"(",Q1,"-",Q3,")")))
  d1<-do.call(cbind,d)
  names(d1)<-c('水平','男.频数','男.Median','水平','女.频数','女.Median')
  d1<-datatable(d1[,-4])
  e<-lapply(pepsinogen_split,function(x){
    if(length(table(x[,c]))==2){
      wilcox.test(formula_uni,x)
    }else{kruskal.test(formula_uni,x)}
  }
  )
  out<-list(均值比较=print(d1),非参数检验=e)
  return(out)
}
my.render.cat <- function(x) {
  c("", sapply(stats.default(x), function(y) with(y,
                                                  sprintf("%d (%0.2f %%)", FREQ, PCT))))
}
chisq<-function(x,y,data){
  p1<-list()
  p<-list()
  y=data[[y]]
  for(i in x){
    x1<-data[[i]]
    p1[[i]]<-as.data.frame(round(prop.table(table(x1,y),margin = 1)*100,2))
    p[[i]]<-round(chisq.test(table(x1,y))$p.value,3)
  }
  results1<-do.call(rbind,p1)
  results2<-do.call(rbind,p)
  results<-list(freq=results1,p=results2)
  return(results)
}
