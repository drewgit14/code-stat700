/**
\file
\ingroup	module group

\brief		brief description

			Exercise 1,2,4,5 for homework assignment 7;

\version	\$Revision: 1.0 $
\author		\$Author: Andrew Marshall $
\date		\$Date:	2018-7-14 $

/* options macrogen symbolgen mprint mlogic; */

/*
 * General Instructions.
 * There are not unit tests for this exercise. This file defines the data
 * you will need for this homework.
 * 
 * You can delete the data for exercises you do not attempt in SAS.
 */

%macro Homework4Data;
  Year = {1936 1946 1951 1963 1975 1997 2006};
  CaloriesPerRecipeMean = {2123.8 2122.3 2089.9 2250.0 2234.2 2249.6 3051.9};
  CaloriesPerRecipeSD = {1050.0 1002.3 1009.6 1078.6 1089.2 1094.8 1496.2};
  CaloriesPerServingMean = {268.1 271.1 280.9 294.7 285.6 288.6 384.4};

  CaloriesPerServingSD = {124.8 124.2 116.2 117.7 118.3 122.0 168.3};
  ServingsPerRecipeMean = {12.9 12.9 13.0 12.7 12.4 12.4 12.7};
  ServingsPerRecipeSD = {13.3 13.3 14.5 14.6 14.3 14.3 13.0};
  sample_size = 18;
  tenth_increment = 0.10;
  idx_1936 = 1;
  idx_2006 = dimension(CaloriesPerRecipeMean)[2];
  idxs36_07 = {idx_1936, idx_2006};
  alpha=0.05;
    
%mend;

%macro Homework4DataTable;  
  data CookingTooMuch;
    input Year CaloriesPerRecipeMean CaloriesPerRecipeSD CaloriesPerServingMean CaloriesPerServingSD ServingsPerRecipeMean ServingsPerRecipeSD;
    datalines;
    1936 2123.8 1050.0 268.1 124.8 12.9 13.3
    1946 2122.3 1002.3 271.1 124.2 12.9 13.3
    1951 2089.9 1009.6 280.9 116.2 13.0 14.5
    1963 2250.0 1078.6 294.7 117.7 12.7 14.6
    1975 2234.2 1089.2 285.6 118.3 12.4 14.3
    1997 2249.6 1094.8 288.6 122.0 12.4 14.3
    2006 3051.9 1496.2 384.4 168.3 12.7 13.0
  run;
%mend;

title 'Exercise 1';
/* Part A*/

/*This will build column Year1*/
data CookingTooMuchYear1;
   do i = 1 to 7;
   	 do j = 1 to n;
         set CookingTooMuch nobs=n point=j;
         keep Year;
         output;
         end;
        end;
   	stop;
   run;
   
/*Adding rowcount column*/
data CTMYear1;
set CookingTooMuchYear1;
keep Year row;
rename  Year = Year1;
row = _n_;

/*This will build column Year2*/
data CookingTooMuchYear2;
	set CookingTooMuch;
	keep Year;
	do i = 1 to 7;
	output;
	end;

/*Adding rowcount column*/
data CTMYear2;
set CookingTooMuchYear2;
keep Year row;
rename  Year = Year2;
row = _n_;

/*This will build column Mean1*/
data CookingTooMuchMean1;
   do i = 1 to 7;
      do j = 1 to n;
         set CookingTooMuch nobs=n point=j;
         keep CaloriesPerRecipeMean;
          output;
         end;
      end;
   stop;
   run;
   
/*Adding rowcount column*/
data CTMMean1;
set CookingTooMuchMean1;
keep CaloriesPerRecipeMean row;
rename CaloriesPerRecipeMean = Mean1;
row = _n_;
run;

/*This will build column Mean2*/
data CookingTooMuchMean2;
	set CookingTooMuch;
	keep CaloriesPerRecipeMean;
	do i = 1 to 7;
	output;
	end;

/*Adding rowcount column*/
data CTMMean2;
set CookingTooMuchMean2;
keep CaloriesPerRecipeMean row;
rename CaloriesPerRecipeMean = Mean2;
row = _n_;
run;

/*This will build column SD1*/
data CookingTooMuchSD1;
   do i = 1 to 7;
      do j = 1 to n;
         set CookingTooMuch nobs=n point=j;
         keep CaloriesPerRecipeSD;
         output;
         end;
      end;
   stop;
   run;

data CTMSD1;
set CookingTooMuchSD1;
keep CaloriesPerRecipeSD row;
rename CaloriesPerRecipeSD = SD1;
row = _n_;
run;

/*This will build column SD2*/
data CookingTooMuchSD2;
	set CookingTooMuch;
	keep CaloriesPerRecipeSD;
	do i = 1 to 7;
	output;
	end;

/*Adding rowcount column*/
data CTMSD2;
set CookingTooMuchSD2;
keep CaloriesPerRecipeSD row;
rename CaloriesPerRecipeSD = SD2;
row = _n_;
run;

/*Proc to show all generated data for data table CohenA
proc sql;
select * from CohenA;
quit;

/*Export CohenD output from R as CSV and import file into SAS for CohenD column data*/
filename Cohen '/home/drewmars70/summer2018/CohenD.csv';

proc import datafile = Cohen
  dbms=csv replace
  out=Cohendat;
  getnames=yes;
run;

data Cohend;
set Cohendat;
keep Cohend;
rename Cohend = d;
run;

/*Adding rowcount column*/
data CTMCohend;
set Cohend;
keep d row;
row = _n_;
run;

/*Merging columns to complete remaining calculations*/
data CohenA;
merge CTMYear1 CTMYear2 CTMMean1 CTMMean2 CTMSD1 CTMSD2 CTMCohend;
keep row Year1 Year2 Mean1 Mean2 SD1 SD2 d;
by row;
run;
 
/*Part B*/

proc sql;
create table CohenB as 
select * from CohenA
where Year1 <> Year2;
quit;

/*Part C*/

proc sort data=CohenB out=CohenCTemp;
by d;
quit;

/*Generating data table that only contains even number rows*/
data CohenC;
set CohenCTemp;
keep Year1 Year2 Mean1 Mean2 SD1 SD2 d;
if MOD(row,2)=1 then output;
run;

/*part D*/

/*Data for data table CohenC*/
proc sql;
select * from CohenC
order by Year1,Year2;
quit;




title 'Exercise 2';
/* Optional - see R Markdown  */
/*
 * Contemporary Statistical Models for the Plant and Soil Sciences
 * Oliver Schabenberger, Francis J. Pierce
 * November 13, 2001 by CRC Press 
 * ISBN 9781584881117 - CAT# 1405
 * https://www.crcpress.com/Contemporary-Statistical-Models-for-the-Plant-and-Soil-Sciences/Schabenberger-Pierce/p/book/9781584881117
 */
/* ------------------------------------------------ */
/* Apple data                                       */
/* Data made kindly available by Dr. Ross E. Byers, */
/* Alson H. Smith, Jr. Agricultural Research and    */
/* Extension Center, Virginia Polytechnic Insitute  */ 
/* and State University                             */  
/* ------------------------------------------------ */

data apples;
  input tree apple time diam;
  datalines;
  1        1       1     2.90
  1        1       2     2.90
  1        1       3     2.90
  1        1       4     2.93
  1        1       5     2.94
  1        1       6     2.94
  1        4       1     2.86
  1        4       2     2.90
  1        4       3     2.93
  1        4       4     2.96
  1        4       5     2.99
  1        4       6     3.01
  1        5       1     2.75
  1        5       2     2.78
  1        5       3     2.80
  1        5       4     2.82
  1        5       5     2.82
  1        5       6     2.84
  1       10       1     2.81
  1       10       2     2.84
  1       10       3     2.88
  1       10       4     2.92
  1       10       5     2.92
  1       10       6     2.95
  1       11       1     2.75
  1       11       2     2.78
  1       11       3     2.80
  1       11       4     2.82
  1       11       5     2.83
  1       11       6     2.90
  1       13       1     2.92
  1       13       2     2.96
  1       13       3     2.96
  1       13       4     3.02
  1       13       5     3.02
  1       13       6     3.04
  1       14       1     3.08
  1       14       2      .
  1       14       3      .
  1       14       4      .
  1       14       5      .
  1       14       6      .
  1       15       1     3.04
  1       15       2     3.10
  1       15       3     3.11
  1       15       4     3.15
  1       15       5     3.18
  1       15       6     3.21
  1       17       1     2.78
  1       17       2     2.82
  1       17       3     2.83
  1       17       4     2.86
  1       17       5     2.87
  1       17       6      .
  1       18       1     2.76
  1       18       2     2.78
  1       18       3     2.82
  1       18       4     2.85
  1       18       5     2.86
  1       18       6     2.87
  1       19       1     2.79
  1       19       2     2.86
  1       19       3     2.88
  1       19       4     2.93
  1       19       5     2.95
  1       19       6     2.98
  1       25       1     2.76
  1       25       2     2.81
  1       25       3     2.82
  1       25       4     2.86
  1       25       5     2.90
  1       25       6     2.90
  2        7       1     2.84
  2        7       2     2.89
  2        7       3     2.92
  2        7       4     2.93
  2        7       5     2.95
  2        7       6      .
  2        9       1     2.75
  2        9       2     2.80
  2        9       3     2.82
  2        9       4     2.84
  2        9       5     2.86
  2        9       6     2.86
  2       11       1     2.78
  2       11       2     2.81
  2       11       3     2.84
  2       11       4     2.85
  2       11       5     2.87
  2       11       6     2.90
  2       15       1     2.84
  2       15       2     2.86
  2       15       3     2.86
  2       15       4      .
  2       15       5      .
  2       15       6      .
  2       17       1     2.83
  2       17       2     2.88
  2       17       3     2.89
  2       17       4     2.92
  2       17       5     2.93
  2       17       6     2.93
  2       23       1     2.80
  2       23       2     2.86
  2       23       3     2.89
  2       23       4     2.92
  2       23       5     2.93
  2       23       6     2.95
  2       24       1     2.86
  2       24       2     2.89
  2       24       3     2.92
  2       24       4     2.96
  2       24       5     2.96
  2       24       6     2.99
  2       25       1     2.75
  2       25       2     2.80
  2       25       3     2.83
  2       25       4     2.85
  2       25       5     2.86
  2       25       6     2.88
  3        1       1     2.91
  3        1       2     3.00
  3        1       3     3.02
  3        1       4     3.03
  3        1       5      .
  3        1       6      .
  3       10       1     2.81
  3       10       2     2.89
  3       10       3     2.87
  3       10       4     2.93
  3       10       5     2.93
  3       10       6     2.94
  3       16       1     2.95
  3       16       2     3.00
  3       16       3     3.03
  3       16       4     3.03
  3       16       5     3.06
  3       16       6     3.08
  3       17       1     2.79
  3       17       2     2.83
  3       17       3     2.86
  3       17       4     2.87
  3       17       5     2.87
  3       17       6     2.93
  3       18       1     2.98
  3       18       2     3.03
  3       18       3     3.06
  3       18       4     3.09
  3       18       5     3.09
  3       18       6     3.09
  3       20       1     2.76
  3       20       2     2.82
  3       20       3     2.83
  3       20       4     2.85
  3       20       5     2.86
  3       20       6     2.88
  3       22       1     2.76
  3       22       2     2.82
  3       22       3     2.85
  3       22       4     2.87
  3       22       5     2.90
  3       22       6     2.90
  3       23       1     2.76
  3       23       2     2.78
  3       23       3     2.77
  3       23       4     2.79
  3       23       5     2.79
  3       23       6     2.79
  3       24       1     2.80
  3       24       2     2.85
  3       24       3     2.87
  3       24       4     2.87
  3       24       5     2.89
  3       24       6     2.92
  4        1       1     2.85
  4        1       2     2.88
  4        1       3     2.93
  4        1       4     2.98
  4        1       5     3.01
  4        1       6     3.01
  4        2       1     2.82
  4        2       2     2.88
  4        2       3     2.94
  4        2       4     2.96
  4        2       5     2.99
  4        2       6     3.03
  4        3       1     2.80
  4        3       2     2.86
  4        3       3     2.90
  4        3       4     2.90
  4        3       5     2.93
  4        3       6     2.95
  4        8       1     2.84
  4        8       2     2.91
  4        8       3     2.95
  4        8       4     2.96
  4        8       5     3.03
  4        8       6     3.03
  4       11       1     2.93
  4       11       2     2.98
  4       11       3     3.00
  4       11       4     3.04
  4       11       5     3.04
  4       11       6     3.10
  4       17       1     2.75
  4       17       2     2.81
  4       17       3     2.81
  4       17       4     2.84
  4       17       5     2.84
  4       17       6      .
  4       18       1     2.75
  4       18       2     2.75
  4       18       3     2.75
  4       18       4     2.80
  4       18       5     2.82
  4       18       6     2.84
  4       20       1     2.90
  4       20       2     2.91
  4       20       3     2.95
  4       20       4     3.00
  4       20       5     3.00
  4       20       6      .
  4       24       1     2.95
  4       24       2     3.05
  4       24       3     3.14
  4       24       4     3.14
  4       24       5     3.18
  4       24       6     3.19
  4       25       1     2.76
  4       25       2     2.81
  4       25       3     2.85
  4       25       4     2.85
  4       25       5     2.90
  4       25       6      .
  5        1       1     2.90
  5        1       2     2.95
  5        1       3     2.98
  5        1       4     3.01
  5        1       5     3.02
  5        1       6     3.05
  5       11       1     2.77
  5       11       2     2.81
  5       11       3     2.85
  5       11       4     2.89
  5       11       5      .
  5       11       6      .
  5       14       1     2.85
  5       14       2     2.86
  5       14       3     2.92
  5       14       4     2.95
  5       14       5     2.96
  5       14       6     2.99
  5       18       1     2.75
  5       18       2     2.81
  5       18       3     2.84
  5       18       4     2.86
  5       18       5     2.90
  5       18       6     2.91
  5       20       1     2.83
  5       20       2     2.86
  5       20       3     2.90
  5       20       4     2.94
  5       20       5     2.96
  5       20       6     2.97
  5       24       1     2.93
  5       24       2     2.98
  5       24       3     3.00
  5       24       4     3.04
  5       24       5     3.05
  5       24       6     3.08
  6        3       1     2.83
  6        3       2     2.86
  6        3       3     2.90
  6        3       4     2.94
  6        3       5     2.96
  6        3       6     2.96
  6        4       1     2.95
  6        4       2     3.00
  6        4       3     3.05
  6        4       4     3.12
  6        4       5     3.12
  6        4       6     3.14
  6        5       1     2.79
  6        5       2     2.81
  6        5       3     2.84
  6        5       4      .
  6        5       5      .
  6        5       6      .
  6        7       1     2.90
  6        7       2     2.98
  6        7       3     3.01
  6        7       4     3.02
  6        7       5     3.03
  6        7       6     3.04
  6       10       1     2.89
  6       10       2     2.93
  6       10       3     2.93
  6       10       4     2.99
  6       10       5     2.99
  6       10       6     3.02
  6       12       1     2.78
  6       12       2     2.81
  6       12       3     2.85
  6       12       4     2.85
  6       12       5     2.85
  6       12       6     2.85
  6       14       1     2.78
  6       14       2     2.82
  6       14       3     2.85
  6       14       4     2.88
  6       14       5     2.91
  6       14       6     2.92
  6       17       1     2.96
  6       17       2     3.00
  6       17       3     3.00
  6       17       4     3.05
  6       17       5     3.09
  6       17       6     3.10
  6       19       1     2.82
  6       19       2     2.84
  6       19       3     2.85
  6       19       4     2.87
  6       19       5     2.91
  6       19       6     2.92
  6       20       1     2.85
  6       20       2     2.94
  6       20       3     2.92
  6       20       4     3.00
  6       20       5     3.03
  6       20       6     3.04
  6       24       1     2.87
  6       24       2     2.93
  6       24       3     2.96
  6       24       4     3.01
  6       24       5     3.01
  6       24       6     3.04
  7        2       1     2.79
  7        2       2     2.89
  7        2       3     2.89
  7        2       4     2.91
  7        2       5     2.91
  7        2       6     2.95
  7        4       1     2.80
  7        4       2     2.81
  7        4       3     2.85
  7        4       4     2.91
  7        4       5     2.92
  7        4       6     2.96
  7        9       1     3.06
  7        9       2     3.15
  7        9       3     3.15
  7        9       4     3.23
  7        9       5     3.27
  7        9       6     3.31
  7       25       1     2.84
  7       25       2     2.86
  7       25       3     2.88
  7       25       4     2.93
  7       25       5     2.93
  7       25       6     2.96
  8        2       1     2.90
  8        2       2     2.93
  8        2       3     2.98
  8        2       4     3.00
  8        2       5     3.01
  8        2       6     3.05
  8        5       1     2.91
  8        5       2     2.95
  8        5       3     3.00
  8        5       4     3.02
  8        5       5     3.05
  8        5       6     3.11
  8        9       1     3.00
  8        9       2     3.05
  8        9       3     3.06
  8        9       4     3.09
  8        9       5      .
  8        9       6      .
  8       12       1     2.83
  8       12       2     2.90
  8       12       3     2.94
  8       12       4     2.98
  8       12       5     3.00
  8       12       6     3.04
  8       15       1     2.80
  8       15       2     2.86
  8       15       3     2.89
  8       15       4     2.94
  8       15       5     2.97
  8       15       6     2.99
  8       20       1     2.88
  8       20       2     2.91
  8       20       3     2.95
  8       20       4     2.95
  8       20       5     3.00
  8       20       6     3.01
  8       21       1     2.76
  8       21       2     2.80
  8       21       3     2.81
  8       21       4     2.86
  8       21       5     2.87
  8       21       6     2.89
  9        8       1     2.75
  9        8       2     2.75
  9        8       3     2.78
  9        8       4     2.80
  9        8       5     2.82
  9        8       6     2.82
  9       10       1     2.80
  9       10       2     2.84
  9       10       3     2.90
  9       10       4     2.93
  9       10       5     2.94
  9       10       6     2.95
  9       12       1     2.94
  9       12       2     2.96
  9       12       3     2.96
  9       12       4     3.02
  9       12       5     3.02
  9       12       6     3.02
 10        2       1     2.92
 10        2       2     2.95
 10        2       3     3.00
 10        2       4     3.01
 10        2       5     3.07
 10        2       6      .
 10        5       1     2.87
 10        5       2     2.89
 10        5       3     2.94
 10        5       4     2.95
 10        5       5     3.01
 10        5       6     3.02
 10        8       1     2.76
 10        8       2     2.81
 10        8       3     2.86
 10        8       4     2.90
 10        8       5      .
 10        8       6      .
 10        9       1     2.91
 10        9       2     3.01
 10        9       3     3.07
 10        9       4     3.09
 10        9       5     3.11
 10        9       6      .
 10       10       1     2.88
 10       10       2     2.88
 10       10       3     2.92
 10       10       4     2.97
 10       10       5     2.97
 10       10       6     2.99
 10       17       1     3.00
 10       17       2     3.05
 10       17       3     3.05
 10       17       4     3.06
 10       17       5     3.11
 10       17       6      .
 10       18       1     2.85
 10       18       2     2.87
 10       18       3     2.91
 10       18       4     2.95
 10       18       5     2.98
 10       18       6     3.00
 10       21       1     2.76
 10       21       2     2.83
 10       21       3     2.84
 10       21       4     2.87
 10       21       5     2.88
 10       21       6     2.91
 10       22       1     3.25
 10       22       2     3.34
 10       22       3     3.34
 10       22       4     3.38
 10       22       5     3.47
 10       22       6      .
 10       23       1     3.00
 10       23       2     3.06
 10       23       3     3.08
 10       23       4     3.14
 10       23       5     3.18
 10       23       6      .
;;
run;

/*Part A*/
data specialapples;
set apples;
where tree in (3,7,10);
run;

proc sort data = specialapples out=sortedspecapples;
by time;
run;


/*Part B*/
/*Transposing columns using SQL code*/
proc sql;
create table AppleWide as
SELECT 
tree,
apple,
SUM(CASE WHEN time=1 THEN diam END) as diam1,
SUM(CASE WHEN time=2 THEN diam END) as diam2,
SUM(CASE WHEN time=3 THEN diam END) as diam3,
SUM(CASE WHEN time=4 THEN diam END) as diam4,
SUM(CASE WHEN time=5 THEN diam END) as diam5,
SUM(CASE WHEN time=6 THEN diam END) as diam6
from sortedspecapples
group by tree,apple;

quit;
 

 
/*Part C*/
/*Generating proc means data*/
proc means data = sortedspecapples;
var diam;
by time;
output out=sortapplesmeans;
quit;

proc means data =  AppleWide;
var diam1 diam2 diam3 diam4 diam5 diam6;
output out=widemeans;
quit;


/*Part D*/


title 'Exercise 4';

/*Importing CSV file for calculations*/
filename Fastest '/home/drewmars70/summer2018/fastest.csv';
/*Part A*/
proc import datafile=Fastest
  dbms=csv replace
  out=Fastestdat;
  getnames=yes;
run;

proc sort data=Fastestdat out=Fastest;
by 'Initial Model Year'n;
run;

/*Creating table fastestever*/
data fastestever;
	set fastest;
	by 'Initial Model Year'n;
	if MPH > lag(MPH) AND 'Initial Model Year'n > lag('Initial Model Year'n) then faster=1; else faster=0;	
run;

/*Creating table notfastestever*/
data notfastestever;
	set fastestever;
	by 'Initial Model Year'n;
	where faster=0;
run;

/*Part B*/
proc sql;
select Make,Model,'Initial Model Year'n,Engine,CC,Horsepower,MPH from fastestever
where faster=0;
quit;

/*Merging columns for graph*/
data fastestgraph;
merge fastestever notfastestever;
run;

/*Part C*/

data fastattrmap;
length linecolor $ 9 fillcolor $ 9;
input ID $ value $ linecolor $ fillcolor $;
datalines;
myid fast red red
;
run;
/*Plotting first data table fastestever*/
title 'Fastest ever';
proc sgplot data=fastestever dattrmap=fastattrmap;
  STEP  X = 'Initial Model Year'n Y = MPH;
run;


title 'Exercise 5';
/* Optional - see R Markdown  */
/*Part a*/

/*Export original AtmWtAgt dataframe output from R to CSV and import file into SAS for AtmWtAgt column data*/
filename AtmWtAgt '/home/drewmars70/summer2018/AtmWtAgt.csv';

proc import datafile = AtmWtAgt
  dbms=csv replace
  out=AtmWtAgtdat;
  getnames=yes;
run;


/*Part B*/
/*creating tables for further calculations*/

data AtmWtAgt1;
set AtmWtAgtdat;
keep VAR1;
rename VAR1=I1;
where VAR1 NOT IN ('1');
run;

data AWA1;
set AtmWtAgt1;
keep I1 row;
row = _n_;
run;

data AtmWtAgt2;
set AtmWtAgtdat;
keep Instrument;
rename Instrument=I2;
where Instrument <> 2;
run;

data AWA2;
set AtmWtAgt2;
keep I2 row;
row = _n_;
run;

data AWA12;
merge AWA1 AWA2;
by row;
run;


/*Part C*/
/*transposing tables for further work*/
proc transpose data=AWA12 out=AWAL;
    var I1 I2;
    by row;
  run;
  
 data AtmWtAgLong;
 set AWAL;
 rename COL1 = AgWt;
 run;

proc sql;
select *
from AtmWtAgLong;
quit;

/*Part D*/



/*
proc glm data=AtmWtAgLong;
  class Instrument;
  model AgWt = Instrument / solution;
run;
*/