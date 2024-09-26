#Must first run PCORI aim 1 file setup.R to get All


#Adding the family survey outcomes
survey <- read.csv('family_survey_for_seneca.csv')
survey$studyid <- survey$fec_study_id
survey <- survey %>% dplyr::select(studyid, is, toc, ecd, pfe, fec)


All <- left_join(All, survey, 'studyid')

#Convert family survey domains into binary, either 1 or <1
All$is[All$is<1] <- 0
All$toc[All$toc<1] <- 0
All$ecd[All$ecd<1] <- 0
All$pfe[All$pfe<1] <- 0

#Convert to factors
All$is <- as.factor(All$is)
All$toc <- as.factor(All$toc)
All$ecd <- as.factor(All$ecd)
All$pfe <- as.factor(All$pfe)


#modeling the timeliness outcomes pre vs post intervention
library(lmerTest)

#Set to factors
All$admitreason <- as.factor(All$admitreason)
All$pmca <- as.factor(All$pmca)

#Create composite ICU transfer/rapid response variable
All$tran_read <- 0
All$tran_read[All$tran_icu==1 | All$rapid_response==1] <- 1

#For log regression, convert 0 min times to 1
All$first_clinical_assessment[All$first_clinical_assessment==0] <- 1

#Make pre-intervention the reference value
All$post[All$drop==0] <- 1
All$post[All$drop==1] <- 0




###Unadjusted models (still including experimental design aspects)###

#Timeliness variables -- gamma regression with log link
fit1un <- glmer(first_clinical_assessment ~ post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data=All, family = Gamma(link = "log"))
summary(fit1un)
fit2un <- glmer(first_labs_imaging ~ post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data=All, family = Gamma(link = "log"))
summary(fit2un)
fit3un <- glmer(first_medication_admin ~ post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data=All, family = Gamma(link = "log"))
summary(fit3un)

#Family experience of care overall mean -- linear regression
fit4un <- lmer(fec ~ post +
               site + arrive_block + arrive_block*site +
               (1 | Practice.group), data=All)
summary(fit4un)

#Family experience of care domains -- logistic regression
fit5un <- glmer(is~post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All, family = "binomial")
exp(coef(fit5un))
exp(confint(fit5un))
fit6un <- glmer(toc~post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All, family = "binomial")
exp(coef(fit6un))
exp(confint(fit6un))
fit7un <- glmer(ecd~post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All, family = "binomial")
exp(coef(fit7un))
exp(confint(fit7un))
fit8un <- glmer(pfe~post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All, family = "binomial")
exp(coef(fit8un))
exp(confint(fit8un))

#Rapid response/ICU transfer -- logistic regression
fit9un <- glmer(tran_read~post +
                site + arrive_block + arrive_block*site +
                (1 | Practice.group), data = All, family = "binomial")
exp(coef(fit9un))
exp(confint(fit9un))



###Fully adjusted models -- hierarchical model with a random effect for practice group###

#Timeliness variables
fit1full <- glmer(first_clinical_assessment ~ post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = Gamma(link = "log"))
summary(fit1full)
fit2full <- glmer(first_labs_imaging ~ post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = Gamma(link = "log"))
summary(fit2full)
fit3full <- glmer(first_medication_admin ~ post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = Gamma(link = "log"))
summary(fit3full)

#Family experience of care overall mean
fit4full <- lmer(fec ~ post + age2 + gender +
                   payer + admitreason + race + pmca + unstable_bp +
                   unstable_hr + unstable_resp + unstable_tp + unstable_o2 +
                   site + arrive_block + arrive_block*site + brief_comp + (1 | Practice.group), data=All)
summary(fit4full)

#Family experience of care domains
fit5full <- glmer(is~post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = 'binomial')
summary(fit5full)
fit6full <- glmer(toc~post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = 'binomial')
summary(fit6full)
fit7full <- glmer(ecd~post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = 'binomial')
summary(fit7full)
fit8full <- glmer(pfe~post + age2 + gender +
                    payer + admitreason + race + pmca + unstable_bp +
                    unstable_hr + unstable_resp + unstable_tp + unstable_o2 + language + brief_comp +
                    site + arrive_block + arrive_block*site +
                    (1 | Practice.group), data=All, family = 'binomial')
summary(fit8full)

#Rapid response/ICU transfer
fit9full <- glmer(tran_read ~ post + age2 + gender +
                    payer + admitreason + race + pmca +
                    site + arrive_block + arrive_block*site + (1 | Practice.group), data=All,
                  family = 'binomial')
summary(fit9full)