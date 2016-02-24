
proc freq data = clean_sba2 noprint;
	tables loan_status / out = freq_loanstatus; *options nocum nofreq nopercent;
	*by variables;
run;


data chargeoff;
	set clean_sba2;
	if loan_status = 'CHGOFF';
run;

proc means data = chargeoff noprint; *options noprint sum mean std min max;
	var gross_chargeoff_amt;
	*by variables;
	where gross_chargeoff_amt ~= 0;
	*weight variables;
	output out = chargeoff_means (drop=_TYPE_ _FREQ_ rename=(_STAT_=Summary_Statistics)); *option: (drop=_TYPE_ _FREQ_ rename=(_STAT_=Summary_Statistics));
run;

proc sort data = clean_sba2 out = clean_sba_sort; by loan_status; run;
proc freq data = clean_sba_sort noprint;
	tables borrstate / out = a0; *options nocum nofreq nopercent;
	by loan_status;
run;
proc sort data = clean_sba2 out = clean_sba_sort; by borrstate; run;
proc freq data = clean_sba_sort noprint;
	tables loan_status / out = a1; *options nocum nofreq nopercent;
	by borrstate;
run;






%macro export(data, fname);
proc export
	data = &data
	OUTFILE = "C:\Users\pejhlee\Downloads\Export\&fname..csv" replace;
run;

%mend export;

%export (clean_sba2, clean_data);
%export (a1, loan_status_bystate);
%export (chargeoff_means, summary_chargeoff_amt);

