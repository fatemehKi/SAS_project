ODS graphics on;
Proc GLMSELECT data=MCT.DiamondsFE_Training valdata=MCT.DiamondsFE_Validation
               PLOTS=All;
     
     Class Cut Color Clarity;
     *Code file="D:\SAS\Users\DDM\SupharerkP\MCT\Regression.sas";

     Model logprice = logcarat|cut|color|clarity @2 / Choose=Validate
                                                      Stats=(ASE AIC ADJRSQ)
                                                      ;
     output out=Diamonds_Stat
            P=Diamonds_pred
            R=Diamonds_Residual            
            ;
Run;
ODS graphics off;