#Must first run PCORI aim 1 file setup.R to get All_primary


#Adding the family survey outcomes
survey <- read.csv('family_survey_for_seneca.csv')
survey$studyid <- survey$fec_study_id
survey <- survey %>% dplyr::select(studyid, is, toc, ecd, pfe, fec)


All_primary <- left_join(All_primary, survey, 'studyid')

#Convert family survey domains into binary, either 1 or <1
All_primary$is[All_primary$is<1] <- 0
All_primary$toc[All_primary$toc<1] <- 0
All_primary$ecd[All_primary$ecd<1] <- 0
All_primary$pfe[All_primary$pfe<1] <- 0

#Convert to factors
All_primary$is <- as.factor(All_primary$is)
All_primary$toc <- as.factor(All_primary$toc)
All_primary$ecd <- as.factor(All_primary$ecd)
All_primary$pfe <- as.factor(All_primary$pfe)


#modeling the timeliness outcomes DA vs ED
library(lmerTest)

#Set ED to reference value and set certain numeric variables to factors
All_primary$admit_type[All_primary$admit_type==2] <- 0
All_primary$admit_type <- as.factor(All_primary$admit_type)
All_primary$admitreason <- as.factor(All_primary$admitreason)
All_primary$pmca <- as.factor(All_primary$pmca)

#Create composite ICU transfer/rapid response variable
All_primary$tran_read <- 0
All_primary$tran_read[All_primary$tran_icu==1 | All_primary$rapid_response==1] <- 1

#For log regression, convert 0 min times to 1
All_primary$first_clinical_assessment[All_primary$first_clinical_assessment==0] <- 1


#Create dummy-coded variable to handle interaction between admit type and admission diagnosis
All_primary$D1[All_primary$admit_type=='0' & All_primary$admitreason2=='0'] <- 0
All_primary$D1[All_primary$admit_type=='1' & All_primary$admitreason2=='0'] <- 1
All_primary$D1[All_primary$admit_type=='0' & All_primary$admitreason2=='1'] <- 2
All_primary$D1[All_primary$admit_type=='1' & All_primary$admitreason2=='1'] <- 3
All_primary$D1[All_primary$admit_type=='0' & All_primary$admitreason2=='4'] <- 4
All_primary$D1[All_primary$admit_type=='1' & All_primary$admitreason2=='4'] <- 5
All_primary$D1 <- as.factor(All_primary$D1)

#Create dummy-coded variable to handle interaction between admit type and medical complexity
All_primary$D2[All_primary$admit_type=='0' & All_primary$pmca2=='1'] <- 0
All_primary$D2[All_primary$admit_type=='1' & All_primary$pmca2=='1'] <- 1
All_primary$D2[All_primary$admit_type=='0' & All_primary$pmca2=='3'] <- 2
All_primary$D2[All_primary$admit_type=='1' & All_primary$pmca2=='3'] <- 3
All_primary$D2 <- as.factor(All_primary$D2)



###Admit diagnosis Models###
fit1ad <- glmer(first_clinical_assessment ~ D1 + age2 + gender +
                    payer + race + pmca + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit1ad)
vcov(fit1ad)
fit2ad <- glmer(first_labs_imaging ~ D1 + age2 + gender +
                    payer + race + pmca + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit2ad)
vcov(fit2ad)
fit3ad <- glmer(first_medication_admin ~ D1 + age2 + gender +
                    payer + race + pmca + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit3ad)
vcov(fit3ad)


###PMCA models###
fit1p <- glmer(first_clinical_assessment ~ D2 + age2 + gender +
                    payer + admitreason + race + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit1p)
vcov(fit1p)
fit2p <- glmer(first_labs_imaging ~ D2 + age2 + gender +
                    payer + admitreason + race + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit2p)
vcov(fit2p)
fit3p <- glmer(first_medication_admin ~ D2 + age2 + gender +
                    payer + admitreason + race + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit3p)
vcov(fit3p)



#For medians and IQRs
tapply(All_primary$first_clinical_assessment, All_primary$D1, summary)
tapply(All_primary$first_labs_imaging, All_primary$D1, summary)
tapply(All_primary$first_medication_admin, All_primary$D1, summary)

tapply(All_primary$first_clinical_assessment, All_primary$D2, summary)
tapply(All_primary$first_labs_imaging, All_primary$D2, summary)
tapply(All_primary$first_medication_admin, All_primary$D2, summary)


