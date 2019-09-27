ODS Graphics on;
Title;
Proc GLM data=MCT.DiamondsFE_Training
         PLOTS(Maxpoints=None)
         PLOTS=diagnostics;
    CLASS cut color clarity;
    MODEL_A: Model logprice = logcarat 
                              logcarat*cut 
                              logcarat*color 
                              logcarat*clarity / SOLUTION;
    
Run;
ODS Graphics off;