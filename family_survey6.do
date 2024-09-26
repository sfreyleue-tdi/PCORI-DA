/********************************************************************
* Pull in files
	* Pulls in all versions of the family surveytype
	* Applies the proper labels
	* Appends all files into one dataset
*********************************************************************/

* pull in smartphone1
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_2\2_FamilySurveySmartphone1_DATA_2020-07-30.csv, clear
rename v67 family_experience_of_v_1
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\smartphone1labels.do"
gen surveytype="sp1"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_care_other, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\smartphone1.dta", replace

* pull in smartphone2
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\40_FamilySurveyEnglishSP2_DATA_2023-07-19.csv, clear
rename v91 family_experience_of_v_1
rename ïrecord_id record_id
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\smartphone2labels.do"
gen surveytype="sp2"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_4_phone_other fec_4_video_other fec_4_inperson_other, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\smartphone2.dta", replace

* pull in original 
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_2\2_FamilySurveyEnglish_DATA_2020-07-30.csv, clear
rename v67 family_experience_of_v_1
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\origlabels.do"
gen surveytype="orig"
replace fec_study_id="3038" if fec_study_id=="3038!"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_care_other, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\orig.dta", replace

* pull in spanish version of original
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_2\2_FamilySurveySpanish_DATA_2020-07-30.csv, clear
rename v67 family_experience_of_v_1
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\origlabels.do"
gen surveytype="orig-sp"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_care_other fec_36, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\orig_sp.dta", replace

* pull in nepalese version of smartphone2
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\35_FamilySurveyNepaliSP2_DATA_2023-01-30.csv, clear
rename v91 family_experience_of_v_1
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\smartphone2labels.do"
gen surveytype="sp2-np"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_36 fec_4_inperson_other fec_4_phone_other fec_4_video_other fec_pcp_covid_comments, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\sp2_np.dta", replace

* pull in spanish version of smartphone2
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\40_FamilySurveySpanishSP2_DATA_2023-07-19.csv, clear
rename v91 family_experience_of_v_1
rename ïrecord_id record_id
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\smartphone2labels.do"
gen surveytype="sp2-sp"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_36 fec_4_inperson_other fec_4_phone_other fec_4_video_other fec_pcp_covid_comments, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\sp2_sp.dta", replace

* pull in somali version of smartphone2
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\35_FamilySurveySomaliSP2_DATA_2023-01-30.csv, clear
rename v91 family_experience_of_v_1
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\smartphone2labels.do"
gen surveytype="sp2-so"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_36 fec_4_inperson_other fec_4_phone_other fec_4_video_other fec_pcp_covid_comments, replace
save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\sp2_so.dta", replace

* pull in arabic version of smartphone2
import delimited C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\35_FamilySurveyArabicSP2_DATA_2023-01-30.csv, clear
rename v91 family_experience_of_v_1
rename ïrecord_id record_id
rename family_experience_of_care_survey family_experience_of_v_0
do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\smartphone2labels.do"
gen surveytype="sp2-ar"
tostring record_id fec_site fec_respondent_other fec_respondent_race_other fec_study_id fec_36 fec_4_inperson_other fec_4_phone_other fec_4_video_other fec_pcp_covid_comments, replace

* append files
append using "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\smartphone1.dta" "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\smartphone2.dta" "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\orig.dta" "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\orig_sp.dta" "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\sp2_np.dta" "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\sp2_sp.dta" "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\sp2_so.dta"

/********************************************************************
* Create Unified Variables
	* Harmonizes different question wordings into single variable
*********************************************************************/

gen fec_site_unified=""
replace fec_site_unified="NCH" if fec_site==1
replace fec_site_unified="PRMCE" if fec_site==2
replace fec_site_unified="CHP" if fec_site==3
label var fec_site_unified "Unified version of fec_site"

gen fec_3_unified=fec_3
replace fec_3_unified=1 if fec_3_type==1 | fec_3_type==3
replace fec_3_unified=0 if fec_3_type==0 | fec_3_type==2
label var fec_3_unified "Unified version of fec_3"
label values fec_3_unified fec_3_


foreach x in 1 2 3 4 5 6 7 8 {
gen fec_4_`x'_unified=0
replace fec_4_`x'_unified=1 if fec_4___`x'==1 | fec_4_phone___`x'==1 | fec_4_inperson___`x'==1 | fec_4_video___`x'==1
label var fec_4_`x' "Unified version of fec_4_`x'"
label values fec_4_`x' fec_4___`x'_
}

gen fec_4_other_unified=""
replace fec_4_other_unified=fec_care_other if surveytype=="orig" | surveytype=="orig-sp"
replace fec_4_other_unified=fec_care_other if surveytype=="sp1"
replace fec_4_other_unified="" if surveytype=="sp2" | surveytype=="sp2-sp" | surveytype=="sp2-np"
label var fec_4_other "Unified version of fec_4_other"

foreach x in 9 10 15 16 17 18 23 24 25 26 27 28 29 30 31 32 33 34 35 { 
gen fec_`x'_unified=fec_`x'
replace fec_`x'_unified=fec_`x'_phone if surveytype=="sp1" | surveytype=="sp2" | surveytype=="sp2-np" | surveytype=="sp2-sp"
label var fec_`x'_unified "Unified version of fec_`x'"
label values fec_`x'_unified fec_`x'_
}

foreach var of varlist fec_9_unified fec_10_unified fec_15_unified fec_16_unified fec_17_unified fec_18_unified fec_23_unified fec_24_unified fec_25_unified fec_26_unified fec_27_unified fec_28_unified fec_29_unified fec_30_unified fec_31_unified fec_32_unified fec_33_unified fec_34_unified fec_35_unified fec_3_unified fec_site_unified fec_4_1_unified fec_4_2_unified fec_4_3_unified fec_4_4_unified fec_4_5_unified fec_4_6_unified fec_4_7_unified fec_4_8_unified fec_4_other_unified {

tab `var' surveytype, mi

}

/********************************************************************
* Clean Up
	* Drops cases where necessary
	* Recodes study ID where necessary
	* Pulls in admit_dx 
	* Exports family_survey_recoded_'date' files
*********************************************************************/


order record_id redcap_survey_identifier surveytype
sort fec_study_id
drop if fec_study_id=="2002b" | fec_study_id=="7777" | fec_study_id=="3362"
replace fec_study_id="3325" if substr(fec_study_id,1,4)=="3325"
replace fec_study_id="3329" if substr(fec_study_id,1,4)=="3329"

replace fec_study_id=substr(fec_study_id,3,4) if substr(fec_study_id,1,2)=="  "

save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\family_survey_recoded_20230724.dta", replace

do "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\add.admit_dx_to_family_survey.do"

use "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\extra_variables_family_survey_20230724.dta", clear
tostring fec_study_id, replace
sort fec_study_id

merge 1:m fec_study_id using "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\family_survey_recoded_20230724.dta", gen(merge)

keep if merge==3

*hard remove observations
replace fec_study_id="****" if record_id == "1696"

foreach x in 0030 63 0179 1609 55 1261 1261-2 1341 1572-1 1603 1603-2 119 2071-1 2071-2 82 3293-1 3293-2 3400 3677 3707 3713 3722 1703-2 3698 3698-2 3698-3 3698-4{
drop if record_id == "`x'"
}
drop if record_id=="1703" & surveytype=="sp2-sp"
drop if record_id=="1605" & surveytype=="sp2-so"
drop if record_id=="0063 - duplicate"
drop if record_id=="0127 - delete"
drop if record_id=="0179 - delete"
drop if record_id=="0291-delete"

drop if record_id=="0127 - delete2"
drop if record_id=="0168 - delete"
drop if record_id=="0267 - delete"
drop if record_id=="1348 - delete"
drop if record_id=="1609 - delete"
drop if record_id=="1610 - delete"
drop if record_id=="1611 - delete"
drop if record_id=="4002-delete"
drop if record_id=="4002-delete2"
drop if record_id=="4002-delete3"
drop if record_id=="4055-delete"
drop if record_id=="4064- delete"
drop if record_id=="1612- delete"
drop if record_id=="4095- delete"
drop if record_id=="4095 - delete"
drop if record_id=="4135- delete"
drop if record_id=="4136- delete"
drop if record_id=="4240- delete"
drop if record_id=="4306- delete"
drop if record_id=="4359 - delete"
drop if record_id=="4476- delete"
drop if record_id=="4467-delete"
drop if record_id=="0030 - delete"

drop if record_id=="4491- delete"
drop if record_id=="4512- delete"
drop if record_id=="0666 - delete"
drop if record_id=="0752-delete"
drop if record_id=="0848 - delete"
drop if record_id=="0992-delete"

drop if record_id=="1652-p"
drop if record_id=="1500-p"
drop if record_id=="1652S"
drop if record_id=="1607 - delete"
drop if fec_study_id=="Steph-Fake"
drop if fec_study_id=="x"
drop if missing(fec_study_id) | fec_study_id=="."
replace fec_study_id="1632" if record_id=="1623" & surveytype=="sp2"

drop if record_id=="3763"
drop if record_id=="3810"
drop if record_id=="4177"
drop if record_id=="4250"
drop if record_id=="4252"
drop if record_id=="4157"
drop if record_id=="1611"
drop if record_id=="3800"
drop if record_id=="0815-1"
drop if fec_study_id=="4244"
drop if record_id=="3876"

drop if fec_study_id=="831"

replace admittype="DA" if fec_study_id=="2284"

/********************************************************************
* Analysis
	* Create Experience Domans
	* Check Missingness
	* Domains by Admit Type (primary / full)
	* Domains by Drop
	* Family survey recipients vs. non-recipients
*********************************************************************/
tab admittype

egen nonmiss=rownonmiss(fec_9_unified fec_10_unified fec_11 fec_12 fec_13 fec_14 fec_15_unified fec_21 fec_23_unified fec_24_unified fec_25_unified fec_26_unified fec_27_unified fec_29_unified)
tab nonmiss admittype
drop if nonmiss == 0

tab admittype

egen nm_toc=rownonmiss(fec_9_unified fec_10_unified)
egen nm_is=rownonmiss(fec_11 fec_12)
egen nm_ecd=rownonmiss(fec_13 fec_14 fec_15_unified fec_21)
egen nm_pfe=rownonmiss(fec_23_unified fec_24_unified fec_25_unified fec_26_unified fec_27_unified fec_29_unified)

tab nm_toc
tab nm_is
tab nm_ecd
tab nm_pfe

foreach var of varlist fec_9_unified fec_10_unified fec_11 fec_12 fec_13 fec_14 fec_15_unified fec_21 fec_23_unified fec_24_unified fec_25_unified fec_26_unified fec_27_unified fec_29_unified {
tab `var', mi
} 

gen mistake1 = fec_21==2
gen mistake2 = fec_22==2
replace mistake1=. if missing(fec_21)
replace mistake2=. if missing(fec_22)
replace mistake2=. if fec_21==0

gen pfe1 = fec_23_unified==3
gen pfe2 = fec_24_unified==3
gen pfe3 = fec_26_unified==3
gen pfe4 = fec_25_unified==3
gen pfe5 = fec_27_unified==3
gen pfe6 = fec_29_unified==3
egen pfe=rowmean(pfe1-pfe6) if nm_pfe > 0

gen is1 = fec_11==2
gen is2 = fec_12==2
egen is=rowmean(is1-is2) if nm_is > 0

gen ecd1 = fec_21==0
gen ecd2 = fec_15_unified==0
gen ecd3 = fec_13==2
gen ecd4 = fec_14==0
egen ecd=rowmean(ecd1-ecd4) if nm_ecd >0

gen toc1 = (fec_9_unified==0 | fec_9_unified==1)
gen toc2 = (fec_10_unified==0 | fec_10_unified==1)
egen toc=rowmean(toc1-toc2) if nm_toc > 0

egen nm_fec=rownonmiss(pfe is ecd toc)
egen fec=rowmean(pfe is ecd toc) if nm_fec == 4
tab fec, mi


*Domains by admit type (full)
tab admittype
ttest fec, by(admittype)
ttest pfe, by(admittype)
tab pfe1 admittype, col chi2
tab pfe2 admittype, col chi2
tab pfe3 admittype, col chi2
tab pfe4 admittype, col chi2
tab pfe5 admittype, col chi2
tab pfe6 admittype, col chi2

ttest is, by(admittype)
tab is1 admittype, col chi2
tab is2 admittype, col chi2

ttest ecd, by(admittype)
tab ecd1 admittype, col chi2
tab ecd2 admittype, col chi2
tab ecd3 admittype, col chi2
tab ecd4 admittype, col chi2

ttest toc, by(admittype)
tab toc1 admittype, col chi2
tab toc2 admittype, col chi2

tab mistake1 admittype, col chi2
tab mistake2 admittype, col chi2

*(primary)
tab admittype if drop==0
ttest fec if drop==0, by(admittype)
ttest pfe if drop==0, by(admittype)
tab pfe1 admittype if drop==0, col chi2
tab pfe2 admittype if drop==0, col chi2
tab pfe3 admittype if drop==0, col chi2
tab pfe4 admittype if drop==0, col chi2
tab pfe5 admittype if drop==0, col chi2
tab pfe6 admittype if drop==0, col chi2

ttest is if drop==0, by(admittype)
tab is1 admittype if drop==0, col chi2
tab is2 admittype if drop==0, col chi2

ttest ecd if drop==0, by(admittype)
tab ecd1 admittype if drop==0, col chi2
tab ecd2 admittype if drop==0, col chi2
tab ecd3 admittype if drop==0, col chi2
tab ecd4 admittype if drop==0, col chi2

ttest toc if drop==0, by(admittype)
tab toc1 admittype if drop==0, col chi2
tab toc2 admittype if drop==0, col chi2

tab mistake1 admittype if drop==0, col chi2
tab mistake2 admittype if drop==0, col chi2

*Domains by drop
tab drop
ttest fec, by(drop)
ttest pfe, by(drop)
tab pfe1 drop, col chi2
tab pfe2 drop, col chi2
tab pfe3 drop, col chi2
tab pfe4 drop, col chi2
tab pfe5 drop, col chi2
tab pfe6 drop, col chi2

ttest is, by(drop)
tab is1 drop, col chi2
tab is2 drop, col chi2

ttest ecd, by(drop)
tab ecd1 drop, col chi2
tab ecd2 drop, col chi2
tab ecd3 drop, col chi2
tab ecd4 drop, col chi2

ttest toc, by(drop)
tab toc1 drop, col chi2
tab toc2 drop, col chi2

tab mistake1 drop, col chi2
tab mistake2 drop, col chi2

export delimited fec_study_id is toc ecd pfe fec admittype site drop using "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\family_survey_for_seneca.csv", replace


* Analysis of timeliness variables and Table 1 for family survey participants vs non-participants
gen familysurvey=1

save "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\familysurvey.dta", replace
use "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\extra_variables_family_survey_20230724.dta", clear
tostring fec_study_id, replace
sort fec_study_id

merge 1:m fec_study_id using "C:\Users\aschaefer\Desktop\Leyenaar\PCORI\family_survey_6\familysurvey.dta", gen(merge1)
tab merge1
replace familysurvey=0 if merge1==1
destring first_clinical_assessment, force replace
destring first_labs_imaging, force replace
destring first_medication_admin, force replace

tab admittype familysurvey if drop==0, col chi2
tabstat age if drop==0, s(p25 p50 p75) by(familysurvey)
kwallis age if drop==0, by(familysurvey)
ttest age if drop==0, by(familysurvey)
tab gender familysurvey if drop==0, col chi2
tab payer familysurvey if drop==0, col chi2
tab admitreason familysurvey if drop==0, col chi2
tab race familysurvey if drop==0, col chi2
tab language familysurvey if drop==0, col chi2
tab pmca familysurvey if drop==0, col chi2
tab arrive_block familysurvey if drop==0, col chi2
tab site familysurvey if drop==0, col chi2

tabstat first_clinical_assessment if drop==0, s(p25 p50 p75) by(familysurvey)
kwallis first_clinical_assessment if drop==0, by(familysurvey)
ttest first_clinical_assessment if drop==0, by(familysurvey)

tabstat first_labs_imaging if drop==0, s(p25 p50 p75) by(familysurvey)
kwallis first_labs_imaging if drop==0, by(familysurvey)
ttest first_labs_imaging if drop==0, by(familysurvey)

tabstat first_medication_admin if drop==0, s(p25 p50 p75) by(familysurvey)
kwallis first_medication_admin if drop==0, by(familysurvey)
ttest first_medication_admin if drop==0, by(familysurvey)


tab admittype drop, col chi2
tabstat age, s(p25 p50 p75) by(drop)
kwallis age, by(drop)
ttest age, by(drop)
tab gender drop, col chi2
tab payer drop, col chi2
tab admitreason drop, col chi2
tab race drop, col chi2
tab language drop, col chi2
tab pmca drop, col chi2
tab arrive_block drop, col chi2
tab site drop, col chi2

tabstat first_clinical_assessment, s(p25 p50 p75) by(drop)
kwallis first_clinical_assessment, by(drop)
ttest first_clinical_assessment, by(drop)

tabstat first_labs_imaging, s(p25 p50 p75) by(drop)
kwallis first_labs_imaging, by(drop)
ttest first_labs_imaging, by(drop)

tabstat first_medication_admin, s(p25 p50 p75) by(drop)
kwallis first_medication_admin, by(drop)
ttest first_medication_admin, by(drop)

