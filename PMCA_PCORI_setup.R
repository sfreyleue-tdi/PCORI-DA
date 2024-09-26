library(readxl)
library(dplyr)
library(tidyr)
library(reshape2)
library(data.table)


#Get eligibility file
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
elig3 <- elig3[!(elig3$studyid %in% c(3111, 3115, 3242, 3270, 3273, 3391, 3581,1040,1055,1065,1093,1296,1327,1410,1451,1465,1835)),]



#########
###CHP###
#########

#Get all secondary diagnoses
CHP_sec_diag1 <- read_excel('PCORI Data Request 7.16.21 without identifiers (#3001-3404).xlsx', sheet=2)
CHP_sec_diag1 <- CHP_sec_diag1[,1:2]
y <- c('studyid', 'Dx Code')
colnames(CHP_sec_diag1) <- y
CHP_sec_diag2 <- read_excel('PCORI Data Request 2nd cohort 7.16.21s (#3404-3578) (1).xlsx', sheet=2)
CHP_sec_diag2 <- CHP_sec_diag2[,1:2]
colnames(CHP_sec_diag2) <- y

CHP_sec_diag3 <- read_excel('CHP PHM DA request 12.29.21 (#3579-3737).xlsx', sheet=2)
CHP_sec_diag99 <- read_excel('CHP PHM DA request 12.29.21 (#3579-3737).xlsx', sheet=1)
CHP_sec_diag3 <- CHP_sec_diag3[,c(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53)]
CHP_sec_diag3 <- gather(CHP_sec_diag3, variable, value, -'Study ID#')
CHP_sec_diag3 <- CHP_sec_diag3[,c(1,3)]
colnames(CHP_sec_diag3) <- y
CHP_sec_diag3 <- CHP_sec_diag3[!(is.na(CHP_sec_diag3$`Dx Code`)),]

#Get primary diagnosis
CHP_sec_diag4 <- read_excel('CHP PCORI Data Request 7.20.22 without identifiers.xlsx', sheet=2)
CHP_sec_diag4 <- CHP_sec_diag4[,1:2]
colnames(CHP_sec_diag4) <- y

CHP_sec_diag5 <- read_excel('complete_CHP_PHM_Direct_Admit_12.29.22_(3879-3906).xlsx', sheet=2)
CHP_sec_diag5 <- CHP_sec_diag5[,1:2]
colnames(CHP_sec_diag5) <- y

CHP_sec_diag6<- read_excel('PCORI Data Request 7.16.21 without identifiers (#3001-3404).xlsx', sheet=1)
CHP_sec_diag6 <- CHP_sec_diag6 %>% select(`Study ID#`, 'Admitting Diagnosis Code')
colnames(CHP_sec_diag6) <- y

CHP_sec_diag7 <- read_excel('PCORI Data Request 2nd cohort 7.16.21s (#3404-3578) (1).xlsx', sheet=1)
CHP_sec_diag7 <- CHP_sec_diag7 %>% select(`Study ID#`, 'Admitting Diagnosis Code')
colnames(CHP_sec_diag7) <- y

#Combine into all diagnoses
CHP_sec_diag <- distinct(rbind(CHP_sec_diag1, CHP_sec_diag2, CHP_sec_diag3, CHP_sec_diag4, CHP_sec_diag5, CHP_sec_diag6, CHP_sec_diag7))

#Remove period
CHP_sec_diag$`Dx Code` <- gsub('\\.', '', CHP_sec_diag$`Dx Code`)

#Sort by study ID
CHP_sec_diag <- CHP_sec_diag[order(CHP_sec_diag$studyid),]


#Convert long to wide
CHP_diags <- dcast(CHP_sec_diag, studyid~rowid(studyid, prefix = 'Dx_Code'))

#Rename Dx columns
x <- c('studyid')
for(i in 2:ncol(CHP_diags)){
  x <- c(x, paste(i-1, ' Diagnosis Code'))
}
colnames(CHP_diags) <- x

#Remove ineligible participants and retain only ID, diagnoses, and site
elig_da <- elig3 %>% select(studyid, `Admit Type`)
CHP_diags <- inner_join(CHP_diags, elig3, 'studyid')
CHP_diags <- CHP_diags[, c(1:33, 37)]

  
#########
###NCH###
#########

#Get all diagnoses
N1 <- read_excel('_USE THIS_NCH Admin Data_07-20-22 (pw=pcorida)(#1001-1999, 0001-0930, plus extras).xlsx')
N1$studyid <- as.numeric(N1$STUDYID)
N2 <- read_excel('_USE SOME OF THIS_NCH Admin Data_01-11-23 (pw=pcorida)(Use for #0931-0999, 4001-4268).xlsx')
N2$studyid <- as.numeric(N2$STUDYID)
N3 <- read_excel('_rev_NCH_admin data_6-22-23 - PCORI_DA_Data_(password=pcorida).xlsx')
N3$studyid <- as.numeric(N3$STUDYID)
N4 <- read_excel('_USE THIS_NCH Admin Data_07-20-22 (pw=pcorida)(#1001-1999, 0001-0930, plus extras).xlsx', sheet=2)
N4$studyid <- as.numeric(N4$STUDYID)
N4 <- N4[N4$studyid==41,]
N5 <- read_excel('4_NCH Admin Data_6-22-23 (pw=pcorida)(Use for #4022).xlsx')
N5$studyid <- as.numeric(N5$STUDYID)
N_extra <- N1[N1$studyid %in% c(1340,1696),]


NCH_admin <- distinct(rbind(N_extra, N4, N3, N5))
NCH_admin <- inner_join(NCH_admin, elig3, by='studyid')


#Split DX codes from one variable into several, separated by ";"
#Important: number of split columns depends on max number of diagnoses one 
#person has. Need to check this using table, adding columns until NA.
NCH_diags <- NCH_admin %>% separate(DISCH_DX_ICD_CODE, c('A_ICD_CODE', 'B_ICD_CODE', 'C_ICD_CODE','D_ICD_CODE','E_ICD_CODE','F_ICD_CODE','G_ICD_CODE',
                                                         'H_ICD_CODE','I_ICD_CODE','J_ICD_CODE','K_ICD_CODE','L_ICD_CODE','M_ICD_CODE','N_ICD_CODE','O_ICD_CODE','P_ICD_CODE',
                                                         'Q_ICD_CODE','R_ICD_CODE','S_ICD_CODE','T_ICD_CODE','U_ICD_CODE','V_ICD_CODE','W_ICD_CODE','X_ICD_CODE','Y_ICD_CODE','Z_ICD_CODE',
                                                         'AA_ICD_CODE','BB_ICD_CODE'), sep=';') 



#Remove period
NCH_diags$ADMIT_DX_ICD_CODE <- gsub('\\.', '', NCH_diags$ADMIT_DX_ICD_CODE)
NCH_diags$A_ICD_CODE <- gsub('\\.', '', NCH_diags$A_ICD_CODE)
NCH_diags$B_ICD_CODE <- gsub('\\.', '', NCH_diags$B_ICD_CODE)
NCH_diags$C_ICD_CODE <- gsub('\\.', '', NCH_diags$C_ICD_CODE)
NCH_diags$D_ICD_CODE <- gsub('\\.', '', NCH_diags$D_ICD_CODE)
NCH_diags$E_ICD_CODE <- gsub('\\.', '', NCH_diags$E_ICD_CODE)
NCH_diags$F_ICD_CODE <- gsub('\\.', '', NCH_diags$F_ICD_CODE)
NCH_diags$G_ICD_CODE <- gsub('\\.', '', NCH_diags$G_ICD_CODE)
NCH_diags$H_ICD_CODE <- gsub('\\.', '', NCH_diags$H_ICD_CODE)
NCH_diags$I_ICD_CODE <- gsub('\\.', '', NCH_diags$I_ICD_CODE)
NCH_diags$J_ICD_CODE <- gsub('\\.', '', NCH_diags$J_ICD_CODE)
NCH_diags$K_ICD_CODE <- gsub('\\.', '', NCH_diags$K_ICD_CODE)
NCH_diags$L_ICD_CODE <- gsub('\\.', '', NCH_diags$L_ICD_CODE)
NCH_diags$M_ICD_CODE <- gsub('\\.', '', NCH_diags$M_ICD_CODE)
NCH_diags$N_ICD_CODE <- gsub('\\.', '', NCH_diags$N_ICD_CODE)
NCH_diags$O_ICD_CODE <- gsub('\\.', '', NCH_diags$O_ICD_CODE)
NCH_diags$P_ICD_CODE <- gsub('\\.', '', NCH_diags$P_ICD_CODE)
NCH_diags$Q_ICD_CODE <- gsub('\\.', '', NCH_diags$Q_ICD_CODE)
NCH_diags$R_ICD_CODE <- gsub('\\.', '', NCH_diags$R_ICD_CODE)
NCH_diags$S_ICD_CODE <- gsub('\\.', '', NCH_diags$S_ICD_CODE)
NCH_diags$T_ICD_CODE <- gsub('\\.', '', NCH_diags$T_ICD_CODE)
NCH_diags$U_ICD_CODE <- gsub('\\.', '', NCH_diags$U_ICD_CODE)
NCH_diags$V_ICD_CODE <- gsub('\\.', '', NCH_diags$V_ICD_CODE)
NCH_diags$W_ICD_CODE <- gsub('\\.', '', NCH_diags$W_ICD_CODE)
NCH_diags$X_ICD_CODE <- gsub('\\.', '', NCH_diags$X_ICD_CODE)
NCH_diags$Y_ICD_CODE <- gsub('\\.', '', NCH_diags$Y_ICD_CODE)
NCH_diags$Z_ICD_CODE <- gsub('\\.', '', NCH_diags$Z_ICD_CODE)
NCH_diags$AA_ICD_CODE <- gsub('\\.', '', NCH_diags$AA_ICD_CODE)
NCH_diags$BB_ICD_CODE <- gsub('\\.', '', NCH_diags$BB_ICD_CODE)
#Add blank colums to match number that CHP has
NCH_diags$CC_ICD_CODE <- NA
NCH_diags$DD_ICD_CODE <- NA
NCH_diags$EE_ICD_CODE <- NA
NCH_diags$FF_ICD_CODE <- NA

#Select correct columns and merge column names with CHP
NCH_diags <- NCH_diags %>% select(studyid, A_ICD_CODE, B_ICD_CODE,C_ICD_CODE,D_ICD_CODE,E_ICD_CODE,F_ICD_CODE,G_ICD_CODE,H_ICD_CODE,I_ICD_CODE,J_ICD_CODE,
K_ICD_CODE,L_ICD_CODE,M_ICD_CODE,N_ICD_CODE,O_ICD_CODE,P_ICD_CODE,Q_ICD_CODE,R_ICD_CODE,S_ICD_CODE,T_ICD_CODE,U_ICD_CODE,V_ICD_CODE,W_ICD_CODE,X_ICD_CODE,
Y_ICD_CODE,Z_ICD_CODE,AA_ICD_CODE,BB_ICD_CODE,CC_ICD_CODE,DD_ICD_CODE,EE_ICD_CODE,FF_ICD_CODE, site)
colnames(NCH_diags) <- colnames(CHP_diags)


##########
###PRMC###
##########

#Gather diagnosis codes
p1 <- read_excel('1_PRMCE_admin data_Feb.Mar2020_revSCA (2001-2035).xlsx', sheet=1)
p2 <- read_excel('2_PRMCE_admin data_202004_05_revSCA (2036-2041).xlsx', sheet=1)
p3 <- read_excel('3_PRMCE_admin data_202006_rev (2042-2056).xlsx', sheet=1)
p4 <- read_excel('4_PRMCE_admin data_202007 to 11_Rev (2058-2119).xlsx', sheet=1)
p5 <- read_excel('5_Pediatric_Unit_Dec 2020 through Feb 2021 (2120-2182).xlsx', sheet=1)
p6 <- read_excel('6_PRMCE_Admin Data_2183 to 2303.xlsx', sheet=1)
p1$studyid <- as.numeric(p1$`Study ID`)
p2$studyid <- as.numeric(p2$`Study ID`)
p3$studyid <- as.numeric(p3$`Study ID`)
p4$studyid <- as.numeric(p4$`Study ID`)
p5$studyid <- as.numeric(p5$`Study ID`)
p6$studyid <- as.numeric(p6$`Study ID`)
p1 <- p1 %>% select(studyid, `Disch ICD10`)
p2 <- p2 %>% select(studyid, `Disch ICD10`)
p3 <- p3 %>% select(studyid, `Disch ICD10`)
p4 <- p4 %>% select(studyid, `Disch ICD10`)
p5 <- p5 %>% select(studyid, `DISCH_ICD10`)
p6 <- p6 %>% select(studyid, `DISCH_ICD10`)
colnames(p5) <- colnames(p6) <- colnames(p4)
PRMC_admin <- rbind(p1,p2,p3,p4,p5,p6)
PRMC_admin <- inner_join(PRMC_admin, elig3, 'studyid')

PRMC_admin$`Dx Code` <- gsub('\\.', '', PRMC_admin$`Disch ICD10`)
PRMC_admin <- PRMC_admin[,c(1,7)]


#Convert long to wide
PRMC_diags <- dcast(PRMC_admin, studyid~rowid(studyid, prefix = 'Dx_Code'))

#Rename columns
x <- c('studyid')
for(i in 2:ncol(PRMC_diags)){
  x <- c(x, paste(i-1, ' Diagnosis Code'))
}
colnames(PRMC_diags) <- x

#Add blank DX Code columns to match CHP
PRMC_diags$`17  Diagnosis Code` <- NA
PRMC_diags$`18  Diagnosis Code` <- NA
PRMC_diags$`19  Diagnosis Code` <- NA
PRMC_diags$`20  Diagnosis Code` <- NA
PRMC_diags$`21  Diagnosis Code` <- NA
PRMC_diags$`22  Diagnosis Code` <- NA
PRMC_diags$`23  Diagnosis Code` <- NA
PRMC_diags$`24  Diagnosis Code` <- NA
PRMC_diags$`25  Diagnosis Code` <- NA
PRMC_diags$`26  Diagnosis Code` <- NA
PRMC_diags$`27  Diagnosis Code` <- NA
PRMC_diags$`28  Diagnosis Code` <- NA
PRMC_diags$`29  Diagnosis Code` <- NA
PRMC_diags$`30  Diagnosis Code` <- NA
PRMC_diags$`31  Diagnosis Code` <- NA
PRMC_diags$`32  Diagnosis Code` <- NA
PRMC_diags$site <- 'PRMC'

#Combine three sites and save
All_diags <- rbind(NCH_diags, CHP_diags, PRMC_diags)
write.csv(All_diags, 'PCORI_PMCA.csv', row.names=F)













