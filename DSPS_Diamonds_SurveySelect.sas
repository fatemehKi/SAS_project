/*
Proc Sort Data=MCT.diamonds_clean
          Out=diamonds_clean;
    By Cut;
Run;
*/
proc surveyselect data=MCT.diamonds_clean2
    out=Diamonds_Train_Valid
    method=SRS
    samprate=0.6667 /* Wanted Training Dataset 67% */
    seed=1357924
    outall; 
    *strata cut;     /* Stratified Sampling on Cut */
run;

Data Diamonds_Training Diamonds_Valid;
    Set Diamonds_Train_Valid;
    If Selected Then 
        output MCT.Diamonds_Training;
    Else 
        output MCT.Diamonds_Valid;
Run;
