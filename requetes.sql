select no_atel, count(jour)
	from activite
	group by (no_atel)
		having count(jour) > 2
;
	
	
select no_atel, jour, count(no_insc)
	from activite
		left outer join inscription using (no_atel, jour)
	group by no_atel, jour
		having count(no_insc) = 0
;

select no_atel
	from activite
	where jour = 'DI'
;

select no_atel, jour, count(no_insc) effectif
	from inscription
	where no_atel = p_no_atel
	  and jour <> 'DI'
	group by jour
	order by effectif
;


select no_atel, jour, count(no_insc) effectif
	from inscription
	where  no_atel in (
		select no_atel from activite where jour = 'DI'
	  )
	group by jour, no_atel
	order by no_atel, effectif
;

select count(*) into nb_anim
	from animateur
	where no_resp = ?
	
select count(no_atel) into nb_atel
	from atelier
	where no_anim = ?

create or replace function nb_atelier 
		(p_no_anim Animateur.no_anim%type) 
		return integer 
is
	nombre integer;
begin
	
	select count(no_atel) into nombre
		from atelier
		where no_anim = p_no_anim;
	
	return nombre;

end;

select nb_atelier(6) from dual;

create or replace trigger nom_maj
	before insert or update of nom
	on  Adherent
	for each row
begin

	:new.ville := upper(:new.ville);

end;

insert into Adherent (no_adher, nom, prenom, ville)
	values (70, 'TROADEC', 'Nolwenn', 'Quimper');
	
select * from Adherent;

create or replace view v_animation as
	select no_atel, intitule, genre, vente_heure, 
		   no_anim, nom, prenom, tel
		from atelier inner join animateur using (no_anim)
;

select * from v_animation

insert into V_animation 
	values (20, 'VOILE', 'SPORT', 15, 30, 'RIOU', 'Vincent', '01.23.45.67.89');

insert into Animateur (no_anim, nom, prenom, tel)
	values (:new.no_anim, :new.nom, ...)
insert into Atelier (no_atel, intitule, genre, vente_heure, no_anim)
	values (:new.no_atel, :new. ...)






