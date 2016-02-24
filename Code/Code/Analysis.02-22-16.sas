
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

proc freq data = clean_sba2 noprint;
	tables approval_date approval_fyear borrcity borrname borrstreet borrzip business_type cdc_city cdc_name cdc_state
			cdc_street cdc_zip chargeoff_date delivery_method grossapproval gross_chargeoff_amt init_intrate
			loan_status naics_code naics_desc program project_county project_state subpgmdesc term_months
			tpdollars tplender_city tplender_name tplender_state / out = test;
run;
PROC SOrt data = test; by descending count; run;

proc sql;
     create table test2 as
     select *
     from clean_sba2;
quit;





%macro na_check(name);
proc freq data = clean_sba2 noprint;
	tables &name / out = nacheck_&name; *options nocum nofreq nopercent;
	* by variables;
run;
proc sort data = nacheck_&name; by &name descending count; run;
data nacheck_&name._2;
	set nacheck_&name;
	if &name in ('','N/A','#N/A',"' ",'. ','NA');

run;
%mend;

%na_check (program);
%na_check (borrname);
%na_check (borrstreet);
%na_check (borrcity);
%na_check (borrstate);
%na_check (borrzip);
%na_check (cdc_name);
%na_check (cdc_street);
%na_check (cdc_city);
%na_check (cdc_state);
%na_check (cdc_zip);
%na_check (tplender_name);
%na_check (tplender_city);
%na_check (tplender_state);
%na_check (tpdollars);
%na_check (grossapproval);
%na_check (approval_date);
%na_check (approval_fyear);
%na_check (delivery_method);
%na_check (subpgmdesc);
%na_check (init_intrate);
%na_check (term_months);
%na_check (naics_code);
%na_check (naics_desc);
%na_check (project_county);
%na_check (project_state);
%na_check (business_type);
%na_check (loan_status);
%na_check (chargeoff_date);
%na_check (gross_chargeoff_amt);




%macro export(data, fname);
proc export
	data = &data
	OUTFILE = "C:\Users\pejhlee\Downloads\Export\&fname..csv" replace;
run;

%mend export;

%export (clean_sba2, clean_data);
%export (a1, loan_status_bystate);
%export (chargeoff_means, summary_chargeoff_amt);

