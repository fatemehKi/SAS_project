proc template;
define statgraph threepanel;
dynamic _X _QUANTILE _Title _mu _sigma;
begingraph;
   entrytitle halign=center _Title;
   layout lattice / rowdatarange=data columndatarange=union 
      columns=1 rowgutter=5 rowweights=(0.6 0.10 0.3);
      layout overlay;
         histogram  _X  / name='histogram' 
                          binaxis=false
                          datatransparency=0.7 
                          fillattrs=(color=blue);
         
         densityplot _X / name='Normal' normal()
                          lineattrs=(color=red thickness=2);
         densityplot _X / name='Kernel' kernel() 
                          lineattrs=(color=green thickness=2);
         discretelegend 'Normal' 'Kernel' / border=true 
                                            halign=right 
                                            valign=top location=inside across=1;
      endlayout;
      layout overlay;
         boxplot y=_X / boxwidth=0.8                         
                        orient=horizontal 
                        fillattrs=(color=darkcyan) 
                        outlineattrs=(color=black)
                        medianattrs=(color=black) 
                        meanattrs=(color=black)
                        outlierattrs=(color=red)
                        datatransparency=0.5
                       ;
      endlayout;
      layout overlay;
         scatterplot x=_X y=_QUANTILE / markerattrs=(color=green size=10) datatransparency=0.7;
         lineparm x=_mu y=0.0 slope=eval(1./_sigma) / lineattrs=(color=red) extend=true clip=true;
      endlayout;
      columnaxes;
         columnaxis;
      endcolumnaxes;
   endlayout;
endgraph;
end;
run;

%macro ThreePanel(DSName, Var);
   %local mu sigma;

   /* 1. sort copy of data */
   proc sort data=&DSName out=_MyData(keep=&Var);
      by &Var;
   run;

   /* 2. Use PROC UNIVARIATE to create Q-Q plot 
         and parameter estimates */
   ods exclude all;
   proc univariate data=_MyData;
      var &Var;
      histogram &Var / normal; /* create ParameterEstimates table */
      qqplot    &Var / normal; 
      ods output ParameterEstimates=_PE QQPlot=_QQ(keep=Quantile Data rename=(Data=&Var));
   run;
   ods exclude none;

   /* 3. Merge quantiles with data */
   data _MyData;
       merge _MyData _QQ;
       label Quantile = "Normal Quantile";
   run;

   /* 4. Get parameter estimates into macro vars */
   data _null_;
       set _PE;
       if Symbol="Mu"    then call symputx("mu", Estimate);
       if Symbol="Sigma" then call symputx("sigma", Estimate);
   run;

   proc sgrender data=_MyData template=threepanel;
       dynamic _X="&Var" _QUANTILE="Quantile" _mu="&mu" _sigma="&sigma"
               _title="Distribution of &Var";
   run;
%mend;

Title;
ODS graphics on / reset width=8in height=5in;
%ThreePanel(MCT.diamonds_FE, price);
%ThreePanel(MCT.diamonds_FE, logprice);

%*ThreePanel(MCT.diamonds_FE, carat);
%*ThreePanel(MCT.diamonds_FE, logcarat);

ODS graphics off;