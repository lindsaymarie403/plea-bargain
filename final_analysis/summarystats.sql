use criminal_circuit_baltimore_city;

/*total cases involving convicted officers*/
select distinct CaseNumber
from related_person_information
where Name in ('GONDO, MOMODUB K', 'HERSL, DDAN', 'HENDRIX, EVODIO C', 'RAYAM, JEMELL L', 'TAYLOR, MARCUS R', 'WARD, MAURICE K JR', 'JENKINS, WAYNE E', 'JENKINS, WAYNE OFFR')
or Name like 'HERSL, DAN%' or Name like 'ALLERS%';

/*total cases involving implicated officers*/
create temporary table officers
select distinct CaseNumber, Name
from related_person_information
where Name like '%Dombroski%' or Name like '%Suiter%' or Name like '%Guinn, R%' or Name like '%Sylvester, MICHAEL J%' or 
Name like '%Giordano, JASON%' or Name like '%Edwards, Tariq%' or Name like '%Ivery, K%' or Name like '%Biggers, Sherrod%' or 
Name like '%Woodlon, Michael%' or Name like '%Snell, Eric%' or Name like '%Palmere, D%' or Name like '%Wilson, THO%' or Name like '%Wilson, TOM%';

create temporary table officers2
select distinct CaseNumber
from officers
where Name not in ('PALMERE, DAM', 'PALMERE, DAN', 'PALMERE, DENO', 'PALMERE, DEON SGT', 'PALMERE, DEUN OFF', 'WILSON, THOMAS J');

select *
from officers2;

/*total cases involving all GTTF officers*/
create temporary table officersall
select distinct CaseNumber, Name
from related_person_information
where Name like '%Dombroski%' or Name like '%Suiter%' or Name like '%Guinn, R%' or Name like '%Sylvester, MICHAEL J%' or 
Name like '%Giordano, JASON%' or Name like '%Edwards, Tariq%' or Name like '%Ivery, K%' or Name like '%Biggers, Sherrod%' or 
Name like '%Woodlon, Michael%' or Name like '%Snell, Eric%' or Name like '%Palmere, D%' or Name like '%Wilson, THO%' or Name like '%Wilson, TOM%' or 
Name = 'GONDO, MOMODUB K' or Name like 'HERSL, DAN%' or Name = 'HERSL, DDAN' or Name = 'HENDRIX, EVODIO C' or Name = 'RAYAM, JEMELL L' or
Name = 'TAYLOR, MARCUS R' or Name = 'WARD, MAURICE K JR' or Name = 'JENKINS, WAYNE E' or Name = 'JENKINS, WAYNE OFFR' or Name like 'ALLERS%';

create temporary table officersall2
select distinct CaseNumber
from officers
where Name not in ('PALMERE, DAM', 'PALMERE, DAN', 'PALMERE, DENO', 'PALMERE, DEON SGT', 'PALMERE, DEUN OFF', 'WILSON, THOMAS J');

select *
from officersall2;

/*compare to 'GUILTY' in plea*/
select distinct CaseNumber
from officersall2 join charge_and_disposition_information using(CaseNumber)
where Plea = 'GUILTY';

/*compare to 'ALFORD PLEA' in plea*/
select distinct CaseNumber
from officersall2 join charge_and_disposition_information using(CaseNumber)
where Plea = 'ALFORD PLEA';

/*cases with no pleas*/
select distinct CaseNumber
from officersall2 join charge_and_disposition_information using(CaseNumber)
where Plea is not null;


/*pleas for vacated cases in circuit court*/
select distinct CaseNumber
from charge_and_disposition_information
where CaseNumber in ('113304018','114055034','114183008','114183010','114183011','114280004','114321033','114338005','115083020',
'115134009','115195020','115195021','115211015','115215035','115215036','115217009','115223036','115230017','115230019',
'115254056','115265013','115266025','115266026','115267015','115272017','115272029','115281007','115288020','115293017','115294004',
'115294012','115294025','115300027','115302015','115303015','115303028','115316007','115317004','115322003','115322004','115322005',
'115327027','115327036','115335024','115349026','115350020','115350022','115357037','115364009','116006001','116006007','116013011',
'116015002','116040013','116040015','116041017','116047023','116048008','116053040','116060012','116068010','116068011','116075022',
'116088005','116088015','116088025','116089013','116127002','116127013','116133006','116137007','116137011','116139012','116144013',
'116144033','116145011','116145030','116152009','116159027','116160018','116189010','116195014','116201014','116202017','116207003',
'116214004','116222020','116224007','116229025','116230003','116238007','116238008','116242002','116243014','116246017',
'116252038','116253018','116253019','116253020','116253026','116263029','116278035','116280007','116280008','116306003','116312012',
'116319005','116319013','116320016','116321004','117024001','117024002','211154001','316188001','414220009','415245006',
'416047002','416064003','416134001','416176001','416239002','416280025','416288001','416319003','417030001','417055005','815092008',
'815092009','815106003','815161017','815236013','815252007','815295025','815296005','815300010','815320005','815327009','816057012',
'816088012','816105004','816189012','816211004','816214006','816214012','816225004','816231005','816243019','816258008','816265011',
'816286005','816294011','816299014','816327003','817010002','817023029','817027020','817038010')
and Plea is not null;


/*pleas for all Baltimore cases*/

/*all cases in Baltimore*/
select distinct CaseNumber
from case_information;

select distinct CaseNumber
from charge_and_disposition_information
where Plea is not null;

select distinct CaseNumber
from charge_and_disposition_information
where Plea = 'GUILTY';

select distinct CaseNumber
from charge_and_disposition_information
where Plea = 'ALFORD PLEA';





