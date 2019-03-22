create sequence seq_id start with 400;

select seq_id.nextval from dual;

insert into adherent (nom, prenom, date_naissance, sexe)
  values ('TROADEC', 'Nolwenn', '01/01/1980','F');

create or replace trigger ai_adherent
  before insert
  on adherent
  for each row
  when (new.no_adher is null)
begin
  select seq_id.nextval into :new.no_adher from dual;
end;
/

select no_adher, nom, prenom from adherent;



