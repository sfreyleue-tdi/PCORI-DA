library(readxl)
library(dplyr)


#Create eligibility file
elig_nch <- read_excel('38_Master_List of Eligible Study IDs_4-30-23_FINAL.xlsx', sheet=1)
elig_nch <- elig_nch[,1:3]
elig_nch$site <- 'NCH'
elig_chp <- read_excel('38_Master_List of Eligible Study IDs_4-30-23_FINAL.xlsx', sheet=2)
elig_chp <- elig_chp[,1:3]
elig_chp$site <- 'CHP'
elig_prmc <- read_excel('38_Master_List of Eligible Study IDs_4-30-23_FINAL.xlsx', sheet=3)
elig_prmc <- elig_prmc[,1:3]
elig_prmc$site <- 'PRMC'
elig3 <- rbind(elig_nch, elig_chp, elig_prmc)
elig3$studyid <- elig3$`Study ID`
elig3 <- elig3[elig3$'PCORI Eligible'=='Yes',]

#These IDs were originally considered eligible, but have since been deemed ineligibile
elig3 <- elig3[!(elig3$studyid %in% c(3111, 3115, 3242, 3270, 3273, 3391, 3581,1040,1055,1065,1093,1296,1327,1410,1451,1465,1835,1509)),]


###########NCH##############
#Read in NCH file  
NCH <- read.csv('41_PCORIProjectNCH_DATA_2023-07-28.csv')
colnames(NCH)[1] <- 'record_id'
#drop bad rows
NCH <- NCH[!(substr(NCH$record_id,5,5) == 'B' | substr(NCH$record_id,5,5) == 'b' |
               substr(NCH$record_id,5,5) == 'C'),]

#Fix typos in manual study ID
NCH <- NCH[!(NCH$manual_study_id_nch %in% c('898','885')),]
NCH$manual_study_id_nch[NCH$record_id=='0419'] <- '0419'
NCH$manual_study_id_nch[NCH$record_id=='4173'] <- '4173'
NCH$manual_study_id_nch[NCH$record_id=='4115'] <- '4115'
NCH$manual_study_id_nch[NCH$record_id=='4141'] <- '4141'
NCH$manual_study_id_nch[NCH$record_id=='4634'] <- '4634'
NCH$manual_study_id_nch[NCH$record_id=='4428'] <- '4428'
NCH$manual_study_id_nch[NCH$record_id=='4440'] <- '4440'
NCH$manual_study_id_nch[NCH$record_id=='4662'] <- '4662'
NCH$manual_study_id_nch[NCH$record_id=='4695'] <- '4695'

#There are multiple versions of some IDs that need to be removed for incompleteness
NCH$record_id[substr(NCH$record_id,5,5)==' '] <- substr(NCH$record_id,1,4)[substr(NCH$record_id,5,5)==' ']
NCH$order <- case_when(substr(NCH$record_id,5,5) == 'F'~2,
                       substr(NCH$record_id,5,5) == ''~1,
                       substr(NCH$record_id,5,5) == '-'~0,
                       substr(NCH$record_id,4,4) == '-'~0)

orders <- NCH %>% group_by(manual_study_id_nch) %>% summarise(maxorder=max(order))
NCH <- left_join(NCH, orders, "manual_study_id_nch")
NCH <- NCH[!(NCH$maxorder > NCH$order | NCH$manual_study_id_nch == '1153-2'),]
NCH$studyid <- as.numeric(as.character(NCH$manual_study_id_nch))

#inner_join only keeps studyids that appear in both datasets
NCH <- inner_join(NCH, elig3, by = 'studyid')


#fixing incorrect care times
NCH$vitals_time_nch[NCH$studyid==4174] <- '2022-09-25 18:38'
NCH$time_arrival_ed_nch[NCH$studyid==177] <- '2021-11-11 19:49'
NCH$first_other_tx_ed_nch[NCH$studyid==177] <- NA
NCH$time_arrival_ed_nch[NCH$studyid==384] <- "2021-02-21 17:20"
NCH$vitals_time_ed_nch[NCH$studyid==384] <- "2021-02-21 18:08"
NCH$time_arrival_ed_nch[NCH$studyid==688] <- "2022-03-24 19:16"
NCH$vitals_time_ed_nch[NCH$studyid==688] <- "2022-03-24 19:24"
NCH$vitals_time_ed_nch[NCH$studyid==862] <- "2022-05-23 21:25"
NCH$vitals_time_ed_nch[NCH$studyid==999] <- "2022-07-16 18:43"
NCH$vitals_time_ed_nch[NCH$studyid==1329] <- "2020-10-04 14:38"
NCH$time_arrival_ed_nch[NCH$studyid==1337] <- "2020-10-12 19:20"
NCH$vitals_time_ed_nch[NCH$studyid==1337] <- NA
NCH$brief_time_ed_nch[NCH$studyid==1337] <- "2020-10-12 19:21"
NCH$first_lab_ed_nch[NCH$studyid==1337] <- NA
NCH$vitals_time_nch[NCH$studyid==4247] <- "2022-10-23 19:03"
NCH$time_arrival_admitting_nch[NCH$studyid==4247] <- "2022-10-23 19:03"
NCH$time_arrival_ed_nch[NCH$studyid==4406] <- "2023-01-05 18:14"
NCH$time_arrival_admitting_nch[NCH$studyid==329] <- "2021-11-20 21:00"
NCH$vitals_time_nch[NCH$studyid==329] <- "2021-11-20 21:00"
NCH$second_lab_ed_nch[NCH$studyid==57] <- "2021-09-25 12:31"
NCH$second_lab_ed_nch[NCH$studyid==1862] <- "2021-07-18 22:29"
NCH$first_antibiotics_nch[NCH$studyid==650] <- "2022-03-14 20:46"
NCH$vitals_time_ed_nch[NCH$studyid==859] <- "2022-05-22 19:12"
NCH$vitals_time_ed_nch[NCH$studyid==898] <- '2022-06-05 18:06'
NCH$vitals_time_ed_nch[NCH$studyid==899] <- '2022-06-05 16:20'
NCH$vitals_time_ed_nch[NCH$studyid==903] <- '2022-06-06 18:38'
NCH$vitals_time_ed_nch[NCH$studyid==939] <- '2022-06-20 18:51'
NCH$vitals_time_ed_nch[NCH$studyid==1694] <- '2021-05-08 16:06'
NCH$vitals_time_ed_nch[NCH$studyid==1701] <- '2021-05-14 22:16'
NCH$dob_nch[NCH$studyid==1869] <- "2021-06-11"

#Working with Dates
NCH$dob_nch[NCH$studyid==967] <- "2019-10-16"
NCH$dob_nch[NCH$studyid==1869] <- "2021-06-11"#These birth dates were incorrectly labelled


#####Convert All empty vars into NAs -- necessary to work with POSIXct#####
NCH$time_arrival_ed_nch[(NCH$time_arrival_ed_nch == '')] <- NA
NCH$time_first_assess_ed_nch[(NCH$time_first_assess_ed_nch == '')] <- NA
NCH$brief_time_ed_nch[(NCH$brief_time_ed_nch == '')] <- NA
NCH$vitals_time_ed_nch[(NCH$vitals_time_ed_nch == '')] <- NA
NCH$first_lab_ed_nch[(NCH$first_lab_ed_nch == '')] <- NA
NCH$first_imaging_ed_nch[(NCH$first_imaging_ed_nch == '')] <- NA
NCH$first_pain_meds_ed_nch[(NCH$first_pain_meds_ed_nch == '')] <- NA
NCH$first_antibiotics_ed_nch[(NCH$first_antibiotics_ed_nch == '')] <- NA
NCH$first_other_tx_ed_nch[(NCH$first_other_tx_ed_nch == '')] <- NA
NCH$first_popg_fluids_ed_nch[(NCH$first_popg_fluids_ed_nch == '')] <- NA
NCH$first_iv_fluids_ed_nch[(NCH$first_iv_fluids_ed_nch == '')] <- NA
NCH$second_lab_ed_nch[(NCH$second_lab_ed_nch=='')] <- NA
NCH$time_arrival_unit_ed_nch[(NCH$time_arrival_unit_ed_nch=='')] <- NA

NCH$time_arrival_admitting_nch[(NCH$time_arrival_admitting_nch == '')] <- NA
NCH$brief_time_nch[(NCH$brief_time_nch == '')] <- NA
NCH$vitals_time_nch[(NCH$vitals_time_nch == '')] <- NA
NCH$first_lab_nch[(NCH$first_lab_nch == '')] <- NA
NCH$first_imaging_nch[(NCH$first_imaging_nch == '')] <- NA
NCH$first_pain_meds_nch[(NCH$first_pain_meds_nch == '')] <- NA
NCH$first_antibiotics_nch[(NCH$first_antibiotics_nch == '')] <- NA
NCH$first_other_tx_nch[(NCH$first_other_tx_nch == '')] <- NA
NCH$first_popg_fluids_nch[(NCH$first_popg_fluids_nch == '')] <- NA
NCH$first_iv_fluids_nch[(NCH$first_iv_fluids_nch == '')] <- NA
NCH$second_lab_nch[(NCH$second_lab_nch=='')] <- NA
NCH$time_arrival_unit_nch[(NCH$time_arrival_unit_nch=='')] <- NA



###Create Numeric Versions of Datetimes###
#first convert string to POSIXct date object. Then convert that to numeric
NCH$time_arrival_ed <- as.numeric(as.POSIXct(NCH$time_arrival_ed_nch))
NCH$time_first_assessed_ed <- as.numeric(as.POSIXct(NCH$time_first_assess_ed_nch))
NCH$brief_time_ed <- as.numeric(as.POSIXct(NCH$brief_time_ed_nch))
NCH$vitals_time_ed <- as.numeric(as.POSIXct(NCH$vitals_time_ed_nch))
NCH$first_lab_ed <- as.numeric(as.POSIXct(NCH$first_lab_ed_nch))
NCH$first_imaging_ed <- as.numeric(as.POSIXct(NCH$first_imaging_ed_nch))
NCH$first_pain_meds_ed <- as.numeric(as.POSIXct(NCH$first_pain_meds_ed_nch))
NCH$first_antibiotics_ed <- as.numeric(as.POSIXct(NCH$first_antibiotics_ed_nch))
NCH$first_other_tx_ed <- as.numeric(as.POSIXct(NCH$first_other_tx_ed_nch))
NCH$first_popg_fluids_ed <- as.numeric(as.POSIXct(NCH$first_popg_fluids_ed_nch))
NCH$first_iv_fluids_ed <- as.numeric(as.POSIXct(NCH$first_iv_fluids_ed_nch))
NCH$second_lab_ed <- as.numeric(as.POSIXct(NCH$second_lab_ed_nch))
NCH$time_arrival_unit_ed <- as.numeric(as.POSIXct(NCH$time_arrival_unit_ed_nch))

NCH$time_arrival_admitting <- as.numeric(as.POSIXct(NCH$time_arrival_admitting_nch))
NCH$brief_time_da <- as.numeric(as.POSIXct(NCH$brief_time_nch))
NCH$vitals_time_da <- as.numeric(as.POSIXct(NCH$vitals_time_nch))
NCH$first_lab_da <- as.numeric(as.POSIXct(NCH$first_lab_nch))
NCH$first_imaging_da <- as.numeric(as.POSIXct(NCH$first_imaging_nch))
NCH$first_pain_meds_da <- as.numeric(as.POSIXct(NCH$first_pain_meds_nch))
NCH$first_antibiotics_da <- as.numeric(as.POSIXct(NCH$first_antibiotics_nch))
NCH$first_other_tx_da <- as.numeric(as.POSIXct(NCH$first_other_tx_nch))
NCH$first_popg_fluids_da <- as.numeric(as.POSIXct(NCH$first_popg_fluids_nch))
NCH$first_iv_fluids_da <- as.numeric(as.POSIXct(NCH$first_iv_fluids_nch))
NCH$second_lab_da <- as.numeric(as.POSIXct(NCH$second_lab_nch))
NCH$time_arrival_unit <- as.numeric(as.POSIXct(NCH$time_arrival_unit_nch))



##Turning first med admin times to missing when only given NSAIDs
NCH$pain_meds_nsaid_ed <- 0
NCH$pain_meds_nsaid_ed[(NCH$pain_meds_ed_nch___2==1 | NCH$pain_meds_ed_nch___3==1) &
                         NCH$pain_meds_ed_nch___4==0 & NCH$pain_meds_ed_nch___5==0 &
                         NCH$pain_meds_ed_nch___6==0 & NCH$pain_meds_ed_nch___7==0] <- 1
NCH$pain_meds_nsaid_da <- 0
NCH$pain_meds_nsaid_da[(NCH$pain_meds_nch___2==1 | NCH$pain_meds_nch___3==1) &
                         NCH$pain_meds_nch___4==0 & NCH$pain_meds_nch___5==0 &
                         NCH$pain_meds_nch___6==0 & NCH$pain_meds_nch___7==0] <- 1


NCH$first_pain_meds_ed2 <- NCH$first_pain_meds_ed
NCH$first_pain_meds_ed2[NCH$pain_meds_nsaid_ed==1] <- NA
NCH$first_pain_meds_da2 <- NCH$first_pain_meds_da
NCH$first_pain_meds_da2[NCH$pain_meds_nsaid_da==1] <- NA

##Now pain meds and lidocane
NCH$painlid_da <- 0
NCH$painlid_da[NCH$pain_meds_other_nch=='lidocaine' & NCH$pain_meds_nch___2==0 & NCH$pain_meds_nch___3==0 & NCH$pain_meds_nch___4==0 &
                 NCH$pain_meds_nch___5==0 & NCH$pain_meds_nch___6==0] <- 1
NCH$first_pain_meds_da2[NCH$painlid_da==1] <- NA

###Create Time Vars###

#Loop through each row in the dataset and find the first care time. Looop is necessary because of the min function
#NCH$admit_type[i] is the admit type of the ith row. admit_type==1 meand DA, admit_type==2 means ED
for(i in 1:nrow(NCH)){
  if(NCH$admit_type[i]==2){
    NCH$first_clinical_assessment[i] <- (min(NCH$vitals_time_ed[i])-NCH$time_arrival_ed[i])/60
    NCH$first_brief[i] <- (NCH$brief_time_ed[i]-NCH$time_arrival_ed[i])/60
    NCH$first_labs_imaging[i] <- (min(NCH$first_lab_ed[i],NCH$first_lab_da[i],NCH$first_imaging_da[i],NCH$first_imaging_ed[i], na.rm=T)-NCH$time_arrival_ed[i])/60
    NCH$first_pain_meds[i] <- (min(NCH$first_pain_meds_da2[i], NCH$first_pain_meds_ed2[i], na.rm=T)-NCH$time_arrival_ed[i])/60
    NCH$first_antibiotics[i] <- (min(NCH$first_antibiotics_da[i], NCH$first_antibiotics_ed[i], na.rm=T)-NCH$time_arrival_ed[i])/60
    NCH$first_other_tx[i] <- (min(NCH$first_other_tx_da[i], NCH$first_other_tx_ed[i], na.rm=T)-NCH$time_arrival_ed[i])/60
    NCH$first_popg_fluids[i] <- (min(NCH$first_popg_fluids_da[i], NCH$first_popg_fluids_ed[i], na.rm=T)-NCH$time_arrival_ed[i])/60
    NCH$first_iv_fluids[i] <- (min(NCH$first_iv_fluids_da[i], NCH$first_iv_fluids_ed[i], na.rm=T)-NCH$time_arrival_ed[i])/60
    NCH$second_lab[i] <- (NCH$second_lab_ed[i]-NCH$time_arrival_ed[i])/60

  }
  else{
    NCH$first_clinical_assessment[i] <- (min(NCH$vitals_time_da[i] , na.rm=T) - NCH$time_arrival_admitting[i])/60
    NCH$first_brief[i] <- (NCH$brief_time_da[i]-NCH$time_arrival_admitting[i])/60
    NCH$first_labs_imaging[i] <- (min(NCH$first_imaging_da[i],NCH$first_lab_da[i], na.rm=T)-NCH$time_arrival_admitting[i])/60
    NCH$first_pain_meds[i] <- (NCH$first_pain_meds_da2[i]-NCH$time_arrival_admitting[i])/60
    NCH$first_antibiotics[i] <- (NCH$first_antibiotics_da[i]-NCH$time_arrival_admitting[i])/60
    NCH$first_other_tx[i] <- (NCH$first_other_tx_da[i]-NCH$time_arrival_admitting[i])/60
    NCH$first_popg_fluids[i] <- (NCH$first_popg_fluids_da[i]-NCH$time_arrival_admitting[i])/60
    NCH$first_iv_fluids[i] <- (NCH$first_iv_fluids_da[i]-NCH$time_arrival_admitting[i])/60
    NCH$second_lab[i] <- (NCH$second_lab_da[i]-NCH$time_arrival_admitting[i])/60
    NCH$first_management_from_unit[i] <- (min(NCH$first_lab_da[i], NCH$first_imaging_da[i], NCH$first_pain_meds_da[i],
                                              NCH$first_antibiotics_da[i], NCH$first_other_tx_da[i], NCH$first_popg_fluids_da[i],
                                              NCH$first_iv_fluids_da[i], na.rm=T)-NCH$time_arrival_admitting[i])/60
  }
  NCH$first_medication_admin[i] <- min(NCH$first_pain_meds[i],NCH$first_antibiotics[i],
                                       NCH$first_other_tx[i],NCH$first_popg_fluids[i],
                                       NCH$first_iv_fluids[i], na.rm=T)

}



#convert inf to NA
NCH$first_clinical_assessment[is.infinite(NCH$first_clinical_assessment)] <- NA
NCH$first_clinical_management[is.infinite(NCH$first_clinical_management)] <- NA
NCH$first_labs_imaging[is.infinite(NCH$first_labs_imaging)] <- NA
NCH$first_labs_imaging2[is.infinite(NCH$first_labs_imaging2)] <- NA
NCH$first_pain_meds[is.infinite(NCH$first_pain_meds)] <- NA
NCH$first_antibiotics[is.infinite(NCH$first_antibiotics)] <- NA
NCH$first_other_tx[is.infinite(NCH$first_other_tx)] <- NA
NCH$first_popg_fluids[is.infinite(NCH$first_popg_fluids)] <- NA
NCH$first_iv_fluids[is.infinite(NCH$first_iv_fluids)] <- NA
NCH$first_medication_admin[is.infinite(NCH$first_medication_admin)] <- NA
NCH$first_management_from_unit[is.infinite(NCH$first_management_from_unit)] <- NA


#If missing vitals, use brief
NCH$first_clinical_assessment[is.na(NCH$first_clinical_assessment)] <- NCH$first_brief[is.na(NCH$first_clinical_assessment)]



#create age var
NCH$dobnumb <- as.numeric(as.POSIXct(NCH$dob_nch, format='%Y-%m-%d'))
NCH$arrival <- case_when(
  NCH$admit_type==2~NCH$time_arrival_ed,
  NCH$admit_type==1~NCH$time_arrival_admitting
)
NCH$age <- (NCH$arrival-NCH$dobnumb)/60/60/24/365.25

summary(NCH$age)

#getting month from start date
NCH$arrive_date[NCH$admit_type==1] <- NCH$time_arrival_admitting_nch[NCH$admit_type==1]
NCH$arrive_date[NCH$admit_type==2] <- NCH$time_arrival_ed_nch[NCH$admit_type==2]
NCH$arrive_year <- as.numeric(substr(NCH$arrive_date, 1, 4))
NCH$arrive_month[NCH$arrive_year==2020] <- as.numeric(substr(NCH$arrive_date[NCH$arrive_year==2020], 6, 7))-1
NCH$arrive_month[NCH$arrive_year==2021] <- as.numeric(substr(NCH$arrive_date[NCH$arrive_year==2021], 6, 7))-1+12
NCH$arrive_month[NCH$arrive_year==2022] <- as.numeric(substr(NCH$arrive_date[NCH$arrive_year==2022], 6, 7))-1+24
NCH$arrive_month[NCH$arrive_year==2023] <- as.numeric(substr(NCH$arrive_date[NCH$arrive_year==2023], 6, 7))-1+36
look <- NCH %>% select(studyid, arrive_date, arrive_month, arrive_year)

#Getting larger time periods
NCH$arrive_date[1:5]
NCH$arrive_date_num <- as.numeric(as.POSIXct(NCH$arrive_date))
t1 <- as.numeric(as.POSIXct('2020-08-01 00:00:00'))
t2 <- as.numeric(as.POSIXct('2021-02-01 00:00:00'))
t3 <- as.numeric(as.POSIXct('2021-11-01 00:00:00'))

NCH$arrive_block[NCH$arrive_date_num<t1] <- '1'
NCH$arrive_block[NCH$arrive_date_num>=t1 & NCH$arrive_date_num<t2] <- '2'
NCH$arrive_block[NCH$arrive_date_num>=t2 & NCH$arrive_date_num<t3] <- '3'
NCH$arrive_block[NCH$arrive_date_num>=t3] <- '4'


##############PRMC######################

PRMC <- read.csv('40_PCORIProjectPRMCE_DATA_2023-07-19.csv')
colnames

#drop bad rows
PRMC <- PRMC[!(substr(PRMC$manual_study_id_prov,5,5) == 'B' | 
                 substr(PRMC$manual_study_id_prov,5,5) == 'b' |
                 substr(PRMC$manual_study_id_prov,5,5) == 'C'),]


PRMC$studyid <- as.numeric(substr(PRMC$manual_study_id_prov,1,4))


PRMC <- distinct(inner_join(PRMC, elig3, by = 'studyid'))


###Dates###
PRMC$time_arrival_ed_prov[(PRMC$time_arrival_ed_prov == '')] <- NA
PRMC$time_first_assess_ed_prov[(PRMC$time_first_assess_ed_prov == '')] <- NA
PRMC$brief_time_ed_prov[(PRMC$brief_time_ed_prov == '')] <- NA
PRMC$vitals_time_ed_prov[(PRMC$vitals_time_ed_prov == '')] <- NA
PRMC$first_lab_ed_prov[(PRMC$first_lab_ed_prov == '')] <- NA
PRMC$first_imaging_ed_prov[(PRMC$first_imaging_ed_prov == '')] <- NA
PRMC$first_pain_meds_ed_prov[(PRMC$first_pain_meds_ed_prov == '')] <- NA
PRMC$first_antibiotics_ed_prov[(PRMC$first_antibiotics_ed_prov == '')] <- NA
PRMC$first_other_tx_ed_prov[(PRMC$first_other_tx_ed_prov == '')] <- NA
PRMC$first_popg_fluids_ed_prov[(PRMC$first_popg_fluids_ed_prov == '')] <- NA
PRMC$first_iv_fluids_ed_prov[(PRMC$first_iv_fluids_ed_prov == '')] <- NA
PRMC$second_lab_ed_prov[(PRMC$second_lab_ed_prov=='')] <- NA
PRMC$time_arrival_unit_ed_prov[(PRMC$time_arrival_unit_ed_prov=='')] <- NA


PRMC$time_arrival_admitting_prov[(PRMC$time_arrival_admitting_prov == '')] <- NA
PRMC$brief_time[(PRMC$brief_time == '')] <- NA
PRMC$vitals_time[(PRMC$vitals_time == '')] <- NA
PRMC$first_lab_prov[(PRMC$first_lab_prov == '')] <- NA
PRMC$first_imaging_prov[(PRMC$first_imaging_prov == '')] <- NA
PRMC$first_pain_meds_prov[(PRMC$first_pain_meds_prov == '')] <- NA
PRMC$first_antibiotics_prov[(PRMC$first_antibiotics_prov == '')] <- NA
PRMC$first_other_tx_prov[(PRMC$first_other_tx_prov == '')] <- NA
PRMC$first_popg_fluids_prov[(PRMC$first_popg_fluids_prov == '')] <- NA
PRMC$first_iv_fluids_prov[(PRMC$first_iv_fluids_prov == '')] <- NA
PRMC$second_lab_prov[(PRMC$second_lab_prov=='')] <- NA


###Create Numeric Versions of Datetimes###
PRMC$time_arrival_ed <- as.numeric(as.POSIXct(PRMC$time_arrival_ed_prov))
PRMC$time_first_assessed_ed <- as.numeric(as.POSIXct(PRMC$time_first_assess_ed_prov))
PRMC$brief_time_ed <- as.numeric(as.POSIXct(PRMC$brief_time_ed_prov))
PRMC$vitals_time_ed <- as.numeric(as.POSIXct(PRMC$vitals_time_ed_prov))
PRMC$first_lab_ed <- as.numeric(as.POSIXct(PRMC$first_lab_ed_prov))
PRMC$first_imaging_ed <- as.numeric(as.POSIXct(PRMC$first_imaging_ed_prov))
PRMC$first_pain_meds_ed <- as.numeric(as.POSIXct(PRMC$first_pain_meds_ed_prov))
PRMC$first_antibiotics_ed <- as.numeric(as.POSIXct(PRMC$first_antibiotics_ed_prov))
PRMC$first_other_tx_ed <- as.numeric(as.POSIXct(PRMC$first_other_tx_ed_prov))
PRMC$first_popg_fluids_ed <- as.numeric(as.POSIXct(PRMC$first_popg_fluids_ed_prov))
PRMC$first_iv_fluids_ed <- as.numeric(as.POSIXct(PRMC$first_iv_fluids_ed_prov))
PRMC$second_lab_ed <- as.numeric(as.POSIXct(PRMC$second_lab_ed_prov))
PRMC$time_arrival_unit_ed <- as.numeric(as.POSIXct(PRMC$time_arrival_unit_ed_prov))

PRMC$time_arrival_admitting <- as.numeric(as.POSIXct(PRMC$time_arrival_admitting_prov))
PRMC$brief_time_da <- as.numeric(as.POSIXct(PRMC$brief_time))
PRMC$vitals_time_da <- as.numeric(as.POSIXct(PRMC$vitals_time))
PRMC$first_lab_da <- as.numeric(as.POSIXct(PRMC$first_lab_prov))
PRMC$first_imaging_da <- as.numeric(as.POSIXct(PRMC$first_imaging_prov))
PRMC$first_pain_meds_da <- as.numeric(as.POSIXct(PRMC$first_pain_meds_prov))
PRMC$first_antibiotics_da <- as.numeric(as.POSIXct(PRMC$first_antibiotics_prov))
PRMC$first_other_tx_da <- as.numeric(as.POSIXct(PRMC$first_other_tx_prov))
PRMC$first_popg_fluids_da <- as.numeric(as.POSIXct(PRMC$first_popg_fluids_prov))
PRMC$first_iv_fluids_da <- as.numeric(as.POSIXct(PRMC$first_iv_fluids_prov))
PRMC$second_lab_da <- as.numeric(as.POSIXct(PRMC$second_lab_prov))


##Turning first med admin times to missing when only given NSAIDs
PRMC$pain_meds_nsaid_ed <- 0
PRMC$pain_meds_nsaid_ed[(PRMC$pain_meds_ed_prov___2==1 | PRMC$pain_meds_ed_prov___3==1) &
                          PRMC$pain_meds_ed_prov___4==0 & PRMC$pain_meds_ed_prov___5==0 &
                          PRMC$pain_meds_ed_prov___6==0 & PRMC$pain_meds_ed_prov___7==0] <- 1
PRMC$pain_meds_nsaid_da <- 0
PRMC$pain_meds_nsaid_da[(PRMC$pain_meds_prov___2==1 | PRMC$pain_meds_prov___3==1) &
                          PRMC$pain_meds_prov___4==0 & PRMC$pain_meds_prov___5==0 &
                          PRMC$pain_meds_prov___6==0 & PRMC$pain_meds_prov___7==0] <- 1
PRMC$first_pain_meds_ed2 <- PRMC$first_pain_meds_ed
PRMC$first_pain_meds_ed2[PRMC$pain_meds_nsaid_ed==1] <- NA
PRMC$first_pain_meds_da2 <- PRMC$first_pain_meds_da
PRMC$first_pain_meds_da2[PRMC$pain_meds_nsaid_da==1] <- NA




####################################################
for(i in 1:nrow(PRMC)){
  if(PRMC$admit_type_prov[i]==2){
    PRMC$first_clinical_assessment[i] <- (min(PRMC$vitals_time_da[i], PRMC$vitals_time_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$first_brief[i] <- (PRMC$brief_time_ed-PRMC$time_arrival_ed)/60
    PRMC$first_labs_imaging[i] <- (min(PRMC$first_lab_ed[i],PRMC$first_lab_da[i],PRMC$first_imaging_da[i],PRMC$first_imaging_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$first_pain_meds[i] <- (min(PRMC$first_pain_meds_da[i], PRMC$first_pain_meds_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$first_antibiotics[i] <- (min(PRMC$first_antibiotics_da[i], PRMC$first_antibiotics_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$first_other_tx[i] <- (min(PRMC$first_other_tx_da[i], PRMC$first_other_tx_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$first_popg_fluids[i] <- (min(PRMC$first_popg_fluids_da[i], PRMC$first_popg_fluids_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$first_iv_fluids[i] <- (min(PRMC$first_iv_fluids_da[i], PRMC$first_iv_fluids_ed[i], na.rm=T)-PRMC$time_arrival_ed[i])/60
    PRMC$second_lab[i] <- (PRMC$second_lab_ed[i]-PRMC$time_arrival_ed[i])/60
    PRMC$first_management_from_unit[i] <- (min(PRMC$first_lab_da[i], PRMC$first_imaging_da[i], PRMC$first_pain_meds_da[i],
                                               PRMC$first_antibiotics_da[i], PRMC$first_other_tx_da[i], PRMC$first_popg_fluids_da[i],
                                               PRMC$first_iv_fluids_da[i], na.rm=T)-PRMC$time_arrival_unit_ed[i])/60
  }
  else{
    PRMC$first_clinical_assessment[i] <- (min(PRMC$vitals_time_da[i], PRMC$vitals_time_ed[i], na.rm=T) - PRMC$time_arrival_admitting[i])/60
    PRMC$first_brief[i] <- (PRMC$brief_time_da-PRMC$time_arrival_admitting)/60
    PRMC$first_labs_imaging[i] <- (min(PRMC$first_imaging_da[i],PRMC$first_lab_da[i], na.rm=T)-PRMC$time_arrival_admitting[i])/60
    PRMC$first_pain_meds[i] <- (PRMC$first_pain_meds_da[i]-PRMC$time_arrival_admitting[i])/60
    PRMC$first_antibiotics[i] <- (PRMC$first_antibiotics_da[i]-PRMC$time_arrival_admitting[i])/60
    PRMC$first_other_tx[i] <- (PRMC$first_other_tx_da[i]-PRMC$time_arrival_admitting[i])/60
    PRMC$first_popg_fluids[i] <- (PRMC$first_popg_fluids_da[i]-PRMC$time_arrival_admitting[i])/60
    PRMC$first_iv_fluids[i] <- (PRMC$first_iv_fluids_da[i]-PRMC$time_arrival_admitting[i])/60
    PRMC$second_lab[i] <- (PRMC$second_lab_da[i]-PRMC$time_arrival_admitting[i])/60
    PRMC$first_management_from_unit[i] <- (min(PRMC$first_lab_da[i], PRMC$first_imaging_da[i], PRMC$first_pain_meds_da[i],
                                               PRMC$first_antibiotics_da[i], PRMC$first_other_tx_da[i], PRMC$first_popg_fluids_da[i],
                                               PRMC$first_iv_fluids_da[i], na.rm=T)-PRMC$time_arrival_admitting[i])/60
  }
  PRMC$first_medication_admin[i] <- min(PRMC$first_pain_meds[i],PRMC$first_antibiotics[i],
                                        PRMC$first_other_tx[i],PRMC$first_popg_fluids[i],
                                        PRMC$first_iv_fluids[i], na.rm=T)
}


PRMC$first_clinical_assessment[is.infinite(PRMC$first_clinical_assessment)] <- NA
PRMC$first_clinical_management[is.infinite(PRMC$first_clinical_management)] <- NA
PRMC$first_labs_imaging[is.infinite(PRMC$first_labs_imaging)] <- NA
PRMC$first_pain_meds[is.infinite(PRMC$first_pain_meds)] <- NA
PRMC$first_antibiotics[is.infinite(PRMC$first_antibiotics)] <- NA
PRMC$first_other_tx[is.infinite(PRMC$first_other_tx)] <- NA
PRMC$first_popg_fluids[is.infinite(PRMC$first_popg_fluids)] <- NA
PRMC$first_iv_fluids[is.infinite(PRMC$first_iv_fluids)] <- NA
PRMC$first_medication_admin[is.infinite(PRMC$first_medication_admin)] <- NA
PRMC$first_management_from_unit[is.infinite(PRMC$first_management_from_unit)] <- NA


PRMC$first_clinical_assessment[is.na(PRMC$first_clinical_assessment)] <- PRMC$first_brief[is.na(PRMC$first_clinical_assessment)]


PRMC$dobnumb <- as.numeric(as.POSIXct(PRMC$dob_prov))
PRMC$arrival <- case_when(
  PRMC$admit_type_prov==2~PRMC$time_arrival_ed,
  PRMC$admit_type_prov==1~PRMC$time_arrival_admitting
)

PRMC$age <- (PRMC$arrival-PRMC$dobnumb)/60/60/24/365.25


#getting month from start date
PRMC$arrive_date[PRMC$admit_type==1] <- PRMC$time_arrival_admitting_prov[PRMC$admit_type==1]
PRMC$arrive_date[PRMC$admit_type==2] <- PRMC$time_arrival_ed_prov[PRMC$admit_type==2]
PRMC$arrive_year <- as.numeric(substr(PRMC$arrive_date, 1, 4))
PRMC$arrive_month[PRMC$arrive_year==2020] <- as.numeric(substr(PRMC$arrive_date[PRMC$arrive_year==2020], 6, 7))-1
PRMC$arrive_month[PRMC$arrive_year==2021] <- as.numeric(substr(PRMC$arrive_date[PRMC$arrive_year==2021], 6, 7))-1+12
PRMC$arrive_month[PRMC$arrive_year==2022] <- as.numeric(substr(PRMC$arrive_date[PRMC$arrive_year==2022], 6, 7))-1+24
PRMC$arrive_month[PRMC$arrive_year==2023] <- as.numeric(substr(PRMC$arrive_date[PRMC$arrive_year==2023], 6, 7))-1+36

PRMC$arrive_date_num <- as.numeric(as.POSIXct(PRMC$arrive_date))
PRMC$arrive_block[PRMC$arrive_date_num<t1] <- '1'
PRMC$arrive_block[PRMC$arrive_date_num>=t1 & PRMC$arrive_date_num<t2] <- '2'
PRMC$arrive_block[PRMC$arrive_date_num>=t2 & PRMC$arrive_date_num<t3] <- '3'
PRMC$arrive_block[PRMC$arrive_date_num>=t3] <- '4'


########################################
########################################


##############CHP#######################

CHP <- read.csv('35_PCORIProjectCHP_DATA_2023-01-30.csv')


#drop bad rows
CHP <- CHP[!(substr(CHP$record_id,5,5) == 'B' | 
               substr(CHP$record_id,5,5) == 'b' |
               substr(CHP$record_id,5,5) == 'C' |
               substr(CHP$record_id,6,7) == 'DD' |
               substr(CHP$record_id,5,6) == 'DD'),]

CHP$studyid <- as.numeric(substr(CHP$record_id,1,4))


#manual fixes
CHP$first_pain_meds_ed[CHP$studyid==3302] <- '2020-07-20 18:37'
CHP$time_arrival_admitting[CHP$studyid==3733] <- CHP$time_arrival_unit[CHP$studyid==3733]
CHP$first_lab_ed[CHP$studyid==3187] <- '2020-04-04 13:20'
CHP$first_lab_ed[CHP$studyid==3204] <- '2020-04-17 20:10'
CHP$vitals_time_ed[CHP$studyid==3251] <- '2020-05-28 14:35'
CHP$vitals_time[CHP$studyid==3677] <- '2021-10-13 14:06'
CHP$first_lab_ed[CHP$studyid==3306]
CHP$vitals_time_ed[CHP$studyid==3589] <- '2021-07-10 19:06'
CHP$vitals_time_ed[CHP$studyid==3800] <- '2022-03-05 22:34'
CHP$dob[CHP$studyid==3118] <- '2019-04-29'

CHP <- inner_join(CHP, elig3, by = 'studyid')


#Working with Dates
CHP$time_arrival_ed[(CHP$time_arrival_ed == '')] <- NA
CHP$time_first_assess_ed[(CHP$time_first_assess_ed == '')] <- NA
CHP$brief_time_ed[(CHP$brief_time_ed == '')] <- NA
CHP$vitals_time_ed[(CHP$vitals_time_ed == '')] <- NA
CHP$first_lab_ed[(CHP$first_lab_ed == '')] <- NA
CHP$first_imaging_ed[(CHP$first_imaging_ed == '')] <- NA
CHP$first_pain_meds_ed[(CHP$first_pain_meds_ed == '')] <- NA
CHP$first_antibiotics_ed[(CHP$first_antibiotics_ed == '')] <- NA
CHP$first_other_tx_ed[(CHP$first_other_tx_ed == '')] <- NA
CHP$first_popg_fluids_ed[(CHP$first_popg_fluids_ed == '')] <- NA
CHP$first_iv_fluids_ed[(CHP$first_iv_fluids_ed == '')] <- NA
CHP$second_lab_ed[(CHP$second_lab_ed=='')] <- NA
CHP$time_arrival_unit_ed[(CHP$time_arrival_unit_ed=='')] <- NA
CHP$time_primeassess_ed[(CHP$time_primeassess_ed=='')] <- NA

CHP$time_arrival_admitting[(CHP$time_arrival_admitting == '')] <- NA
CHP$brief_time[(CHP$brief_time == '')] <- NA
CHP$vitals_time[(CHP$vitals_time == '')] <- NA
CHP$first_lab[(CHP$first_lab == '')] <- NA
CHP$first_imaging[(CHP$first_imaging == '')] <- NA
CHP$first_pain_meds[(CHP$first_pain_meds == '')] <- NA
CHP$first_antibiotics[(CHP$first_antibiotics == '')] <- NA
CHP$first_other_tx[(CHP$first_other_tx == '')] <- NA
CHP$first_popg_fluids[(CHP$first_popg_fluids == '')] <- NA
CHP$first_iv_fluids[(CHP$first_iv_fluids == '')] <- NA
CHP$second_lab[(CHP$second_lab=='')] <- NA



###Create Numeric Versions of Datetimes###
CHP$time_arrival_ed <- as.numeric(as.POSIXct(CHP$time_arrival_ed))
CHP$time_first_assessed_ed <- as.numeric(as.POSIXct(CHP$time_first_assess_ed))
CHP$brief_time_ed <- as.numeric(as.POSIXct(CHP$brief_time_ed))
CHP$vitals_time_ed <- as.numeric(as.POSIXct(CHP$vitals_time_ed))
CHP$first_lab_ed <- as.numeric(as.POSIXct(CHP$first_lab_ed))
CHP$first_imaging_ed <- as.numeric(as.POSIXct(CHP$first_imaging_ed))
CHP$first_pain_meds_ed <- as.numeric(as.POSIXct(CHP$first_pain_meds_ed))
CHP$first_antibiotics_ed <- as.numeric(as.POSIXct(CHP$first_antibiotics_ed))
CHP$first_other_tx_ed <- as.numeric(as.POSIXct(CHP$first_other_tx_ed))
CHP$first_popg_fluids_ed <- as.numeric(as.POSIXct(CHP$first_popg_fluids_ed))
CHP$first_iv_fluids_ed <- as.numeric(as.POSIXct(CHP$first_iv_fluids_ed))
CHP$second_lab_ed <- as.numeric(as.POSIXct(CHP$second_lab_ed))
CHP$time_arrival_unit_ed <- as.numeric(as.POSIXct(CHP$time_arrival_unit_ed))
CHP$time_primeassess_ed <- as.numeric(as.POSIXct(CHP$time_primeassess_ed))

CHP$time_arrival_admitting <- as.numeric(as.POSIXct(CHP$time_arrival_admitting))
CHP$brief_time_da <- as.numeric(as.POSIXct(CHP$brief_time))
CHP$vitals_time_da <- as.numeric(as.POSIXct(CHP$vitals_time))
CHP$first_lab_da <- as.numeric(as.POSIXct(CHP$first_lab))
CHP$first_imaging_da <- as.numeric(as.POSIXct(CHP$first_imaging))
CHP$first_pain_meds_da <- as.numeric(as.POSIXct(CHP$first_pain_meds))
CHP$first_antibiotics_da <- as.numeric(as.POSIXct(CHP$first_antibiotics))
CHP$first_other_tx_da <- as.numeric(as.POSIXct(CHP$first_other_tx))
CHP$first_popg_fluids_da <- as.numeric(as.POSIXct(CHP$first_popg_fluids))
CHP$first_iv_fluids_da <- as.numeric(as.POSIXct(CHP$first_iv_fluids))
CHP$second_lab_da <- as.numeric(as.POSIXct(CHP$second_lab))


##Turning first med admin times to missing when only given NSAIDs
CHP$pain_meds_nsaid_ed <- 0
CHP$pain_meds_nsaid_ed[(CHP$pain_meds_ed___2==1 | CHP$pain_meds_ed___3==1) &
                         CHP$pain_meds_ed___4==0 & CHP$pain_meds_ed___5==0 &
                         CHP$pain_meds_ed___6==0 & CHP$pain_meds_ed___7==0] <- 1
CHP$pain_meds_nsaid_da <- 0
CHP$pain_meds_nsaid_da[(CHP$pain_meds___2==1 | CHP$pain_meds___3==1) &
                         CHP$pain_meds___4==0 & CHP$pain_meds___5==0 &
                         CHP$pain_meds___6==0 & CHP$pain_meds___7==0] <- 1
table(CHP$pain_meds_nsaid_ed)
CHP$mispain[is.na(CHP$first_pain_meds_ed)] <- 1
table(CHP$mispain)
CHP$first_pain_meds_ed2 <- CHP$first_pain_meds_ed
CHP$first_pain_meds_ed2[CHP$pain_meds_nsaid_ed==1] <- NA
CHP$first_pain_meds_da2 <- CHP$first_pain_meds_da
CHP$first_pain_meds_da2[CHP$pain_meds_nsaid_da==1] <- NA



#Make difference in time variables
for(i in 1:nrow(CHP)){
  if(CHP$admit_type[i]==2){
    CHP$first_clinical_assessment[i] <- ((min(CHP$vitals_time_ed[i], na.rm=T))-CHP$time_arrival_ed[i])/60
    CHP$first_brief[i] <- (CHP$time_primeassess_ed[i]-CHP$time_arrival_ed[i])/60
    CHP$first_labs_imaging[i] <- as.numeric((min(CHP$first_lab_ed[i],CHP$first_lab_da[i],CHP$first_imaging_da[i],CHP$first_imaging_ed[i], na.rm=T))-CHP$time_arrival_ed[i])/60
    CHP$first_pain_meds[i] <- as.numeric((min(CHP$first_pain_meds_da[i], CHP$first_pain_meds_ed[i], na.rm=T))-CHP$time_arrival_ed[i])/60
    CHP$first_antibiotics[i] <- as.numeric((min(CHP$first_antibiotics_da[i], CHP$first_antibiotics_ed[i], na.rm=T))-CHP$time_arrival_ed[i])/60
    CHP$first_other_tx[i] <- as.numeric((min(CHP$first_other_tx_da[i], CHP$first_other_tx_ed[i], na.rm=T)-CHP$time_arrival_ed[i]))/60
    CHP$first_popg_fluids[i] <- as.numeric((min(CHP$first_popg_fluids_da[i], CHP$first_popg_fluids_ed[i], na.rm=T))-CHP$time_arrival_ed[i])/60
    CHP$first_iv_fluids[i] <- as.numeric((min(CHP$first_iv_fluids_da[i], CHP$first_iv_fluids_ed[i], na.rm=T))-CHP$time_arrival_ed[i])/60
    CHP$second_lab[i] <- (CHP$second_lab_ed[i]-CHP$time_arrival_ed[i])/60
    CHP$first_management_from_unit[i] <- (min(CHP$first_lab_da[i], CHP$first_imaging_da[i], CHP$first_pain_meds_da[i],
                                          CHP$first_antibiotics_da[i], CHP$first_other_tx_da[i], CHP$first_popg_fluids_da[i],
                                          CHP$first_iv_fluids_da[i], na.rm=T)-CHP$time_arrival_unit_ed[i])/60
  }
  else{
    CHP$first_clinical_assessment[i] <- as.numeric((min(CHP$vitals_time_da[i], na.rm=T)) - CHP$time_arrival_admitting[i])/60
    CHP$first_brief[i] <- (CHP$brief_time_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$first_labs_imaging[i] <- as.numeric((min(CHP$first_imaging_da[i],CHP$first_lab_da[i], na.rm=T))-CHP$time_arrival_admitting[i])/60
    CHP$first_pain_meds[i] <- (CHP$first_pain_meds_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$first_antibiotics[i] <- (CHP$first_antibiotics_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$first_other_tx[i] <- (CHP$first_other_tx_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$first_popg_fluids[i] <- (CHP$first_popg_fluids_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$first_iv_fluids[i] <- (CHP$first_iv_fluids_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$second_lab[i] <- (CHP$second_lab_da[i]-CHP$time_arrival_admitting[i])/60
    CHP$first_management_from_unit[i] <- (min(CHP$first_lab_da[i], CHP$first_imaging_da[i], CHP$first_pain_meds_da[i],
                                          CHP$first_antibiotics_da[i], CHP$first_other_tx_da[i], CHP$first_popg_fluids_da[i],
                                          CHP$first_iv_fluids_da[i], na.rm=T)-CHP$time_arrival_admitting[i])/60
  }
  CHP$first_medication_admin[i] <- as.numeric(min(first_pain_meds[i],first_antibiotics[i],
                                              first_other_tx[i],first_popg_fluids[i],
                                              first_iv_fluids[i], na.rm=T))

}


#check all for inf
CHP$first_clinical_assessment[is.infinite(CHP$first_clinical_assessment)] <- NA
CHP$first_clinical_management[is.infinite(CHP$first_clinical_management)] <- NA
CHP$first_labs_imaging[is.infinite(CHP$first_labs_imaging)] <- NA
CHP$first_labs_imaging2[is.infinite(CHP$first_labs_imaging2)] <- NA
CHP$first_pain_meds[is.infinite(CHP$first_pain_meds)] <- NA
CHP$first_antibiotics[is.infinite(CHP$first_antibiotics)] <- NA
CHP$first_other_tx[is.infinite(CHP$first_other_tx)] <- NA
CHP$first_popg_fluids[is.infinite(CHP$first_popg_fluids)] <- NA
CHP$first_iv_fluids[is.infinite(CHP$first_iv_fluids)] <- NA
CHP$first_medication_admin[is.infinite(CHP$first_medication_admin)] <- NA
CHP$first_management_from_unit[is.infinite(CHP$first_management_from_unit)] <- NA
CHP$first_brief[is.infinite(CHP$first_brief)] <- NA



CHP$first_clinical_assessment[is.na(CHP$first_clinical_assessment)] <- CHP$first_brief[is.na(CHP$first_clinical_assessment)]




CHP$dobnumb <- as.numeric(as.POSIXct(CHP$dob))
CHP$arrival <- case_when(
  CHP$admit_type==2~CHP$time_arrival_ed,
  CHP$admit_type==1~CHP$time_arrival_admitting
)

CHP$age <- (CHP$arrival-CHP$dobnumb)/60/60/24/365.25


#getting month from start date
CHP$arrive_date[CHP$admit_type==1] <- CHP$time_arrival_admitting_chp[CHP$admit_type==1]
CHP$arrive_date[CHP$admit_type==2] <- CHP$time_arrival_ed_chp[CHP$admit_type==2]
CHP$arrive_year <- as.numeric(substr(CHP$arrive_date, 1, 4))
CHP$arrive_month[CHP$arrive_year==2020] <- as.numeric(substr(CHP$arrive_date[CHP$arrive_year==2020], 6, 7))-1
CHP$arrive_month[CHP$arrive_year==2021] <- as.numeric(substr(CHP$arrive_date[CHP$arrive_year==2021], 6, 7))-1+12
CHP$arrive_month[CHP$arrive_year==2022] <- as.numeric(substr(CHP$arrive_date[CHP$arrive_year==2022], 6, 7))-1+24
CHP$arrive_month[CHP$arrive_year==2023] <- as.numeric(substr(CHP$arrive_date[CHP$arrive_year==2023], 6, 7))-1+36


CHP$arrive_date_num <- as.numeric(as.POSIXct(CHP$arrive_date))
CHP$arrive_block[CHP$arrive_date_num<t1] <- '1'
CHP$arrive_block[CHP$arrive_date_num>=t1 & CHP$arrive_date_num<t2] <- '2'
CHP$arrive_block[CHP$arrive_date_num>=t2 & CHP$arrive_date_num<t3] <- '3'
CHP$arrive_block[CHP$arrive_date_num>=t3] <- '4'


#########################################################
#################Add administrative data#################
#########################################################

#########
###NCH###
#########

#read in admin data
N1 <- read_excel('_USE THIS_NCH Admin Data_07-20-22 (pw=pcorida)(#1001-1999, 0001-0930, plus extras).xlsx')
N1$studyid <- as.numeric(N1$STUDYID)
N2 <- read_excel('_USE SOME OF THIS_NCH Admin Data_01-11-23 (pw=pcorida)(Use for #0931-0999, 4001-4268).xlsx')
N2$studyid <- as.numeric(N2$STUDYID)
N3 <- read_excel('3_NCH Admin Data_6-22-23 (pw=pcorida)(Use for #4269-4703 plus 0983, 4001, 4034, 4044).xlsx')
N3$studyid <- as.numeric(N3$STUDYID)
N4 <- read_excel('_USE THIS_NCH Admin Data_07-20-22 (pw=pcorida)(#1001-1999, 0001-0930, plus extras).xlsx', sheet=2)
N4$studyid <- as.numeric(N4$STUDYID)
N4 <- N4[N4$studyid==41,]
N5 <- read_excel('4_NCH Admin Data_6-22-23 (pw=pcorida)(Use for #4022).xlsx')
N5$studyid <- as.numeric(N5$STUDYID)
N_extra <- N1[N1$studyid %in% c(1340,1696),]

NCH_admin <- distinct(rbind(N_extra, N4, N3, N5))

NCH_admin <- inner_join(NCH_admin, elig3, by='studyid')

#merge with REDCap data
NCH <- full_join(NCH, NCH_admin, by='studyid')


NCH$race <- case_when(
  (NCH$RACE == 'Black or African American' | NCH$RACE == 'African')~'Non-Hispanic Black',
  (NCH$RACE == 'White')~'Non-Hispanic White',
  NCH$RACE =='Asian'~'Non-Hispanic Asian',
  (NCH$RACE =='Bi-racial/Multi-racial' | NCH$RACE =='Multiple race')~'Non-Hispanic Other Race',
  (NCH$RACE =='Latino/Hispanic/Black' | NCH$RACE =='Latino/Hispanic/White' | NCH$RACE == 'Latino/Hispanic/Unspecified')~'Hispanic'
)
table(NCH$race)


NCH$gender <- NCH$GENDER


NCH$payer <- case_when(
  (NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'HMO Ohio Medicaid' |
     NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'Medicaid Ohio' |
     NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'OOS Medicaid' | 
     NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'BCMH' |
     NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'Tricare')~'Medicaid',
  NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'Self-Pay'~'Other',
  NCH$PRIMARY_PAYOR_FINANCIAL_CLASS == 'Commercial'~'Commercial'
)

#admission diagnosis
NCH$admitreason <- case_when(NCH$admit_reason_nch==3~1,
                             NCH$admit_reason_nch==5~2,
                             (NCH$admit_reason_nch==1 |NCH$admit_reason_nch==2)~3,
                             NCH$admit_reason_nch==4~4,
                             NCH$admit_reason_nch==6~5,
                             NCH$admit_reason_nch==7~6,
                             (NCH$admit_reason_nch==8 |NCH$admit_reason_nch==9 |NCH$admit_reason_nch==10)~7)

#standardizing names
NCH$site <- 'NCH'
NCH$admit_type <- NCH$admit_type_nch
NCH$pcp <- NCH$pcp_nch

###vitals###
#Heart rate
NCH$vitals_hr[NCH$admit_type==2] <- NCH$vitals_hr_ed_nch[NCH$admit_type==2]
NCH$vitals_hr[NCH$admit_type==1] <- NCH$vitals_hr_nch[NCH$admit_type==1]

NCH$unstable_hr <- NA
NCH$unstable_hr[!(is.na(NCH$vitals_hr))] <- 0

NCH$unstable_hr[(NCH$age*365.25) < 29 & (NCH$vitals_hr<100 | NCH$vitals_hr>205)] <- 1
NCH$unstable_hr[(NCH$age*365.25) >= 29 & (NCH$age*365.25) <= 365 & (NCH$vitals_hr<100 | NCH$vitals_hr>180)] <- 1
NCH$unstable_hr[(NCH$age*365.25) > 365 & (NCH$age) < 3 & (NCH$vitals_hr<98 | NCH$vitals_hr>140)] <- 1
NCH$unstable_hr[(NCH$age) >= 3 & (NCH$age) < 6 & (NCH$vitals_hr<80 | NCH$vitals_hr>120)] <- 1
NCH$unstable_hr[(NCH$age) >= 6 & (NCH$age) < 10 & (NCH$vitals_hr<75 | NCH$vitals_hr>118)] <- 1
NCH$unstable_hr[(NCH$age) >= 10 & (NCH$age) < 12 & (NCH$vitals_hr<75 | NCH$vitals_hr>118)] <- 1
NCH$unstable_hr[(NCH$age) >= 12 & (NCH$vitals_hr<60 | NCH$vitals_hr>100)] <- 1



#Respiratory rate
NCH$vitals_resp[NCH$admit_type==2] <- NCH$vitals_resp_ed_nch[NCH$admit_type==2]
NCH$vitals_resp[NCH$admit_type==1] <- NCH$vitals_resp_nch[NCH$admit_type==1]

NCH$unstable_resp <- NA
NCH$unstable_resp[!(is.na(NCH$vitals_resp))] <- 0
NCH$unstable_resp[(NCH$age*365.25) < 29 & (NCH$vitals_resp<30 | NCH$vitals_resp>53)] <- 1
NCH$unstable_resp[(NCH$age*365.25) >= 29 & (NCH$age*365.25) <= 365 & (NCH$vitals_resp<30 | NCH$vitals_resp>53)] <- 1
NCH$unstable_resp[(NCH$age*365.25) > 365 & (NCH$age) < 3 & (NCH$vitals_resp<22 | NCH$vitals_resp>37)] <- 1
NCH$unstable_resp[(NCH$age) >= 3 & (NCH$age) < 6 & (NCH$vitals_resp<20 | NCH$vitals_resp>28)] <- 1
NCH$unstable_resp[(NCH$age) >= 6 & (NCH$age) < 10 & (NCH$vitals_resp<18 | NCH$vitals_resp>25)] <- 1
NCH$unstable_resp[(NCH$age) >= 10 & (NCH$age) < 12 & (NCH$vitals_resp<18 | NCH$vitals_resp>25)] <- 1
NCH$unstable_resp[(NCH$age) >= 12 & (NCH$vitals_resp<12 | NCH$vitals_resp>20)] <- 1


#Blood Pressure (splitting up systolic and diastolic)
library(tidyr)
NCH$vitals_bp_ed_nch2 <- NCH$vitals_bp_ed_nch
NCH$vitals_bp_nch2 <- NCH$vitals_bp_nch
NCH <- separate(data = NCH, col = vitals_bp_ed_nch2, into = c("vitals_sbp_ed_nch", "vitals_dbp_ed_nch"), sep = "/")
NCH <- separate(data = NCH, col = vitals_bp_nch2, into = c("vitals_sbp_nch", "vitals_dbp_nch"), sep = "/")
NCH$vitals_sbp_ed_nch <- as.numeric(NCH$vitals_sbp_ed_nch)
NCH$vitals_sbp_nch <- as.numeric(NCH$vitals_sbp_nch)
NCH$vitals_dbp_ed_nch <- as.numeric(NCH$vitals_dbp_ed_nch)
NCH$vitals_dbp_nch <- as.numeric(NCH$vitals_dbp_nch)
look <- NCH %>% select(vitals_bp_ed_nch, vitals_sbp_ed_nch, vitals_dbp_ed_nch, vitals_bp_nch, vitals_sbp_nch, vitals_dbp_nch)


NCH$vitals_sbp[NCH$admit_type==2] <- NCH$vitals_sbp_ed_nch[NCH$admit_type==2]
NCH$vitals_sbp[NCH$admit_type==1] <- NCH$vitals_sbp_nch[NCH$admit_type==1]
NCH$vitals_dbp[NCH$admit_type==2] <- NCH$vitals_dbp_ed_nch[NCH$admit_type==2]
NCH$vitals_dbp[NCH$admit_type==1] <- NCH$vitals_dbp_nch[NCH$admit_type==1]

NCH$unstable_bp <- NA
NCH$unstable_bp[!(is.na(NCH$vitals_sbp) & is.na(NCH$vitals_dbp))] <- 0
NCH$unstable_bp[(NCH$age*365.25) < 29 & (NCH$vitals_sbp<67 | NCH$vitals_dbp<35)] <- 1
NCH$unstable_bp[(NCH$age*365.25) >= 29 & (NCH$age*365.25) <= 365 & (NCH$vitals_sbp<72 | NCH$vitals_dbp<37)] <- 1
NCH$unstable_bp[(NCH$age*365.25) > 365 & (NCH$age) < 3 & (NCH$vitals_sbp<86 | NCH$vitals_dbp<42)] <- 1
NCH$unstable_bp[(NCH$age) >= 3 & (NCH$age) < 6 & (NCH$vitals_sbp<89 | NCH$vitals_dbp<46)] <- 1
NCH$unstable_bp[(NCH$age) >= 6 & (NCH$age) < 10 & (NCH$vitals_sbp<97 | NCH$vitals_dbp<57)] <- 1
NCH$unstable_bp[(NCH$age) >= 10 & (NCH$age) < 12 & (NCH$vitals_sbp<102 | NCH$vitals_dbp<61)] <- 1
NCH$unstable_bp[(NCH$age) >= 12 & (NCH$vitals_sbp<110 | NCH$vitals_dbp<64)] <- 1



#Temperature
NCH$vitals_tp[NCH$admit_type==2] <- NCH$vitals_temp_ed_nch[NCH$admit_type==2]
NCH$vitals_tp[NCH$admit_type==1] <- NCH$vitals_temp_nch[NCH$admit_type==1]

NCH$unstable_tp <- NA
NCH$unstable_tp[!(is.na(NCH$vitals_tp))] <- 0

NCH$unstable_tp[NCH$vitals_tp < 35 | NCH$vitals_tp > 38] <- 1


#02sat
NCH$vitals_o2[NCH$admit_type==2] <- NCH$vitals_o2sat_ed_nch[NCH$admit_type==2]
NCH$vitals_o2[NCH$admit_type==1] <- NCH$vitals_o2sat_nch[NCH$admit_type==1]

NCH$unstable_o2 <- NA
NCH$unstable_o2[!(is.na(NCH$vitals_o2))] <- 0

NCH$unstable_o2[NCH$vitals_o2 < 92] <- 1



NCH$language <- NCH$LANGUAGE
NCH$rapid_response <- NCH$rapid_response_nch
NCH$tran_icu <- NCH$tran_icu_nch


##LOS (from admin data)##
distime <- as.numeric(as.POSIXct(NCH$`ADT_DISCHARGE_DATETIME`, format='%m/%d/%Y %H:%M:%S'))
arrtime <- as.numeric(as.POSIXct(NCH$`ADT_ADMISSION_DATETIME`, format='%m/%d/%Y %H:%M:%S'))
NCH$los <- (distime-arrtime)/60/60

NCH$admission_date <- arrtime


##Brief variables##
#color
NCH$brief_color[NCH$admit_type==1] <- NCH$brief_color_nch[NCH$admit_type==1]
NCH$brief_color[NCH$admit_type==2] <- NCH$brief_color_ed_nch[NCH$admit_type==2]
NCH$abnormal_color <- NA
NCH$abnormal_color[!(is.na(NCH$brief_color))] <- 0
NCH$abnormal_color[NCH$admit_type==1 & NCH$brief_color>3] <- 1
NCH$abnormal_color[NCH$admit_type==2 & NCH$brief_color>2] <- 1

#behavior
NCH$brief_behav[NCH$admit_type==1] <- NCH$brief_behav_nch[NCH$admit_type==1]
NCH$brief_behav[NCH$admit_type==2] <- NCH$brief_behav_ed_nch[NCH$admit_type==2]
NCH$abnormal_behav <- NA
NCH$abnormal_behav[!(is.na(NCH$brief_behav))] <- 0
NCH$abnormal_behav[NCH$admit_type==1 & NCH$brief_behav==4] <- 1
NCH$abnormal_behav[NCH$admit_type==2 & NCH$brief_behav %in% c(8,9)] <- 1



#cap refil
NCH$brief_cap[NCH$admit_type==1] <- NCH$brief_caprefill_nch[NCH$admit_type==1]
NCH$brief_cap[NCH$admit_type==2] <- NCH$brief_caprefill_ed_nch[NCH$admit_type==2]
NCH$brief_cap[NCH$brief_cap==''] <- NA
NCH$abnormal_cap <- NA
NCH$abnormal_cap[!(is.na(NCH$brief_cap))] <- 0
NCH$abnormal_cap[NCH$brief_cap %in% c('7','8')] <- 1


#readmissions -- from a different file
N_read <- read.csv('NCH readmissions.csv')
colnames(N_read) <- c('studyid')
NCH$readmission <- 0
NCH$readmission[NCH$studyid %in% N_read$studyid] <- 1


N_sub <- NCH %>% select(studyid, site, admitreason, admit_type, age, gender, payer, race, language, pcp, unstable_hr, unstable_resp,
                        unstable_bp, unstable_tp, unstable_o2, first_clinical_assessment, first_clinical_management, first_labs_imaging,
                        first_medication_admin, rapid_response, tran_icu, los, readmission, admission_date, abnormal_cap, abnormal_color, 
                        abnormal_behav,first_labs_imaging, first_labs_imaging2,
                        first_pain_meds,first_antibiotics, first_other_tx, first_popg_fluids, first_iv_fluids, starts_with('labs'), starts_with('imaging'),
                        first_lab_ed, first_lab_da, first_imaging_ed, first_imaging_da, first_management_from_unit, time_arrival_admitting, 
                        time_arrival_ed, arrive_month, labglu_ed, labglu_da, second_lab, arrive_block, cov_block)

#NCH doesn't have a column for lab 26, but CHP does
N_sub$labs___26 <- 0
N_sub$labs_ed___26 <- 0


#########
###CHP###
#########

C1 <- read_excel('C:/Users/sfrey/Downloads/1_complete_PCORI Data Request 7.16.21 without identifiers (#3001-3404).xlsx')
C2 <- read_excel('C:/Users/sfrey/Downloads/2_use some_PCORI Data Request 2nd cohort 7.16.21s (use for #3404-3563).xlsx')
C3 <- read_excel('C:/Users/sfrey/Downloads/3_use some_CHP_PCORI Data Request 7.20.22_(use for 3579-3870).xlsx')
C4 <- read_excel('C:/Users/sfrey/Downloads/4_complete_CHP_PHM_Direct_Admit_12.29.22_(3879-3906).xlsx')
C4$`First Readmission (if yes, specify date)`[C4$`First Readmission (if yes, specify date)`=='none'] <- NA
C1$studyid <- as.numeric(C1$`Study ID#`)
C2$studyid <- as.numeric(C2$`Study ID#`)
C3$studyid <- as.numeric(C3$`Study ID#`)
C4$studyid <- as.numeric(C4$`Study ID#`)

C1 <- C1 %>% select(studyid, Registration, Discharge,'Race Display', 'Gender Display','Ethnic Group', 'Insurance Type', 'Language Display', 'First Readmission (if yes, specify date)')
C2 <- C2 %>% select(studyid, Registration, Discharge,'Race Display', 'Gender Display','Ethnic Group', 'Insurance Type', 'Language Display', 'First Readmission (if yes, specify date)')
C3 <- C3 %>% select(studyid, Registration, Discharge,'Race Display', 'Gender Display','Ethnic Group', 'Insurance Type', 'Language Display', 'First Readmission (if yes, specify date)')
C4 <- C4 %>% select(studyid, Registration, Discharge,'Race Display', 'Gender Display','Ethnic Group', 'Insurance Type', 'Language Display', 'First Readmission (if yes, specify date)')

CHP_admin <- distinct(rbind(C1,C2,C3,C4))
CHP_admin <- inner_join(CHP_admin, elig3, 'studyid')

CHP <- full_join(CHP, CHP_admin, 'studyid')



CHP$race <- case_when(
  (CHP$`Race Display` == 'Black' & CHP$`Ethnic Group` != 'Hispanic or Latino')~'Non-Hispanic Black',
  (CHP$`Race Display` == 'White' & CHP$`Ethnic Group` != 'Hispanic or Latino')~'Non-Hispanic White',
  ((CHP$`Race Display` == 'Chinese' | CHP$`Race Display` == 'Indian ( Asia)' |
      CHP$`Race Display` == 'OTH Asian') & 
     CHP$`Ethnic Group` != 'Hispanic or Latino')~'Non-Hispanic Asian',
  CHP$`Race Display` == 'Multiple' & CHP$`Ethnic Group` != 'Hispanic or Latino'~'Non-Hispanic Other Race',
  CHP$`Ethnic Group` == 'Hispanic or Latino'~'Hispanic',
  (CHP$`Race Display` == 'Not Specified' | CHP$`Race Display` == 'PATIENT DECLINED')~'Missing'
  
)


CHP$gender <- CHP$`Gender Display`

CHP$language <- CHP$`Language Display`


CHP$payer <- case_when(
  CHP$`Insurance Type` == 'Commercial'~'Commercial',
  CHP$`Insurance Type` == 'Private'~'Commercial',
  CHP$`Insurance Type` == 'Medicaid'~ 'Medicaid',
  CHP$`Insurance Type` == 'Self'~ 'Self'
)


CHP$admitreason <- case_when(CHP$admit_reason==3~1,
                             CHP$admit_reason==5~2,
                             (CHP$admit_reason==1 |CHP$admit_reason==2)~3,
                             CHP$admit_reason==4~4,
                             CHP$admit_reason==6~5,
                             CHP$admit_reason==7~6,
                             (CHP$admit_reason==8 |CHP$admit_reason==9 |CHP$admit_reason==10)~7)

CHP$site <- 'CHP'

###vitals###
#Heart rate
CHP$vitals_hr[CHP$admit_type==2] <- CHP$vitals_hr_ed[CHP$admit_type==2]
CHP$vitals_hr[CHP$admit_type==1] <- CHP$vitals_hr[CHP$admit_type==1]

CHP$unstable_hr <- NA
CHP$unstable_hr[!(is.na(CHP$vitals_hr))] <- 0
CHP$unstable_hr[(CHP$age*365.25) < 29 & (CHP$vitals_hr<100 | CHP$vitals_hr>205)] <- 1
CHP$unstable_hr[(CHP$age*365.25) >= 29 & (CHP$age*365.25) <= 365 & (CHP$vitals_hr<100 | CHP$vitals_hr>180)] <- 1
CHP$unstable_hr[(CHP$age*365.25) > 365 & (CHP$age) < 3 & (CHP$vitals_hr<98 | CHP$vitals_hr>140)] <- 1
CHP$unstable_hr[(CHP$age) >= 3 & (CHP$age) < 6 & (CHP$vitals_hr<80 | CHP$vitals_hr>120)] <- 1
CHP$unstable_hr[(CHP$age) >= 6 & (CHP$age) < 10 & (CHP$vitals_hr<75 | CHP$vitals_hr>118)] <- 1
CHP$unstable_hr[(CHP$age) >= 10 & (CHP$age) < 12 & (CHP$vitals_hr<75 | CHP$vitals_hr>118)] <- 1
CHP$unstable_hr[(CHP$age) >= 12 & (CHP$vitals_hr<60 | CHP$vitals_hr>100)] <- 1



#Respiratory rate
CHP$vitals_resp[CHP$admit_type==2] <- CHP$vitals_resp_ed[CHP$admit_type==2]
CHP$vitals_resp[CHP$admit_type==1] <- CHP$vitals_resp[CHP$admit_type==1]

CHP$unstable_resp <- NA
CHP$unstable_resp[!(is.na(CHP$vitals_resp))] <- 0
CHP$unstable_resp[(CHP$age*365.25) < 29 & (CHP$vitals_resp<30 | CHP$vitals_resp>53)] <- 1
CHP$unstable_resp[(CHP$age*365.25) >= 29 & (CHP$age*365.25) <= 365 & (CHP$vitals_resp<30 | CHP$vitals_resp>53)] <- 1
CHP$unstable_resp[(CHP$age*365.25) > 365 & (CHP$age) < 3 & (CHP$vitals_resp<22 | CHP$vitals_resp>37)] <- 1
CHP$unstable_resp[(CHP$age) >= 3 & (CHP$age) < 6 & (CHP$vitals_resp<20 | CHP$vitals_resp>28)] <- 1
CHP$unstable_resp[(CHP$age) >= 6 & (CHP$age) < 10 & (CHP$vitals_resp<18 | CHP$vitals_resp>25)] <- 1
CHP$unstable_resp[(CHP$age) >= 10 & (CHP$age) < 12 & (CHP$vitals_resp<18 | CHP$vitals_resp>25)] <- 1
CHP$unstable_resp[(CHP$age) >= 12 & (CHP$vitals_resp<12 | CHP$vitals_resp>20)] <- 1


#Blood Pressure
library(tidyr)
CHP$vitals_bp_ed2 <- CHP$vitals_bp_ed
CHP$vitals_bp2 <- CHP$vitals_bp
CHP <- separate(data = CHP, col = vitals_bp_ed2, into = c("vitals_sbp_ed", "vitals_dbp_ed"), sep = "/")
CHP <- separate(data = CHP, col = vitals_bp2, into = c("vitals_sbp", "vitals_dbp"), sep = "/")
CHP$vitals_sbp_ed <- as.numeric(CHP$vitals_sbp_ed)
CHP$vitals_sbp <- as.numeric(CHP$vitals_sbp)
CHP$vitals_dbp_ed <- as.numeric(CHP$vitals_dbp_ed)
CHP$vitals_dbp <- as.numeric(CHP$vitals_dbp)



CHP$vitals_sbp[CHP$admit_type==2] <- CHP$vitals_sbp_ed[CHP$admit_type==2]
CHP$vitals_sbp[CHP$admit_type==1] <- CHP$vitals_sbp[CHP$admit_type==1]
CHP$vitals_dbp[CHP$admit_type==2] <- CHP$vitals_dbp_ed[CHP$admit_type==2]
CHP$vitals_dbp[CHP$admit_type==1] <- CHP$vitals_dbp[CHP$admit_type==1]

CHP$unstable_bp <- NA
CHP$unstable_bp[!(is.na(CHP$vitals_sbp) & is.na(CHP$vitals_dbp))] <- 0
CHP$unstable_bp[(CHP$age*365.25) < 29 & (CHP$vitals_sbp<67 | CHP$vitals_dbp<35)] <- 1
CHP$unstable_bp[(CHP$age*365.25) >= 29 & (CHP$age*365.25) <= 365 & (CHP$vitals_sbp<72 | CHP$vitals_dbp<37)] <- 1
CHP$unstable_bp[(CHP$age*365.25) > 365 & (CHP$age) < 3 & (CHP$vitals_sbp<86 | CHP$vitals_dbp<42)] <- 1
CHP$unstable_bp[(CHP$age) >= 3 & (CHP$age) < 6 & (CHP$vitals_sbp<89 | CHP$vitals_dbp<46)] <- 1
CHP$unstable_bp[(CHP$age) >= 6 & (CHP$age) < 10 & (CHP$vitals_sbp<97 | CHP$vitals_dbp<57)] <- 1
CHP$unstable_bp[(CHP$age) >= 10 & (CHP$age) < 12 & (CHP$vitals_sbp<102 | CHP$vitals_dbp<61)] <- 1
CHP$unstable_bp[(CHP$age) >= 12 & (CHP$vitals_sbp<110 | CHP$vitals_dbp<64)] <- 1


#Temperature
CHP$vitals_tp[CHP$admit_type==2] <- as.numeric(CHP$vitals_temp_ed[CHP$admit_type==2])
CHP$vitals_tp[CHP$admit_type==1] <- as.numeric(CHP$vitals_temp[CHP$admit_type==1])

CHP$unstable_tp <- NA
CHP$unstable_tp[!(is.na(CHP$vitals_tp))] <- 0

CHP$unstable_tp[CHP$vitals_tp < 35 | CHP$vitals_tp > 38] <- 1



#02sat
CHP$vitals_o2[CHP$admit_type==2] <- as.numeric(CHP$vitals_o2sat_ed[CHP$admit_type==2])
CHP$vitals_o2[CHP$admit_type==1] <- as.numeric(CHP$vitals_o2sat[CHP$admit_type==1])

CHP$unstable_o2 <- NA
CHP$unstable_o2[!(is.na(CHP$vitals_o2))] <- 0

CHP$unstable_o2[CHP$vitals_o2 < 92] <- 1


#Length of stay
CHP$`Registration2`<- as.numeric(as.POSIXct(CHP$`Registration`))
CHP$`Discharge2` <- as.numeric(as.POSIXct(CHP$`Discharge`))

CHP$los <- (CHP$`Discharge2`- CHP$`Registration2`)/60/60

CHP$readmission <- 1
CHP$readmission[is.na(CHP$`First Readmission (if yes, specify date)`)] <- 0



##Brief variables##
#color
CHP$abnormal_color <- 0
CHP$abnormal_color[CHP$admit_type==1 & (CHP$brief_color___4==1 | CHP$brief_color___5==1 |
                                          CHP$brief_color___6==1 | CHP$brief_color___7==1 |
                                          CHP$brief_color___8==1 | CHP$brief_color___9==1 |
                                          CHP$brief_color___10==1)] <- 1
CHP$abnormal_color[CHP$admit_type==2 & (CHP$brief_color_ed___4==1 | CHP$brief_color_ed___2==1)] <- 1

#behavior
CHP$abnormal_behav <- 0
CHP$abnormal_behav[CHP$admit_type==1 & CHP$brief_behav___11==1] <- 1
CHP$abnormal_behav[CHP$admit_type==2 & CHP$brief_loc_ed___2+
                     CHP$brief_loc_ed___3+
                     CHP$brief_loc_ed___4+
                     CHP$brief_loc_ed___8+
                     CHP$brief_loc_ed___9+
                     CHP$brief_loc_ed___10>0] <- 1



#caprefil
table(CHP$brief_caprefill_ed)
table(CHP$brief_caprefill)
CHP$brief_cap[CHP$admit_type==1] <- CHP$brief_caprefill[CHP$admit_type==1]
CHP$brief_cap[CHP$admit_type==2] <- CHP$brief_caprefill_ed[CHP$admit_type==2]
CHP$brief_cap[CHP$brief_cap==''] <- NA
CHP$abnormal_cap <- NA
CHP$abnormal_cap[!(is.na(CHP$brief_cap))] <- 0
CHP$abnormal_cap[CHP$brief_cap %in% c('7','8')] <- 1



C_sub <- CHP %>% select(studyid, site, admitreason, admit_type, age, gender, payer, race, language, pcp, unstable_hr, unstable_resp,
                        unstable_bp, unstable_tp, unstable_o2, first_clinical_assessment, first_clinical_management, first_labs_imaging,
                        first_medication_admin, rapid_response, tran_icu, los, readmission, admission_date, abnormal_cap, abnormal_color, 
                        abnormal_behav,first_labs_imaging, first_labs_imaging2,
                        first_pain_meds,first_antibiotics, first_other_tx, first_popg_fluids, first_iv_fluids, starts_with('labs'), starts_with('imaging'),
                        first_lab_ed, first_lab_da, first_imaging_ed, first_imaging_da, first_management_from_unit, time_arrival_admitting, 
                        time_arrival_ed, arrive_month, labglu_ed, labglu_da, second_lab, arrive_block, cov_block)

#move these labs to the end so the columns line up with NCH and PRMC
C_sub <- C_sub %>% select(-labs_ed___26, -labs___26)
C_sub$labs___26 <- CHP$labs___26
C_sub$labs_ed___26 <- CHP$labs_ed___26


##########
###PRMC###
##########

PRMC$language <- case_when(PRMC$language_prov==1~'English',
                           PRMC$language_prov==2~'Spanish')

PRMC$race <- case_when(
  (PRMC$`race_prov` == 3 & PRMC$`ethnicity_prov` == 2)~'Non-Hispanic Black',
  (PRMC$`race_prov` == 5 & PRMC$`ethnicity_prov` == 2)~'Non-Hispanic White',
  ((PRMC$`race_prov` == 1 | 
      PRMC$`race_prov` == 4 | PRMC$`race_prov` == 6 |PRMC$`race_prov` == 7) & 
     PRMC$`ethnicity_prov` == 2)~'Non-Hispanic Other Race',
  PRMC$`race_prov` == 2 & PRMC$`ethnicity_prov` == 2~'Non-Hispanic Asian',
  PRMC$`ethnicity_prov` == 1~'Hispanic',
  (PRMC$`race_prov` == 'Not Specified' | PRMC$`race_prov` == 'PATIENT DECLINED')~'Missing'
  
)


PRMC$gender <- case_when(
  PRMC$gender_prov==1~'Male',
  PRMC$gender_prov==2~'Female'
)


PRMC$payer <- case_when(
  PRMC$payer_prov == 1~'Commercial',
  PRMC$payer_prov == 2~'Medicaid',
  (PRMC$payer_prov == 3 |
     PRMC$payer_prov == 4 |
     PRMC$payer_prov == 5)~'Other'
)



PRMC$admitreason <- case_when(PRMC$admit_reason_prov==3~1,
                              PRMC$admit_reason_prov==5~2,
                              (PRMC$admit_reason_prov==1 |PRMC$admit_reason_prov==2)~3,
                              PRMC$admit_reason_prov==4~4,
                              PRMC$admit_reason_prov==6~5,
                              PRMC$admit_reason_prov==7~6,
                              (PRMC$admit_reason_prov==8 |PRMC$admit_reason_prov==9 |PRMC$admit_reason_prov==10)~7)

PRMC$admit_type <- PRMC$admit_type_prov


###vitals###
#Heart rate
PRMC$vitals_hr[PRMC$admit_type==2] <- PRMC$vitals_hr_ed_prov[PRMC$admit_type==2]
PRMC$vitals_hr[PRMC$admit_type==1] <- PRMC$vitals_hr_prov[PRMC$admit_type==1]

PRMC$unstable_hr <- NA
PRMC$unstable_hr[!(is.na(PRMC$vitals_hr))] <- 0
PRMC$unstable_hr[(PRMC$age*365.25) < 29 & (PRMC$vitals_hr<100 | PRMC$vitals_hr>205)] <- 1
PRMC$unstable_hr[(PRMC$age*365.25) >= 29 & (PRMC$age*365.25) <= 365 & (PRMC$vitals_hr<100 | PRMC$vitals_hr>180)] <- 1
PRMC$unstable_hr[(PRMC$age*365.25) > 365 & (PRMC$age) < 3 & (PRMC$vitals_hr<98 | PRMC$vitals_hr>140)] <- 1
PRMC$unstable_hr[(PRMC$age) >= 3 & (PRMC$age) < 6 & (PRMC$vitals_hr<80 | PRMC$vitals_hr>120)] <- 1
PRMC$unstable_hr[(PRMC$age) >= 6 & (PRMC$age) < 10 & (PRMC$vitals_hr<75 | PRMC$vitals_hr>118)] <- 1
PRMC$unstable_hr[(PRMC$age) >= 10 & (PRMC$age) < 12 & (PRMC$vitals_hr<75 | PRMC$vitals_hr>118)] <- 1
PRMC$unstable_hr[(PRMC$age) >= 12 & (PRMC$vitals_hr<60 | PRMC$vitals_hr>100)] <- 1



#Respiratory rate
PRMC$vitals_resp[PRMC$admit_type==2] <- PRMC$vitals_resp_ed_prov[PRMC$admit_type==2]
PRMC$vitals_resp[PRMC$admit_type==1] <- PRMC$vitals_resp_prov[PRMC$admit_type==1]

PRMC$unstable_resp <- NA
PRMC$unstable_resp[!(is.na(PRMC$vitals_resp))] <- 0
PRMC$unstable_resp[(PRMC$age*365.25) < 29 & (PRMC$vitals_resp<30 | PRMC$vitals_resp>53)] <- 1
PRMC$unstable_resp[(PRMC$age*365.25) >= 29 & (PRMC$age*365.25) <= 365 & (PRMC$vitals_resp<30 | PRMC$vitals_resp>53)] <- 1
PRMC$unstable_resp[(PRMC$age*365.25) > 365 & (PRMC$age) < 3 & (PRMC$vitals_resp<22 | PRMC$vitals_resp>37)] <- 1
PRMC$unstable_resp[(PRMC$age) >= 3 & (PRMC$age) < 6 & (PRMC$vitals_resp<20 | PRMC$vitals_resp>28)] <- 1
PRMC$unstable_resp[(PRMC$age) >= 6 & (PRMC$age) < 10 & (PRMC$vitals_resp<18 | PRMC$vitals_resp>25)] <- 1
PRMC$unstable_resp[(PRMC$age) >= 10 & (PRMC$age) < 12 & (PRMC$vitals_resp<18 | PRMC$vitals_resp>25)] <- 1
PRMC$unstable_resp[(PRMC$age) >= 12 & (PRMC$vitals_resp<12 | PRMC$vitals_resp>20)] <- 1


#Blood Pressure
library(tidyr)
PRMC$vitals_bp_ed_prov2 <- PRMC$vitals_bp_ed_prov
PRMC$vitals_bp_prov2 <- PRMC$vitals_bp_prov
PRMC <- separate(data = PRMC, col = vitals_bp_ed_prov2, into = c("vitals_sbp_ed_prov", "vitals_dbp_ed_prov"), sep = "/")
PRMC <- separate(data = PRMC, col = vitals_bp_prov2, into = c("vitals_sbp_prov", "vitals_dbp_prov"), sep = "/")
PRMC$vitals_sbp_ed_prov <- as.numeric(PRMC$vitals_sbp_ed_prov)
PRMC$vitals_sbp_prov <- as.numeric(PRMC$vitals_sbp_prov)
PRMC$vitals_dbp_ed_prov <- as.numeric(PRMC$vitals_dbp_ed_prov)
PRMC$vitals_dbp_prov <- as.numeric(PRMC$vitals_dbp_prov)


PRMC$vitals_sbp[PRMC$admit_type==2] <- PRMC$vitals_sbp_ed_prov[PRMC$admit_type==2]
PRMC$vitals_sbp[PRMC$admit_type==1] <- PRMC$vitals_sbp_prov[PRMC$admit_type==1]
PRMC$vitals_dbp[PRMC$admit_type==2] <- PRMC$vitals_dbp_ed_prov[PRMC$admit_type==2]
PRMC$vitals_dbp[PRMC$admit_type==1] <- PRMC$vitals_dbp_prov[PRMC$admit_type==1]

PRMC$unstable_bp <- NA
PRMC$unstable_bp[!(is.na(PRMC$vitals_sbp) & is.na(PRMC$vitals_dbp))] <- 0
PRMC$unstable_bp[(PRMC$age*365.25) < 29 & (PRMC$vitals_sbp<67 | PRMC$vitals_dbp<35)] <- 1
PRMC$unstable_bp[(PRMC$age*365.25) >= 29 & (PRMC$age*365.25) <= 365 & (PRMC$vitals_sbp<72 | PRMC$vitals_dbp<37)] <- 1
PRMC$unstable_bp[(PRMC$age*365.25) > 365 & (PRMC$age) < 3 & (PRMC$vitals_sbp<86 | PRMC$vitals_dbp<42)] <- 1
PRMC$unstable_bp[(PRMC$age) >= 3 & (PRMC$age) < 6 & (PRMC$vitals_sbp<89 | PRMC$vitals_dbp<46)] <- 1
PRMC$unstable_bp[(PRMC$age) >= 6 & (PRMC$age) < 10 & (PRMC$vitals_sbp<97 | PRMC$vitals_dbp<57)] <- 1
PRMC$unstable_bp[(PRMC$age) >= 10 & (PRMC$age) < 12 & (PRMC$vitals_sbp<102 | PRMC$vitals_dbp<61)] <- 1
PRMC$unstable_bp[(PRMC$age) >= 12 & (PRMC$vitals_sbp<110 | PRMC$vitals_dbp<64)] <- 1


#Temperature
PRMC$vitals_tp[PRMC$admit_type==2] <- PRMC$vitals_temp_ed_prov[PRMC$admit_type==2]
PRMC$vitals_tp[PRMC$admit_type==1] <- PRMC$vitals_temp_prov[PRMC$admit_type==1]

PRMC$unstable_tp <- NA
PRMC$unstable_tp[!(is.na(PRMC$vitals_tp))] <- 0

PRMC$unstable_tp[PRMC$vitals_tp < 35 | PRMC$vitals_tp > 38] <- 1


#02sat
PRMC$vitals_o2[PRMC$admit_type==2] <- PRMC$vitals_o2sat_ed_prov[PRMC$admit_type==2]
PRMC$vitals_o2[PRMC$admit_type==1] <- PRMC$vitals_o2sat_prov[PRMC$admit_type==1]

PRMC$unstable_o2 <- NA
PRMC$unstable_o2[!(is.na(PRMC$vitals_o2))] <- 0

PRMC$unstable_o2[PRMC$vitals_o2 < 92] <- 1

PRMC$pcp <- PRMC$pcp_prov

PRMC$rapid_response <- PRMC$rapid_response_prov
PRMC$tran_icu <- PRMC$tran_icu_prov


#Los and readmission (from admin data -- many files need to be combined)
p1 <- read_excel('C:/Users/sfrey/Downloads/1_PRMCE_admin data_Feb.Mar2020_revSCA (2001-2035).xlsx', sheet=1)
p2 <- read_excel('C:/Users/sfrey/Downloads/2_PRMCE_admin data_202004_05_revSCA (2036-2041).xlsx', sheet=1)
p3 <- read_excel('C:/Users/sfrey/Downloads/3_PRMCE_admin data_202006_rev (2042-2056).xlsx', sheet=1)
p4 <- read_excel('C:/Users/sfrey/Downloads/4_PRMCE_admin data_202007 to 11_Rev (2058-2119).xlsx', sheet=1)
p4 <- p4[!(p4$`Study ID`=='2091' & is.na(p4$`IP Admission Date`)),]
p5 <- read_excel('C:/Users/sfrey/Downloads/5_Pediatric_Unit_Dec 2020 through Feb 2021 (2120-2182).xlsx', sheet=1)
p5 <- p5[!(p5$`Study ID`=='2170' & p5$ADMIT_TYPE=='Urgent'),]
p6 <- read_excel('C:/Users/sfrey/Downloads/6_PRMCE_Admin Data_2183 to 2303.xlsx', sheet=1)
p6 <- p6[!(p6$`Study ID`=='2216' & p6$ADMIT_ICD10=='E86.0'),]
p6 <- p6[!(p6$`Study ID`=='2251' & p6$ADMIT_ICD10=='N13.70'),]

p1$studyid <- as.numeric(p1$`Study ID`)
p2$studyid <- as.numeric(p2$`Study ID`)
p3$studyid <- as.numeric(p3$`Study ID`)
p4$studyid <- as.numeric(p4$`Study ID`)
p5$studyid <- as.numeric(p5$`Study ID`)
p6$studyid <- as.numeric(p6$`Study ID`)

p1 <- p1 %>% select(studyid, `Readmit Date`, `Admission Date`, `Discharge Date`)
p2 <- p2 %>% select(studyid, `Readmit Date`, `Admission Date`, `Discharge Date`)
p3 <- p3 %>% select(studyid, `Readmit Date`, `Admission Date`, `Discharge Date`)
p4 <- p4 %>% select(studyid, `Readmit Date`, `Admission Date`, `Discharge Date`)
p5 <- p5 %>% select(studyid, READMIT_DATE, ADMISSION_DATE, DISCHARGE_DATE)
p6 <- p6 %>% select(studyid, READMIT_DATE, ADMISSION_DATE, DISCHARGE_DATE)
colnames(p5) <- colnames(p6) <- colnames(p4)
p1 <- p1[p1$studyid>=2001 & p1$studyid<=2035,]
p2 <- p2[p2$studyid>=2036 & p2$studyid<=2041,]
p3 <- p3[p3$studyid>=2042 & p3$studyid<=2056,]
p4 <- p4[(p4$studyid>=2058 & p4$studyid<=2119) | (p4$studyid>=2136 & p4$studyid<=2140),]
p5 <- p5[p5$studyid>=2120 & p5$studyid<=2182,]
p6 <- p6[p6$studyid>=2183 & p6$studyid<=2303,]
p <- distinct(rbind(p1,p2,p3,p4,p5,p6))
p <- inner_join(p, elig3, 'studyid')

PRMC <- left_join(PRMC, p, 'studyid')

PRMC$disdate <- as.numeric(as.POSIXct(PRMC$`Discharge Date`))
PRMC$regdate <- as.numeric(as.POSIXct(PRMC$`Admission Date`))

PRMC$los <- (PRMC$disdate-PRMC$regdate)/60/60


PRMC$readmission <- 1
PRMC$readmission[is.na(PRMC$`Readmit Date`)] <- 0

PRMC$site <- 'PRMC'
PRMC$admission_date <- as.numeric(as.POSIXct(PRMC$`Admission Date`))

##Brief variables##
#color
PRMC$abnormal_color <- NA
PRMC$abnormal_color[!(is.na(PRMC$brief_color_ed_prov))] <- 0
PRMC$abnormal_color[PRMC$brief_color_ed_prov %in% c(4,5,6)] <- 1


#behavior
table(PRMC$brief_behav_prov)
table(PRMC$brief_behav_ed_prov)
PRMC$brief_behav[PRMC$admit_type==1] <- PRMC$brief_behav_prov[PRMC$admit_type==1]
PRMC$brief_behav[PRMC$admit_type==2] <- PRMC$brief_behav_ed_prov[PRMC$admit_type==2]
PRMC$abnormal_behav <- NA
PRMC$abnormal_behav[!(is.na(PRMC$brief_behav))] <- 0
PRMC$abnormal_behav[PRMC$admit_type==2 & PRMC$brief_behav==4] <- 1


#caprefil
table(PRMC$brief_caprefill_ed_prov)
table(PRMC$brief_caprefill_prov)
PRMC$brief_cap[PRMC$admit_type==1] <- PRMC$brief_caprefill_prov[PRMC$admit_type==1]
PRMC$brief_cap[PRMC$admit_type==2] <- PRMC$brief_caprefill_ed_prov[PRMC$admit_type==2]
PRMC$brief_cap[PRMC$brief_cap==''] <- NA
PRMC$abnormal_cap <- NA
PRMC$abnormal_cap[!(is.na(PRMC$brief_cap))] <- 0
PRMC$abnormal_cap[PRMC$brief_cap %in% c('7','8')] <- 1
table(PRMC$abnormal_cap)



P_sub <- PRMC %>% select(studyid, site, admitreason, admit_type, age, gender, payer, race, language, pcp, unstable_hr, unstable_resp,
                         unstable_bp, unstable_tp, unstable_o2, first_clinical_assessment, first_clinical_management, first_labs_imaging,
                         first_medication_admin, rapid_response, tran_icu, los, readmission, admission_date, abnormal_cap, abnormal_color, 
                         abnormal_behav,first_labs_imaging, first_labs_imaging2,
                         first_pain_meds,first_antibiotics, first_other_tx, first_popg_fluids, first_iv_fluids, starts_with('labs'), starts_with('imaging'),
                         first_lab_ed, first_lab_da, first_imaging_ed, first_imaging_da, first_management_from_unit, time_arrival_admitting, 
                         time_arrival_ed, arrive_month, labglu_ed, labglu_da, second_lab, arrive_block, cov_block)

P_sub$labs_ed___26 <- 0
P_sub$labs___26 <- 0


#Combine NCH, CHP, PRMC
colnames(N_sub) <- colnames(C_sub)
colnames(P_sub) <- colnames(C_sub)

All <- rbind(N_sub, C_sub, P_sub)


#PMCA
##PMCA Algorithm run in SAS. Dx file prepared in PMCA_PCORI_setup.R 
pmca <- read.csv('C:/Users/sfrey/Downloads/PMCA_values.csv')
All <- left_join(All, pmca, 'studyid')

All$payer[All$payer=='Self'] <- 'Other'
All$admitreason[All$admitreason>5] <- 5
All$race[is.na(All$race)] <- 'Missing'
All$language[!(All$language %in% c('English'))] <- 'Other'

#Number of tests
All$numtests <- All$labs___2+All$labs___3+
  All$labs___4+All$labs___6+All$labs___7+
  All$labs___8+All$labs___9+All$labs___10+
  All$labs___11+All$labs___12+All$labs___13+
  All$labs___14+All$labs___15+All$labs___16+
  All$labs___17+All$labs___18+All$labs___19+
  All$labs___20+All$labs___21+All$labs___22+
  All$labs___23+All$labs___24+All$labs___25+
  All$labs___26+All$labs___27+All$labs___28+
  All$labs___29+
  All$labs_ed___2+All$labs_ed___3+
  All$labs_ed___4+All$labs_ed___6+All$labs_ed___7+
  All$labs_ed___8+All$labs_ed___9+All$labs_ed___10+
  All$labs_ed___11+All$labs_ed___12+All$labs_ed___13+
  All$labs_ed___14+All$labs_ed___15+All$labs_ed___16+
  All$labs_ed___17+All$labs_ed___18+All$labs_ed___19+
  All$labs_ed___20+All$labs_ed___21+All$labs_ed___22+
  All$labs_ed___23+All$labs_ed___24+All$labs_ed___25+
  All$labs_ed___26+All$labs_ed___27+All$labs_ed___28+
  All$labs_ed___29+
  All$imaging___2+All$imaging___3+
  All$imaging___5+All$imaging___6+All$imaging___7+
  All$imaging___8+All$imaging___10+
  All$imaging___11+All$imaging___12+
  All$imaging___14+All$imaging___15+All$imaging___16+
  All$imaging___17+
  All$imaging_ed___2+All$imaging_ed___3+
  All$imaging_ed___5+All$imaging_ed___6+All$imaging_ed___7+
  All$imaging_ed___8+All$imaging_ed___10+
  All$imaging_ed___11+All$imaging_ed___12+
  All$imaging_ed___14+All$imaging_ed___15+All$imaging_ed___16+
  All$imaging_ed___17

#More than 1 lab
All$multilab <- 1
All$multilab[is.na(All$second_lab)] <- 0

#Short LOS
All$shortlos <- 1
All$shortlos[All$los>=24] <- 0

##############Only including those after DA training###############

practices <- read_excel('C:/Users/sfrey/Downloads/Randomization Groups & Dates.xlsx')
practices$start_date <- 0
practices$start_date[3:20] <- as.numeric(as.POSIXct('2020-02-01 00:00:00')) 
practices$start_date[21:38] <- as.numeric(as.POSIXct('2020-08-01 00:00:00')) 
practices$start_date[39:54] <- as.numeric(as.POSIXct('2021-02-01 00:00:00')) 
practices$start_date[55:71] <- as.numeric(as.POSIXct('2021-11-01 00:00:00'))

practices <- practices[practices$start_date != 0,]
practices$pcp <- as.numeric(practices$REDCap)
practices <- practices %>% select(pcp, start_date, Practice.group)

All <- left_join(All, practices, 'pcp')
All$keep <- 1
All$drop[All$admission_date<All$start_date] <- 0
All$drop <- 0
All$drop[All$admission_date<All$start_date] <- 1
table(All$drop)

All_primary <- All[All$drop==0,]
