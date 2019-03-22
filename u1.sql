select nom, prenom, ville
  from Adherent
  order by ville
;  

select nom, prenom, ville
  from Adherent
  where ville in (select ville from Adherent where upper(trim(nom)) = 'GERMAIN')
;
select nom, prenom, ville
  from Adherent
    inner join (
        select ville from Adherent where upper(trim(nom)) = 'GERMAIN'
      ) using (ville)
;

select no_adher, adh.nom, adh.prenom
  from Atelier
    inner join Animateur ani using (no_anim)
    inner join Inscription using (no_atel)
    inner join Adherent adh using (no_adher)
  where
    upper(trim(ani.nom)) = 'POIRIER'
;

select no_adher, no_atel, inscription.* from inscription where no_adher = 6;

select * from activite where no_atel in (14);

insert 
  into inscription (NO_INSC, no_atel, jour, no_adher)
  values (100, 14, 'SA', 6);
insert 
  into inscription (NO_INSC, no_atel, jour, no_adher)
  values (101, 14, 'LU', 6);
  


select sum( sum(duree * vente_heure) ) -- no_adher, sum(duree * vente_heure)
  from activite 
    inner join inscription using (no_atel, jour)
    inner join atelier using (no_atel)
  group by no_adher;


select ville, genre, count(no_insc) Effectif
  from adherent 
    cross join atelier
    left outer join inscription using (no_adher, no_atel)
  group by ville, genre
    having count(no_insc) = 0
  order by ville, genre
  ;
--    where ville = 'NANTES' and genre = 'SPORT'

select count(*)
  from adherent
  where ville = 'NANTES';

select count(*)
  from atelier
  where genre = 'SPORT';





