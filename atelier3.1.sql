insert into atelier (no_atel,intitule,genre)
  values (17,'TENNIS','SPORT');
insert into activite (no_atel,jour,duree) values (17,'SA',3);
commit;

create or replace trigger ins_upd_insc
  before insert or update of no_atel
  on inscription
  for each row
declare
  Vintitule atelier.intitule%type;
  msg_err varchar2(100);
begin
  select intitule into Vintitule
    from atelier
    where no_atel=:new.no_atel
    and no_anim is null;
  Msg_err := 'L''atelier '||Vintitule||' n''est pas animé, inscription refusée';
  raise_application_error (-20100,Msg_err);
exception
  when no_data_found then
    null;
end;



