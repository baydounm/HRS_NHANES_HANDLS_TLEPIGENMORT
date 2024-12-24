clear
clear mata
clear matrix
set maxvar 20000


*********************************************************************************************************************************************

capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\DATA_MANAGEMENT_HRS.smcl",replace

**STEP 0: OPEN FILES AND CREATE HHIDPN VARIABLE, SORT BY THIS VARIABLE**

cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS"

use randhrs1992_2020v2,clear


capture drop HHID PN
gen HHID=hhid
gen PN=pn
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save, replace

use trk2022tr_r,clear
capture rename HHID-VERSION,lower
save, replace

capture drop HHID PN
gen HHID=hhid
gen PN=pn
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save, replace

**STEP 1: REDUCE RAND FILE TO RESPONDENT VARIABLE FILE****

use randhrs1992_2020v2,clear
 
keep HHIDPN r* inw* h*

save randhrs1992_2020v2_resp, replace



**STEP 2: MERGE REDUCED RAND FILE WITH TRACKER FILE****

use randhrs1992_2020v2_resp,clear
capture drop _merge
merge HHIDPN using trk2022tr_r
tab _merge
capture drop _merge
sort HHIDPN
save randhrs1992_2020v2_resp_tracker, replace




**STEP 3: DESCRIBE AND SUMMARIZE THE FILE****

describe 

su 

**STEP 4: IDENTIFY THE REQUIRED VARIABLES USING RAND AND TRACKER FILE DOCUMENTATION AND LIST THEM ****
use randhrs1992_2020v2_resp_tracker,clear


**LIST OF AGE VARIABLES (2006-2018):
**2006 is r8: r8agey_e
**2008 is r9: r9agey_e
**2010 is r10: r10agey_e
**2012 is r11: r11agey_e
**2014 is r12: r12agey_e
**2016 is r13: r13agey_e
**2018 is r14: r14agey_e

su r8agey_e r9agey_e r10agey_e r11agey_e r12agey_e r13agey_e r14agey_e


**LIST OF VARIABLES NEEDED TO CREATE THE RACE/ETHNICITY (fixed):

**RACE: need to impute, n=5 missing**

capture drop RACE
gen RACE=rarace

tab RACE 

**Ethnicity: 1=Hispanic, 0=Non-Hispanic: n=1 missing

capture drop ETHNICITY
gen ETHNICITY=rahispan

tab ETHNICITY 

**RACE/ETHNICITY: 

capture drop RACE_ETHN
gen RACE_ETHN=.
replace RACE_ETHN=1 if RACE==1 & ETHNICITY==0
replace RACE_ETHN=2 if RACE==2 & ETHNICITY==0
replace RACE_ETHN=3 if ETHNICITY==1 & RACE~=.
replace RACE_ETHN=4 if RACE==3 & ETHNICITY==0

tab RACE_ETHN,missing
tab RACE_ETHN 


**GENDER (fixed):

capture drop SEX
gen SEX=ragender

tab SEX 


**EDUCATION (fixed):

tab raeduc, missing 

capture drop education
gen education = .
replace education = 1 if raeduc == 1 /*< HS*/
replace education = 2 if raeduc == 2 /*GED*/
replace education = 3 if raeduc == 3 /*HS GRADUATE*/
replace education = 4 if raeduc == 4 /*SOME COLLEGE*/
replace education = 5 if raeduc == 5 /*COLLEGE AND ABOVE*/

tab education , missing
tab education 

************************************************************2006*************************************************************


**INCOME VARIABLE (2006):

tab h8itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2006
gen totwealth_2006 = .
replace totwealth_2006 = 1 if h8itot < 25000
replace totwealth_2006 = 2 if h8itot >= 25000 & h8itot < 125000
replace totwealth_2006 = 3 if h8itot >= 125000 & h8itot < 300000
replace totwealth_2006 = 4 if h8itot >= 300000 & h8itot < 650000
replace totwealth_2006 = 5 if h8itot >= 650000 & h8itot ~= .


tab totwealth_2006 , missing
tab totwealth_2006 

save, replace

**MARITAL STATUS (2006)**

tab r8mstat, missing

capture drop marital_2006
gen marital_2006 = .
replace marital_2006 = 1 if r8mstat == 8 /*never married*/
replace marital_2006 = 2 if (r8mstat == 1 | r8mstat == 2 | r8mstat == 3) /*married / partnered*/
replace marital_2006 = 3 if (r8mstat == 4 | r8mstat == 5 | r8mstat == 6) /*separated / divorced*/
replace marital_2006 = 4 if (r8mstat == 7) /*widowed*/

tab marital_2006, missing
tab marital_2006

**EMPLOYMENT (2006):

tab r8work, missing

capture drop work_st_2006
gen work_st_2006 = .
replace work_st_2006 = 0 if r8work == 0
replace work_st_2006 = 1 if r8work == 1

tab work_st_2006, missing
tab work_st_2006


**CIGARETTE SMOKING (2006): 
tab r8smokev, missing
tab r8smoken, missing

capture drop smoking_2006
gen smoking_2006 = .
replace smoking_2006 = 1 if r8smokev == 0
replace smoking_2006 = 2 if r8smokev == 1 & r8smoken == 0
replace smoking_2006 = 3 if r8smokev == 1 & r8smoken == 1

tab smoking_2006, missing
tab smoking_2006 

save, replace



*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2006* n=173 missing/


tab r8drink, missing
tab r8drinkd, missing


capture drop alcohol_2006
gen alcohol_2006 = .
replace alcohol_2006 = 1 if r8drink == 0
replace alcohol_2006 = 2 if r8drink == 1 & r8drinkd == 0
replace alcohol_2006 = 3 if r8drink == 1 & (r8drinkd == 1 | r8drinkd == 2)
replace alcohol_2006 = 4 if r8drink == 1 & (r8drinkd > 3 & r8drinkd ~= . & r8drinkd ~= .d & r8drinkd ~= .m & r8drinkd ~= .r)

tab alcohol_2006, missing


**PHYSICAL ACTIVITY (2006):
tab r8vgactx, missing
tab r8mdactx, missing

capture drop physic_act_2006
gen physic_act_2006 = .
replace physic_act_2006 = 1 if (r8vgactx ==  5 & r8mdactx == 5)
replace physic_act_2006 = 2 if (r8vgactx ==  3 | r8mdactx == 3 | r8vgactx ==  4 | r8mdactx == 4)
replace physic_act_2006 = 3 if (r8vgactx ==  1 | r8mdactx == 1 | r8vgactx ==  2 | r8mdactx == 2)

tab physic_act_2006, missing
tab physic_act_2006


**SELF-RATED HEALTH (2006):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r8shlt, missing

capture drop srh_2006
gen srh_2006 = .
replace srh_2006 = 1 if (r8shlt == 1 | r8shlt == 2 | r8shlt == 3)
replace srh_2006 = 2 if (r8shlt == 4 | r8shlt == 5)

tab srh_2006, missing
tab srh_2006 

save, replace


**WEIGTH STATUS, 2006**
/*body mass index*/

/*2006*/

*<25 
**  25-29.9
**  ≥30


tab r8pmbmi, missing
tab r8bmi, missing
tab r8bmi , missing
tab r8bmi 
su r8bmi ,det


capture drop bmi_2006
gen bmi_2006 = r8pmbmi if r8pmbmi < 100
else replace bmi_2006 = r8bmi if r8bmi < 100

tab bmi_2006, missing
tab bmi_2006 , missing
tab bmi_2006 
su bmi_2006 , det



capture drop bmibr_2006
gen bmibr_2006 = 1 if bmi_2006 < 25
replace bmibr_2006 = 2 if bmi_2006 >= 25 & bmi_2006 < 30
replace bmibr_2006 = 3 if bmi_2006 >= 30 & bmi_2006 ~= .

tab bmibr_2006, missing


/*cardiometabolic risk factors and chronic conditions, 2006*/

/*HYPERTENSION*/

tab r8hibpe, missing

capture drop hbp_ever_2006sv
gen hbp_ever_2006 = .
replace hbp_ever_2006 = 0 if r8hibpe == 0
replace hbp_ever_2006 = 1 if r8hibpe == 1

tab hbp_ever_2006, missing
tab hbp_ever_2006 


/*DIABETES*/

tab r8diabe, missing

capture drop diab_ever_2006
gen diab_ever_2006 = .
replace diab_ever_2006 = 0 if r8diabe == 0
replace diab_ever_2006 = 1 if r8diabe == 1

tab diab_ever_2006, missing
tab diab_ever_2006 


/*HEART PROBLEMS*/

tab r8hearte, missing

capture drop heart_ever_2006
gen heart_ever_2006 = .
replace heart_ever_2006 = 0 if r8hearte == 0
replace heart_ever_2006 = 1 if r8hearte == 1

tab heart_ever_2006, missing
tab heart_ever_2006 


/*STROKE*/

tab r8stroke, missing

capture drop stroke_ever_2006
gen stroke_ever_2006 = .
replace stroke_ever_2006 = 0 if r8stroke == 0
replace stroke_ever_2006 = 1 if r8stroke == 1

tab stroke_ever_2006, missing
tab stroke_ever_2006 , missing
tab stroke_ever_2006 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2006
gen cardiometcond_2006 = .
replace cardiometcond_2006 = hbp_ever_2006 + diab_ever_2006 + heart_ever_2006 + stroke_ever_2006

tab cardiometcond_2006, missing
tab cardiometcond_2006 , missing
tab cardiometcond_2006 


capture drop cardiometcondbr_2006
gen cardiometcondbr_2006 = .
replace cardiometcondbr_2006 = 1 if cardiometcond_2006 ==0
replace cardiometcondbr_2006 = 2 if (cardiometcond_2006 == 1 | cardiometcond_2006 == 2)
replace cardiometcondbr_2006 = 3 if (cardiometcond_2006 == 3 | cardiometcond_2006 == 4)

tab cardiometcondbr_2006, missing
tab cardiometcondbr_2006 

**2006 CESD**
capture drop cesd_2006
gen cesd_2006=r8cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2006-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum 


************************************************2008****************************************************************************************************

**INCOME VARIABLE (2008):

tab h9itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2008
gen totwealth_2008 = .
replace totwealth_2008 = 1 if h9itot < 25000
replace totwealth_2008 = 2 if h9itot >= 25000 & h9itot < 125000
replace totwealth_2008 = 3 if h9itot >= 125000 & h9itot < 300000
replace totwealth_2008 = 4 if h9itot >= 300000 & h9itot < 650000
replace totwealth_2008 = 5 if h9itot >= 650000 & h9itot ~= .


tab totwealth_2008 , missing
tab totwealth_2008 

save, replace

**MARITAL STATUS (2008)**

tab r9mstat, missing

capture drop marital_2008
gen marital_2008 = .
replace marital_2008 = 1 if r9mstat == 8 /*never married*/
replace marital_2008 = 2 if (r9mstat == 1 | r9mstat == 2 | r9mstat == 3) /*married / partnered*/
replace marital_2008 = 3 if (r9mstat == 4 | r9mstat == 5 | r9mstat == 6) /*separated / divorced*/
replace marital_2008 = 4 if (r9mstat == 7) /*widowed*/

tab marital_2008, missing
tab marital_2008

**EMPLOYMENT (2008):

tab r9work, missing

capture drop work_st_2008
gen work_st_2008 = .
replace work_st_2008 = 0 if r9work == 0
replace work_st_2008 = 1 if r9work == 1

tab work_st_2008, missing
tab work_st_2008


**CIGARETTE SMOKING (2008): 
tab r9smokev, missing
tab r9smoken, missing

capture drop smoking_2008
gen smoking_2008 = .
replace smoking_2008 = 1 if r9smokev == 0
replace smoking_2008 = 2 if r9smokev == 1 & r9smoken == 0
replace smoking_2008 = 3 if r9smokev == 1 & r9smoken == 1

tab smoking_2008, missing
tab smoking_2008 

save, replace

*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2008* n=173 missing/


tab r10drink, missing
tab r10drinkd, missing


*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2008* n=173 missing/


tab r9drink, missing
tab r9drinkd, missing


capture drop alcohol_2008
gen alcohol_2008 = .
replace alcohol_2008 = 1 if r9drink == 0
replace alcohol_2008 = 2 if r9drink == 1 & r9drinkd == 0
replace alcohol_2008 = 3 if r9drink == 1 & (r9drinkd == 1 | r9drinkd == 2)
replace alcohol_2008 = 4 if r9drink == 1 & (r9drinkd > 3 & r9drinkd ~= . & r9drinkd ~= .d & r9drinkd ~= .m & r9drinkd ~= .r)

tab alcohol_2008, missing


**PHYSICAL ACTIVITY (2008):
tab r9vgactx, missing
tab r9mdactx, missing

capture drop physic_act_2008
gen physic_act_2008 = .
replace physic_act_2008 = 1 if (r9vgactx ==  5 & r9mdactx == 5)
replace physic_act_2008 = 2 if (r9vgactx ==  3 | r9mdactx == 3 | r9vgactx ==  4 | r9mdactx == 4)
replace physic_act_2008 = 3 if (r9vgactx ==  1 | r9mdactx == 1 | r9vgactx ==  2 | r9mdactx == 2)

tab physic_act_2008, missing
tab physic_act_2008


**SELF-RATED HEALTH (2008):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r9shlt, missing

capture drop srh_2008
gen srh_2008 = .
replace srh_2008 = 1 if (r9shlt == 1 | r9shlt == 2 | r9shlt == 3)
replace srh_2008 = 2 if (r9shlt == 4 | r9shlt == 5)

tab srh_2008, missing
tab srh_2008 

save, replace


**WEIGTH STATUS, 2008**
/*body mass index*/

/*2008*/

*<25 
**  25-29.9
**  ≥30


tab r9pmbmi, missing
tab r9bmi, missing
tab r9bmi , missing
tab r9bmi 
su r9bmi ,det


capture drop bmi_2008
gen bmi_2008 = r9pmbmi if r9pmbmi < 100
else replace bmi_2008 = r9bmi if r9bmi < 100

tab bmi_2008, missing
tab bmi_2008 , missing
tab bmi_2008 
su bmi_2008 , det



capture drop bmibr_2008
gen bmibr_2008 = 1 if bmi_2008 < 25
replace bmibr_2008 = 2 if bmi_2008 >= 25 & bmi_2008 < 30
replace bmibr_2008 = 3 if bmi_2008 >= 30 & bmi_2008 ~= .

tab bmibr_2008, missing


/*cardiometabolic risk factors and chronic conditions, 2008*/

/*HYPERTENSION*/

tab r9hibpe, missing

capture drop hbp_ever_2008
gen hbp_ever_2008 = .
replace hbp_ever_2008 = 0 if r9hibpe == 0
replace hbp_ever_2008 = 1 if r9hibpe == 1

tab hbp_ever_2008, missing
tab hbp_ever_2008 


/*DIABETES*/

tab r9diabe, missing

capture drop diab_ever_2008
gen diab_ever_2008 = .
replace diab_ever_2008 = 0 if r9diabe == 0
replace diab_ever_2008 = 1 if r9diabe == 1

tab diab_ever_2008, missing
tab diab_ever_2008 


/*HEART PROBLEMS*/

tab r9hearte, missing

capture drop heart_ever_2008
gen heart_ever_2008 = .
replace heart_ever_2008 = 0 if r9hearte == 0
replace heart_ever_2008 = 1 if r9hearte == 1

tab heart_ever_2008, missing
tab heart_ever_2008 


/*STROKE*/

tab r9stroke, missing

capture drop stroke_ever_2008
gen stroke_ever_2008 = .
replace stroke_ever_2008 = 0 if r9stroke == 0
replace stroke_ever_2008 = 1 if r9stroke == 1

tab stroke_ever_2008, missing
tab stroke_ever_2008 , missing
tab stroke_ever_2008 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2008
gen cardiometcond_2008 = .
replace cardiometcond_2008 = hbp_ever_2008 + diab_ever_2008 + heart_ever_2008 + stroke_ever_2008

tab cardiometcond_2008, missing
tab cardiometcond_2008 , missing
tab cardiometcond_2008 


capture drop cardiometcondbr_2008
gen cardiometcondbr_2008 = .
replace cardiometcondbr_2008 = 1 if cardiometcond_2008 ==0
replace cardiometcondbr_2008 = 2 if (cardiometcond_2008 == 1 | cardiometcond_2008 == 2)
replace cardiometcondbr_2008 = 3 if (cardiometcond_2008 == 3 | cardiometcond_2008 == 4)

tab cardiometcondbr_2008, missing
tab cardiometcondbr_2008 

**2008 CESD**
capture drop cesd_2008
gen cesd_2008=r9cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2008-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum 


**********************************************2010***************************************************************


**INCOME VARIABLE (2010):

tab h10itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2010
gen totwealth_2010 = .
replace totwealth_2010 = 1 if h10itot < 25000
replace totwealth_2010 = 2 if h10itot >= 25000 & h10itot < 125000
replace totwealth_2010 = 3 if h10itot >= 125000 & h10itot < 300000
replace totwealth_2010 = 4 if h10itot >= 300000 & h10itot < 650000
replace totwealth_2010 = 5 if h10itot >= 650000 & h10itot ~= .


tab totwealth_2010 , missing
tab totwealth_2010 

save, replace

**MARITAL STATUS (2010)**

tab r10mstat, missing

capture drop marital_2010
gen marital_2010 = .
replace marital_2010 = 1 if r10mstat == 8 /*never married*/
replace marital_2010 = 2 if (r10mstat == 1 | r10mstat == 2 | r10mstat == 3) /*married / partnered*/
replace marital_2010 = 3 if (r10mstat == 4 | r10mstat == 5 | r10mstat == 6) /*separated / divorced*/
replace marital_2010 = 4 if (r10mstat == 7) /*widowed*/

tab marital_2010, missing
tab marital_2010

**EMPLOYMENT (2010):

tab r10work, missing

capture drop work_st_2010
gen work_st_2010 = .
replace work_st_2010 = 0 if r10work == 0
replace work_st_2010 = 1 if r10work == 1

tab work_st_2010, missing
tab work_st_2010


**CIGARETTE SMOKING (2010): 
tab r10smokev, missing
tab r10smoken, missing

capture drop smoking_2010
gen smoking_2010 = .
replace smoking_2010 = 1 if r10smokev == 0
replace smoking_2010 = 2 if r10smokev == 1 & r10smoken == 0
replace smoking_2010 = 3 if r10smokev == 1 & r10smoken == 1

tab smoking_2010, missing
tab smoking_2010 

save, replace


*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2010* n=173 missing/


tab r10drink, missing
tab r10drinkd, missing


capture drop alcohol_2010
gen alcohol_2010 = .
replace alcohol_2010 = 1 if r10drink == 0
replace alcohol_2010 = 2 if r10drink == 1 & r10drinkd == 0
replace alcohol_2010 = 3 if r10drink == 1 & (r10drinkd == 1 | r10drinkd == 2)
replace alcohol_2010 = 4 if r10drink == 1 & (r10drinkd > 3 & r10drinkd ~= . & r10drinkd ~= .d & r10drinkd ~= .m & r10drinkd ~= .r)

tab alcohol_2010, missing


**PHYSICAL ACTIVITY (2010):
tab r10vgactx, missing
tab r10mdactx, missing

capture drop physic_act_2010
gen physic_act_2010 = .
replace physic_act_2010 = 1 if (r10vgactx ==  5 & r10mdactx == 5)
replace physic_act_2010 = 2 if (r10vgactx ==  3 | r10mdactx == 3 | r10vgactx ==  4 | r10mdactx == 4)
replace physic_act_2010 = 3 if (r10vgactx ==  1 | r10mdactx == 1 | r10vgactx ==  2 | r10mdactx == 2)

tab physic_act_2010, missing
tab physic_act_2010


**SELF-RATED HEALTH (2010):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r10shlt, missing

capture drop srh_2010
gen srh_2010 = .
replace srh_2010 = 1 if (r10shlt == 1 | r10shlt == 2 | r10shlt == 3)
replace srh_2010 = 2 if (r10shlt == 4 | r10shlt == 5)

tab srh_2010, missing
tab srh_2010 

save, replace


**WEIGTH STATUS, 2010**
/*body mass index*/

/*2010*/

*<25 
**  25-29.9
**  ≥30


tab r10pmbmi, missing
tab r10bmi, missing
tab r10bmi , missing
tab r10bmi 
su r10bmi ,det


capture drop bmi_2010
gen bmi_2010 = r10pmbmi if r10pmbmi < 100
else replace bmi_2010 = r10bmi if r10bmi < 100

tab bmi_2010, missing
tab bmi_2010 , missing
tab bmi_2010 
su bmi_2010 , det



capture drop bmibr_2010
gen bmibr_2010 = 1 if bmi_2010 < 25
replace bmibr_2010 = 2 if bmi_2010 >= 25 & bmi_2010 < 30
replace bmibr_2010 = 3 if bmi_2010 >= 30 & bmi_2010 ~= .

tab bmibr_2010, missing


/*cardiometabolic risk factors and chronic conditions, 2010*/

/*HYPERTENSION*/

tab r10hibpe, missing

capture drop hbp_ever_2010
gen hbp_ever_2010 = .
replace hbp_ever_2010 = 0 if r10hibpe == 0
replace hbp_ever_2010 = 1 if r10hibpe == 1

tab hbp_ever_2010, missing
tab hbp_ever_2010 


/*DIABETES*/

tab r10diabe, missing

capture drop diab_ever_2010
gen diab_ever_2010 = .
replace diab_ever_2010 = 0 if r10diabe == 0
replace diab_ever_2010 = 1 if r10diabe == 1

tab diab_ever_2010, missing
tab diab_ever_2010 


/*HEART PROBLEMS*/

tab r10hearte, missing

capture drop heart_ever_2010
gen heart_ever_2010 = .
replace heart_ever_2010 = 0 if r10hearte == 0
replace heart_ever_2010 = 1 if r10hearte == 1

tab heart_ever_2010, missing
tab heart_ever_2010 


/*STROKE*/

tab r10stroke, missing

capture drop stroke_ever_2010
gen stroke_ever_2010 = .
replace stroke_ever_2010 = 0 if r10stroke == 0
replace stroke_ever_2010 = 1 if r10stroke == 1

tab stroke_ever_2010, missing
tab stroke_ever_2010 , missing
tab stroke_ever_2010 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2010
gen cardiometcond_2010 = .
replace cardiometcond_2010 = hbp_ever_2010 + diab_ever_2010 + heart_ever_2010 + stroke_ever_2010

tab cardiometcond_2010, missing
tab cardiometcond_2010 , missing
tab cardiometcond_2010 


capture drop cardiometcondbr_2010
gen cardiometcondbr_2010 = .
replace cardiometcondbr_2010 = 1 if cardiometcond_2010 ==0
replace cardiometcondbr_2010 = 2 if (cardiometcond_2010 == 1 | cardiometcond_2010 == 2)
replace cardiometcondbr_2010 = 3 if (cardiometcond_2010 == 3 | cardiometcond_2010 == 4)

tab cardiometcondbr_2010, missing
tab cardiometcondbr_2010 

**2010 CESD**
capture drop cesd_2010
gen cesd_2010=r10cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2010-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum 

save,replace


**********************************************2012***************************************************************


**INCOME VARIABLE (2012):

tab h11itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2012
gen totwealth_2012 = .
replace totwealth_2012 = 1 if h11itot < 25000
replace totwealth_2012 = 2 if h11itot >= 25000 & h11itot < 125000
replace totwealth_2012 = 3 if h11itot >= 125000 & h11itot < 300000
replace totwealth_2012 = 4 if h11itot >= 300000 & h11itot < 650000
replace totwealth_2012 = 5 if h11itot >= 650000 & h11itot ~= .


tab totwealth_2012 , missing
tab totwealth_2012 

save, replace

**MARITAL STATUS (2012)**

tab r11mstat, missing

capture drop marital_2012
gen marital_2012 = .
replace marital_2012 = 1 if r11mstat == 8 /*never married*/
replace marital_2012 = 2 if (r11mstat == 1 | r11mstat == 2 | r11mstat == 3) /*married / partnered*/
replace marital_2012 = 3 if (r11mstat == 4 | r11mstat == 5 | r11mstat == 6) /*separated / divorced*/
replace marital_2012 = 4 if (r11mstat == 7) /*widowed*/

tab marital_2012, missing
tab marital_2012

**EMPLOYMENT (2012):

tab r11work, missing

capture drop work_st_2012
gen work_st_2012 = .
replace work_st_2012 = 0 if r11work == 0
replace work_st_2012 = 1 if r11work == 1

tab work_st_2012, missing
tab work_st_2012


**CIGARETTE SMOKING (2012): 
tab r11smokev, missing
tab r11smoken, missing

capture drop smoking_2012
gen smoking_2012 = .
replace smoking_2012 = 1 if r11smokev == 0
replace smoking_2012 = 2 if r11smokev == 1 & r11smoken == 0
replace smoking_2012 = 3 if r11smokev == 1 & r11smoken == 1

tab smoking_2012, missing
tab smoking_2012 

save, replace

*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2012* n=173 missing/


tab r11drink, missing
tab r11drinkd, missing


capture drop alcohol_2012
gen alcohol_2012 = .
replace alcohol_2012 = 1 if r11drink == 0
replace alcohol_2012 = 2 if r11drink == 1 & r11drinkd == 0
replace alcohol_2012 = 3 if r11drink == 1 & (r11drinkd == 1 | r11drinkd == 2)
replace alcohol_2012 = 4 if r11drink == 1 & (r11drinkd > 3 & r11drinkd ~= . & r11drinkd ~= .d & r11drinkd ~= .m & r11drinkd ~= .r)

tab alcohol_2012, missing


**PHYSICAL ACTIVITY (2012):
tab r11vgactx, missing
tab r11mdactx, missing

capture drop physic_act_2012
gen physic_act_2012 = .
replace physic_act_2012 = 1 if (r11vgactx ==  5 & r11mdactx == 5)
replace physic_act_2012 = 2 if (r11vgactx ==  3 | r11mdactx == 3 | r11vgactx ==  4 | r11mdactx == 4)
replace physic_act_2012 = 3 if (r11vgactx ==  1 | r11mdactx == 1 | r11vgactx ==  2 | r11mdactx == 2)

tab physic_act_2012, missing
tab physic_act_2012


**SELF-RATED HEALTH (2012):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r11shlt, missing

capture drop srh_2012
gen srh_2012 = .
replace srh_2012 = 1 if (r11shlt == 1 | r11shlt == 2 | r11shlt == 3)
replace srh_2012 = 2 if (r11shlt == 4 | r11shlt == 5)

tab srh_2012, missing
tab srh_2012 

save, replace


**WEIGTH STATUS, 2012**
/*body mass index*/

/*2012*/

*<25 
**  25-29.9
**  ≥30


tab r11pmbmi, missing
tab r11bmi, missing
tab r11bmi , missing
tab r11bmi 
su r11bmi ,det


capture drop bmi_2012
gen bmi_2012 = r11pmbmi if r11pmbmi < 100
else replace bmi_2012 = r11bmi if r11bmi < 100

tab bmi_2012, missing
tab bmi_2012 , missing
tab bmi_2012 
su bmi_2012 , det



capture drop bmibr_2012
gen bmibr_2012 = 1 if bmi_2012 < 25
replace bmibr_2012 = 2 if bmi_2012 >= 25 & bmi_2012 < 30
replace bmibr_2012 = 3 if bmi_2012 >= 30 & bmi_2012 ~= .

tab bmibr_2012, missing


/*cardiometabolic risk factors and chronic conditions, 2012*/

/*HYPERTENSION*/

tab r11hibpe, missing

capture drop hbp_ever_2012
gen hbp_ever_2012 = .
replace hbp_ever_2012 = 0 if r11hibpe == 0
replace hbp_ever_2012 = 1 if r11hibpe == 1

tab hbp_ever_2012, missing
tab hbp_ever_2012 


/*DIABETES*/

tab r11diabe, missing

capture drop diab_ever_2012
gen diab_ever_2012 = .
replace diab_ever_2012 = 0 if r11diabe == 0
replace diab_ever_2012 = 1 if r11diabe == 1

tab diab_ever_2012, missing
tab diab_ever_2012 


/*HEART PROBLEMS*/

tab r11hearte, missing

capture drop heart_ever_2012
gen heart_ever_2012 = .
replace heart_ever_2012 = 0 if r11hearte == 0
replace heart_ever_2012 = 1 if r11hearte == 1

tab heart_ever_2012, missing
tab heart_ever_2012 


/*STROKE*/

tab r11stroke, missing

capture drop stroke_ever_2012
gen stroke_ever_2012 = .
replace stroke_ever_2012 = 0 if r11stroke == 0
replace stroke_ever_2012 = 1 if r11stroke == 1

tab stroke_ever_2012, missing
tab stroke_ever_2012 , missing
tab stroke_ever_2012 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2012
gen cardiometcond_2012 = .
replace cardiometcond_2012 = hbp_ever_2012 + diab_ever_2012 + heart_ever_2012 + stroke_ever_2012

tab cardiometcond_2012, missing
tab cardiometcond_2012 , missing
tab cardiometcond_2012 


capture drop cardiometcondbr_2012
gen cardiometcondbr_2012 = .
replace cardiometcondbr_2012 = 1 if cardiometcond_2012 ==0
replace cardiometcondbr_2012 = 2 if (cardiometcond_2012 == 1 | cardiometcond_2012 == 2)
replace cardiometcondbr_2012 = 3 if (cardiometcond_2012 == 3 | cardiometcond_2012 == 4)

tab cardiometcondbr_2012, missing
tab cardiometcondbr_2012 

**2012 CESD**
capture drop cesd_2012
gen cesd_2012=r11cesd


save, replace




**********************************************2014***************************************************************


**INCOME VARIABLE (2014):

tab h12itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2014
gen totwealth_2014 = .
replace totwealth_2014 = 1 if h12itot < 25000
replace totwealth_2014 = 2 if h12itot >= 25000 & h12itot < 125000
replace totwealth_2014 = 3 if h12itot >= 125000 & h12itot < 300000
replace totwealth_2014 = 4 if h12itot >= 300000 & h12itot < 650000
replace totwealth_2014 = 5 if h12itot >= 650000 & h12itot ~= .


tab totwealth_2014 , missing
tab totwealth_2014 

save, replace

**MARITAL STATUS (2014)**

tab r12mstat, missing

capture drop marital_2014
gen marital_2014 = .
replace marital_2014 = 1 if r12mstat == 8 /*never married*/
replace marital_2014 = 2 if (r12mstat == 1 | r12mstat == 2 | r12mstat == 3) /*married / partnered*/
replace marital_2014 = 3 if (r12mstat == 4 | r12mstat == 5 | r12mstat == 6) /*separated / divorced*/
replace marital_2014 = 4 if (r12mstat == 7) /*widowed*/

tab marital_2014, missing
tab marital_2014

**EMPLOYMENT (2014):

tab r12work, missing

capture drop work_st_2014
gen work_st_2014 = .
replace work_st_2014 = 0 if r12work == 0
replace work_st_2014 = 1 if r12work == 1

tab work_st_2014, missing
tab work_st_2014


**CIGARETTE SMOKING (2014): 
tab r12smokev, missing
tab r12smoken, missing

capture drop smoking_2014
gen smoking_2014 = .
replace smoking_2014 = 1 if r12smokev == 0
replace smoking_2014 = 2 if r12smokev == 1 & r12smoken == 0
replace smoking_2014 = 3 if r12smokev == 1 & r12smoken == 1

tab smoking_2014, missing
tab smoking_2014 

save, replace

*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2014* n=173 missing/


tab r12drink, missing
tab r12drinkd, missing


capture drop alcohol_2014
gen alcohol_2014 = .
replace alcohol_2014 = 1 if r12drink == 0
replace alcohol_2014 = 2 if r12drink == 1 & r12drinkd == 0
replace alcohol_2014 = 3 if r12drink == 1 & (r12drinkd == 1 | r12drinkd == 2)
replace alcohol_2014 = 4 if r12drink == 1 & (r12drinkd > 3 & r12drinkd ~= . & r12drinkd ~= .d & r12drinkd ~= .m & r12drinkd ~= .r)

tab alcohol_2014, missing


**PHYSICAL ACTIVITY (2014):
tab r12vgactx, missing
tab r12mdactx, missing

capture drop physic_act_2014
gen physic_act_2014 = .
replace physic_act_2014 = 1 if (r12vgactx ==  5 & r12mdactx == 5)
replace physic_act_2014 = 2 if (r12vgactx ==  3 | r12mdactx == 3 | r12vgactx ==  4 | r12mdactx == 4)
replace physic_act_2014 = 3 if (r12vgactx ==  1 | r12mdactx == 1 | r12vgactx ==  2 | r12mdactx == 2)

tab physic_act_2014, missing
tab physic_act_2014


**SELF-RATED HEALTH (2014):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r12shlt, missing

capture drop srh_2014
gen srh_2014 = .
replace srh_2014 = 1 if (r12shlt == 1 | r12shlt == 2 | r12shlt == 3)
replace srh_2014 = 2 if (r12shlt == 4 | r12shlt == 5)

tab srh_2014, missing
tab srh_2014 

save, replace


**WEIGTH STATUS, 2014**
/*body mass index*/

/*2014*/

*<25 
**  25-29.9
**  ≥30


tab r12pmbmi, missing
tab r12bmi, missing
tab r12bmi , missing
tab r12bmi 
su r12bmi ,det


capture drop bmi_2014
gen bmi_2014 = r12pmbmi if r12pmbmi < 100
else replace bmi_2014 = r12bmi if r12bmi < 100

tab bmi_2014, missing
tab bmi_2014 , missing
tab bmi_2014 
su bmi_2014 , det



capture drop bmibr_2014
gen bmibr_2014 = 1 if bmi_2014 < 25
replace bmibr_2014 = 2 if bmi_2014 >= 25 & bmi_2014 < 30
replace bmibr_2014 = 3 if bmi_2014 >= 30 & bmi_2014 ~= .

tab bmibr_2014, missing


/*cardiometabolic risk factors and chronic conditions, 2014*/

/*HYPERTENSION*/

tab r12hibpe, missing

capture drop hbp_ever_2014
gen hbp_ever_2014 = .
replace hbp_ever_2014 = 0 if r12hibpe == 0
replace hbp_ever_2014 = 1 if r12hibpe == 1

tab hbp_ever_2014, missing
tab hbp_ever_2014 


/*DIABETES*/

tab r12diabe, missing

capture drop diab_ever_2014
gen diab_ever_2014 = .
replace diab_ever_2014 = 0 if r12diabe == 0
replace diab_ever_2014 = 1 if r12diabe == 1

tab diab_ever_2014, missing
tab diab_ever_2014 


/*HEART PROBLEMS*/

tab r12hearte, missing

capture drop heart_ever_2014
gen heart_ever_2014 = .
replace heart_ever_2014 = 0 if r12hearte == 0
replace heart_ever_2014 = 1 if r12hearte == 1

tab heart_ever_2014, missing
tab heart_ever_2014 


/*STROKE*/

tab r12stroke, missing

capture drop stroke_ever_2014
gen stroke_ever_2014 = .
replace stroke_ever_2014 = 0 if r12stroke == 0
replace stroke_ever_2014 = 1 if r12stroke == 1

tab stroke_ever_2014, missing
tab stroke_ever_2014 , missing
tab stroke_ever_2014 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2014
gen cardiometcond_2014 = .
replace cardiometcond_2014 = hbp_ever_2014 + diab_ever_2014 + heart_ever_2014 + stroke_ever_2014

tab cardiometcond_2014, missing
tab cardiometcond_2014 , missing
tab cardiometcond_2014 


capture drop cardiometcondbr_2014
gen cardiometcondbr_2014 = .
replace cardiometcondbr_2014 = 1 if cardiometcond_2014 ==0
replace cardiometcondbr_2014 = 2 if (cardiometcond_2014 == 1 | cardiometcond_2014 == 2)
replace cardiometcondbr_2014 = 3 if (cardiometcond_2014 == 3 | cardiometcond_2014 == 4)

tab cardiometcondbr_2014, missing
tab cardiometcondbr_2014 

**2014 CESD**
capture drop cesd_2014
gen cesd_2014=r12cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2014-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum 

save,replace


**************************************************2016************************************************************


**INCOME VARIABLE (2016):

tab h13itot, missing

 /*< 25,000*/ 
/*25,000–124,999*/ 
/*125,000–299,999*/ 
/*300,000–649,999*/ 
/*≥ 650,000*/


capture drop totwealth_2016
gen totwealth_2016 = .
replace totwealth_2016 = 1 if h13itot < 25000
replace totwealth_2016 = 2 if h13itot >= 25000 & h13itot < 125000
replace totwealth_2016 = 3 if h13itot >= 125000 & h13itot < 300000
replace totwealth_2016 = 4 if h13itot >= 300000 & h13itot < 650000
replace totwealth_2016 = 5 if h13itot >= 650000 & h13itot ~= .


tab totwealth_2016 , missing
tab totwealth_2016 

save, replace

**MARITAL STATUS (2016)**

tab r13mstat, missing

capture drop marital_2016
gen marital_2016 = .
replace marital_2016 = 1 if r13mstat == 8 /*never married*/
replace marital_2016 = 2 if (r13mstat == 1 | r13mstat == 2 | r13mstat == 3) /*married / partnered*/
replace marital_2016 = 3 if (r13mstat == 4 | r13mstat == 5 | r13mstat == 6) /*separated / divorced*/
replace marital_2016 = 4 if (r13mstat == 7) /*widowed*/

tab marital_2016, missing
tab marital_2016

**EMPLOYMENT (2016):

tab r13work, missing

capture drop work_st_2016
gen work_st_2016 = .
replace work_st_2016 = 0 if r13work == 0
replace work_st_2016 = 1 if r13work == 1

tab work_st_2016, missing
tab work_st_2016


**CIGARETTE SMOKING (2016): 
tab r13smokev, missing
tab r13smoken, missing

capture drop smoking_2016
gen smoking_2016 = .
replace smoking_2016 = 1 if r13smokev == 0
replace smoking_2016 = 2 if r13smokev == 1 & r13smoken == 0
replace smoking_2016 = 3 if r13smokev == 1 & r13smoken == 1

tab smoking_2016, missing
tab smoking_2016 

save, replace

*Alcohol driking:(abstinent, 1-3 days per month, 1-2 days per week, ≥3 days per week) *2016* n=173 missing/


tab r13drink, missing
tab r13drinkd, missing


capture drop alcohol_2016
gen alcohol_2016 = .
replace alcohol_2016 = 1 if r13drink == 0
replace alcohol_2016 = 2 if r13drink == 1 & r13drinkd == 0
replace alcohol_2016 = 3 if r13drink == 1 & (r13drinkd == 1 | r13drinkd == 2)
replace alcohol_2016 = 4 if r13drink == 1 & (r13drinkd > 3 & r13drinkd ~= . & r13drinkd ~= .d & r13drinkd ~= .m & r13drinkd ~= .r)

tab alcohol_2016, missing


**PHYSICAL ACTIVITY (2016):
tab r13vgactx, missing
tab r13mdactx, missing

capture drop physic_act_2016
gen physic_act_2016 = .
replace physic_act_2016 = 1 if (r13vgactx ==  5 & r13mdactx == 5)
replace physic_act_2016 = 2 if (r13vgactx ==  3 | r13mdactx == 3 | r13vgactx ==  4 | r13mdactx == 4)
replace physic_act_2016 = 3 if (r13vgactx ==  1 | r13mdactx == 1 | r13vgactx ==  2 | r13mdactx == 2)

tab physic_act_2016, missing
tab physic_act_2016


**SELF-RATED HEALTH (2016):


/*   Excellent/very good/good
    Fair/poor 
*/


tab r13shlt, missing

capture drop srh_2016
gen srh_2016 = .
replace srh_2016 = 1 if (r13shlt == 1 | r13shlt == 2 | r13shlt == 3)
replace srh_2016 = 2 if (r13shlt == 4 | r13shlt == 5)

tab srh_2016, missing
tab srh_2016 

save, replace


**WEIGTH STATUS, 2016**
/*body mass index*/

/*2016*/

*<25 
**  25-29.9
**  ≥30


tab r13pmbmi, missing
tab r13bmi, missing
tab r13bmi , missing
tab r13bmi 
su r13bmi ,det


capture drop bmi_2016
gen bmi_2016 = r13pmbmi if r13pmbmi < 100
else replace bmi_2016 = r13bmi if r13bmi < 100

tab bmi_2016, missing
tab bmi_2016 , missing
tab bmi_2016 
su bmi_2016 , det



capture drop bmibr_2016
gen bmibr_2016 = 1 if bmi_2016 < 25
replace bmibr_2016 = 2 if bmi_2016 >= 25 & bmi_2016 < 30
replace bmibr_2016 = 3 if bmi_2016 >= 30 & bmi_2016 ~= .

tab bmibr_2016, missing


/*cardiometabolic risk factors and chronic conditions, 2016*/

/*HYPERTENSION*/

tab r13hibpe, missing

capture drop hbp_ever_2016
gen hbp_ever_2016 = .
replace hbp_ever_2016 = 0 if r13hibpe == 0
replace hbp_ever_2016 = 1 if r13hibpe == 1

tab hbp_ever_2016, missing
tab hbp_ever_2016 


/*DIABETES*/

tab r13diabe, missing

capture drop diab_ever_2016
gen diab_ever_2016 = .
replace diab_ever_2016 = 0 if r13diabe == 0
replace diab_ever_2016 = 1 if r13diabe == 1

tab diab_ever_2016, missing
tab diab_ever_2016 


/*HEART PROBLEMS*/

tab r13hearte, missing

capture drop heart_ever_2016
gen heart_ever_2016 = .
replace heart_ever_2016 = 0 if r13hearte == 0
replace heart_ever_2016 = 1 if r13hearte == 1

tab heart_ever_2016, missing
tab heart_ever_2016 


/*STROKE*/

tab r13stroke, missing

capture drop stroke_ever_2016
gen stroke_ever_2016 = .
replace stroke_ever_2016 = 0 if r13stroke == 0
replace stroke_ever_2016 = 1 if r13stroke == 1

tab stroke_ever_2016, missing
tab stroke_ever_2016 , missing
tab stroke_ever_2016 


/*NUMBER OF CONDITIONS*/
**  0
**    1-2
**    ≥ 3


capture drop cardiometcond_2016
gen cardiometcond_2016 = .
replace cardiometcond_2016 = hbp_ever_2016 + diab_ever_2016 + heart_ever_2016 + stroke_ever_2016

tab cardiometcond_2016, missing
tab cardiometcond_2016 , missing
tab cardiometcond_2016 


capture drop cardiometcondbr_2016
gen cardiometcondbr_2016 = .
replace cardiometcondbr_2016 = 1 if cardiometcond_2016 ==0
replace cardiometcondbr_2016 = 2 if (cardiometcond_2016 == 1 | cardiometcond_2016 == 2)
replace cardiometcondbr_2016 = 3 if (cardiometcond_2016 == 3 | cardiometcond_2016 == 4)

tab cardiometcondbr_2016, missing
tab cardiometcondbr_2016 

**2016 CESD**
capture drop cesd_2016
gen cesd_2016=r13cesd


save, replace


**INW VARIABLES FROM TRACKER FILE (2016-2018):

tab1 inw*

save, replace

**PSU, STRATUM AND WEIGHT VARIABLES (NOT NEEDED FOR THIS ANALYSIS):
tab1 secu stratum 

save,replace

*******************************************STEP 5: MERGE WITH TELOMERE LENGTH DATA**************************************************************

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\randhrs1992_2020v2_resp_tracker",clear

sort HHIDPN
capture drop _merge

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\randhrs1992_2020v2_resp_tracker",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\TELOMERESA_R",clear
 
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

save, replace

merge HHIDPN using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\randhrs1992_2020v2_resp_tracker"

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta", replace 


****************************************STEP 6: MERGE WITH EPIGENETIC DATA*******************************************************************************

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",clear
tab _merge
sort HHIDPN
capture drop _merge
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta", replace 


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\EPICLOCKA_R.dta",clear
destring HHID, replace
destring PN, replace

capture drop HHIDPN
egen HHIDPN = concat(HHID PN)

destring HHIDPN, replace
sort HHIDPN

capture drop _merge
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\EPICLOCKA_R.dta",replace


merge HHIDPN using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta"
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta", replace 



*****************************************************************************************************************


capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\FIGURES1_HRS_PARTICIPANTFLOWCHART.smcl",replace

******************************************STEP 7: PARTICIPANT FLOWCHART******************************************************************


**DETERMINE SAMPLE WITH COMPLETE DATA ON TELOMERE LENGTH AND EPIGENETIC CLOCK AND WHERE RESPONDENT'S AGE IS >50 IN 2008 AND ALIVE IN 2016**

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",clear

capture drop sample50plus2008
gen sample50plus2008=.
replace sample50plus2008=1 if r9agey_e>=50 & r9agey_e~=.
replace sample50plus2008=0 if sample50plus2008~=1 & r9agey_e~=.

tab sample50plus2008

capture drop samplealivein2016
gen samplealivein2016=.
replace samplealivein2016=1 if inw13==1
replace samplealivein2016=0 if samplealivein2016~=1

tab samplealivein2016


capture drop sampleTL2008
gen sampleTL2008=.
replace sampleTL2008=1 if FINAL_T_S~=. & FINAL_CV~=.
replace sampleTL2008=0 if sampleTL2008~=1 

tab sampleTL2008

**Exclude outliers**

local vars FINAL_T_S FINAL_CV  // Replace with your actual variable names

capture drop FINAL_T_S_no_outliers
capture drop FINAL_CV_no_outliers 

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


capture drop sampleTL2008fin
gen sampleTL2008fin=.
replace sampleTL2008fin=1 if sampleTL2008==1 & FINAL_T_S_no_outliers~=. & FINAL_CV_no_outliers~=.
replace sampleTL2008fin=0 if sampleTL2008fin~=1

tab sampleTL2008fin

capture drop sampleEPI2016
gen sampleEPI2016=.
replace sampleEPI2016=1 if HORVATH_DNAMAGE~=. & HANNUM_DNAMAGE~=. & LEVINE_DNAMAGE~=. & DNAMGRIMAGE~=. & MPOA~=. 
replace sampleEPI2016=0 if sampleEPI2016~=1


**Exclude outliers**
local vars HORVATH_DNAMAGE HANNUM_DNAMAGE LEVINE_DNAMAGE DNAMGRIMAGE MPOA

capture drop HORVATH_DNAMAGE_no_outliers
capture drop HANNUM_DNAMAGE_no_outliers 
capture drop LEVINE_DNAMAGE_no_outliers 
capture drop DNAMGRIMAGE_no_outliers 
capture drop MPOA_no_outliers 


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


capture drop sampleEPI2016fin
gen sampleEPI2016fin=.
replace sampleEPI2016fin=1 if sampleEPI2016==1 & HORVATH_DNAMAGE_no_outliers~=. & HANNUM_DNAMAGE_no_outliers~=. & LEVINE_DNAMAGE_no_outliers~=. & DNAMGRIMAGE_no_outliers~=. & MPOA_no_outliers~=. 
replace sampleEPI2016fin=0 if sampleEPI2016fin~=1



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta", replace

capture drop sample2
gen sample2=.
replace sample2=1 if sample50plus2008==1 & samplealivein2016==1
replace sample2=0 if sample2~=1

capture drop sample3
gen sample3=.
replace sample3=1 if sample2==1 & sampleTL2008fin==1
replace sample3=0 if sample3~=1


capture drop sample4
gen sample4=.
replace sample4=1 if sample3==1 & sampleEPI2016fin==1
replace sample4=0 if sample4~=1


capture drop sample_final
gen sample_final=.
replace sample_final=1 if sample4==1 
replace sample_final=0 if sample_final~=1

tab sample_final



tab sample_final

**Final sample size for HRS: 1,013**




su r9agey_*
su r13agey_*

capture drop AGE2008
gen AGE2008=r9agey_e

capture drop AGE2016
gen AGE2016=r13agey_e

su AGE2008 if sample_final==1,det
su AGE2016 if sample_final==1,det


capture drop AGE
gen AGE=AGE2016




foreach var of varlist FINAL_T_S_no_outliers FINAL_CV_no_outliers {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_TELOMERES\HRS_HIST`var'.gph",replace
	
}



foreach var of varlist HORVATH_DNAMAGE_no_outliers HANNUM_DNAMAGE_no_outliers LEVINE_DNAMAGE_no_outliers DNAMGRIMAGE_no_outliers MPOA_no_outliers {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_EPIGENETIC\HRS_HIST`var'.gph",replace
	
}



**STEP 9: MORTALITY VARIABLES FROM 2008 THROUGH 2020: TRACKER FILE INW**

**dead vs. alive: 2016-2022

capture drop died
gen died=.
replace died=1 if (sample_final==1 & knowndeceasedyr~=. & knowndeceasedmo~=.)
replace died=0 if died!=1 & sample_final==1

tab died if sample_final==1


**Date of death: dod**

su knowndeceasedmo knowndeceasedyr if sample_final==1
tab1 knowndeceasedmo knowndeceasedyr if sample_final==1

capture drop deathmonth
gen deathmonth=knowndeceasedmo if knowndeceasedmo~=98

capture drop deathyear
gen deathyear=knowndeceasedyr

capture drop deathday
gen deathday=14

capture drop dod
gen dod=mdy(deathmonth, deathday, deathyear)

**Date of entry: doenter**
capture drop doenter
gen doenter=mdy(01,01,2016)

**Date of exit if still alive: doexit**
capture drop doexit
gen doexit=mdy(12,31,2022) 

**Date of exit for censor or dead**
capture drop doevent
gen doevent=.
replace doevent=dod if died==1 & sample_final==1
replace doevent=doexit if died==0 & sample_final==1

su doevent

***Estimated birth date**

capture drop dob
gen dob=mdy(birthmo,14,birthyr)



capture drop ageevent
gen ageevent=(doevent-dob)/365.5

su ageevent

capture drop ageenter
gen ageenter=AGE2016

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",replace

**STEP 10: STSET FOR MORTALITY OUTCOME***
capture drop time_event
gen time_event=ageevent-AGE2016

su time_event,det
histogram time_event

tab sample_final


stset time_event [pweight=vbsi16wgtra] if sample_final==1, failure(died==1) scale(1)


stdescribe if sample_final==1
stsum if sample_final==1
strate if sample_final==1



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",replace




**Inverse mills ratio**

capture drop sample_final_age50plus
gen sample_final_age50plus=.
replace sample_final_age50plus=1 if sample_final==1
replace sample_final_age50plus=0 if sample_final==0 & AGE>=50 & AGE~=.

tab sample_final_age50plus


xi:probit sample_final_age50plus AGE SEX i.RACE_ETHN

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




save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",replace




**STEP 10: GENERATE EAA and Z-SCORES FOR EXPOSURES**

capture drop AGE
gen AGE=AGE2016

su AGE if sample_final==1
histogram AGE if sample_final==1

capture drop HORVATH_DNAMAGE_no_outliersEAA    
capture drop HANNUM_DNAMAGE_no_outliersEAA 
capture drop LEVINE_DNAMAGE_no_outliersEAA 
capture drop DNAMGRIMAGE_no_outliersEAA   


foreach var of varlist HORVATH_DNAMAGE_no_outliers HANNUM_DNAMAGE_no_outliers LEVINE_DNAMAGE_no_outliers DNAMGRIMAGE_no_outliers {
	
	reg `var' AGE 
	predict `var'EAA, resid
	histogram `var'EAA
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_EPIGENETIC\HRS_HIST`var'EAA.gph", replace
	su `var'EAA
}

su  MPOA_no_outliers
histogram MPOA_no_outliers
graph save  "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_EPIGENETIC\HRS_HISTDunedinPoAmEAA.gph", replace
 


*******Z-SCORE*************

capture drop zHORVATH_DNAMAGE_no_outliersEAA 
capture drop zHANNUM_DNAMAGE_no_outliersEAA 
capture drop zLEVINE_DNAMAGE_no_outliersEAA 
capture drop zDNAMGRIMAGE_no_outliersEAA 
capture drop zMPOA_no_outliers 
capture drop zFINAL_T_S_no_outliers
foreach var of varlist HORVATH_DNAMAGE_no_outliersEAA HANNUM_DNAMAGE_no_outliersEAA LEVINE_DNAMAGE_no_outliersEAA DNAMGRIMAGE_no_outliersEAA MPOA_no_outliers FINAL_T_S_no_outliers {
	
	egen z`var'=std(`var') if sample_final==1
}

su z*
 

 
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",replace


**STEP 11: GENERATE COVARIATES:**

su AGE 
tab1 SEX RACE_ETHN

capture drop SEX
gen SEX=ragender
recode SEX (1=0) (2=1)
tab SEX

capture drop NHB
gen NHB=.
replace NHB=1 if RACE_ETHN==2
replace NHB=0 if NHB~=1

capture drop HISP
gen HISP=.
replace HISP=1 if RACE_ETHN==3
replace HISP=0 if HISP~=1

capture drop OTHER
gen OTHER=.
replace OTHER=1 if RACE_ETHN==4
replace OTHER=0 if OTHER~=1

tab1 NHB HISP OTHER

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",replace

capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HRS_KAPLANMEIERCURVES.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",clear



**STEP 12: FIGURE 1: K-M CURVES BY TERTLES**



capture drop zHorvathAgeEAA
capture drop zHannumAgeEAA 
capture drop zPhenoAgeEAA
capture drop zGrimAgeMortEAA 
capture drop zDunedinPoAm
capture drop ztelomean_no_outliers

gen zHorvathAgeEAA=zHORVATH_DNAMAGE_no_outliersEAA
gen zHannumAgeEAA=zHANNUM_DNAMAGE_no_outliersEAA
gen zPhenoAgeEAA=zLEVINE_DNAMAGE_no_outliersEAA
gen zGrimAgeMortEAA=zDNAMGRIMAGE_no_outliersEAA
gen zDunedinPoAm=zMPOA_no_outliers
gen ztelomean_no_outliers=zFINAL_T_S_no_outliers

capture drop zHorvathAgeEAAtert 
capture drop zHannumAgeEAAtert 
capture drop zPhenoAgeEAAtert
capture drop zGrimAgeMortEAAtert 
capture drop zDunedinPoAmtert 
capture drop ztelomean_no_outlierstert



foreach var of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers {
	xtile `var'tert=`var' if sample_final==1,nq(3)

}


tab1 *tert 


foreach var of varlist *tert {
	sts test `var' if sample_final==1  
}


foreach var of varlist *tert {
	sts graph if sample_final==1 , by(`var')
graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1`var'.gph",replace
} 

graph combine "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1zHorvathAgeEAAtert.gph" ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1zDunedinPoAmtert.gph" ////
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1zGrimAgeMortEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1zHannumAgeEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1zPhenoAgeEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1ztelomean_no_outlierstert.gph"

graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURE1_KM\FIGURE1combined.gph",replace

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT.dta",replace



capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HRS_CORRELATIONS_EPIGENEITC_TELO.smcl",replace


//STEP 13: CORRELATION MATRIX BETWEEN EPIGENTIC AGE ACCELERATION, EPIGENETIC CLOCKS AND TL VARIABLES//

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear


// Step 1: Run the correlation command and save the matrix
corr zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  
matrix C = r(C)

// Step 2: Clear the current dataset (optional if you don't need it)
clear

// Step 3: Convert the matrix to a dataset with unique variable names
svmat C, names(col)

// Step 4: Save the dataset as a CSV file
export delimited using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HRS_correlation_matrix.csv", replace

**Add a column in excel sheet and re-type labels mannually. Change labels as needed. 


// Step 5: Reload your original dataset if needed

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear


//STEP 13: RStudio code for heatmap: Run IN RStudio//

**# Load necessary libraries
**library(ggplot2)
**library(reshape2)

**# Read the correlation matrix from the CSV file
**file_path <- "E:/16GBBACKUPUSB/BACKUP_USB_SEPTEMBER2014/SUMMER_STUDENT_2025/HRS_NHANES_HANDLS_TLEPIGENMORT/OUTPUT/HRS_correlation_matrix_final.csv"
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

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HRS_LASSOLINEAR.smcl",replace



use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear


//STEP 14: LASSO LINEAR MODELS FOR TL VS. EPIGENETIC EAA, FORCING EXOGENOUS VARIABLES. 


capture drop sample_LASSO
sort HHIDPN
save, replace
splitsample if sample_final==1 , generate(sample_LASSO) nsplit(2) rseed(1234)
tab sample_LASSO

save, replace

*******************************TELOMEAN************************************

lasso linear ztelomean_no_outliers (AGE SEX i.RACE_ETHN) zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm if sample_LASSO==1, rseed(1234)


cvplot 
graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURES2_LASSO\FIGURES2_TELOMEAN.gph",replace

estimates store cvTELOMEAN

lassoknots, display(nonzero osr2 bic)

lassoselect id=1

cvplot

estimates store minBICTELOMEAN

lasso linear ztelomean_no_outliers (AGE SEX i.RACE_ETHN)  zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm if sample_LASSO==1, selection(adaptive) rseed(1234)


estimates store adaptiveTELOMEAN

lassocoef cvTELOMEAN minBICTELOMEAN adaptiveTELOMEAN, sort(coef, standardized) nofvlabel




**-----------------------------------------------------------
**             | cvTELOMEAN minBICTELOMEAN  adaptiveTELOMEAN 
**-------------+---------------------------------------------
**         AGE |     x             x                x        
**             |
**   RACE_ETHN |
**          2  |     x             x                x        
**          3  |     x             x                x        
**          4  |     x             x                x        
**             |
**         SEX |     x             x                x        
**       _cons |     x             x                x        
**             |
**   RACE_ETHN |
**          1  |     e             e                e        
**-----------------------------------------------------------
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
**                      1 |    .9663366       0.0365        515
**                      2 |    .9872245       0.0075        514
**------------------------+------------------------------------
**minBICTELOMEAN          |
**                      1 |    .9663366       0.0365        515
**                      2 |    .9872245       0.0075        514
**------------------------+------------------------------------
**adaptiveTELOMEAN        |
**                      1 |    .9663366       0.0365        515
**                      2 |    .9872245       0.0075        514
**-------------------------------------------------------------





***REDUCED MODEL FROM BEST MODEL SELECTION PROCESS**

reg ztelomean_no_outliers AGE SEX i.RACE_ETHN    if sample_final==1



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",replace

capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\NHANES_HRS_HANDLS_TLEPIGENMORT\OUTPUT\HRS_LASSOCOX.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear


//STEP 15: LASSO COX MODELS FOR MORTALITY VS. TL, EPIGENETIC EAA, FORCING EXOGENOUS VARIABLES. 

**stset time_event [iweight=vbsi16wgtra] if sample_final==1, failure(died==1) scale(1)


**lasso cox (AGE SEX i.RACE_ETHN ) zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  if sample_LASSO==1, rseed(1234) iter(500000)

 

**cvplot 

**graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\NHANES_HRS_HANDLS_TLEPIGENMORT\FIGURES\HRS_FIGURES2_LASSO\FIGURES2_LASSOCOX.gph",replace

**estimates store cvLASSOCOX

**lassoknots, display(nonzero bic)

**lassoselect id=55

**cvplot

**estimates store minBICLASSOCOX

**lasso cox (AGE SEX i.RACE_ETHN ) zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  if sample_LASSO==1, selection(adaptive) rseed(1234) iter(500000)


**estimates store adaptiveLASSOCOX

**lassocoef cvLASSOCOX minBICLASSOCOX adaptiveLASSOCOX, sort(coef, standardized) nofvlabel


**lassogof cvLASSOCOX minBICLASSOCOX adaptiveLASSOCOX, over(sample_LASSO) postselection


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


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",replace



capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\NHANES_HRS_HANDLS_TLEPIGENMORT\OUTPUT\HRS_HEATMAPCOX.smcl",replace

//STEP 16: HEATMAP FOR EACH TELOMERE LENGTH, EPIGENETIC CLOCKS VS. MORTALITY RISK, ADJUSTING AGE, SEX AND RACE_ETHN: COX MODEL///

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear

stset time_event [pweight=vbsi16wgtra] if sample_final==1, failure(died==1) scale(1)


* Install estout if not already installed
ssc install estout, replace

* Clear any previous estimates
est clear

* Start the loop
foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers { 
    
        * Run the stcox command
        stcox `x' AGE SEX i.RACE_ETHN if sample_final==1
        
        * Store the estimates
        eststo output`x'
    }



* Export the results to a dataset
esttab using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\results_TABLE5.csv", replace se ar2

import delimited "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\results_TABLE5.csv", clear


* Convert the CSV file to a Stata dataset (if needed)
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\results_TABLE5.dta",replace



**Fix the dataset so it is simpler. This is saved as : cleaned_results_TABLE5_final.csv in the same folder**

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",replace



capture log close



**STEP 17: FIGURE 3: ERROR BARS FOR COX MODELS: MONDAY**

**# Load necessary library
**library(ggplot2)

**# Read the dataset
**data <- read.csv("E:/16GBBACKUPUSB/BACKUP_USB_SEPTEMBER2014/SUMMER_STUDENT_2025/HRS_NHANES_HANDLS_TLEPIGENMORT/FINAL_DATA/HRS/cleaned_results_TABLE5_final.csv")

**# Rename columns for clarity
**colnames(data) <- c("Variable", "LnHR", "SE")

**# Calculate upper and lower bounds for error bars
**data$Upper <- data$LnHR + 1.96 * data$SE
**data$Lower <- data$LnHR - 1.96 * data$SE

**# Plot with error bars
**ggplot(data, aes(x = Variable, y = LnHR)) +
**  geom_point(size = 3, color = "blue") +
**  geom_errorbar(aes(ymin = Lower, ymax = Upper), width = 0.2, color = "red") +
**  theme_minimal() +
**  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
**  labs(title = "Log Hazard Ratios with Error Bars",
**       x = "Variable",
**       y = "Log Hazard Ratio (LnHR)")



capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\NHANES_HRS_HANDLS_TLEPIGENMORT\OUTPUT\HRS_VARDISCRETIZATION.smcl",replace


//STEP 16: DISCRETIZE VARIABLES FOR ABN ANALYSIS AND GENERATE DATASET FOR R; CREATE A VARIABLE COHORT=1 (NHANES)//

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT",clear

capture drop COHORT
gen COHORT=2

keep if sample_final==1

keep HHIDPN  AGE SEX RACE_ETHN zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  _st _d _t _t0 COHORT

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN",replace



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

foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers   {
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


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN",replace


keep HHIDPN AGE SEX NHB HISP OTHER zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers   _d _st _d _t _t0 COHORT

keep if _d~=.

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN_SMALL",replace



capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HRS_DISCRETE_TIME_HAZARD_ABN.smcl",replace


//STEP 17: GENERATE DATASET WITH DISCRETE TIME HAZARDS: 2 YR INTERVALS: FRIDAY PLUS CORRECT FIGURES USING SAMPLING WEIGHTS (K-M and Error bar) //

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN_SMALL",clear

sort HHIDPN

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN_SMALL",replace


* Step 1: Expand the dataset
capture drop period
gen period = floor(_t / 2) + 1  // Create time periods based on 2-year intervals
expand period  // Expand the dataset for each time period

* Step 2: Create time variables for analysis
capture drop start_time
capture drop end_time

bysort HHIDPN: gen start_time = (_n - 1) * 2  // Start of each 2-year period
bysort HHIDPN: gen end_time = start_time + 2  // End of each 2-year period

* Step 3: Indicate event occurrence in each period
capture drop event

gen event = (_d == 1 & _t <= end_time & _t > start_time)

* Step 4: Create dummy variables for each 2-year interval
gen interval = floor(start_time / 2) + 1  // Create interval number
tabulate interval, generate(dummy)  // Generate dummy variables for each interval


logistic _d dummy1-dummy4 AGE SEX NHB HISP OTHER zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_no_outliers  

sort HHIDPN 

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN__DISCRETE",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN__DISCRETE",clear

capture rename _d d_var


keep AGE SEX NHB HISP OTHER d_var dummy* zHorvathAgeEAA-ztelomean_no_outliers

destring(AGE),replace

capture rename ztelomean_no_outliers ztelomean_clean

order AGE zHorvathAgeEAA zHannumAgeEAA zPhenoAgeEAA zGrimAgeMortEAA zDunedinPoAm ztelomean_clean SEX d_var NHB HISP OTHER dummy1 dummy2 dummy3 dummy4


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HRS\HRS_TLEPIGENMORT_ABN_DISCRETEfin",replace


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
file_path <- "E:\\16GBBACKUPUSB\\BACKUP_USB_SEPTEMBER2014\\SUMMER_STUDENT_2025\\HRS_NHANES_HANDLS_TLEPIGENMORT\\FINAL_DATA\\HRS\\HRS_TLEPIGENMORT_ABN_DISCRETEfin.dta"
data.df <- read_dta(file_path)

# Summary of data to inspect structure
summary(data.df)

# Convert variables to factors
factorvars <- c("SEX", "d_var", "NHB", "HISP", "OTHER", "dummy1", "dummy2", "dummy3", "dummy4")
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
  ztelomean_clean= "gaussian",
  SEX = "binomial",
  d_var = "binomial",
  NHB = "binomial",
  HISP = "binomial",
  OTHER = "binomial",
  dummy1 = "binomial",
  dummy2 = "binomial",
  dummy3 = "binomial",
  dummy4 = "binomial"
  
)

# Create an empty matrix for 'retain' and 'banned'
retain <- matrix(0, ncol(abndata), ncol(abndata))
colnames(retain) <- rownames(retain) <- names(abndata)

banned <- matrix(0, ncol(abndata), ncol(abndata))
colnames(banned) <- rownames(banned) <- names(abndata)

# Ban edges as needed from all variables into antecedent variables; and from final outcome into all other variables
# 1 (AGE), 8 (SEX), 10 (NHB), 11 (HISP), 12 (OTHER) Final outcome is #9, dummy times (13 to 16)
banned[1, -1] <- 1
banned[8, -8] <- 1
banned[10, -10] <- 1
banned[11, -11] <- 1
banned[12, -12] <- 1
banned[-9, 9] <- 1

# Ban future dummy times from predicting past dummy times
for (i in 13:15
) {
  for (j in (i+1):16) {
    banned[i, j] <- 1
  }
}

# Ensure all dummy variables directly predict d_var
dummy_vars <- paste0("dummy", 1:4)  # List of dummy variables
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

# Build the score cache, with max.par = 3
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



##########Loop over max.parents 1 to 3########################

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


###############1 parent per child##############################


## Step 1: Open file and do some data wrangling, create groups of variables

library(haven)
library(dplyr)

# Increase memory limit to 16 GB (adjust as needed)
memory.limit(size = 16000)

# Read the dataset
file_path <- "E:\\16GBBACKUPUSB\\BACKUP_USB_SEPTEMBER2014\\SUMMER_STUDENT_2025\\HRS_NHANES_HANDLS_TLEPIGENMORT\\FINAL_DATA\\HRS\\HRS_TLEPIGENMORT_ABN_DISCRETEfin.dta"
data.df <- read_dta(file_path)

# Summary of data to inspect structure
summary(data.df)

# Convert variables to factors
factorvars <- c("SEX", "d_var", "NHB", "HISP", "OTHER", "dummy1", "dummy2", "dummy3", "dummy4")
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
  ztelomean_clean= "gaussian",
  SEX = "binomial",
  d_var = "binomial",
  NHB = "binomial",
  HISP = "binomial",
  OTHER = "binomial",
  dummy1 = "binomial",
  dummy2 = "binomial",
  dummy3 = "binomial",
  dummy4 = "binomial"
  
)

# Create an empty matrix for 'retain' and 'banned'
retain <- matrix(0, ncol(abndata), ncol(abndata))
colnames(retain) <- rownames(retain) <- names(abndata)

banned <- matrix(0, ncol(abndata), ncol(abndata))
colnames(banned) <- rownames(banned) <- names(abndata)

# Ban edges as needed from all variables into antecedent variables; and from final outcome into all other variables
# 1 (AGE), 8 (SEX), 10 (NHB), 11 (HISP), 12 (OTHER) Final outcome is #9, dummy times (13 to 16)
banned[1, -1] <- 1
banned[8, -8] <- 1
banned[10, -10] <- 1
banned[11, -11] <- 1
banned[12, -12] <- 1
banned[-9, 9] <- 1

# Ban future dummy times from predicting past dummy times
for (i in 13:15
) {
  for (j in (i+1):16) {
    banned[i, j] <- 1
  }
}

# Ensure all dummy variables directly predict d_var
dummy_vars <- paste0("dummy", 1:4)  # List of dummy variables
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

# Build the score cache, with max.par = 1
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


###############2 parents per child###############################


## Step 1: Open file and do some data wrangling, create groups of variables

library(haven)
library(dplyr)

# Increase memory limit to 16 GB (adjust as needed)
memory.limit(size = 16000)

# Read the dataset
file_path <- "E:\\16GBBACKUPUSB\\BACKUP_USB_SEPTEMBER2014\\SUMMER_STUDENT_2025\\HRS_NHANES_HANDLS_TLEPIGENMORT\\FINAL_DATA\\HRS\\HRS_TLEPIGENMORT_ABN_DISCRETEfin.dta"
data.df <- read_dta(file_path)

# Summary of data to inspect structure
summary(data.df)

# Convert variables to factors
factorvars <- c("SEX", "d_var", "NHB", "HISP", "OTHER", "dummy1", "dummy2", "dummy3", "dummy4")
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
  ztelomean_clean= "gaussian",
  SEX = "binomial",
  d_var = "binomial",
  NHB = "binomial",
  HISP = "binomial",
  OTHER = "binomial",
  dummy1 = "binomial",
  dummy2 = "binomial",
  dummy3 = "binomial",
  dummy4 = "binomial"
  
)

# Create an empty matrix for 'retain' and 'banned'
retain <- matrix(0, ncol(abndata), ncol(abndata))
colnames(retain) <- rownames(retain) <- names(abndata)

banned <- matrix(0, ncol(abndata), ncol(abndata))
colnames(banned) <- rownames(banned) <- names(abndata)

# Ban edges as needed from all variables into antecedent variables; and from final outcome into all other variables
# 1 (AGE), 8 (SEX), 10 (NHB), 11 (HISP), 12 (OTHER) Final outcome is #9, dummy times (13 to 16)
banned[1, -1] <- 1
banned[8, -8] <- 1
banned[10, -10] <- 1
banned[11, -11] <- 1
banned[12, -12] <- 1
banned[-9, 9] <- 1

# Ban future dummy times from predicting past dummy times
for (i in 13:15
) {
  for (j in (i+1):16) {
    banned[i, j] <- 1
  }
}

# Ensure all dummy variables directly predict d_var
dummy_vars <- paste0("dummy", 1:4)  # List of dummy variables
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





//STEP 19: GSEM MODELS: FRIDAY //




//STEP 20: RSTUDIO CODE FOR GSEM FINDINGS, PROXIMAL AND EXPANDED DAGs: TUESDAY//


//STEP 19: GSEM MODELS: FRIDAY //












**REQUEST HANDLS DATA ON MONDAY AND START WORKING ON IT ON SATURDAY-TUESDAY OF FOLLOWING WEEK; COMPLETE ANALYSIS ON THE 29TH**




**TYPE TABLES JANUARY 2ND-4TH AND WRITE RESULTS/ABSTRACT/FIRST PARAGRAPH DISCUSSION ON THE 5TH. SEND DR. ZONDERMAN FLOWCHART TO HELP WITH ON THE 11TH. 
**ASK MICHAEL TO DO A LITERATURE SEARCH ON JANUARY 2ND-11TH. 
**SEND ENDNOTE FILE TO A FEW CO-AUTHORS: SB AND JK. 
**ASK OTHER CO-AUTHORS TO WORK ON OTHER PARTS: JANUARY 15TH-FEBRUARY 20TH. 








 

