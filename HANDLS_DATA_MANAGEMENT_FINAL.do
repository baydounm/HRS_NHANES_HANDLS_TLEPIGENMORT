
capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HANDLS_DATAMANAGEMENT.smcl", replace


//STEP 1: EPIGENETIC CLOCK AND TELOMERE LENGTH DATA MANAGEMENT//

cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\RAW_DATA\HANDLS_DATA\"


use 2024-12-20_telo_epi,clear
capture rename HNDid HNDID
sort HNDID
capture drop _merge
save, replace

use Age_w1,clear
sort HNDID
capture drop _merge
save, replace

use exam_base_wt,clear
capture rename hndid HNDID
sort HNDID
capture drop _merge
save exam_base_wt,replace

use 2024-12-20_telo_epi,clear
merge HNDID using Age_w1
tab _merge
capture drop _merge
sort HNDID
save 2024-12-20_telo_epi,replace
merge HNDID using exam_base_wt
tab _merge
capture drop _merge
sort HNDID


save HANDLS_MERGED_DATASET, replace

su 

tab1 Sex Race dead



foreach var of varlist DunedinPACE DNAmAge_Horvath DNAmAge_Hannum {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_EPICLOCK\HANDLS_EPICLOCK_HIST`var'", replace
}

save, replace 

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin.dta",replace



//STEP 2: GENERATE EPIGENETIC AGE ACCELERATION VARIABLES FROM HORVATH, HANNUM, PHENO, GRIMM, include POA, remove Outliers and z-score//

capture drop HorvathAge
gen HorvathAge=DNAmAge_Horvath

capture drop HannumAge
gen HannumAge=DNAmAge_Hannum

capture drop DunedinPoAm
gen DunedinPoAm=DunedinPACE

su AGE if HorvathAge~=. & DNAmAge_Hannum~=.
histogram AGE if HorvathAge~=. & DNAmAge_Hannum~=. & DunedinPACE~=. 

capture drop HorvathAgeEAA 
capture drop HannumAgeEAA 

foreach var of varlist HorvathAge HannumAge {
	
	reg `var' AGE 
	predict `var'EAA, resid
	histogram `var'EAA
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_EPICLOCK\HANDLS_HIST`var'EAA.gph", replace
	su `var'EAA
}

su DunedinPoAm
histogram DunedinPoAm
graph save  "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_EPICLOCK\HANDLS_HISTDunedinPoAmEAA.gph", replace
 

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


*******REMOVE OUTLIERS*************

local vars HorvathAgeEAA HannumAgeEAA  DunedinPoAm

foreach var of varlist `vars' {
    quietly summarize `var', detail
    local p25 = r(p25)
    local p75 = r(p75)
    local iqr = `p75' - `p25'

    local lower_bound = `p25' - 4 * `iqr'
    local upper_bound = `p75' + 4 * `iqr'

    gen `var'_no_outliers = `var'
    replace `var'_no_outliers = . if `var' < `lower_bound' | `var' > `upper_bound'
}




*******Z-SCORE*************

capture drop zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm
foreach var of varlist HorvathAgeEAA_no_outliers HannumAgeEAA_no_outliers DunedinPoAm_no_outliers {
	
	egen z`var'=std(`var')
}

su z*

capture rename z*no_outliers z*

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


foreach var of varlist zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_EPICLOCK\HANDLS_HIST`var'.gph",replace
	
}

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear


//STEP 7: TELOMERE LENGTH///


**Remove outliers**

capture drop telomean_no_outliers
gen telomean_no_outliers=tLength

local vars telomean 

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

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear


**Z-scoring**



capture drop ztelomean_no_outliers
foreach var of varlist telomean_no_outliers  {
	
	egen z`var'=std(`var')
}

su z*


foreach var of varlist ztelomean_no_outliers {
	histogram `var'
	graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_TELOMERES\HANDLS_HIST`var'.gph",replace
	
}


save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear


//STEP 8: COVARIATES//


**RACE**

capture drop RACE
gen RACE=.
replace RACE=1 if Race==2
replace RACE=0 if Race==1

tab RACE


**SEX**

tab Sex

capture drop SEX
gen SEX=.
replace SEX=1 if Sex==1
replace SEX=0 if Sex==2

**SEX
**0: Male
**1: Female

tab SEX


**COHORT VARIABLE**

capture drop COHORT
gen COHORT=3

tab COHORT


capture drop telomean_no_outliers_no_outliers

capture rename  zHorvathAgeEAA_ zHorvathAgeEAA

capture rename zHannumAgeEAA_ zHannumAgeEAA

capture rename zDunedinPoAm_ zDunedinPoAm

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace




use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear



//STEP 9: SET UP DATASET AS SURVIVAL DATA//


**Age at death**
capture drop Age_follow
gen  Age_follow=ageout

su Age_follow,det
histogram Age_follow

**Died**
capture drop DIED
gen DIED=1 if dead==1
replace DIED=0 if dead==0

tab DIED


**Demographics**
tab Sex
tab Race
su Age


**Time of follow-up in years**
capture drop TIMEyears
gen TIMEyears=Age_follow-Age



save, replace



stset TIMEyears [pweight=exam_base_wt], id(HNDID) failure(DIED==1)


//STEP 10: STUDY SAMPLE SELECTION STEP, INVERSE MILLS RATIO, USING AGE>=50Y RESTRICTION//

**LARGEST HANDLS SAMPLE**

capture drop sample1
gen sample1=.
replace sample1=1 if Age~=.
replace sample1=0 if sample1~=1

tab sample1   


**TELOMERE LENGTH DATA AVAILABLE**

capture drop sample2
gen sample2=.
replace sample2=1 if ztelomean_no_outliers~=.
replace sample2=0 if sample2~=1

tab sample2  



**EPIGENETIC CLOCK DATA AVAILABLE**

capture drop sample3
gen sample3=.
replace sample3=1 if zHorvathAgeEAA~=. & zHannumAgeEAA~=. & zDunedinPoAm~=.
replace sample3=0 if sample3~=1

tab sample3  


**TELOMERE LENGTH and EPIGENETIC CLOCK DATA AVAILABLE **


capture drop sample4
gen sample4=.
replace sample4=1 if sample3==1 & sample2==1
replace sample4=0 if sample4~=1

tab sample4


capture drop sample_final
gen sample_final=sample4


tab sample_final

**Inverse mills ratio**

xi:probit sample_final Age SEX i.RACE

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



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace



capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HANDLS_KAPLANMEIERCURVES.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear


//STEP 11: KAPLAN MEIER SURVIVAL CURVES BY TERTILES OF EACH EPIGENETIC CLOCK, EPIGENETIC EAA AND TL VARIABLES//

capture drop zHorvathAgeEAAtert zHannumAgeEAAtert zDunedinPoAmtert ztelomean_no_outlierstert  

foreach var of varlist zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm ztelomean_no_outliers {
	xtile `var'tert=`var',nq(3)

}


tab1 *tert 


foreach var of varlist *tert {
	sts test `var'
}


foreach var of varlist *tert {
	sts graph, by(`var')
graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURE1_KM\FIGURE1`var'.gph",replace
} 

graph combine "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURE1_KM\FIGURE1zHorvathAgeEAAtert.gph" ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURE1_KM\FIGURE1zDunedinPoAmtert.gph" ////
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURE1_KM\FIGURE1zHannumAgeEAAtert.gph"  ///
"E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURE1_KM\FIGURE1ztelomean_no_outlierstert.gph" ///

graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURE1_KM\FIGURE1combined.gph",replace

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear




capture log close
capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HANDLS_CORRELATIONS_EPIGENEITC_TELO.smcl",replace


//STEP 12: CORRELATION MATRIX BETWEEN EPIGENTIC AGE ACCELERATION, EPIGENETIC CLOCKS AND TL VARIABLES//

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear


// Step 1: Run the correlation command and save the matrix
corr zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm ztelomean_no_outliers  
matrix C = r(C)

// Step 2: Clear the current dataset (optional if you don't need it)
clear

// Step 3: Convert the matrix to a dataset with unique variable names
svmat C, names(col)

// Step 4: Save the dataset as a CSV file
export delimited using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HANDLS_correlation_matrix.csv", replace

**Add a column in excel sheet and re-type labels mannually. Change labels as needed. 


// Step 5: Reload your original dataset if needed

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear



capture log close



//STEP 13: RStudio code for heatmap: Run IN RStudio//

**# Load necessary libraries
**library(ggplot2)
**library(reshape2)

**# Read the correlation matrix from the CSV file
**file_path <- "E:/16GBBACKUPUSB/BACKUP_USB_SEPTEMBER2014/SUMMER_STUDENT_2025/HRS_NHANES_HANDLS_TLEPIGENMORT/OUTPUT/HANDLS_correlation_matrix_final.csv"
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

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HANDLS_LASSOLINEAR.smcl",replace


use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear


//STEP 14: LASSO LINEAR MODELS FOR TL VS. EPIGENETIC EAA, FORCING EXOGENOUS VARIABLES. 


capture drop sample_LASSO
sort HNDID
save, replace
splitsample , generate(sample_LASSO) nsplit(2) rseed(1234)
tab sample_LASSO

save, replace

*******************************TELOMEAN************************************

lasso linear ztelomean_no_outliers (AGE SEX i.RACE) zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm if sample_LASSO==1, rseed(1234)


cvplot 

graph save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FIGURES\HANDLS_FIGURES2_LASSO\FIGURES2_TELOMEAN.gph",replace

estimates store cvTELOMEAN

lassoknots, display(nonzero osr2 bic)

lassoselect id=1

cvplot

estimates store minBICTELOMEAN

lasso linear ztelomean_no_outliers (AGE SEX i.RACE)  zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm if sample_LASSO==1, selection(adaptive) rseed(1234)


estimates store adaptiveTELOMEAN

lassocoef cvTELOMEAN minBICTELOMEAN adaptiveTELOMEAN, sort(coef, standardized) nofvlabel


**-----------------------------------------------------------
**             | cvTELOMEAN minBICTELOMEAN  adaptiveTELOMEAN 
**-------------+---------------------------------------------
**         AGE |     x             x                x        
**             |
**        RACE |
**          1  |     x             x                x        
**             |
**         SEX |     x             x                x        
**             |
**        RACE |
**          0  |     e             e                e        
**             |
**       _cons |     x             x                x        
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
**                      1 |    .6889135       0.0814         50
**                      2 |    1.269283      -0.0560         42
**------------------------+------------------------------------
**minBICTELOMEAN          |
**                      1 |    .6889135       0.0814         50
**                      2 |    1.269283      -0.0560         42
**------------------------+------------------------------------
**adaptiveTELOMEAN        |
**                      1 |    .6889135       0.0814         50
**                      2 |    1.269283      -0.0560         42
**-------------------------------------------------------------




***REDUCED MODEL FROM BEST MODEL SELECTION PROCESS**

reg ztelomean_no_outliers AGE SEX i.RACE  if sample_final==1



save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace


capture log close

capture log using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\OUTPUT\HANDLS_HEATMAPCOX.smcl",replace

//STEP 15: HEATMAP FOR EACH TELOMERE LENGTH, EPIGENETIC CLOCKS VS. MORTALITY RISK, ADJUSTING AGE, SEX AND RACE: COX MODEL///

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear

stset TIMEyears [pweight=exam_base_wt], id(HNDID) failure(DIED==1)


* Install estout if not already installed
ssc install estout, replace

* Clear any previous estimates
est clear

* Start the loop
foreach x of varlist zHorvathAgeEAA zHannumAgeEAA zDunedinPoAm ztelomean_no_outliers    { 
    
        * Run the stcox command
        stcox `x' AGE SEX i.RACE 
        
        * Store the estimates
        eststo output`x'
    }



* Export the results to a dataset
esttab using "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\results_TABLE5.csv", replace se ar2

import delimited "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\results_TABLE5.csv", clear


* Convert the CSV file to a Stata dataset (if needed)
save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\results_TABLE5.dta",replace



**Fix the dataset so it is simpler. This is saved as : cleaned_results_TABLE5_final.csv in the same folder**

use "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",clear

save "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\SUMMER_STUDENT_2025\HRS_NHANES_HANDLS_TLEPIGENMORT\FINAL_DATA\HANDLS\HANDLS_MERGED_DATASETfin",replace



capture log close










