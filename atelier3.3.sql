create or replace view v_animation as
  select no_atel, intitule, genre, vente_heure, atelier.no_anim, nom, prenom, tel
    from atelier
      inner join animateur on atelier.no_anim = animateur.no_anim
--  with read only
;

create or replace trigger in_ins_v_animation
  instead of insert
  on v_animation
  for each row
declare
  v_no_anim animateur.no_anim%type;
  v_no_atel atelier.no_atel%type;
begin
  select seq_id.nextval into v_no_anim from dual;
  select seq_id.nextval into v_no_atel from dual;
  insert into animateur (no_anim, nom, prenom, tel) 
    values (v_no_anim, :new.nom, :new.prenom, :new.tel);
  insert into atelier (no_atel, intitule, genre, vente_heure, no_anim) 
    values (v_no_atel, :new.intitule, :new.genre, :new.vente_heure, v_no_anim);
end;
/

select no_adher, nom, prenom from adherent;

select seq_id.nextval, seq_id.nextval from dual;

insert into v_animation (intitule, genre, vente_heure, nom, prenom, tel)
  values ('GOLF', 'SPORT', 20, 'LEBRETON','Louann','06.12.34.57.89');

select * from animateur;
select * from atelier;
