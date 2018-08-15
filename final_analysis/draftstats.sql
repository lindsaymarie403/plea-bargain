/*How many cases involve arrests by 1 or more of the eight CONVICTED detective since 2010?*/

use criminal_district_regular;

select *
from related_person_information;

/*How do names appear in district court?*/
/*redid using circuit court below*/
select Name, count(*)
from related_person_information
where Name like '%GONDO, MO%' or Name like '%GONDO, MC%'
group by Name;

select Name, count(*)
from related_person_information
where Name like '%HERSL, D%' or Name in ('HERSL OFF, D','DANIEL, HERSL DET.','HERSL OFFR, DANIEL',
'HERSL, OFF DANIEL','HERSL, OFF. D','HERSLY, D OFFR','OFC, DANIEL HERSL','HERSLY, D OFFR')
group by Name;

select Name, count(*)
from related_person_information
where Name like '%HENDRIX, E%'
group by Name;

select Name, count(*)
from related_person_information
where Name like '%RAYAM%' and Name != 'RAYAM, JERRELL'
group by Name;

select Name, count(*)
from related_person_information
where Name like 'TAYLOR, MARCUS%'
group by Name;

select Name, count(*)
from related_person_information
where Name like 'WARD, MAURICE%'
group by Name;

select Name, count(*)
from related_person_information
where Name like 'JENKINS, WAYNE%'
group by Name;

select Name, count(*)
from related_person_information
where Name like '%ALLERS, T%' or Name = 'P/O THOMAS A. ALLERS'
group by Name;

/*Combine for all cases since 2010*/
create temporary table district
select *
from related_person_information
where Name like '%GONDO, MO%' or Name like '%GONDO, MC%' 
or Name like '%HERSL, D%' or Name in ('HERSL OFF, D','DANIEL, HERSL DET.','HERSL OFFR, DANIEL','HERSL, OFF DANIEL','HERSL, OFF. D','HERSLY, D OFFR','OFC, DANIEL HERSL','HERSLY, D OFFR') 
or Name like '%HENDRIX, E%' 
or Name like '%RAYAM%' 
or Name like 'TAYLOR, MARCUS%' 
or Name like 'WARD, MAURICE%' 
or Name like 'JENKINS, WAYNE%' 
or Name like '%ALLERS, T%' or Name = 'P/O THOMAS A. ALLERS';

create temporary table district2
select *
from district
where Name != 'RAYAM, JERRELL' and Connection like '%POLICE OFFICER%';

create temporary table district3
select distinct CaseNumber
from district2;

drop temporary table district;
drop temporary table district2;

select distinct CaseNumber
from district3 join charge_and_disposition_information using(CaseNumber)
where IncidentDateTo between '2010-01-01' and '2018-05-07';



/*How many cases involve arrests by 1 or more of the 11 IMPLICATED detective since 2010?*/
/*redo using circuit court*/
create temporary table implicated
select *
from related_person_information
where Name like '%Dombroski, I%' or Name in ('DET, DOMBROSKI IAN','DOMBROSKI, ODFF IAN','DOMBROSKI, OFF IAN')
or Name like 'Suiter, S%' or Name = 'DETECTIVE, SEAN SUITER'
or Name like 'Guinn, R%' 
or Name like '%Sylvester, MICHAEL%' 
or Name like '%Giordano, JASON%' 
or Name like '%Edwards, Tariq%' 
or Name like '%Ivery, K%' 
or Name like '%Biggers, Sherrod%' 
or Name like '%Woodlon, Michael%' 
or Name like '%Palmere, D%' 
or Name like '%Wilson, THO%';

select Name, count(*)
from related_person_information
where Name like '%Wilson, T%'
group by Name;

create temporary table implicated2
select distinct CaseNumber
from implicated;

select distinct CaseNumber
from implicated2 join charge_and_disposition_information using(CaseNumber)
where IncidentDateTo between '2010-01-01' and '2018-05-07';


/*Of those convicted, did most plead guilty?*/
use criminal_circuit_baltimore_city;

create temporary table balt_officers
select * from related_person_information
where Name in ('GONDO, MOMODUB K', 'HERSL, DDAN', 'HENDRIX, EVODIO C', 'RAYAM, JEMELL L', 'TAYLOR, MARCUS R', 'WARD, MAURICE K JR', 'JENKINS, WAYNE E', 'JENKINS, WAYNE OFFR')
or Name like 'HERSL, DAN%' or Name like 'ALLERS%';

create temporary table balt_officers2
select distinct CaseNumber
from balt_officers join case_information using(CaseNumber)
where FilingDate between '2010-01-01' and '2018-05-07';

/*numerator*/
select distinct CaseNumber
from balt_officers2 join event_history_information using(CaseNumber)
where Comment like '%GP;%' or Comment like '%AP;%';
/*1261*/

/*alt numerator*/
select distinct CaseNumber
from balt_officers2 join charge_and_disposition_information using(CaseNumber)
where Plea in ('GUILTY', 'ALFORD PLEA');
/*fewer using this method - 1208*/

/*denominator*/
select distinct CaseNumber
from balt_officers2 join charge_and_disposition_information using(CaseNumber)
where Plea is not null;
/*1307*/

/*redid total list using circuit court*/
select *
from balt_officers2;


/*How many arrests involved Wayne Jenkins since 10/8/2015?*/
create temporary table wayne
select distinct CaseNumber
from related_person_information
where Name like '%JENKINS, WAYNE%' and Connection like '%POLICE OFFICER%';

create temporary table wayne2
select distinct CaseNumber
from wayne join case_information using(CaseNumber)
where FilingDate between '2015-10-08' and '2017-11-30';

select *
from wayne2;

/*Jenkins stats at end: How many arrests did Jenkins make between Burley and Branch's?*/
/*When was Burley arrested: April 28, 2010*/
/*When was Branch arrested: July 9, 2014*/
use criminal_circuit_baltimore_city;

select distinct CaseNumber
from wayne join case_information using(CaseNumber)
where FilingDate between '2010-04-28' and '2014-07-09';


/*How many arrests did Jenkins make since Branch's?*/
select distinct CaseNumber
from wayne join case_information using(CaseNumber)
where FilingDate between '2014-07-09' and '2017-11-30';


/*number of cases each officer was involved in starting in 2010*/
/*what were the plea breakdowns in each of those cases?*/
use criminal_circuit_baltimore_city;

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name = 'GONDO, MOMODUB K' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*165*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name like 'HERSL, DAN%' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*834*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name = 'HERSL, DDAN' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*0*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name = 'HENDRIX, EVODIO C' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*339*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name = 'RAYAM, JEMELL L' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*119*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name = 'TAYLOR, MARCUS R' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*346*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name = 'WARD, MAURICE K JR' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*522*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name in ('JENKINS, WAYNE E', 'JENKINS, WAYNE OFFR') and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*380*/

select distinct CaseNumber
from related_person_information join case_information using(CaseNumber)
where Name like 'ALLERS%' and Connection like '%POLICE OFFICER%' and FilingDate between '2010-01-01' and '2018-05-07';
/*288*/

