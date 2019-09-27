ODS graphics on/reset width=8in height=5in;

Proc GLMSELECT data=MCT.DiamondsFE_Training
               outdesign=DiamondsFE_Design;
               
     Class cut color clarity;
     Model logprice = logcarat 
                      cut
                      color
                      clarity
                     ;
    
Run;

Proc REG Data=DiamondsFE_Design
         PLOTS(Maxpoints=None)
         PLOTS=diagnostics;

     ODS Output ParameterEstimates=MCT.Model_A_ParmEst;
     MODEL_A: Model logprice = &_GLSMOD;

Run;

ODS Graphics off;