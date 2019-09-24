proc template;
  define statgraph heatmap;
    begingraph;
      entrytitle 'Diamonds Price by Cut and Clarity Heatmap';
      rangeattrmap name="rmap";
      range 0 - max / rangecolormodel=(white darkgreen);
      endrangeattrmap;
      rangeattrvar attrmap="rmap" var=price attrvar=pColor;
      layout overlay;
          heatmapparm x=clarity y=cut 
                      colorresponse=pColor / display=all
                                             name="heatmap";
          continuouslegend "heatmap" / title="Price($)";
      endlayout;
    endgraph;
  end;
run;

Title;
ODS graphics / reset height=5in width=8in ANTIALIASMAX=53800;
proc sgrender data=MCT.diamonds_clean2 template=heatmap; 
run;