ODS graphics on / reset width=9in height=5in;
/*
Proc corresp all data=MCT.diamonds_clean2 out=dismonds_coord short;
    tables color clarity cut;
Run;
*/
Proc corresp data=MCT.diamonds_clean2 MCA DIMENS=3 greenacre outc=diamonds_coord all;
    ODS select burt;
    tables color clarity cut;
Run;

Title "Multiple Correspondence Analysis (MCA)";
proc sgplot data = diamonds_coord noautolegend;
    scatter x = dim1 y = dim2 / group=_TYPE_
                               transparency=0.5
                               markerattrs=(symbol=circlefilled size=10 color=red)                               
                               datalabel = _NAME_
	  					       datalabelattrs=(color=white weight=bold)
                               ;
	
run;

proc sgplot data = diamonds_coord noautolegend;
    scatter x = dim1 y = dim3 /transparency=0.5
                               markerattrs=(symbol=circlefilled size=10 color=red)                               
                               datalabel = _NAME_
							   datalabelattrs=(color=white weight=bold)
                               ;
run;