
capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_DATAMANAGEMENT.smcl", replace


//STEP 1: EPIGENETIC CLOCK DATA//

cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\EPIGENETIC\"

clear 

import sas using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\EPIGENETIC\dnmepi.sas7bdat"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\EPIGENETIC\EPIGENETIC_NHANES.dta",replace

codebook

tab XY_Estimation

su HorvathAge-PhenoAge GrimAgeMort GrimAge2Mort HorvathTelo YangCell ZhangAge LinAge WeidnerAge VidalBraloAge DunedinPoAm CD8TPP CD4TPP Nkcell Bcell MonoPP NeuPP WTDN4YR,det

foreach var of varlist HorvathAge-PhenoAge GrimAgeMort GrimAge2Mort HorvathTelo YangCell ZhangAge LinAge WeidnerAge VidalBraloAge DunedinPoAm CD8TPP CD4TPP Nkcell Bcell MonoPP NeuPP {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_EPICLOCK\NHANES_EPICLOCK_HIST`var'", replace
}

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\EPIGENETIC\EPIGENETIC_NHANES.dta",clear
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\EPIGENETIC_NHANES.dta",replace


//STEP 2: TELOMERE LENGTH DATA//


**1999-2000**

cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\1999_2000"

clear 

import sasxport5 "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\1999_2000\TELO_A.xpt"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\1999_2000\TELO_A.dta",replace


capture drop year
gen year=1999.5

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\1999_2000\TELO_A.dta",replace


codebook



su telomean telostd,det

foreach var of varlist telomean telostd {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_TELOMERES\NHANES_TELO1999000_HIST`var'", replace
}




**2001-2002**


cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\2001_2002"

clear 

import sasxport5 "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\2001_2002\TELO_B.xpt"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\2001_2002\TELO_B.dta",replace

capture drop year
gen year=2001.5

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\2001_2002\TELO_B.dta",replace

codebook

su telomean telostd,det

foreach var of varlist telomean telostd {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_TELOMERES\NHANES_TELO200102_HIST`var'", replace
}



**Append the two waves**

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\1999_2000\TELO_A.dta",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_A.dta",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\TELOMERE_LENGTH\2001_2002\TELO_B.dta",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_B.dta",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_A.dta",clear
append using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_B.dta"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_AB.dta",replace

codebook

su 


//STEP 3: DEMOGRAPHIC //


**1999-00**
cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\1999_00"

clear 

import sasxport5 "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\1999_00\DEMO.xpt"


capture drop year
gen year=1999.5

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\1999_00\DEMO.dta",replace


codebook

su sddsrvyr-year, det


**2001-2002**
cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\2001_02"

clear 

import sasxport5 "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\2001_02\DEMO_B.xpt"


capture drop year
gen year=2001.5

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\2001_02\DEMO_B.dta",replace


codebook

su sddsrvyr-year, det


**Append the two waves**

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\1999_00\DEMO.dta",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO.dta",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\DEMOGRAPHICS\2001_02\DEMO_B.dta",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_B.dta",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO.dta",clear
append using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_B.dta"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_AB.dta",replace

codebook

su 

keep seqn sddsrvyr ridstatr ridexmon riagendr ridageyr ridagemn ridageex ridreth1 ridreth2 dmdborn dmdcitzn dmdeduc2 dmdeduc indhhinc indfminc indfmpir dmdhrgnd dmdhrage dmdhrbrn dmdhredu dmdhrmar wtint2yr wtint4yr wtmec2yr wtmec4yr sdmvpsu sdmvstra year

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_ABfinal.dta",replace

su

codebook


//STEP 4: MORTALITY DATA //



***1999-2000***

cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\MORTALITY_LINKAGE\1999_00"

global SURVEY NHANES_1999_2000     // REPLACE <SURVEY> WITH RELEVANT SURVEY NAME (IN ALL CAPS)

clear all


// DEFINE VALUE LABELS FOR REPORTS
label define premiss .z "Missing"
label define eligfmt 1 "Eligible" 2 "Under age 18, not available for public release" 3 "Ineligible" 
label define mortfmt 0 "Assumed alive" 1 "Assumed deceased" .z "Ineligible or under age 18"
label define flagfmt 0 "No - Condition not listed as a multiple cause of death" 1 "Yes - Condition listed as a multiple cause of death"	.z "Assumed alive, under age 18, ineligible for mortality follow-up, or MCOD not available"
label define qtrfmt 1 "January-March" 2 "April-June" 3 "July-September" 4 "October-December" .z "Ineligible, under age 18, or assumed alive"
label define dodyfmt .z "Ineligible, under age 18, or assumed alive"
label define ucodfmt 1 "Diseases of heart (I00-I09, I11, I13, I20-I51)"                           
label define ucodfmt 2 "Malignant neoplasms (C00-C97)"                                            , add
label define ucodfmt 3 "Chronic lower respiratory diseases (J40-J47)"                             , add
label define ucodfmt 4 "Accidents (unintentional injuries) (V01-X59, Y85-Y86)"                    , add
label define ucodfmt 5 "Cerebrovascular diseases (I60-I69)"                                       , add
label define ucodfmt 6 "Alzheimer's disease (G30)"                                                , add
label define ucodfmt 7 "Diabetes mellitus (E10-E14)"                                              , add
label define ucodfmt 8 "Influenza and pneumonia (J09-J18)"                                        , add
label define ucodfmt 9 "Nephritis, nephrotic syndrome and nephrosis (N00-N07, N17-N19, N25-N27)"  , add
label define ucodfmt 10 "All other causes (residual)"                                             , add
label define ucodfmt .z "Ineligible, under age 18, assumed alive, or no cause of death data"      , add

// READ IN THE FIXED-WIDTH FORMAT ASCII PUBLIC-USE LMF
infix seqn 1-6 eligstat 15 mortstat 16 ucod_leading 17-19 diabetes 20 hyperten 21 permth_int 43-45 permth_exm 46-48 using ${SURVEY}_MORT_2019_PUBLIC.dat	


// REPLACE MISSING VALUES TO .z FOR LABELING
replace mortstat = .z if mortstat >=.
replace ucod_leading = .z if ucod_leading >=.
replace diabetes = .z if diabetes >=.
replace hyperten = .z if hyperten >=.
replace permth_int = .z if permth_int >=.
replace permth_exm = .z if permth_exm >=.


// DEFINE VARIABLE LABELS 
label var seqn "NHANES Respondent Sequence Number"
label var eligstat "Eligibility Status for Mortality Follow-up"
label var mortstat "Final Mortality Status"
label var ucod_leading "Underlying Cause of Death: Recode"
label var diabetes "Diabetes flag from Multiple Cause of Death"
label var hyperten "Hypertension flag from Multiple Cause of Death"
label var permth_int "Person-Months of Follow-up from NHANES Interview date"
label var permth_exm "Person-Months of Follow-up from NHANES Mobile Examination Center (MEC) Date"


// ASSOCIATE VARIABLES WITH FORMAT VALUES 
label values eligstat eligfmt
label values mortstat mortfmt
label values ucod_leading ucodfmt
label values diabetes flagfmt
label values hyperten flagfmt
label value permth_int premiss
label value permth_exm premiss


// DISPLAY OVERALL DESCRIPTION OF FILE 
describe


// ONE-WAY FREQUENCIES (UNWEIGHTED)
tab1 eligstat mortstat ucod_leading diabetes hyperten, missing
tab permth_int if permth_int==.z, missing
tab permth_exm if permth_exm==.z, missing

// SAVE DATA FILE IN DIRECTORY DESIGNATED AT TOP OF PROGRAM AS **SURVEY**_PUF.DTA
// replace option allows Stata to overwrite an existing .dta file
save ${SURVEY}_PUF, replace


codebook

capture drop year
gen year=1999.5


save ${SURVEY}_PUF, replace


**2001-2002**
cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\MORTALITY_LINKAGE\2001_02"

global SURVEY NHANES_2001_2002     // REPLACE <SURVEY> WITH RELEVANT SURVEY NAME (IN ALL CAPS)

clear all


// DEFINE VALUE LABELS FOR REPORTS
label define premiss .z "Missing"
label define eligfmt 1 "Eligible" 2 "Under age 18, not available for public release" 3 "Ineligible" 
label define mortfmt 0 "Assumed alive" 1 "Assumed deceased" .z "Ineligible or under age 18"
label define flagfmt 0 "No - Condition not listed as a multiple cause of death" 1 "Yes - Condition listed as a multiple cause of death"	.z "Assumed alive, under age 18, ineligible for mortality follow-up, or MCOD not available"
label define qtrfmt 1 "January-March" 2 "April-June" 3 "July-September" 4 "October-December" .z "Ineligible, under age 18, or assumed alive"
label define dodyfmt .z "Ineligible, under age 18, or assumed alive"
label define ucodfmt 1 "Diseases of heart (I00-I09, I11, I13, I20-I51)"                           
label define ucodfmt 2 "Malignant neoplasms (C00-C97)"                                            , add
label define ucodfmt 3 "Chronic lower respiratory diseases (J40-J47)"                             , add
label define ucodfmt 4 "Accidents (unintentional injuries) (V01-X59, Y85-Y86)"                    , add
label define ucodfmt 5 "Cerebrovascular diseases (I60-I69)"                                       , add
label define ucodfmt 6 "Alzheimer's disease (G30)"                                                , add
label define ucodfmt 7 "Diabetes mellitus (E10-E14)"                                              , add
label define ucodfmt 8 "Influenza and pneumonia (J09-J18)"                                        , add
label define ucodfmt 9 "Nephritis, nephrotic syndrome and nephrosis (N00-N07, N17-N19, N25-N27)"  , add
label define ucodfmt 10 "All other causes (residual)"                                             , add
label define ucodfmt .z "Ineligible, under age 18, assumed alive, or no cause of death data"      , add

// READ IN THE FIXED-WIDTH FORMAT ASCII PUBLIC-USE LMF
infix seqn 1-6 eligstat 15 mortstat 16 ucod_leading 17-19 diabetes 20 hyperten 21 permth_int 43-45 permth_exm 46-48 using ${SURVEY}_MORT_2019_PUBLIC.dat	


// REPLACE MISSING VALUES TO .z FOR LABELING
replace mortstat = .z if mortstat >=.
replace ucod_leading = .z if ucod_leading >=.
replace diabetes = .z if diabetes >=.
replace hyperten = .z if hyperten >=.
replace permth_int = .z if permth_int >=.
replace permth_exm = .z if permth_exm >=.


// DEFINE VARIABLE LABELS 
label var seqn "NHANES Respondent Sequence Number"
label var eligstat "Eligibility Status for Mortality Follow-up"
label var mortstat "Final Mortality Status"
label var ucod_leading "Underlying Cause of Death: Recode"
label var diabetes "Diabetes flag from Multiple Cause of Death"
label var hyperten "Hypertension flag from Multiple Cause of Death"
label var permth_int "Person-Months of Follow-up from NHANES Interview date"
label var permth_exm "Person-Months of Follow-up from NHANES Mobile Examination Center (MEC) Date"


// ASSOCIATE VARIABLES WITH FORMAT VALUES 
label values eligstat eligfmt
label values mortstat mortfmt
label values ucod_leading ucodfmt
label values diabetes flagfmt
label values hyperten flagfmt
label value permth_int premiss
label value permth_exm premiss


// DISPLAY OVERALL DESCRIPTION OF FILE 
describe


// ONE-WAY FREQUENCIES (UNWEIGHTED)
tab1 eligstat mortstat ucod_leading diabetes hyperten, missing
tab permth_int if permth_int==.z, missing
tab permth_exm if permth_exm==.z, missing

// SAVE DATA FILE IN DIRECTORY DESIGNATED AT TOP OF PROGRAM AS **SURVEY**_PUF.DTA
// replace option allows Stata to overwrite an existing .dta file
save ${SURVEY}_PUF, replace


codebook

capture drop year
gen year=2001.5


save ${SURVEY}_PUF, replace


**********Append the two waves*****************************


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\MORTALITY_LINKAGE\1999_00\NHANES_1999_2000_PUF",clear
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_1999_0000_PUF",replace



use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\NHANES_DATA\MORTALITY_LINKAGE\2001_02\NHANES_2001_2002_PUF",clear
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_2001_2002_PUF",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_1999_0000_PUF",clear
append using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_2001_2002_PUF"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_1999_2002_PUF",replace

su

codebook

//STEP 5: MERGE DATASETS TOGETHER WITH DEMOGRAPHICS DATA//

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_ABfinal",clear
sort seqn
capture drop _merge
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_ABfinal",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\EPIGENETIC_NHANES",clear
capture rename SEQN seqn
sort seqn
capture drop _merge
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\EPIGENETIC_NHANES",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_AB",clear
sort seqn
capture drop _merge
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_AB",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_1999_2002_PUF",clear
sort seqn
capture drop _merge
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_1999_2002_PUF",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\DEMO_ABfinal",clear
merge seqn using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\EPIGENETIC_NHANES"
sort seqn
capture drop _merge
merge seqn using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\TELO_AB"
sort seqn
capture drop _merge
merge seqn using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_1999_2002_PUF"
sort seqn
capture drop _merge

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace

codebook
su


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 6: GENERATE EPIGENETIC AGE ACCELERATION VARIABLES FROM HORVATH, HANNUM, PHENO, GRIMM, include POA, remove Outliers and z-score//
capture drop AGE
gen AGE=ridageyr

su AGE if HorvathAge~=.
histogram AGE if HorvathAge~=.

capture drop HorvathAgeEAA 
capture drop HannumAgeEAA 
capture drop PhenoAgeEAA 
capture drop GrimAgeMortEAA   


foreach var of varlist HorvathAge HannumAge PhenoAge GrimAgeMort {
	
	reg `var' AGE 
	predict `var'EAA, resid
	histogram `var'EAA
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_EPICLOCK\NHANES_HIST`var'EAA.gph", replace
	su `var'EAA
}

su DunedinPoAm
histogram DunedinPoAm
graph save  "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_EPICLOCK\NHANES_HISTDunedinPoAmEAA.gph", replace
 

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace


*******REMOVE OUTLIERS*************

local vars HorvathAgeEAA HannumAgeEAA PhenoAgeEAA GrimAgeMortEAA DunedinPoAm  // Replace with your actual variable names

foreach var of varlist `vars' {
    // Calculate IQR
    quietly summarize `var', detail
    local p25 = r(p25)
    local p75 = r(p75)
    local iqr = `p75' - `p25'

    // Define the upper and lower bounds for outliers
    local lower_bound = `p25' - 4 * `iqr'
    local upper_bound = `p75' + 4 * `iqr'

    // Generate a new variable excluding outliers
    gen `var'_no_outliers = `var'
    replace `var'_no_outliers = . if `var' < `lower_bound' | `var' > `upper_bound'
}




*******Z-SCORE*************

capture drop zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm
foreach var of varlist HorvathAgeEAA HannumAgeEAA PhenoAgeEAA GrimAgeMortEAA DunedinPoAm {
	
	egen z`var'=std(`var')
}

su z*

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace


foreach var of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_EPICLOCK\NHANES_HIST`var'.gph",replace
	
}

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 7: TELOMERE LENGTH///


**Remove outliers**

capture drop telomean_no_outliers telostd_no_outliers

local vars telomean telostd  // Replace with your actual variable names

foreach var of varlist `vars' {
    // Calculate IQR
    quietly summarize `var', detail
    local p25 = r(p25)
    local p75 = r(p75)
    local iqr = `p75' - `p25'

    // Define the upper and lower bounds for outliers
    local lower_bound = `p25' - 4 * `iqr'
    local upper_bound = `p75' + 4 * `iqr'

    // Generate a new variable excluding outliers
    gen `var'_no_outliers = `var'
    replace `var'_no_outliers = . if `var' < `lower_bound' | `var' > `upper_bound'
}

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


**Z-scoring**


capture drop ztelomean_no_outliers ztelostd_no_outliers
foreach var of varlist telomean_no_outliers telostd_no_outliers  {
	
	egen z`var'=std(`var')
}

su z*


foreach var of varlist ztelo* {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_TELOMERES\NHANES_HIST`var'.gph",replace
	
}


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 8: COVARIATES//


**RACE**

**ridreth1
**1: Mexican American
**2: Other Hispanic
**3: Non-Hispanic White
**4: Non-Hispanic Black
**5: Other Race - Including Multi-Racial

tab ridreth1

**Race/Ethnic |
**      ity - |
**     Recode |      Freq.     Percent        Cum.
**------------+-----------------------------------
**          1 |      6,169       29.37       29.37
**          2 |      1,106        5.27       34.64
**          3 |      7,973       37.96       72.60
**          4 |      4,909       23.37       95.97
**          5 |        847        4.03      100.00
**------------+-----------------------------------
**      Total |     21,004      100.00




capture drop RACE
gen RACE=.
replace RACE=0 if ridreth1==3
replace RACE=1 if ridreth1==4
replace RACE=2 if ridreth1==1 | ridreth1==2
replace RACE=3 if RACE==. & ridreth1~=.


tab RACE

**       RACE |      Freq.     Percent        Cum.
**------------+-----------------------------------
**          0 |      7,973       37.96       37.96
**          1 |      4,909       23.37       61.33
**          2 |      7,275       34.64       95.97
**          3 |        847        4.03      100.00
**------------+-----------------------------------
**     Total |     21,004      100.00


**RACE**
**0=Non-Hispanic White
**1=Non-Hispanic Black
**2=Hispanic
**3=Other


**SEX**
capture drop SEX

gen SEX=riagendr

tab SEX


**SEX
**1: Male
**2: Female


**COHORT VARIABLE**

capture drop COHORT
gen COHORT=1

tab COHORT


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 9: SET UP DATASET AS SURVIVAL DATA//

su permth_exm
tab mortstat

capture drop DIED
gen DIED=mortstat

capture drop TIMEyears
gen TIMEyears=permth_exm/12
su TIMEyears
histogram TIMEyears

graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_MORTALITY\HIST_TIMETOEVENT.gph",replace

stset TIMEyears [pweight=WTDN4YR] , id(seqn) failure(DIED==1)


//STEP 10: STUDY SAMPLE SELECTION STEP, INVERSE MILLS RATIO, USING AGE>=50Y RESTRICTION//

**AGE 50+ Y**

capture drop sample1
gen sample1=.
replace sample1=1 if AGE>=50 & AGE~=.
replace sample1=0 if sample1~=1

tab sample1   


**TELOMERE LENGTH DATA AVAILABLE**

capture drop sample2
gen sample2=.
replace sample2=1 if ztelomean_no_outliers~=. & ztelostd_no_outliers~=. 
replace sample2=0 if sample2~=1

tab sample2  



**EPIGENETIC CLOCK DATA AVAILABLE**

capture drop sample3
gen sample3=.
replace sample3=1 if zHorvathAgeEAA~=. & zHannumAgeEAA~=. & zPhenoAgeEAA~=. & zGrimAgeMortEAA~=. & zDunedinPoAm~=.
replace sample3=0 if sample3~=1

tab sample3  


**TELOMERE LENGTH DATA AVAILABLE AND 50+Y**

capture drop sample4
gen sample4=.
replace sample4=1 if sample1==1 & sample2==1
replace sample4=0 if sample4~=1

tab sample4


**TELOMERE LENGTH and EPIGENETIC CLOCK DATA AVAILABLE AND 50+Y**


capture drop sample5
gen sample5=.
replace sample5=1 if sample4==1 & sample3==1
replace sample5=0 if sample5~=1

tab sample5


capture drop sample_final
gen sample_final=sample5


tab sample_final

**Inverse mills ratio**

capture drop sample_final_age50plus
gen sample_final_age50plus=.
replace sample_final_age50plus=1 if sample_final==1
replace sample_final_age50plus=0 if sample_final==0 & AGE>=50 & AGE~=.

tab sample_final_age50plus


xi:probit sample_final_age50plus AGE SEX i.RACE

capture drop p1fin
predict p1fin, xb

capture drop phifin
capture drop caphifin
capture drop invmillsfin

gen phifin=(1/sqrt(2*_pi))*exp(-(p1fin^2/2))

egen caphifin=std(p1fin)

capture drop invmillsfin
gen invmillsfin=phifin/caphifin


su invmillsfin
histogram invmillsfin



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace



capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_KAPLANMEIERCURVES.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 11: KAPLAN MEIER SURVIVAL CURVES BY TERTILES OF EACH EPIGENETIC CLOCK, EPIGENETIC EAA AND TL VARIABLES//

capture drop zHorvathAgeEAAtert zHannumAgeEAAtert zPhenoAgeEAAtert zGrimAgeMortEAAtert zDunedinPoAmtert ztelomean_no_outlierstert  

foreach var of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers {
	xtile `var'tert=`var' if sample_final==1,nq(3)

}


tab1 *tert 


foreach var of varlist *tert {
	sts test `var'
}


foreach var of varlist *tert {
	sts graph, by(`var')
graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1`var'.gph",replace
} 

graph combine "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1zHorvathAgeEAAtert.gph" ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1zDunedinPoAmtert.gph" ////
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1zGrimAgeMortEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1zHannumAgeEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1zPhenoAgeEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1ztelomean_no_outlierstert.gph" ///

graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURE1_KM\FIGURE1combined.gph",replace

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear




capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_CORRELATIONS_EPIGENEITC_TELO.smcl",replace


//STEP 12: CORRELATION MATRIX BETWEEN EPIGENTIC AGE ACCELERATION, EPIGENETIC CLOCKS AND TL VARIABLES//

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


// Step 1: Run the correlation command and save the matrix
corr zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  
matrix C = r(C)

// Step 2: Clear the current dataset (optional if you don't need it)
clear

// Step 3: Convert the matrix to a dataset with unique variable names
svmat C, names(col)

// Step 4: Save the dataset as a CSV file
export delimited using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_correlation_matrix.csv", replace

**Add a column in excel sheet and re-type labels mannually. Change labels as needed. 


// Step 5: Reload your original dataset if needed

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear



capture log close



//STEP 13: RStudio code for heatmap: Run IN RStudio//

**# Load necessary libraries
**library(ggplot2)
**library(reshape2)

**# Read the correlation matrix from the CSV file
**file_path <- "E:/16GBBACKUPUSB/BACKUP_USB_SEPTEMBER2014/SUMMER_STUDENT_2025/HRS_NHANES_HANDLS_TLEPIGENMORT/OUTPUT/NHANES_correlation_matrix_final.csv"
**cor_matrix <- read.csv(file_path, check.names = FALSE)

**# Check if row names need to be set
**if (is.character(cor_matrix[[1]])) {
**  rownames(cor_matrix) <- cor_matrix[[1]]
**  cor_matrix <- cor_matrix[, -1]
**}

**# Ensure all columns and rows are numeric
**cor_matrix <- as.matrix(cor_matrix)
**
**# Melt the matrix for ggplot2
**cor_data <- melt(cor_matrix)
**
**# Create the heatmap
**ggplot(data = cor_data, aes(x = Var1, y = Var2, fill = value)) +
**  geom_tile(color = "white") +
**  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0,
**                       limits = c(-1, 1),  # Make the legend symmetrical
**                       name = "Correlation") +
**  theme_minimal() +
**  theme(
**    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),  # Rotate x-axis labels
**    axis.text.y = element_text(angle = 0, hjust = 1)               # Ensure y-axis labels are present
**  ) +
**  labs(x = "", y = "") +
**  coord_fixed()



capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_LASSOLINEAR.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 14: LASSO LINEAR MODELS FOR TL VS. EPIGENETIC EAA, FORCING EXOGENOUS VARIABLES. 


capture drop sample_LASSO
sort seqn
save, replace
splitsample , generate(sample_LASSO) nsplit(2) rseed(1234)
tab sample_LASSO

save, replace

*******************************TELOMEAN************************************

lasso linear ztelomean_no_outliers (AGE SEX i.RACE) zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm if sample_LASSO==1, rseed(1234)


cvplot 
graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURES2_LASSO\FIGURES2_TELOMEAN.gph",replace

estimates store cvTELOMEAN

lassoknots, display(nonzero osr2 bic)

lassoselect id=27

cvplot

estimates store minBICTELOMEAN

lasso linear ztelomean_no_outliers (AGE SEX i.RACE)  zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm if sample_LASSO==1, selection(adaptive) rseed(1234)


estimates store adaptiveTELOMEAN

lassocoef cvTELOMEAN minBICTELOMEAN adaptiveTELOMEAN, sort(coef, standardized) nofvlabel



**--------------------------------------------------------------
**                | cvTELOMEAN minBICTELOMEAN  adaptiveTELOMEAN 
**----------------+---------------------------------------------
**            AGE |     x             x                x        
**  zHannumAgeEAA |     x             x                x        
** zHorvathAgeEAA |     x             x                x        
**            SEX |     x             x                x        
**   zPhenoAgeEAA |     x             x                x        
**                |
**           RACE |
**             3  |     x             x                x        
**             2  |     x             x                x        
**                |
** zGrimAgeMortEAA |     x             x                x        
**                |
**           RACE |
**             1  |     x             x                x        
**              |
**          _cons |     x             x                x        
**                |
**           RACE |
**            0  |     e             e                e        
**--------------------------------------------------------------
**Legend:
**  b - base level
**  e - empty cell
**  o - omitted
**  x - estimated





lassogof cvTELOMEAN minBICTELOMEAN adaptiveTELOMEAN, over(sample_LASSO) postselection


**Postselection coefficients
**-------------------------------------------------------------
**Name         sample_L~O |         MSE    R-squared        Obs
**------------------------+------------------------------------
**cvTELOMEAN              |
**                      1 |    .6975822       0.0951      1,272
**                      2 |    .6294661       0.1252      1,258
**------------------------+------------------------------------
**minBICTELOMEAN          |
**                      1 |    .6975822       0.0951      1,272
**                      2 |    .6294661       0.1252      1,258
**------------------------+------------------------------------
**adaptiveTELOMEAN        |
**                      1 |    .6975822       0.0951      1,272
**                      2 |    .6294661       0.1252      1,258
**-------------------------------------------------------------

***REDUCED MODEL FROM BEST MODEL SELECTION PROCESS**

reg ztelomean_no_outliers AGE SEX i.RACE  zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA  if sample_final==1



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace

capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_LASSOCOX.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear


//STEP 14: LASSO COX MODELS FOR MORTALITY VS. TL, EPIGENETIC EAA, FORCING EXOGENOUS VARIABLES. 

stset TIMEyears [iweight=WTDN4YR] , id(seqn) failure(DIED==1)


lasso cox (AGE SEX i.RACE ) zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  if sample_LASSO==1, rseed(1234)

 

cvplot 
graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\NHANES_FIGURES2_LASSO\FIGURES2_LASSOCOX.gph",replace

estimates store cvLASSOCOX

lassoknots, display(nonzero bic)

lassoselect id=55

cvplot

estimates store minBICLASSOCOX

lasso cox (AGE SEX i.RACE ) zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  ztelostd_no_outliers if sample_LASSO==1, selection(adaptive) rseed(1234)


estimates store adaptiveLASSOCOX

lassocoef cvLASSOCOX minBICLASSOCOX adaptiveLASSOCOX, sort(coef, standardized) nofvlabel

**--------------------------------------------------------------------
**                      | cvLASSOCOX minBICLASSOCOX  adaptiveLASSOCOX 
**----------------------+---------------------------------------------
**                  AGE |     x             x                x        
**      zGrimAgeMortEAA |     x             x                x        
**         zDunedinPoAm |     x             x                x        
**         zPhenoAgeEAA |     x             x                x        
**ztelomean_no_outliers |     x             x                x        
**                      |
**                 RACE |
**                   3  |     x             x                x        
**                   1  |     x             x                x        
**                      |
**       zHorvathAgeEAA |     x             x       
**                  SEX |     x             x                x        
**        zHannumAgeEAA |     x             x       
**                      |
**                 RACE |
**                   2  |     x             x                x        
**                   0  |     e             e                e        
**--------------------------------------------------------------------
**Legend:
**  b - base level
**  e - empty cell
**  o - omitted
**  x - estimated



lassogof cvLASSOCOX minBICLASSOCOX adaptiveLASSOCOX, over(sample_LASSO) postselection


**Postselection coefficients
**-------------------------------------------------------------
**                        |                 Deviance
**Name         sample_L~O |    Deviance        ratio        Obs
**------------------------+------------------------------------
**cvLASSOCOX              |
**                      1 |    4.638475       0.1048      1,272
**                      2 |    4.637543       0.1064      1,258
**------------------------+------------------------------------
**minBICLASSOCOX          |
**                      1 |    4.638475       0.1048      1,272
**                      2 |    4.637543       0.1064      1,258
**------------------------+------------------------------------
**adaptiveLASSOCOX        |
**                      1 |    4.640192       0.1045      1,272
**                      2 |    4.638015       0.1063      1,258
**-------------------------------------------------------------


***REDUCED MODEL FROM BEST MODEL SELECTION PROCESS**

stcox AGE SEX i.RACE  zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm zHorvathAgeEAA zHannumAgeEAA ztelomean_no_outliers  if sample_final==1

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace



capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_HEATMAPCOX.smcl",replace

//STEP 15: HEATMAP FOR EACH TELOMERE LENGTH, EPIGENETIC CLOCKS VS. MORTALITY RISK, ADJUSTING AGE, SEX AND RACE: COX MODEL///

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear

stset TIMEyears [pweight=WTDN4YR] , id(seqn) failure(DIED==1)


* Install estout if not already installed
ssc install estout, replace

* Clear any previous estimates
est clear

* Start the loop
foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  ztelostd_no_outliers  { 
    
        * Run the stcox command
        stcox `x' AGE SEX i.RACE if sample_final==1
        
        * Store the estimates
        eststo output`x'
    }



* Export the results to a dataset
esttab using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\results_TABLE5.csv", replace se ar2

import delimited "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\results_TABLE5.csv", clear


* Convert the CSV file to a Stata dataset (if needed)
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\results_TABLE5.dta",replace



**Fix the dataset so it is simpler. This is saved as : cleaned_results_TABLE5_final.csv in the same folder**








use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace

*****SENSITIVITY ANALYSIS #1: DunedinPoAm residuals adjusted for age*****

capture drop zDunedinPoAmresid
reg zDunedinPoAm AGE if sample_final==1
predict zDunedinPoAmresid, resid

stcox zDunedinPoAmresid AGE SEX i.RACE if sample_final==1

*****SENSITIVITY ANALYSIS #2: C-statistic*****

stset TIMEyears , id(seqn) failure(DIED==1)


foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm zDunedinPoAmresid ztelomean_no_outliers { 
    di "=============================================="
    di "Cox regression with predictor: `x'"
    * Run the Cox regression
    stcox `x' AGE SEX i.RACE if sample_final==1

    * Display Harrell's C-statistic
    estat concordance

    di "=============================================="
}


stset TIMEyears [pweight=WTDN4YR] , id(seqn) failure(DIED==1)

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",replace



capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_VARDISCRETIZATION.smcl",replace




//STEP 16: DISCRETIZE VARIABLES FOR ABN ANALYSIS AND GENERATE DATASET FOR R; CREATE A VARIABLE COHORT=1 (NHANES)//

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET",clear

keep if sample_final==1

keep seqn  AGE SEX RACE zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  ztelostd_no_outliers _st _d _t _t0 COHORT

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN",replace



**AGE**
capture drop AGEbr
xtile AGEbr = AGE, nq(100)
bysort AGEbr: egen AGE_median = median(AGE)
replace AGE_median = round(AGE_median, 0.01)
replace AGE = AGE_median
histogram AGE
tab AGE

**SEX***
tab SEX
recode SEX (1=0) (2=1)

tab SEX


**NonWhite RACES**

**Non-Hispanic Black**

capture drop NHB
gen NHB=.
replace NHB=1 if RACE==1
replace NHB=0 if RACE~=. & NHB~=1

tab NHB

**Hispanic**
capture drop HISP
gen HISP=.
replace HISP=1 if RACE==2
replace HISP=0 if RACE~=. & HISP~=1

tab HISP

**Other**
capture drop OTHER
gen OTHER=.
replace OTHER=1 if RACE==3
replace OTHER=0 if RACE~=. & OTHER~=1

tab OTHER



*EPIGENETIC CLOCKS AND TELOMERE LENGHTS*

capture drop zz*
foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers    {
	egen z`x'=std(`x')
}

capture rename zz* z*


foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers    {
capture drop `x'br
xtile `x'br = `x', nq(100)
bysort `x'br: egen `x'_median = median(`x')
replace `x'_median = round(`x'_median, 0.01)
replace `x' = `x'_median
histogram `x' 
tab `x'

}

*MORTALITY*
tab _d


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN",replace


keep seqn AGE SEX NHB HISP OTHER zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers   _d _st _d _t _t0 COHORT


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN_SMALL",replace



capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\NHANES_DISCRETE_TIME_HAZARD_ABN.smcl",replace


//STEP 17: GENERATE DATASET WITH DISCRETE TIME HAZARDS: 2 YR INTERVALS: FRIDAY PLUS CORRECT FIGURES USING SAMPLING WEIGHTS (K-M and Error bar) //

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN_SMALL",clear

sort seqn

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN_SMALL",replace


* Step 1: Expand the dataset
capture drop period
gen period = floor(_t / 2) + 1  // Create time periods based on 2-year intervals
expand period  // Expand the dataset for each time period

* Step 2: Create time variables for analysis
capture drop start_time
capture drop end_time

bysort seqn: gen start_time = (_n - 1) * 2  // Start of each 2-year period
bysort seqn: gen end_time = start_time + 2  // End of each 2-year period

* Step 3: Indicate event occurrence in each period
capture drop event

gen event = (_d == 1 & _t <= end_time & _t > start_time)

* Step 4: Create dummy variables for each 2-year interval
gen interval = floor(start_time / 2) + 1  // Create interval number
tabulate interval, generate(dummy)  // Generate dummy variables for each interval


logistic _d dummy1-dummy10 AGE SEX NHB HISP OTHER zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  

sort seqn 

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN_DISCRETE",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN_DISCRETE",clear

capture rename _d d_var

keep AGE SEX NHB HISP OTHER d_var dummy* zHorvathAgeEAA-ztelomean_no_outliers

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\NHANES\NHANES_MERGED_DATASET_ABN_DISCRETEfin",replace



capture log close

//STEP 18: RSTUDIO CODE FOR ABN//



##Step 0: install abn and other related packages on newer version of R, install JAGS manually**

##Install R version 4.4 or higher**

install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("graph", "Rgraphviz"), dep=TRUE)


install.packages("memisc", repos = c("https://melff.r-universe.dev", "https://cloud.r-project.org"), dependencies=T)
library(memisc)


install.packages("abn", dependencies=T)
library(abn)

install.packages(c("nnet", "lme4", "Rgraphviz", "knitr", "R.rsp", "testthat", "entropy", "moments", "boot", "brglm", "dplyr"))

library(dplyr)
library(nnet)
library(lme4)
library(Rgraphviz)
library(knitr)
library(R.rsp)
library(testthat)
library(entropy)
library(moments)
library(boot)
library(brglm) 

install.packages("haven", dependencies=T)


## Step 1: Open file and do some data wrangling, create groups of variables

library(haven)
library(dplyr)

# Increase memory limit to 16 GB (adjust as needed)
memory.limit(size = 16000)

# Read the dataset
file_path <- "E:\\16GBBACKUPUSB\\BACKUP_USB_SEPTEMBER2014\\SUMMER_STUDENT_2025\\HRS_NHANES_HANDLS_TLEPIGENMORT\\FINAL_DATA\\NHANES\\NHANES_MERGED_DATASET_ABN_DISCRETEfin.dta"
data.df <- read_dta(file_path)

# Summary of data to inspect structure
summary(data.df)

# Convert variables to factors
factorvars <- c("SEX", "d_var", "NHB", "HISP", "OTHER", "dummy1", "dummy2", "dummy3", "dummy4", "dummy5", "dummy6", "dummy7", "dummy8", "dummy9", "dummy10", "dummy11")
data.df[factorvars] <- lapply(data.df[factorvars], factor)

# Inspect structure of the data
str(data.df)

# Convert to data frame for further use
abndata <- as.data.frame(data.df)

# Define antecedent and outcome variables
antecedent_vars <- c("AGE", "SEX", "NHB", "HISP", "OTHER")
outcome_vars <- c("d_var")

# Step 2: Fit the additive Bayesian network using the abn package

# Define the data distributions
data.dists <- list(
  AGE = "gaussian",
  zHorvathAgeEAA = "gaussian",
  zHannumAgeEAA = "gaussian",
  zPhenoAgeEAA = "gaussian",
  zGrimAgeMortEAA = "gaussian",
  zDunedinPoAm = "gaussian",
  ztelomean_no_outliers = "gaussian",
  SEX = "binomial",
  d_var = "binomial",
  NHB = "binomial",
  HISP = "binomial",
  OTHER = "binomial",
  dummy1 = "binomial",
  dummy2 = "binomial",
  dummy3 = "binomial",
  dummy4 = "binomial",
  dummy5 = "binomial",
  dummy6 = "binomial",
  dummy7 = "binomial",
  dummy8 = "binomial",
  dummy9 = "binomial",
  dummy10 = "binomial",
  dummy11 = "binomial"
)

# Create an empty matrix for 'retain' and 'banned'
retain <- matrix(0, ncol(abndata), ncol(abndata))
colnames(retain) <- rownames(retain) <- names(abndata)

banned <- matrix(0, ncol(abndata), ncol(abndata))
colnames(banned) <- rownames(banned) <- names(abndata)

# Ban edges as needed from all variables into antecedent variables; and from final outcome into all other variables
# 1 (AGE), 8 (SEX), 10 (NHB), 11 (HISP), 12 (OTHER) Final outcome is #9, dummy times (13 to 23)
banned[1, -1] <- 1
banned[8, -8] <- 1
banned[10, -10] <- 1
banned[11, -11] <- 1
banned[12, -12] <- 1
banned[-9, 9] <- 1

# Ban future dummy times from predicting past dummy times
for (i in 13:22
) {
  for (j in (i+1):23) {
    banned[i, j] <- 1
  }
}

# Ensure all dummy variables directly predict d_var
dummy_vars <- paste0("dummy", 1:11)  # List of dummy variables
for (dummy in dummy_vars) {
  retain[dummy, "d_var"] <- 1
}


# Check the banned matrix
summary(banned)
View(banned)



# Check the retain matrix
summary(retain)
View(retain)

# Find overlapping edges between banned and retained
conflicts <- which(banned == 1 & retain == 1, arr.ind = TRUE)
print(conflicts)  # Should return an empty set if no conflicts exist

# Resolve conflicts by prioritizing bans (set to 0 in retained matrix)
retain[conflicts] <- 0


# Install the package if it's not already installed
if (!requireNamespace("abn", quietly = TRUE)) {
  install.packages("abn")
}

# Load the package
library(abn)


# Set max.parents
max.par <- 2

# Get the variable names from the dataset to ensure the order is correct
var_names <- colnames(abndata)

# Initialize the start.dag matrix with the correct dimensions (matching the number of variables)
start.dag <- matrix(0, nrow = length(var_names), ncol = length(var_names))
rownames(start.dag) <- colnames(start.dag) <- var_names

# Print the start.dag to check if it's correctly set up
print(start.dag)

# Build the score cache, with max.par = 2
mycache <- buildScoreCache(data.df = as.data.frame(abndata), data.dists = data.dists, 
                           dag.banned = banned, dag.retained=retain, max.parents = max.par)

# Perform the search for the DAG using Hill Climber, passing the start.dag as a matrix
mydag <- searchHillClimber(score.cache = mycache, start.dag = start.dag)

# If the search runs successfully, plot the DAG
plotAbn(dag = mydag)

fabn <- fitAbn(object = mydag)

summary(fabn)

plotAbn(dag = mydag, labels="TRUE")

fabn <- fitAbn(object = mydag)

plot(fabn)



##########Loop over max.parents 1 to 4########################

datadir <- tempdir()

for (i in 1:3) {
  
  max.par <- i
  
mycache <- buildScoreCache(data.df = as.data.frame(abndata), data.dists = data.dists, 
                             dag.banned = banned, dag.retained = retain, 
                             max.parents = max.par)


mydag <- searchHillClimber(score.cache = mycache, start.dag = NULL)
  
fabn <- fitAbn(object = mydag)

cat(paste("network score for", i, "parents =", fabn$mlik, "\n\n"))
  
save(mycache, mydag, fabn, file = paste(datadir,"mp_", max.par,".RData", sep=""))
  
}


# get network score for all parent limits
# ---------------------------------------
mp.mlik <- c()
for (i in 1:max.par) {
  load(paste(datadir,"mp_", i,".RData", sep=""))
  mp.mlik <- c(mp.mlik, fabn$mlik)
}



plot(1:max.par, mp.mlik, xlab = "Parent limit", ylab = "Log marginal likelihood", 
     type = "b", col="red", ylim=range(mp.mlik))
abline(v=which(mp.mlik==max(mp.mlik))[1], col="grey", lty=2)


############1 parent/child###################



## Step 1: Open file and do some data wrangling, create groups of variables

library(haven)
library(dplyr)

# Increase memory limit to 16 GB (adjust as needed)
memory.limit(size = 16000)

# Read the dataset
file_path <- "E:\\16GBBACKUPUSB\\BACKUP_USB_SEPTEMBER2014\\SUMMER_STUDENT_2025\\HRS_NHANES_HANDLS_TLEPIGENMORT\\FINAL_DATA\\NHANES\\NHANES_MERGED_DATASET_ABN_DISCRETEfin.dta"
data.df <- read_dta(file_path)

# Summary of data to inspect structure
summary(data.df)

# Convert variables to factors
factorvars <- c("SEX", "d_var", "NHB", "HISP", "OTHER", "dummy1", "dummy2", "dummy3", "dummy4", "dummy5", "dummy6", "dummy7", "dummy8", "dummy9", "dummy10", "dummy11")
data.df[factorvars] <- lapply(data.df[factorvars], factor)

# Inspect structure of the data
str(data.df)

# Convert to data frame for further use
abndata <- as.data.frame(data.df)

# Define antecedent and outcome variables
antecedent_vars <- c("AGE", "SEX", "NHB", "HISP", "OTHER")
outcome_vars <- c("d_var")

# Step 2: Fit the additive Bayesian network using the abn package

# Define the data distributions
data.dists <- list(
  AGE = "gaussian",
  zHorvathAgeEAA = "gaussian",
  zHannumAgeEAA = "gaussian",
  zPhenoAgeEAA = "gaussian",
  zGrimAgeMortEAA = "gaussian",
  zDunedinPoAm = "gaussian",
  ztelomean_no_outliers = "gaussian",
  SEX = "binomial",
  d_var = "binomial",
  NHB = "binomial",
  HISP = "binomial",
  OTHER = "binomial",
  dummy1 = "binomial",
  dummy2 = "binomial",
  dummy3 = "binomial",
  dummy4 = "binomial",
  dummy5 = "binomial",
  dummy6 = "binomial",
  dummy7 = "binomial",
  dummy8 = "binomial",
  dummy9 = "binomial",
  dummy10 = "binomial",
  dummy11 = "binomial"
)

# Create an empty matrix for 'retain' and 'banned'
retain <- matrix(0, ncol(abndata), ncol(abndata))
colnames(retain) <- rownames(retain) <- names(abndata)

banned <- matrix(0, ncol(abndata), ncol(abndata))
colnames(banned) <- rownames(banned) <- names(abndata)

# Ban edges as needed from all variables into antecedent variables; and from final outcome into all other variables
# 1 (AGE), 8 (SEX), 10 (NHB), 11 (HISP), 12 (OTHER) Final outcome is #9, dummy times (13 to 23)
banned[1, -1] <- 1
banned[8, -8] <- 1
banned[10, -10] <- 1
banned[11, -11] <- 1
banned[12, -12] <- 1
banned[-9, 9] <- 1

# Ban future dummy times from predicting past dummy times
for (i in 13:22
) {
  for (j in (i+1):23) {
    banned[i, j] <- 1
  }
}

# Ensure all dummy variables directly predict d_var
dummy_vars <- paste0("dummy", 1:11)  # List of dummy variables
for (dummy in dummy_vars) {
  retain[dummy, "d_var"] <- 1
}


# Check the banned matrix
summary(banned)
View(banned)



# Check the retain matrix
summary(retain)
View(retain)

# Find overlapping edges between banned and retained
conflicts <- which(banned == 1 & retain == 1, arr.ind = TRUE)
print(conflicts)  # Should return an empty set if no conflicts exist

# Resolve conflicts by prioritizing bans (set to 0 in retained matrix)
retain[conflicts] <- 0


# Install the package if it's not already installed
if (!requireNamespace("abn", quietly = TRUE)) {
  install.packages("abn")
}

# Load the package
library(abn)


# Set max.parents
max.par <- 1

# Get the variable names from the dataset to ensure the order is correct
var_names <- colnames(abndata)

# Initialize the start.dag matrix with the correct dimensions (matching the number of variables)
start.dag <- matrix(0, nrow = length(var_names), ncol = length(var_names))
rownames(start.dag) <- colnames(start.dag) <- var_names

# Print the start.dag to check if it's correctly set up
print(start.dag)

# Build the score cache, with max.par = 2
mycache <- buildScoreCache(data.df = as.data.frame(abndata), data.dists = data.dists, 
                           dag.banned = banned, dag.retained=retain, max.parents = max.par)

# Perform the search for the DAG using Hill Climber, passing the start.dag as a matrix
mydag <- searchHillClimber(score.cache = mycache, start.dag = start.dag)

# If the search runs successfully, plot the DAG
plotAbn(dag = mydag)

fabn <- fitAbn(object = mydag)

summary(fabn)

plotAbn(dag = mydag, labels="TRUE")

fabn <- fitAbn(object = mydag)

plot(fabn)

###########3 parents/child###################



## Step 1: Open file and do some data wrangling, create groups of variables

library(haven)
library(dplyr)

# Increase memory limit to 16 GB (adjust as needed)
memory.limit(size = 16000)

# Read the dataset
file_path <- "E:\\16GBBACKUPUSB\\BACKUP_USB_SEPTEMBER2014\\SUMMER_STUDENT_2025\\HRS_NHANES_HANDLS_TLEPIGENMORT\\FINAL_DATA\\NHANES\\NHANES_MERGED_DATASET_ABN_DISCRETEfin.dta"
data.df <- read_dta(file_path)

# Summary of data to inspect structure
summary(data.df)

# Convert variables to factors
factorvars <- c("SEX", "d_var", "NHB", "HISP", "OTHER", "dummy1", "dummy2", "dummy3", "dummy4", "dummy5", "dummy6", "dummy7", "dummy8", "dummy9", "dummy10", "dummy11")
data.df[factorvars] <- lapply(data.df[factorvars], factor)

# Inspect structure of the data
str(data.df)

# Convert to data frame for further use
abndata <- as.data.frame(data.df)

# Define antecedent and outcome variables
antecedent_vars <- c("AGE", "SEX", "NHB", "HISP", "OTHER")
outcome_vars <- c("d_var")

# Step 2: Fit the additive Bayesian network using the abn package

# Define the data distributions
data.dists <- list(
  AGE = "gaussian",
  zHorvathAgeEAA = "gaussian",
  zHannumAgeEAA = "gaussian",
  zPhenoAgeEAA = "gaussian",
  zGrimAgeMortEAA = "gaussian",
  zDunedinPoAm = "gaussian",
  ztelomean_no_outliers = "gaussian",
  SEX = "binomial",
  d_var = "binomial",
  NHB = "binomial",
  HISP = "binomial",
  OTHER = "binomial",
  dummy1 = "binomial",
  dummy2 = "binomial",
  dummy3 = "binomial",
  dummy4 = "binomial",
  dummy5 = "binomial",
  dummy6 = "binomial",
  dummy7 = "binomial",
  dummy8 = "binomial",
  dummy9 = "binomial",
  dummy10 = "binomial",
  dummy11 = "binomial"
)

# Create an empty matrix for 'retain' and 'banned'
retain <- matrix(0, ncol(abndata), ncol(abndata))
colnames(retain) <- rownames(retain) <- names(abndata)

banned <- matrix(0, ncol(abndata), ncol(abndata))
colnames(banned) <- rownames(banned) <- names(abndata)

# Ban edges as needed from all variables into antecedent variables; and from final outcome into all other variables
# 1 (AGE), 8 (SEX), 10 (NHB), 11 (HISP), 12 (OTHER) Final outcome is #9, dummy times (13 to 23)
banned[1, -1] <- 1
banned[8, -8] <- 1
banned[10, -10] <- 1
banned[11, -11] <- 1
banned[12, -12] <- 1
banned[-9, 9] <- 1

# Ban future dummy times from predicting past dummy times
for (i in 13:22
) {
  for (j in (i+1):23) {
    banned[i, j] <- 1
  }
}

# Ensure all dummy variables directly predict d_var
dummy_vars <- paste0("dummy", 1:11)  # List of dummy variables
for (dummy in dummy_vars) {
  retain[dummy, "d_var"] <- 1
}


# Check the banned matrix
summary(banned)
View(banned)



# Check the retain matrix
summary(retain)
View(retain)

# Find overlapping edges between banned and retained
conflicts <- which(banned == 1 & retain == 1, arr.ind = TRUE)
print(conflicts)  # Should return an empty set if no conflicts exist

# Resolve conflicts by prioritizing bans (set to 0 in retained matrix)
retain[conflicts] <- 0


# Install the package if it's not already installed
if (!requireNamespace("abn", quietly = TRUE)) {
  install.packages("abn")
}

# Load the package
library(abn)


# Set max.parents
max.par <- 3

# Get the variable names from the dataset to ensure the order is correct
var_names <- colnames(abndata)

# Initialize the start.dag matrix with the correct dimensions (matching the number of variables)
start.dag <- matrix(0, nrow = length(var_names), ncol = length(var_names))
rownames(start.dag) <- colnames(start.dag) <- var_names

# Print the start.dag to check if it's correctly set up
print(start.dag)

# Build the score cache, with max.par = 2
mycache <- buildScoreCache(data.df = as.data.frame(abndata), data.dists = data.dists, 
                           dag.banned = banned, dag.retained=retain, max.parents = max.par)

# Perform the search for the DAG using Hill Climber, passing the start.dag as a matrix
mydag <- searchHillClimber(score.cache = mycache, start.dag = start.dag)

# If the search runs successfully, plot the DAG
plotAbn(dag = mydag)

fabn <- fitAbn(object = mydag)

summary(fabn)

plotAbn(dag = mydag, labels="TRUE")

fabn <- fitAbn(object = mydag)

plot(fabn)





//STEP 19: GSEM MODELS: FRIDAY //




//STEP 20: RSTUDIO CODE FOR GSEM FINDINGS, PROXIMAL AND EXPANDED DAGs: TUESDAY//










