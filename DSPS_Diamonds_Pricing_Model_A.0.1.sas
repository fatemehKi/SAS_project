*ODS graphics on;

Proc Reg data=MCT.DiamondsFE_Training;
    *PLOTS(MAXPOINTS=None) plots=diagnostics;
    *ODS Select FitStatistics ParameterEstimates; 
    ODS Output ParameterEstimates=MCT.Model_A_Parameters;
    Model_A: Model logprice = logcarat
                   cut1-cut5
                   color1-color7
                   clarity1-clarity8                     
                   ;
    
Run;

*ODS Graphics off;