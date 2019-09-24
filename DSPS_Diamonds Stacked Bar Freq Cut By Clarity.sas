proc freq data=MCT.diamonds_clean2 order=freq noprint;
   tables cut*clarity / out=FreqOut(where=(percent^=.));
run;
 
ods graphics /height=500px width=800px;
title "Counts of Diamonds Cut by Clarity";
proc sgplot data=FreqOut;
  hbarparm category=Cut response=count / group=Clarity  
      seglabel seglabelfitpolicy=none seglabelattrs=(weight=bold);
  keylegend / opaque across=1 position=bottomright location=inside;
  xaxis grid;
  yaxis labelpos=top;
run;