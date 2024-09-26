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

#Make ED the reference level and set variables to factor
All_primary$admit_type[All_primary$admit_type==2] <- 0
All_primary$admit_type <- as.factor(All_primary$admit_type)
All_primary$admitreason <- as.factor(All_primary$admitreason)
All_primary$pmca <- as.factor(All_primary$pmca)

#Create composite ICU transfer/rapid response variable
All_primary$tran_read <- 0
All_primary$tran_read[All_primary$tran_icu==1 | All_primary$rapid_response==1] <- 1

#For log regression, convert 0 min times to 1
All_primary$first_clinical_assessment[All_primary$first_clinical_assessment==0] <- 1


###Unadjusted models (still including experimental design aspects)###

#Timeliness variables -- gamma regression with log link
fit1un <- glm(first_clinical_assessment +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group)~ admit_type , data=All_primary, family = Gamma(link = "log"))
summary(fit1un)
fit2un <- glm(first_labs_imaging +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group) ~ admit_type , data=All_primary, family = Gamma(link = "log"))
summary(fit2un)
fit3un <- glm(first_medication_admin +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group) ~ admit_type , data=All_primary, family = Gamma(link = "log"))
summary(fit3un)

#Family experience of care overall mean -- linear regression
fit4un <- lm(fec ~ admit_type +
               site + arrive_block + arrive_block*site +
               (1 | Practice.group), data=All_primary)
summary(fit4un)

#Family experience of care domains -- logistic regression
fit5un <- glm(is~admit_type +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All_primary, family = "binomial")
exp(coef(fit5un))
exp(confint(fit5un))
fit6un <- glm(toc~admit_type +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All_primary, family = "binomial")
exp(coef(fit6un))
exp(confint(fit6un))
fit7un <- glm(ecd~admit_type +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All_primary, family = "binomial")
exp(coef(fit7un))
exp(confint(fit7un))
fit8un <- glm(pfe~admit_type +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All_primary, family = "binomial")
exp(coef(fit8un))
exp(confint(fit8un))

#Rapid response/ICU transfer -- logistic regression
fit9un <- glm(tran_read~admit_type +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All_primary, family = "binomial")
exp(coef(fit9un))
exp(confint(fit9un))



###Fully adjusted models -- hierarchical model with a random effect for practice group###

#Timeliness variables
fit1full <- glmer(first_clinical_assessment ~ admit_type + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit1full)
 fit2full <- glmer(first_labs_imaging ~ admit_type + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit2full)
fit3full <- glmer(first_medication_admin ~ admit_type + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All_primary, family = Gamma(link = "log"))
summary(fit3full)

#Family experience of care overall mean
fit4full <- lmer(fec ~ admit_type + age2 + gender +
                     payer + admitreason + race + pmca + unstable_bp +
                     unstable_hr + unstable_resp + unstable_tp + unstable_o2 +
                     site + arrive_block + arrive_block*site + brief_comp + (1 | Practice.group), data=All_primary)
summary(fit4full)

#Family experience of care domains
fit5full <- glmer(is~admit_type + age2 + gender +
                   payer + admitreason + race + pmca + unstable_bp +
                   unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                   site + arrive_block + arrive_block*site +
                   (1 | Practice.group), data=All_primary, family = 'binomial')
summary(fit5full)
fit6full <- glmer(toc~admit_type + age2 + gender +
                   payer + admitreason + race + pmca + unstable_bp +
                   unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                   site + arrive_block + arrive_block*site +
                   (1 | Practice.group), data=All_primary, family = 'binomial')
summary(fit6full)
fit7full <- glmer(ecd~admit_type + age2 + gender +
                   payer + admitreason + race + pmca + unstable_bp +
                   unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                   site + arrive_block + arrive_block*site +
                   (1 | Practice.group), data=All_primary, family = 'binomial')
summary(fit7full)
fit8full <- glmer(pfe~admit_type + age2 + gender +
                   payer + admitreason + race + pmca + unstable_bp +
                   unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                   site + arrive_block + arrive_block*site +
                   (1 | Practice.group), data=All_primary, family = 'binomial')
summary(fit8full)

#Rapid response/ICU transfer
fit9full <- glmer(tran_read ~ admit_type + age2 + gender +
                    payer + admitreason + race + pmca +
                    site + arrive_block + arrive_block*site + (1 | Practice.group), data=All_primary,
                 family = 'binomial')
summary(fit9full)
