#Must first run PCORI aim 1 file setup.R to get All and All_primary

###################################################################
###################################################################
##############Only including those after DA training###############
###################################################################
###################################################################
####Table 1####
#totals
table(All_primary$admit_type)
#age
summary(All_primary$age)
tapply(All_primary$age, All_primary$admit_type, summary)
t.test(All_primary$age~All_primary$admit_type)
#gender
table(All_primary$gender)
prop.table(table(All_primary$gender))
table(All_primary$gender, All_primary$admit_type)
prop.table(table(All_primary$gender, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$gender, All_primary$admit_type))
#payer
table(All_primary$payer)
prop.table(table(All_primary$payer))
table(All_primary$payer, All_primary$admit_type)
prop.table(table(All_primary$payer, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$payer, All_primary$admit_type))
#admitting diagnosis
table(All_primary$admitreason)
prop.table(table(All_primary$admitreason))
table(All_primary$admitreason, All_primary$admit_type)
prop.table(table(All_primary$admitreason, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$admitreason, All_primary$admit_type))
#race
table(All_primary$race)
prop.table(table(All_primary$race))
table(All_primary$race, All_primary$admit_type)
prop.table(table(All_primary$race, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$race, All_primary$admit_type))
#Language
table(All_primary$language)
prop.table(table(All_primary$language))
table(All_primary$language, All_primary$admit_type)
prop.table(table(All_primary$language, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$language, All_primary$admit_type))
#Chronic conditions
table(All_primary$pmca)
prop.table(table(All_primary$pmca))
table(All_primary$pmca, All_primary$admit_type)
prop.table(table(All_primary$pmca, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$pmca, All_primary$admit_type))
#Vital HR
table(All_primary$unstable_hr)
prop.table(table(All_primary$unstable_hr))
table(All_primary$unstable_hr, All_primary$admit_type)
prop.table(table(All_primary$unstable_hr, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$unstable_hr, All_primary$admit_type))
#Vital RR
table(All_primary$unstable_resp)
prop.table(table(All_primary$unstable_resp))
table(All_primary$unstable_resp, All_primary$admit_type)
prop.table(table(All_primary$unstable_resp, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$unstable_resp, All_primary$admit_type))
#Vital o2
table(All_primary$unstable_o2)
prop.table(table(All_primary$unstable_o2))
table(All_primary$unstable_o2, All_primary$admit_type)
prop.table(table(All_primary$unstable_o2, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$unstable_o2, All_primary$admit_type))
#Vital BP
table(All_primary$unstable_bp)
prop.table(table(All_primary$unstable_bp))
table(All_primary$unstable_bp, All_primary$admit_type)
prop.table(table(All_primary$unstable_bp, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$unstable_bp, All_primary$admit_type))
#Vital temp
table(All_primary$unstable_tp)
prop.table(table(All_primary$unstable_tp))
table(All_primary$unstable_tp, All_primary$admit_type)
prop.table(table(All_primary$unstable_tp, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$unstable_tp, All_primary$admit_type))
#brief color
table(All_primary$abnormal_color)
prop.table(table(All_primary$abnormal_color))
table(All_primary$abnormal_color, All_primary$admit_type)
prop.table(table(All_primary$abnormal_color, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$abnormal_color, All_primary$admit_type))
#brief behavior
table(All_primary$abnormal_behav)
prop.table(table(All_primary$abnormal_behav))
table(All_primary$abnormal_behav, All_primary$admit_type)
prop.table(table(All_primary$abnormal_behav, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$abnormal_behav, All_primary$admit_type))
#brief cap
table(All_primary$abnormal_cap)
prop.table(table(All_primary$abnormal_cap))
table(All_primary$abnormal_cap, All_primary$admit_type)
prop.table(table(All_primary$abnormal_cap, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$abnormal_cap, All_primary$admit_type))
#brief composite
All_primary$brief_comp <- 0
All_primary$brief_comp[All_primary$abnormal_behav+All_primary$abnormal_cap+All_primary$abnormal_color>0] <- 1
table(All_primary$brief_comp)
prop.table(table(All_primary$brief_comp))
table(All_primary$brief_comp, All_primary$admit_type)
prop.table(table(All_primary$brief_comp, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$brief_comp, All_primary$admit_type))

#Hospital
table(All_primary$site)
prop.table(table(All_primary$site))
table(All_primary$site, All_primary$admit_type)
prop.table(table(All_primary$site, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$site, All_primary$admit_type))

#Time block
table(All_primary$arrive_block)
prop.table(table(All_primary$arrive_block))
table(All_primary$arrive_block, All_primary$admit_type)
prop.table(table(All_primary$arrive_block, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$arrive_block, All_primary$admit_type))


###Table 2###
#first clinical assessment
summary(All_primary$first_clinical_assessment)
sd(All_primary$first_clinical_assessment, na.rm = T)
tapply(All_primary$first_clinical_assessment, All_primary$admit_type, summary)
tapply(All_primary$first_clinical_assessment, All_primary$admit_type, sd, na.rm=T)
t.test(All_primary$first_clinical_assessment~All_primary$admit_type)
kruskal.test(All_primary$first_clinical_assessment~All_primary$admit_type)
#initial clinical management
summary(All_primary$first_clinical_management)
sd(All_primary$first_clinical_management, na.rm = T)
tapply(All_primary$first_clinical_management, All_primary$admit_type, summary)
tapply(All_primary$first_clinical_management, All_primary$admit_type, sd, na.rm = T)
t.test(All_primary$first_clinical_management~All_primary$admit_type)
kruskal.test(All_primary$first_clinical_management~All_primary$admit_type)
#time to initial diagnostic testing
summary(All_primary$first_labs_imaging)
sd(All_primary$first_labs_imaging, na.rm = T)
tapply(All_primary$first_labs_imaging, All_primary$admit_type, summary)
tapply(All_primary$first_labs_imaging, All_primary$admit_type, sd, na.rm = T)
t.test(All_primary$first_labs_imaging~All_primary$admit_type)
kruskal.test(All_primary$first_labs_imaging~All_primary$admit_type)
#First medication admin
summary(All_primary$first_medication_admin)
sd(All_primary$first_medication_admin, na.rm = T)
tapply(All_primary$first_medication_admin, All_primary$admit_type, summary)
tapply(All_primary$first_medication_admin, All_primary$admit_type, sd, na.rm = T)
t.test(All_primary$first_medication_admin~All_primary$admit_type)
kruskal.test(All_primary$first_medication_admin~All_primary$admit_type)

#Rapid response
table(All_primary$rapid_response)
prop.table(table(All_primary$rapid_response))
table(All_primary$rapid_response, All_primary$admit_type)
prop.table(table(All_primary$rapid_response, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$rapid_response, All_primary$admit_type))

#ICU Transfer
table(All_primary$tran_icu)
prop.table(table(All_primary$tran_icu))
table(All_primary$tran_icu, All_primary$admit_type)
prop.table(table(All_primary$tran_icu, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$tran_icu, All_primary$admit_type))

#composite
All_primary$comp_rapid <- 0
All_primary$comp_rapid[All_primary$rapid_response+All_primary$tran_icu>0] <- 1
table(All_primary$comp_rapid)
prop.table(table(All_primary$comp_rapid))
table(All_primary$comp_rapid, All_primary$admit_type)
prop.table(table(All_primary$comp_rapid, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$comp_rapid, All_primary$admit_type))

#LOS
summary(All_primary$los)
sd(All_primary$los, na.rm = T)
tapply(All_primary$los, All_primary$admit_type, summary)
tapply(All_primary$los, All_primary$admit_type, sd, na.rm = T)
t.test(All_primary$los~All_primary$admit_type)
kruskal.test(All_primary$los~All_primary$admit_type)

#Short LOS
table(All_primary$shortlos)
prop.table(table(All_primary$shortlos))
table(All_primary$shortlos, All_primary$drop)
prop.table(table(All_primary$shortlos, All_primary$drop), margin=2)
chisq.test(table(All_primary$shortlos, All_primary$drop))

#Number of tests
summary(All_primary$numtests)
sd(All_primary$numtests)
tapply(All_primary$numtests, All_primary$drop, summary)
tapply(All_primary$numtests, All_primary$drop, sd)
t.test(All_primary$numtests~All_primary$drop)
kruskal.test(All_primary$numtests~All_primary$drop)

#Multiple labs
table(All_primary$multilab)
prop.table(table(All_primary$multilab))
table(All_primary$multilab, All_primary$drop)
prop.table(table(All_primary$multilab, All_primary$drop), margin=2)
chisq.test(table(All_primary$multilab, All_primary$drop))

#Readmission
table(All_primary$readmission)
prop.table(table(All_primary$readmission))
table(All_primary$readmission, All_primary$admit_type)
prop.table(table(All_primary$readmission, All_primary$admit_type), margin=2)
chisq.test(table(All_primary$readmission, All_primary$admit_type))



###################################################################
###################################################################
################Full cohort analysis (supplemental)################
###################################################################
###################################################################
####Table 1####
#totals
table(All$post)
#age
summary(All$age)
tapply(All$age, All$post, summary)
t.test(All$age~All$post)
#gender
table(All$gender)
table(All$gender, All$post)
prop.table(table(All$gender, All$post), margin=2)
chisq.test(table(All$gender, All$post))
#payer
table(All$payer)
table(All$payer, All$post)
prop.table(table(All$payer, All$post), margin=2)
chisq.test(table(All$payer, All$post))
#admitting diagnosis
table(All$admitreason)
prop.table(table(All$admitreason))
table(All$admitreason, All$post)
prop.table(table(All$admitreason, All$post), margin=2)
chisq.test(table(All$admitreason, All$post))
#race
table(All$race)
prop.table(table(All$race))
table(All$race, All$post)
prop.table(table(All$race, All$post), margin=2)
chisq.test(table(All$race, All$post))
#Language
table(All$language)
prop.table(table(All$language))
table(All$language, All$post)
prop.table(table(All$language, All$post), margin=2)
chisq.test(table(All$language, All$post))
#Chronic conditions
table(All$pmca)
prop.table(table(All$pmca))
table(All$pmca, All$post)
prop.table(table(All$pmca, All$post), margin=2)
chisq.test(table(All$pmca, All$post))
#Vital HR
table(All$unstable_hr)
prop.table(table(All$unstable_hr))
table(All$unstable_hr, All$post)
prop.table(table(All$unstable_hr, All$post), margin=2)
chisq.test(table(All$unstable_hr, All$post))
#Vital RR
table(All$unstable_resp)
prop.table(table(All$unstable_resp))
table(All$unstable_resp, All$post)
prop.table(table(All$unstable_resp, All$post), margin=2)
chisq.test(table(All$unstable_resp, All$post))
#Vital o2
table(All$unstable_o2)
prop.table(table(All$unstable_o2))
table(All$unstable_o2, All$post)
prop.table(table(All$unstable_o2, All$post), margin=2)
chisq.test(table(All$unstable_o2, All$post))
#Vital BP
table(All$unstable_bp)
prop.table(table(All$unstable_bp))
table(All$unstable_bp, All$post)
prop.table(table(All$unstable_bp, All$post), margin=2)
chisq.test(table(All$unstable_bp, All$post))
#Vital temp
table(All$unstable_tp)
prop.table(table(All$unstable_tp))
table(All$unstable_tp, All$post)
prop.table(table(All$unstable_tp, All$post), margin=2)
chisq.test(table(All$unstable_tp, All$post))
#Hospital
table(All$site)
prop.table(table(All$site))
table(All$site, All$post)
prop.table(table(All$site, All$post), margin=2)
chisq.test(table(All$site, All$post))


###Table 2###
#first clinical assessment
summary(All$first_clinical_assessment)
sd(All$first_clinical_assessment, na.rm = T)
tapply(All$first_clinical_assessment, All$post, summary)
tapply(All$first_clinical_assessment, All$post, sd, na.rm=T)
t.test(All$first_clinical_assessment~All$post)
#initial clinical management
summary(All$first_clinical_management)
sd(All$first_clinical_management, na.rm = T)
tapply(All$first_clinical_management, All$post, summary)
tapply(All$first_clinical_management, All$post, sd, na.rm = T)
t.test(All$first_clinical_management~All$post)
#time to initial diagnostic testing
summary(All$first_labs_imaging)
sd(All$first_labs_imaging, na.rm = T)
tapply(All$first_labs_imaging, All$post, summary)
tapply(All$first_labs_imaging, All$post, sd, na.rm = T)
t.test(All$first_labs_imaging~All$post)
#First medication admin
summary(All$first_medication_admin)
sd(All$first_medication_admin, na.rm = T)
tapply(All$first_medication_admin, All$post, summary)
tapply(All$first_medication_admin, All$post, sd, na.rm = T)
t.test(All$first_medication_admin~All$post)

#Rapid response
table(All$rapid_response)
table(All$rapid_response, All$post)
prop.table(table(All$rapid_response, All$post), margin=2)
chisq.test(table(All$rapid_response, All$post))

#ICU Transfer
table(All$tran_icu)
table(All$tran_icu, All$post)
prop.table(table(All$tran_icu, All$post), margin=2)
chisq.test(table(All$tran_icu, All$post))

#LOS
summary(All$los)
sd(All$los, na.rm = T)
tapply(All$los, All$post, summary)
tapply(All$los, All$post, sd, na.rm = T)
t.test(All$los~All$post)

#Short LOS
table(All$shortlos)
prop.table(table(All$shortlos))
table(All$shortlos, All$drop)
prop.table(table(All$shortlos, All$drop), margin=2)
chisq.test(table(All$shortlos, All$drop))

#Number of tests
summary(All$numtests)
sd(All$numtests)
tapply(All$numtests, All$drop, summary)
tapply(All$numtests, All$drop, sd)
t.test(All$numtests~All$drop)
kruskal.test(All$numtests~All$drop)

#Multiple labs
table(All$multilab)
prop.table(table(All$multilab))
table(All$multilab, All$drop)
prop.table(table(All$multilab, All$drop), margin=2)
chisq.test(table(All$multilab, All$drop))

#Readmission
table(All$readmission)
table(All$readmission, All$post)
prop.table(table(All$readmission, All$post), margin=2)
chisq.test(table(All$readmission, All$post))
