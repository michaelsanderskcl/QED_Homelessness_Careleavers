**Set Working Directory**
cd "/Users/michaelsanders/Documents/Homelessness QED"
**Import Dataset**
import delimited df_interventions_coded.csv, varnames(1) 
**Generation a Numerical LA identifier.
egen LAgroup = group(localauthoritydistrictcode)

**Rename variables
ren v40 employmentscore
ren v42 employmentdeprivedproportion
ren v48 incomescore
ren v56 IDACIscore
ren v30 careleavers21plus
**Destringing variables**
destring careleaveraged1820years, force replace
destring youngpersonaged1617years, force replace
destring vulnerableasaresultofhavingbeeni, force replace
destring employmentscore, force replace
destring employmentdeprivedproportion,force  replace
destring incomescore, force replace
destring IDACIscore, force replace
destring careleavers21plus, force replace

**Set a panel**
xtset LAgroup year 
**Set changes over time**
gen change1_21p = careleavers21plus/L.careleavers21plus
gen change2_21p = L.careleavers21plus/L2.careleavers21plus
gen change3_21p = L2.careleavers21plus/L3.careleavers21plus
gen change4_21p= L3.careleavers21plus/L4.careleavers21plus
gen change5_21p= L4.careleavers21plus/L5.careleavers21plus
gen changeall_21p = careleavers21plus/L5.careleavers21plus
gen oldercl = L5.careleavers21plus

**First stab at CEM - Mockingbird 
**Single Mockingbird variable
gen mockingbird = mockingbirdwave1+ mockingbirdwave2 
**Get rid of a single empty entry**
drop if mockingbird==.
**Keep only most recent year
save "Outcomes_clean_QED.dta", replace 
preserve
log using "Mockingbird_CEM.log", replace
keep if year==2021
tab year
**First stab
cem oldercl change5_21p change4_21p change3_21p change2_21p change1_21p employmentscore incomescore IDACIscore, treatment(mockingbird) 
**Outcomes**
local outcomes youngpersonaged1617years careleaveraged1820years vulnerableasaresultofhavingbeeni
foreach x of local outcomes{
reg `x' mockingbird careleavers21plus if cem_matched==1
}
gen matched1 = cem_matched==1
gen mockingbird2 = mockingbird==1 & cem_matched==0

cem oldercl changeall_21p employmentscore incomescore IDACIscore , treatment(mockingbird2) 
foreach x of local outcomes{
reg `x' mockingbird careleavers21plus if cem_matched==1
}
gen matched2 = cem_matched==1
gen mockingbird3 = mockingbird==1 & cem_matched==0 & matched1==0

cem  employmentscore incomescore IDACIscore , treatment(mockingbird3) 
foreach x of local outcomes{
reg `x' mockingbird careleavers21plus if cem_matched==1 
}
gen matched3 = cem_matched==1
**Keep only variables for merging**
keep matched1 matched2 matched3 LAgroup 
**Save matched dataset
save  "Homelessness_QED_Mockingbird_CEM1.dta", replace
**Merge in outcomes dataset**
merge 1:m LAgroup using "Outcomes_clean_QED.dta"
save "Mockingbird_Analysis.dta", replace
log close 
restore
**Staying Put**
preserve
log using "Staying-Put_CEM.log", replace
keep if year==2021
tab year
**First stab
cem oldercl change5_21p change4_21p change3_21p change2_21p change1_21p employmentscore incomescore IDACIscore, treatment(stayingput) 
**Outcomes**
local outcomes youngpersonaged1617years careleaveraged1820years vulnerableasaresultofhavingbeeni
foreach x of local outcomes{
reg `x' stayingput careleavers21plus if cem_matched==1
}
gen matched1 = cem_matched==1
gen stayingput2 = stayingput==1 & cem_matched==0

cem oldercl changeall_21p employmentscore incomescore IDACIscore , treatment(stayingput2) 
foreach x of local outcomes{
reg `x' stayingput careleavers21plus if cem_matched==1
}
gen matched2 = cem_matched==1
gen stayingput3 = stayingput==1 & cem_matched==0 & matched1==0

cem  employmentscore incomescore IDACIscore , treatment(stayingput3) 
foreach x of local outcomes{
reg `x' stayingput careleavers21plus if cem_matched==1 
}
gen matched3 = cem_matched==1
**Keep only variables for merging**
keep matched1 matched2 matched3 LAgroup 
**Save matched dataset
save  "Homelessness_QED_StayingPut_CEM1.dta", replace
**Merge in outcomes dataset**
merge 1:m LAgroup using "Outcomes_clean_QED.dta"
save "StayingPut_Analysis.dta", replace
log close 
restore
**Bradford**
preserve
log using "Bradford_CEM.log", replace
keep if year==2021
tab year
**First stab - commented out as first approach yields no matches. 
cem oldercl change5_21p change4_21p change3_21p change2_21p change1_21p employmentscore incomescore IDACIscore, treatment(bradford) 
**Outcomes**
**local outcomes youngpersonaged1617years careleaveraged1820years vulnerableasaresultofhavingbeeni
**foreach x of local outcomes{
**reg `x' bradford careleavers21plus if cem_matched==1
**}
gen matched1 = cem_matched==1
gen bradford2 = bradford==1 & cem_matched==0

cem oldercl changeall_21p employmentscore incomescore IDACIscore , treatment(bradford2) 
foreach x of local outcomes{
*reg `x' bradford careleavers21plus if cem_matched==1
}
gen matched2 = cem_matched==1
gen bradford3 = bradfordb==1 & cem_matched==0 & matched1==0

cem  employmentscore incomescore IDACIscore , treatment(bradford3) 
foreach x of local outcomes{
reg `x' bradfordb careleavers21plus if cem_matched==1 
}
gen matched3 = cem_matched==1
**Keep only variables for merging**
keep matched1 matched2  matched3 LAgroup 
**Save matched dataset
save  "Homelessness_QED_Bradford_CEM1.dta", replace
**Merge in outcomes dataset**
merge 1:m LAgroup using "Outcomes_clean_QED.dta"
save "bradford_Analysis.dta", replace
log close 
restore
**Lifelong Links**
preserve
log using "Lifelong_Links_CEM.log", replace
keep if year==2021
tab year
**First stab
cem oldercl change5_21p change4_21p change3_21p change2_21p change1_21p employmentscore incomescore IDACIscore, treatment(lifelonglinks) 
**Outcomes**
local outcomes youngpersonaged1617years careleaveraged1820years vulnerableasaresultofhavingbeeni
foreach x of local outcomes{
reg `x' lifelonglinks careleavers21plus if cem_matched==1
}
gen matched1 = cem_matched==1
gen lifelonglinks2 = lifelonglinks==1 & cem_matched==0

cem oldercl changeall_21p employmentscore incomescore IDACIscore , treatment(lifelonglinks2) 
foreach x of local outcomes{
reg `x' lifelonglinks careleavers21plus if cem_matched==1
}
gen matched2 = cem_matched==1
gen lifelonglinks3 = lifelonglinks==1 & cem_matched==0 & matched1==0

*cem  employmentscore incomescore IDACIscore , treatment(lifelonglinks3) 
*foreach x of local outcomes{
*reg `x' lifelonglinks careleavers21plus if cem_matched==1 
*}
*gen matched3 = cem_matched==1
**Keep only variables for merging**
keep matched1 matched2 LAgroup 
**Save matched dataset
save  "Homelessness_QED_lifelonglinks_CEM1.dta", replace
**Merge in outcomes dataset**
merge 1:m LAgroup using "Outcomes_clean_QED.dta"
save "lifelonglinks_Analysis.dta", replace
log close 
restore



