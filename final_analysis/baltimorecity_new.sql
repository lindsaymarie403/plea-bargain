use criminal_circuit_baltimore_city;

select *
from related_person_information;

select Connection, count(*)
from related_person_information
group by Connection;

/*pull only cases where related person is police officer*/
select *
from related_person_information
where Connection in ('POLICE OFFICER','POLICE OFFICER - STATE', 'PRIMARY POLICE OFFICER');

/*
finding the individual officers
*/

/*pled guilty*/
select *
from related_person_information
where Name = 'GONDO, MOMODUB K';

/*on trial now*/
select *
from related_person_information
where Name like 'HERSL, DAN%' or Name = 'HERSL, DDAN';

/*pled guilty*/
select *
from related_person_information
where Name = 'HENDRIX, EVODIO C';

/*pled guilty*/
select *
from related_person_information
where Name = 'RAYAM, JEMELL L';

/*on trial now*/
select *
from related_person_information
where Name = 'TAYLOR, MARCUS R';

/*pled guilty*/
select *
from related_person_information
where Name = 'WARD, MAURICE K JR';

/*pled guilty*/
select *
from related_person_information
where Name in ('JENKINS, WAYNE E', 'JENKINS, WAYNE OFFR');

/*pled guilty*/
select *
from related_person_information
where Name like 'ALLERS%';


/*creating table with just the cases involving those officers*/

create temporary table balt_officers
select * from related_person_information
where Name in ('GONDO, MOMODUB K', 'HERSL, DDAN', 'HENDRIX, EVODIO C', 'RAYAM, JEMELL L', 'TAYLOR, MARCUS R', 'WARD, MAURICE K JR', 'JENKINS, WAYNE E', 'JENKINS, WAYNE OFFR')
or Name like 'HERSL, DAN%' or Name like 'ALLERS%';

select *
from balt_officers;


/*all cases with guilty or alford pleas where disposition wasn't nolle prosequi*/

create temporary table balt_pleas
select CaseNumber, Connection, Name, Disposition, ChargeNo, DispositionDate, PleaDate, Plea, Description, Verdict, VerdictDate
from balt_officers b join charge_and_disposition_information c using (CaseNumber)
where Plea in ('ALFORD PLEA', 'GUILTY') and Disposition not in ('Nolle Prosequi');

select *
from balt_pleas;


/*now we're just joining that info to all the cases involving those officers*/

create temporary table balt_all_pleas
select CaseNumber, Connection, Name, Disposition, ChargeNo, DispositionDate, PleaDate, Plea, Description, Verdict, VerdictDate
from balt_officers b join charge_and_disposition_information c using (CaseNumber);

select *
from balt_all_pleas;


/*table of all alford and guilty cases involving those officers*/

create temporary table balt_guilty_alford
select CaseNumber, Connection, Name, Disposition, ChargeNo, DispositionDate, PleaDate, Plea, Description, Verdict, VerdictDate
from balt_officers b join charge_and_disposition_information c using (CaseNumber)
where Plea in ('ALFORD PLEA', 'GUILTY');

select distinct CaseNumber
from balt_guilty_alford;


/*table with just the alford pleas in cases involving those officers*/

create temporary table balt_alford
select CaseNumber, Connection, Name, Disposition, ChargeNo, DispositionDate, PleaDate, Plea, Description, Verdict, VerdictDate
from balt_officers b join charge_and_disposition_information c using (CaseNumber)
where Plea in ('ALFORD PLEA');


/*previous table includes multiple records for some cases, since each record is an individual charge in the case, and cases have multiple. so find the distinct case numbers*/

create temporary table balt_alford_numbers
select distinct CaseNumber
from balt_alford;

select *
from balt_alford_numbers;

/*trying to get all the adjoining info for those alford case numbers

create temporary table balt_alford2
select b.CaseNumber, BailAmount, SetDate, ReleaseDate, ReleaseReason
from balt_alford_numbers b left join bail_and_bond_information i using(CaseNumber);

select CaseNumber, count(*)
from bail_and_bond_information
group by CaseNumber;

drop temporary table balt_alford4;

select CaseNumber, count(*) 
from balt_alford2
group by CaseNumber;

select *
from balt_alford2;

create temporary table balt_alford3
select b.CaseNumber, BailAmount, SetDate, ReleaseDate, ReleaseReason, DistrictCaseNo, FilingDate, IncidentDate, StatusDate, CaseStatus, CourtSystem, County
from balt_alford2 b left join case_information c using(CaseNumber);

select *
from balt_alford3;

create temporary table balt_alford4
select b.CaseNumber, BailAmount, SetDate, ReleaseDate, ReleaseReason, DistrictCaseNo, FilingDate, IncidentDate, StatusDate, 
CaseStatus, CourtSystem, County, SentenceTimeYrs, SentenceTimeDays, Disposition, SuspendedTimeMos, ProbationTimeDays, ChargeNo, 
DispositionDate, PleaDate, Plea, SentenceTimeConfinement, ProbationTimeMos, Description, SuspendedTimeDays, Verdict, 
ProbationTimeType, SentenceTimeMos, ProbationTimeYrs, VerdictDate, SuspendedTimeYrs, SentenceDate, CJISTrafficCode
from balt_alford3 b left join charge_and_disposition_information c using(CaseNumber);

select *
from balt_alford4;

create temporary table balt_alford5
select b.CaseNumber, BailAmount, SetDate, ReleaseDate, ReleaseReason, DistrictCaseNo, FilingDate, IncidentDate, StatusDate, 
CaseStatus, CourtSystem, County, SentenceTimeYrs, SentenceTimeDays, Disposition, SuspendedTimeMos, ProbationTimeDays, ChargeNo, 
DispositionDate, PleaDate, Plea, SentenceTimeConfinement, ProbationTimeMos, Description, SuspendedTimeDays, Verdict, 
ProbationTimeType, SentenceTimeMos, ProbationTimeYrs, VerdictDate, SuspendedTimeYrs, SentenceDate, CJISTrafficCode,
DefendantName, DOB, Sex, Address, City, State, ZipCode, Race
from balt_alford4 b left join defendant_information d using(CaseNumber);

select *
from balt_alford5;

select *
from defendant_information
where CaseNumber = '100003023';

*/

/*now finding guilty pleas in cases involving those officers*/
create temporary table balt_guilty
select CaseNumber, Connection, Name, Disposition, ChargeNo, DispositionDate, PleaDate, Plea, Description, Verdict, VerdictDate
from balt_officers b join charge_and_disposition_information c using (CaseNumber)
where Plea in ('GUILTY');

select *
from balt_guilty;


/*again, pulling unique case numbers*/

create temporary table balt_guilty_numbers
select distinct CaseNumber
from balt_guilty;


/*only guilty ones involving appeals to court or for post-conviction relief*/

create temporary table balt_guilty2
select CaseNumber, Date, Comment, Event
from balt_guilty_numbers left join event_history_information using(CaseNumber)
where Comment like '%special appeal%' or Comment like '%conviction%';


/*finding those distinct case numbers*/

select distinct CaseNumber
from balt_guilty2;

select *
from balt_guilty_numbers;


/*look for more guilty cases using 'gp' code in event field*/

create temporary table balt_gp
select CaseNumber, Connection, Name, Date, Comment, Event
from balt_officers b left join event_history_information e using (CaseNumber)
where Comment like '%gp%';


/*just get case numbers for 'gp' cases*/

create temporary table balt_gp_numbers
select distinct CaseNumber
from balt_gp;


/*look for 'gp' cases with appeals to court or for post-conviction relief*/

select distinct CaseNumber
from balt_gp_numbers b join event_history_information e using(CaseNumber)
where Comment like '%special appeal%' or Comment like '%conviction%'
order by CaseNumber asc;


/*check for additional ones using event codes*/

select distinct CaseNumber
from balt_gp_numbers b join event_history_information e using(CaseNumber)
where Event in ('PCFD', 'APPL')
order by CaseNumber asc;


/*look for more alford plea cases using 'ap' code in event field*/

create temporary table balt_ap
select CaseNumber, Connection, Name, Date, Comment, Event
from balt_officers b left join event_history_information e using (CaseNumber)
where Comment like '%ap;%';


/*just get case numbers for 'ap' cases*/

select distinct CaseNumber
from balt_ap
order by CaseNumber asc;



