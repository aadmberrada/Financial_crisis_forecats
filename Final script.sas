libname memoire "C:\Users\moi\OneDrive\Cours M1\Semestre 1\";


libname memoire "C:\Users\moi\OneDrive\Cours M1\Semestre 1\Data_S&P_SML_Caps\Data\Global Data S&P";

PROC IMPORT DATAFILE="C:\Users\moi\OneDrive\Cours M1\Semestre 1\Data_S&P_SML_Caps\Data\Global Data S&P\S&P.csv" OUT=Memoire.Donnees REPLACE dbms=CSV;
delimiter=',';
RUN;

/* Getting the asset returns */
data Memoire.rend1;
set Memoire.Donnees;
DDD=log(DDD_Close/lag(DDD_Close));
GBCI=log(GBCI_Close/lag(GBCI_Close));
GTY=log(GTY_Close/lag(GTY_Close));
GCO=log(GCO_Close/lag(GCO_Close));
GIII=log(GIII_Close/lag(GIII_Close));
FTRCQ=log(FTRCQ_Close/lag(FTRCQ_Close));
FSS=log(FSS_Close/lag(FSS_Close));
CMTL=log(CMTL_Close/lag(CMTL_Close));
CNMD=log(CNMD_Close/lag(CNMD_Close));
CTB=log(CTB_Close/lag(CTB_Close));
NJR=log(NJR_Close/lag(NJR_Close));
NDSN=log(NDSN_Close/lag(NDSN_Close));
OII=log(OII_Close/lag(OII_Close));
NVR=log(NVR_Close/lag(NVR_Close));
NEU=log(NEU_Close/lag(NEU_Close));
NYT=log(NYT_Close/lag(NYT_Close));
DCI=log(DCI_Close/lag(DCI_Close));
DDS=log(DDS_Close/lag(DDS_Close));
DLX=log(DLX_Close/lag(DLX_Close));
MDU=log(MDU_Close/lag(MDU_Close));
AAPL=log(AAPL_Close/lag(AAPL_Close));
ADBE=log(ADBE_Close/lag(ADBE_Close));
DIS=log(DIS_Close/lag(DIS_Close));
INTL=log(INTL_Close/lag(INTL_Close));
JNJ=log(JNJ_Close/lag(JNJ_Close));
JPM=log(JPM_Close/lag(JPM_Close));
MSFT=log(MSFT_Close/lag(MSFT_Close));
PG=log(PG_Close/lag(PG_Close));
UNH=log(UNH_Close/lag(UNH_Close));
VZ=log(VZ_Close/lag(VZ_Close));
run;

data Memoire.rend;
set Memoire.rend1 (drop = DDD_Close GBCI_Close GTY_Close GCO_Close GIII_Close FTRCQ_Close FSS_Close
CMTL_Close CNMD_Close CTB_Close NJR_Close NDSN_Close OII_Close NVR_Close NEU_Close NYT_Close DCI_Close
DDS_Close DLX_Close MDU_Close AAPL_Close ADBE_Close DIS_Close INTL_Close JNJ_Close JPM_Close MSFT_Close
PG_Close UNH_Close VZ_Close);
run;

/* Normalization */
PROC STANDARD DATA=Memoire.rend MEAN=0 STD=1 OUT=Memoire.data;
  VAR DDD GBCI GTY GCO GIII FTRCQ FSS CMTL CNMD CTB NJR NDSN OII NVR NEU NYT DCI DDS DLX MDU AAPL 
ADBE DIS INTL JNJ JPM MSFT PG UNH VZ;
RUN;

PROC IMPORT DATAFILE="C:\Users\moi\OneDrive\Cours M1\Semestre 1\SP500.csv" OUT=Memoire.SP500 REPLACE dbms=CSV;
delimiter=',';
RUN;

/* Getting the S&P500 data ready */
data sp;
set Memoire.Sp500;
drop Open High Low Adj_Close Volume;
rename Close=SP500;
run;

proc sql;
create table df as
select *
from Memoire.Data as L
left join sp as R
on L.Date=R.Date;
quit;

data df;
set df;
COL1=_n_;
run;

data sp;
set df;
keep Date SP500 COL1;
run;

/* Simulation of the Marchenko-Pastur distribution on 3 months */
proc iml;
N=66;
p=30;
mean=0; stdDev=1;

free eig;
do i=1 to 10000;
Simu=j(N,p);
call randgen(Simu, "Normal", mean, stdDev);
eig=eig//eigval(corr(Simu, "Spearman"));
end;
title "Eigenvalues distribution (66-days window)";
call histogram(eig);
create lambda from eig;
append from eig;
close lambda;

quit;

proc univariate data=lambda;
run;

/* Simulation of the Marchenko-Pastur distribution on 6 months */
proc iml;
N=132;
p=30;
mean=0; stdDev=1;

free eig;
do i=1 to 10000;
Simu=j(N,p);
call randgen(Simu, "Normal", mean, stdDev);
eig=eig//eigval(corr(Simu, "Spearman"));
end;
title "Eigenvalues distribution (132-days window)";
call histogram(eig);
create lambda from eig;
append from eig;
close lambda;

quit;

proc univariate data=lambda;
histogram;
run;

/* Graphs and heatmaps */

/* I - 6 months 
i) Dot-com bubble 
i.a) Lamdba max */
ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Lambda6monthsdotcom" imagefmt=png;
proc iml;
varNames =  {"DDD" "GBCI" "GTY" "GCO" "GIII" "FTRCQ" "FSS" "CMTL" "CNMD" "CTB" "NJR" "NDSN" "OII" "NVR"
"NEU" "NYT" "DCI" "DDS" "DLX" "MDU" "AAPL" "ADBE" "DIS" "INTL" "JNJ" "JPM" "MSFT" "PG" "UNH" "VZ"};  
use Memoire.Data;                       /* open the data set */
read all var varNames into X;            /* read vars from Data into matrix */
close Memoire.Data; 
free lambda;
wind=6*22;
do t=2036-wind to 3500-wind;
X1=X[t:t+wind,]; 
lambda=lambda//(t||t+wind||max(eigval(corr(X1, "Spearman"))));
end;
mattrib Lambda[colname={'Start','End','Lambda max'}];
print lambda;

create g from lambda;
append from lambda;
close g;
proc sql;
create table g1 as
select *
from g as L
left join sp as R
on L.COL1=R.COL1;
quit;

proc template;
define statgraph Graph;
dynamic _DATE _COL3A _DATE2 _SP500A;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / yaxisopts=( display=(TICKS TICKVALUES LINE LABEL ) label=('Leading eigenvalues'));
         seriesplot x=_DATE y=_COL3A / curvelabel='Leading eigenvalues' name='series' connectorder=xaxis lineattrs=(color=CX0000FF );
         seriesplot x=_DATE2 y=_SP500A / curvelabel='SP500' name='series2' yaxis=Y2 connectorder=xaxis lineattrs=(color=CXC6C3C6 );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=WORK.G1 template=Graph;
dynamic _DATE="DATE" _COL3A="COL3" _DATE2="DATE" _SP500A="SP500";
run;



/* i.b) Heatmaps */
proc iml;
free X1 X2 X3 X4 X5 X6 X7 X8;
i=2036;
X1=X[i:i+132,]; 
X2=X[i+133:i+265,];
X3=X[i+266:i+398,];
X4=X[i+399:i+531,];
X5=X[i+532:i+664,];
X6=X[i+665:i+792,];
X7=X[i+793:i+925,];
X8=X[i+926:i+1058,];
a=corr(X1, "Spearman");
b=corr(X2, "Spearman");
c=corr(X3, "Spearman");
d=corr(X4, "Spearman");
e=corr(X5, "Spearman");
f=corr(X6, "Spearman");
g=corr(X7, "Spearman");
h=corr(X8, "Spearman");
ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Corr6monthsdotcom" imagefmt=png;
call HeatmapCont(a) COLORRAMP="Gray" title="2 years before the bubble burst" RANGE={-1,1};
call HeatmapCont(b) COLORRAMP="Gray" title="1 year and a half before the bubble burst" RANGE={-1,1};
call HeatmapCont(c) COLORRAMP="Gray" title="1 year before the bubble burst" RANGE={-1,1};
call HeatmapCont(d) COLORRAMP="Gray" title="6 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(e) COLORRAMP="Gray" title="6 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(f) COLORRAMP="Gray" title="1 year after the bubble burst" RANGE={-1,1};
call HeatmapCont(g) COLORRAMP="Gray" title="1 year and a half after the bubble burst" RANGE={-1,1};
call HeatmapCont(h) COLORRAMP="Gray" title="2 years after the bubble burst" RANGE={-1,1};


/* ii) Subprimes
ii.a) Lambda max */

ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Lambda6monthsubprimes" imagefmt=png;
proc iml;
varNames =  {"DDD" "GBCI" "GTY" "GCO" "GIII" "FTRCQ" "FSS" "CMTL" "CNMD" "CTB" "NJR" "NDSN" "OII" "NVR"
"NEU" "NYT" "DCI" "DDS" "DLX" "MDU" "AAPL" "ADBE" "DIS" "INTL" "JNJ" "JPM" "MSFT" "PG" "UNH" "VZ"};  
use Memoire.Data;                       /* open the data set */
read all var varNames into X;            /* read vars from Data into matrix */
close Memoire.Data;  
free lambda;
wind=6*22;
do t=4199-wind to 4991-wind;
X1=X[t:t+wind,]; 
lambda=lambda//(t||t+wind||max(eigval(corr(X1, "Spearman"))));
end;
mattrib Lambda[colname={'Start','End','Lambda max'}];
print lambda;

create g from lambda;
append from lambda;
close g;
proc sql;
create table g2 as
select *
from g as L
left join sp as R
on L.COL1=R.COL1;
quit;

proc template;
define statgraph Graph;
dynamic _DATE _COL3A _DATE2 _SP500A;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / yaxisopts=( display=(TICKS TICKVALUES LINE LABEL ) label=('Leading eigenvalues'));
         seriesplot x=_DATE y=_COL3A / curvelabel='Leading eigenvalues' name='series' connectorder=xaxis lineattrs=(color=CX0000FF );
         seriesplot x=_DATE2 y=_SP500A / curvelabel='SP500' name='series2' yaxis=Y2 connectorder=xaxis lineattrs=(color=CXC6C3C6 );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=WORK.G2 template=Graph;
dynamic _DATE="DATE" _COL3A="COL3" _DATE2="DATE" _SP500A="SP500";
run;


/* ii.b) Heatmaps */
proc iml;
free X1 X2 X3 X4 X5 X6 X7 X8;
i=4199;
X1=X[i:i+132,]; 
X2=X[i+133:i+265,];
X3=X[i+266:i+398,];
X4=X[i+399:i+531,];
X5=X[i+532:i+664,];
X6=X[i+665:i+797,];

a=corr(X1, "Spearman");
b=corr(X2, "Spearman");
c=corr(X3, "Spearman");
d=corr(X4, "Spearman");
e=corr(X5, "Spearman");
f=corr(X6, "Spearman");

ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Corr6monthssubprimes" imagefmt=png;
call HeatmapCont(a) COLORRAMP="Gray" title="2 years before october 2008" RANGE={-1,1};
call HeatmapCont(b) COLORRAMP="Gray" title="1 year and a half before october 2008" RANGE={-1,1};
call HeatmapCont(c) COLORRAMP="Gray" title="1 year before october 2008" RANGE={-1,1};
call HeatmapCont(d) COLORRAMP="Gray" title="6 months before october 2008" RANGE={-1,1};
call HeatmapCont(e) COLORRAMP="Gray" title="6 months after october 2008" RANGE={-1,1};
call HeatmapCont(f) COLORRAMP="Gray" title="1 year after october 2008" RANGE={-1,1};



/* iii) Since 2017 
iii.a) Lambda max */
ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Lambda6monthajd" imagefmt=png;
proc iml;
varNames =  {"DDD" "GBCI" "GTY" "GCO" "GIII" "FTRCQ" "FSS" "CMTL" "CNMD" "CTB" "NJR" "NDSN" "OII" "NVR"
"NEU" "NYT" "DCI" "DDS" "DLX" "MDU" "AAPL" "ADBE" "DIS" "INTL" "JNJ" "JPM" "MSFT" "PG" "UNH" "VZ"};  
use Memoire.Data;                       /* open the data set */
read all var varNames into X;            /* read vars from Data into matrix */
close Memoire.Data; 
free lambda;
wind=6*22;
do t=6817-wind to nrow(X)-wind;
X1=X[t:t+wind,]; 
lambda=lambda//(t||t+wind||max(eigval(corr(X1, "Spearman"))));
end;
mattrib Lambda[colname={'Start','End','Lambda max'}];
print lambda;

create g from lambda;
append from lambda;
close g;
proc sql;
create table g3 as
select *
from g as L
left join sp as R
on L.COL1=R.COL1;
quit;

proc template;
define statgraph Graph3;
dynamic _DATE _COL3A _DATE2 _SP500A;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / yaxisopts=( display=(LINE TICKVALUES LABEL TICKS ) griddisplay=off label=('Leading eigenvalues') labelattrs=(color=CX000000 ));
         seriesplot x=_DATE y=_COL3A / curvelabel='Leading eigenvalues' name='series' connectorder=xaxis lineattrs=(color=CX0000FF );
         seriesplot x=_DATE2 y=_SP500A / curvelabel='SP500' name='series2' yaxis=Y2 connectorder=xaxis lineattrs=(color=CXC6C3C6 );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=WORK.G3 template=Graph3;
dynamic _DATE="DATE" _COL3A="COL3" _DATE2="DATE" _SP500A="SP500";
run;


/* iii.b) Heatmaps */
proc iml;
free X1 X2 X3 X4 X5 X6 X7 X8;
i=6817;
X1=X[i:i+132,]; 
X2=X[i+133:i+265,];
X3=X[i+266:i+398,];
X4=X[i+399:i+531,];
X5=X[i+532:i+664,];
X6=X[i+665:i+797,];
X7=X[i+798:i+930,];
X8=X[i+931:i+1063,];
X8=X[i+931:i+998,]; 
a=corr(X1, "Spearman");
b=corr(X2, "Spearman");
c=corr(X3, "Spearman");
d=corr(X4, "Spearman");
e=corr(X5, "Spearman");
f=corr(X6, "Spearman");
g=corr(X7, "Spearman");
h=corr(X8, "Spearman");
ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Corr6monthsajd" imagefmt=png;
call HeatmapCont(a) COLORRAMP="Gray" title="1st semester 2017" RANGE={-1,1};
call HeatmapCont(b) COLORRAMP="Gray" title="2nd semester 2017" RANGE={-1,1};
call HeatmapCont(c) COLORRAMP="Gray" title="1st semester 2018" RANGE={-1,1};
call HeatmapCont(d) COLORRAMP="Gray" title="2nd semester 2018" RANGE={-1,1};
call HeatmapCont(e) COLORRAMP="Gray" title="1st semester 2019" RANGE={-1,1};
call HeatmapCont(f) COLORRAMP="Gray" title="2nd semester 2019" RANGE={-1,1};
call HeatmapCont(g) COLORRAMP="Gray" title="1st semester 2020" RANGE={-1,1};
call HeatmapCont(h) COLORRAMP="Gray" title="2nd semester 2020" RANGE={-1,1};

/* II - 3 months */

/* i) Dot-com bubble 
i.a) Lamdba max */

proc iml;
varNames =  {"DDD" "GBCI" "GTY" "GCO" "GIII" "FTRCQ" "FSS" "CMTL" "CNMD" "CTB" "NJR" "NDSN" "OII" "NVR"
"NEU" "NYT" "DCI" "DDS" "DLX" "MDU" "AAPL" "ADBE" "DIS" "INTL" "JNJ" "JPM" "MSFT" "PG" "UNH" "VZ"};  
use Memoire.Data;                       /* open the data set */
read all var varNames into X;            /* read vars from Data into matrix */
close Memoire.Data; 
free lambda;
wind=3*22;
do t=2036-wind to 3500-wind;
X1=X[t:t+wind,]; 
lambda=lambda//(t||t+wind||max(eigval(corr(X1, "Spearman"))));
end;
mattrib Lambda[colname={'Start','End','Lambda max'}];
print lambda;
create g from lambda;
append from lambda;
close g;
proc sql;
create table g4 as
select *
from g as L
left join sp as R
on L.COL1=R.COL1;
quit;

proc template;
define statgraph Graph2;
dynamic _DATE _COL3A _DATE2 _SP500A;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / yaxisopts=( display=(TICKS TICKVALUES LINE LABEL ) label=('Leading eigenvalues'));
         seriesplot x=_DATE y=_COL3A / curvelabel='Leading eigenvalues' name='series' connectorder=xaxis lineattrs=(color=CX0000FF );
         seriesplot x=_DATE2 y=_SP500A / curvelabel='SP500' name='series2' yaxis=Y2 connectorder=xaxis lineattrs=(color=CXC6C3C6 );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=WORK.G4 template=Graph2;
dynamic _DATE="DATE" _COL3A="COL3" _DATE2="DATE" _SP500A="SP500";
run;


/* i.b) Heatmaps */
proc iml;
free X1 X2 X3 X4 X5 X6 X7 X8;
i=2036;
X1=X[i:i+66,]; 
X2=X[i+67:i+133,];
X3=X[i+134:i+200,];
X4=X[i+201:i+267,];
X5=X[i+268:i+334,];
X6=X[i+335:i+401,];
X7=X[i+402:i+468,];
X8=X[i+469:i+535,];
X9=X[i+536:i+602,];
X10=X[i+603:i+669,];
X11=X[i+670:i+736,];
X12=X[i+737:i+803,];
X13=X[i+804:i+870,];
X14=X[i+871:i+937,];
X15=X[i+938:i+1004,];
X16=X[i+1005:i+1071,];
a=corr(X1, "Spearman");
b=corr(X2, "Spearman");
c=corr(X3, "Spearman");
d=corr(X4, "Spearman");
e=corr(X5, "Spearman");
f=corr(X6, "Spearman");
g=corr(X7, "Spearman");
h=corr(X8, "Spearman");
i=corr(X9, "Spearman");
j=corr(X10, "Spearman");
k=corr(X11, "Spearman");
l=corr(X12, "Spearman");
m=corr(X13, "Spearman");
n=corr(X14, "Spearman");
o=corr(X15, "Spearman");
p=corr(X16, "Spearman");

ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Corr3monthsdotcom" imagefmt=png;
call HeatmapCont(a) COLORRAMP="Gray" title="24 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(b) COLORRAMP="Gray" title="21 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(c) COLORRAMP="Gray" title="18 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(d) COLORRAMP="Gray" title="15 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(e) COLORRAMP="Gray" title="12 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(f) COLORRAMP="Gray" title="9 motnhs before the bubble burst" RANGE={-1,1};
call HeatmapCont(g) COLORRAMP="Gray" title="6 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(h) COLORRAMP="Gray" title="3 months before the bubble burst" RANGE={-1,1};
call HeatmapCont(i) COLORRAMP="Gray" title="3 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(j) COLORRAMP="Gray" title="6 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(k) COLORRAMP="Gray" title="9 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(l) COLORRAMP="Gray" title="12 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(m) COLORRAMP="Gray" title="15 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(n) COLORRAMP="Gray" title="18 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(o) COLORRAMP="Gray" title="21 months after the bubble burst" RANGE={-1,1};
call HeatmapCont(p) COLORRAMP="Gray" title="24 months after the bubble burst" RANGE={-1,1};



/* ii) Subprime
ii.a) Lamdba max */

ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Lambda3monthsubprimes" imagefmt=png; 
proc iml;
varNames =  {"DDD" "GBCI" "GTY" "GCO" "GIII" "FTRCQ" "FSS" "CMTL" "CNMD" "CTB" "NJR" "NDSN" "OII" "NVR"
"NEU" "NYT" "DCI" "DDS" "DLX" "MDU" "AAPL" "ADBE" "DIS" "INTL" "JNJ" "JPM" "MSFT" "PG" "UNH" "VZ"};  
use Memoire.Data;                       /* open the data set */
read all var varNames into X;            /* read vars from Data into matrix */
close Memoire.Data; 
free lambda;
wind=3*22;
do t=4199-wind to 4991-wind;
X1=X[t:t+wind,]; 
lambda=lambda//(t||t+wind||max(eigval(corr(X1, "Spearman"))));
end;
mattrib Lambda[colname={'Start','End','Lambda max'}];
print lambda;

create g from lambda;
append from lambda;
close g;
proc sql;
create table g5 as
select *
from g as L
left join sp as R
on L.COL1=R.COL1;
quit;

proc template;
define statgraph Graph5;
dynamic _DATE _COL3A _DATE2 _SP500A;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / yaxisopts=( display=(TICKS TICKVALUES LINE LABEL ) label=('Leading eigenvalues'));
         seriesplot x=_DATE y=_COL3A / curvelabel='Leading eigenvalues' name='series' connectorder=xaxis lineattrs=(color=CX0000FF );
         seriesplot x=_DATE2 y=_SP500A / curvelabel='SP500' name='series2' yaxis=Y2 connectorder=xaxis lineattrs=(color=CXC6C3C6 );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=WORK.G5 template=Graph5;
dynamic _DATE="DATE" _COL3A="COL3" _DATE2="DATE" _SP500A="SP500";
run;

/* ii.b) Heatmaps */

proc iml;
free X1 X2 X3 X4 X5 X6 X7 X8;
i=4199;
X1=X[i:i+66,]; 
X2=X[i+67:i+133,];
X3=X[i+134:i+200,];
X4=X[i+201:i+267,];
X5=X[i+268:i+334,];
X6=X[i+335:i+401,];
X7=X[i+402:i+468,];
X8=X[i+469:i+535,];
X9=X[i+536:i+602,];
X10=X[i+603:i+669,];
X11=X[i+670:i+736,];
X12=X[i+737:i+803,];
a=corr(X1, "Spearman");
b=corr(X2, "Spearman");
c=corr(X3, "Spearman");
d=corr(X4, "Spearman");
e=corr(X5, "Spearman");
f=corr(X6, "Spearman");
g=corr(X7, "Spearman");
h=corr(X8, "Spearman");
i=corr(X9, "Spearman");
j=corr(X10, "Spearman");
k=corr(X11, "Spearman");
l=corr(X12, "Spearman");

ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Corr3monthssubprimes" imagefmt=png;
call HeatmapCont(a) COLORRAMP="Gray" title="24 months before october 2008" RANGE={-1,1};
call HeatmapCont(b) COLORRAMP="Gray" title="21 months before october 2008" RANGE={-1,1};
call HeatmapCont(c) COLORRAMP="Gray" title="18 months before october 2008" RANGE={-1,1};
call HeatmapCont(d) COLORRAMP="Gray" title="15 months before october 2008" RANGE={-1,1};
call HeatmapCont(e) COLORRAMP="Gray" title="12 months before october 2008" RANGE={-1,1};
call HeatmapCont(f) COLORRAMP="Gray" title="9 months before october 2008" RANGE={-1,1};
call HeatmapCont(g) COLORRAMP="Gray" title="6 months before october 2008" RANGE={-1,1};
call HeatmapCont(h) COLORRAMP="Gray" title="3 months before october 2008" RANGE={-1,1};
call HeatmapCont(i) COLORRAMP="Gray" title="3 months after october 2008" RANGE={-1,1};
call HeatmapCont(j) COLORRAMP="Gray" title="6 months after october 2008" RANGE={-1,1};
call HeatmapCont(k) COLORRAMP="Gray" title="9 months after october 2008" RANGE={-1,1};
call HeatmapCont(l) COLORRAMP="Gray" title="12 months after october 2008" RANGE={-1,1};


/* ii) Since 2017
ii.a) Lamdba max */



ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Lambda3monthsajd" imagefmt=png; 
proc iml;
varNames =  {"DDD" "GBCI" "GTY" "GCO" "GIII" "FTRCQ" "FSS" "CMTL" "CNMD" "CTB" "NJR" "NDSN" "OII" "NVR"
"NEU" "NYT" "DCI" "DDS" "DLX" "MDU" "AAPL" "ADBE" "DIS" "INTL" "JNJ" "JPM" "MSFT" "PG" "UNH" "VZ"};  
use Memoire.Data;                       /* open the data set */
read all var varNames into X;            /* read vars from Data into matrix */
close Memoire.Data; 
free lambda;
wind=3*22;
do t=6817-wind to nrow(X)-wind;
X1=X[t:t+wind,]; 
lambda=lambda//(t||t+wind||max(eigval(corr(X1, "Spearman"))));
end;
mattrib Lambda[colname={'Start','End','Lambda max'}];
print lambda;

create g from lambda;
append from lambda;
close g;
proc sql;
create table g6 as
select *
from g as L
left join sp as R
on L.COL1=R.COL1;
quit;

proc template;
define statgraph Graph6;
dynamic _DATE _COL3A _DATE2 _SP500A;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / yaxisopts=( display=(TICKS TICKVALUES LINE LABEL ) label=('Leading eigenvalues'));
         seriesplot x=_DATE y=_COL3A / curvelabel='Leading eigenvalues' name='series' connectorder=xaxis lineattrs=(color=CX0000FF );
         seriesplot x=_DATE2 y=_SP500A / curvelabel='SP500' name='series2' yaxis=Y2 connectorder=xaxis lineattrs=(color=CXC6C3C6 );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=WORK.G6 template=Graph6;
dynamic _DATE="DATE" _COL3A="COL3" _DATE2="DATE" _SP500A="SP500";
run;

/* ii.b) Heatmaps */
proc iml;
free X1 X2 X3 X4 X5 X6 X7 X8;
i=6817;
X1=X[i:i+66,]; 
X2=X[i+67:i+133,];
X3=X[i+134:i+200,];
X4=X[i+201:i+267,];
X5=X[i+268:i+334,];
X6=X[i+335:i+401,];
X7=X[i+402:i+468,];
X8=X[i+469:i+535,];
X9=X[i+536:i+602,];
X10=X[i+603:i+669,];
X11=X[i+670:i+736,];
X12=X[i+737:i+803,];
X13=X[i+804:i+870,];
X14=X[i+871:i+937,];
X15=X[i+938:i+998,];
a=corr(X1, "Spearman");
b=corr(X2, "Spearman");
c=corr(X3, "Spearman");
d=corr(X4, "Spearman");
e=corr(X5, "Spearman");
f=corr(X6, "Spearman");
g=corr(X7, "Spearman");
h=corr(X8, "Spearman");
i=corr(X9, "Spearman");
j=corr(X10, "Spearman");
k=corr(X11, "Spearman");
l=corr(X12, "Spearman");
m=corr(X13, "Spearman");
o=corr(X14, "Spearman");
p=corr(X15, "Spearman");
ods listing gpath='C:\Users\moi\OneDrive\Cours M1\imgSAS'; 
ods graphics / imagename="Corr3monthsajd" imagefmt=png;
call HeatmapCont(a) COLORRAMP="Gray" title="1st quarter 2017" RANGE={-1,1};
call HeatmapCont(b) COLORRAMP="Gray" title="2nd quarter 2017" RANGE={-1,1};
call HeatmapCont(c) COLORRAMP="Gray" title="3rd quarter 2017" RANGE={-1,1};
call HeatmapCont(d) COLORRAMP="Gray" title="4th quarter 2017" RANGE={-1,1};
call HeatmapCont(e) COLORRAMP="Gray" title="1st quarter 2018" RANGE={-1,1};
call HeatmapCont(f) COLORRAMP="Gray" title="2nd quarter 2018" RANGE={-1,1};
call HeatmapCont(g) COLORRAMP="Gray" title="3rd quarter 2018" RANGE={-1,1};
call HeatmapCont(h) COLORRAMP="Gray" title="4th quarter 2018" RANGE={-1,1};
call HeatmapCont(i) COLORRAMP="Gray" title="1st quarter 2019" RANGE={-1,1};
call HeatmapCont(j) COLORRAMP="Gray" title="2nd quarter 2019" RANGE={-1,1};
call HeatmapCont(k) COLORRAMP="Gray" title="3rd quarter 2019" RANGE={-1,1};
call HeatmapCont(l) COLORRAMP="Gray" title="4th quarter 2019" RANGE={-1,1};
call HeatmapCont(m) COLORRAMP="Gray" title="1st quarter 2020" RANGE={-1,1};
call HeatmapCont(n) COLORRAMP="Gray" title="2nd quarter 2020" RANGE={-1,1};
call HeatmapCont(o) COLORRAMP="Gray" title="3rd quarter 2020" RANGE={-1,1};
call HeatmapCont(p) COLORRAMP="Gray" title="4th quarter 2020" RANGE={-1,1};


