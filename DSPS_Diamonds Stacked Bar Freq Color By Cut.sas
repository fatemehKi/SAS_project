proc freq data=MCT.diamonds_clean2 order=freq noprint;
   tables color*cut / out=FreqOut(where=(percent^=.));
run;
 
ods graphics /height=500px width=800px;
title "Counts of Diamonds Color by Cut";
proc sgplot data=FreqOut;
  hbarparm category=Color response=count / group=Cut  
      seglabel seglabelfitpolicy=none seglabelattrs=(weight=bold);
  keylegend / opaque across=1 position=bottomright location=inside;
  xaxis grid;
  yaxis labelpos=top;
run;