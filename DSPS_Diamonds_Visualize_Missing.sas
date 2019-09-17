proc format ;
    value $missfmt ' '="Missing" other="Not Missing";
    value nmissfmt .  ="Missing" other="Not Missing";
run;

%MACRO Gen_MissingVariable_Bar(ds=);

        ods exclude all;
        ods output onewayfreqs=temp;
        title;
        
        Proc freq data=&ds;
                tables _all_ / MISSING;    
                format _numeric_ nmissfmt. _character_ $missfmt.;
        Run;
        
        Data Wanted;    
            length variable $32. variable_value $50.;
            set temp;
            Variable=scan(table, 2);
            Variable_Value=strip(trim(vvaluex(variable)));
            keep variable variable_value frequency percent;
            label variable='Variable' 
                  variable_value='Variable Value';
        Run;
        
        Data Missing_Report(keep=variable NMiss pct_NMiss);    
            do until (last.variable);
                set Wanted;
                by variable notsorted;        
                select (variable_value);
                        when ('Missing') 
                            do; 
                               NMiss = frequency; 
                               pct_NMiss = percent; 
                            end;
                        when ('Not Missing') 
                            do; 
                               NN = frequency; 
                               pct_NN = percent; 
                            end;
                        Otherwise;
                end;
            end;
            NMiss = coalesce(NMiss, 0);
            pct_NMiss = coalesce(pct_NMiss, 0);
            NN = coalesce(NN, 0);
            pct_NN = coalesce(pct_NN, 0);
        
            Label pct_NMIss = "% Missing";
        Run;
        
        %let softgreen=cx8faf7f;
        ods exclude none;
        ods graphics on / height=5in width=10in;

        title "Missing Values by Variable Visualization";
        Proc sgplot data=Missing_report;
            Format pct_NMiss PERCENT8.4;
            Format NMiss COMMA16.;
            vbar variable / response=pct_NMiss 
                            dataskin=sheen 
                            /*other option: gloss, matte */ 
                            barwidth=0.8 
                            fillattrs=(color=green)
                            datalabel=pct_NMiss;
            xaxis discreteorder=data;
            yaxis display=(noline) grid;
            
        run;
    
%MEND Gen_MissingVariable_Bar;

%*Gen_MissingVariable_Bar(ds=SASHELP.cars);
%*Gen_MissingVariable_Bar(ds=SASHELP.iris);
%*Gen_MissingVariable_Bar(ds=SASHELP.shoes);
%*Gen_MissingVariable_Bar(ds=SASHELP.fish);

%Gen_MissingVariable_Bar(ds=MCT.diamonds);

ods _all_ close;
