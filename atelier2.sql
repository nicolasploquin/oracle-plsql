set serveroutput on;
begin

-- atelier 2.1
declare

  cursor c_atelier is 
    select no_atel, intitule
      from atelier
        inner join activite using (no_atel)
      group by no_atel, intitule
        having count(jour) > 2;
        
  cursor c_activite(p_no_atel atelier.no_atel%type) is
    select jour, count(no_insc) effectif
      from atelier
        inner join activite using (no_atel)
        left outer join inscription using (no_atel, jour)
      where no_atel = p_no_atel
      group by jour;
      
begin

  for v_atelier in c_atelier loop
    for v_activite in c_activite(v_atelier.no_atel) loop
      if v_activite.effectif = 0 then
        dbms_output.put_line('L''activté ' || v_atelier.intitule 
                          || ' du ' || v_activite.jour 
                          || ' sera supprimée car il n''y a pas d''inscrits.');
        delete from activite 
          where no_atel = v_atelier.no_atel
            and jour = v_activite.jour;
      end if;
  
    end loop;
  end loop;
  commit;   
end;


-- atelier 2.B
declare

  cursor c_inscription is 
    select no_insc, no_atel, jour
      from inscription
      where jour = 'DI'
    for update of jour
  ;

  cursor c_jour(p_no_atel atelier.no_atel%type) is
    select jour, count(no_insc) effectif
      from inscription
      where no_atel = p_no_atel
        and jour <> 'DI'
      group by jour
      order by effectif
  ;
  
  v_jour c_jour%rowtype;
     
begin

  for v_inscription in c_inscription loop

    open c_jour(v_inscription.no_atel);
        fetch c_jour into v_jour;
        
        if c_jour%found then
            dbms_output.put_line('Les inscrits à l''atelier ' || v_inscription.no_atel 
                                || ' du dimanche sont transférés dans le groupe du ' || v_jour.jour 
                                || '.');
                                
            update inscription
              set jour = v_jour.jour
              where current of c_inscription;
        else
            dbms_output.put_line('Il n''y a pas d''inscrits le dimanche.');
        end if;
    
    close c_jour;

    
    delete from activite where jour = 'DI';
  
  end loop;
  


  
end;

-- atelier 2.2b
declare

  cursor c_atel_di is 
    select no_atel
		from activite
		where jour = 'DI'
  ;

  cursor c_jour_min(p_no_atel atelier.no_atel%type) is
    select jour, count(no_insc) effectif
      from inscription
      where no_atel = p_no_atel
        and jour <> 'DI'
      group by jour
      order by effectif
  ;
  
  v_jour c_jour_min%rowtype;
     
begin

  for v_atel_di in c_atel_di loop
    open c_jour_min(v_atel_di.no_atel);
    fetch c_jour_min into v_jour;
    
    dbms_output.put_line('Les inscrits à l''atelier ' || v_atel_di.no_atel 
                        || ' du dimanche sont transférés dans le groupe du ' || v_jour.jour 
                        || '.');
                        
    update inscription
      set jour = v_jour.jour
      where no_atel = v_atel_di.no_atel
		and jour = 'DI';
  
    close c_jour_min;
  
  end loop;
  


  
end;


-- atelier 2D

declare

  cursor c_villes is 
    select distinct ville
      from adherent;
  
  cursor c_ateliers is 
    select no_atel, intitule
      from atelier;

  cursor c_insc (p_no_atel atelier.no_atel%type, p_ville adherent.ville%type) is 
    select no_insc
      from inscription
        inner join adherent using (no_adher)
      where no_atel = p_no_atel
        and ville = p_ville;
        

  v_ville c_villes%rowtype;
  v_no_atel c_ateliers%rowtype;
  v_insc c_insc%rowtype;
  
begin

    for v_ville in c_villes loop
      for v_no_atel in c_ateliers loop
        open c_insc(v_no_atel.no_atel, v_ville.ville);
        fetch c_insc into v_insc;        
        if c_insc%notfound then
          dbms_output.put_line('Il n''y a pas d''inscrits en '||v_no_atel.intitule||' à '||v_ville.ville||'.');
        end if;
        close c_insc;
      end loop;
    end loop;

end;













end;



-- atelier 2.3
create or replace procedure augmentation
  -- augmentation du cout heure des animateurs en fonction des règles de
  -- gestion suivantes :
  -- Directeur : taux=1%
  -- cadre , addition des taux de la façon suivante
  --      si reponsable de plus de 3 animateurs : taux=2% sinon taux=1%
  --      si anime un atelier taux=1% sinon 0%
  -- Agent, si anime 1 atelier taux=2% sinon taux=0%
  --
  nb_atel integer;
  nb_anim integer;
  taux double;
  cout_heure_aug animateur.cout_heure%type;
  cursor c_anim is 
	select no_anim, fonction, cout_heure
		from animateur 
	for update of cout_heure;
	
begin
  for v_anim in c_anim loop
    taux := 1;
    nb_anim := 0;
    nb_atel := 0;
    if v_anim.fonction='Directeur' then
      taux := taux + 0.01;
    elsif v_anim.fonction='Cadre' then
	
      select count(*) into nb_anim
        from animateur
        where no_resp = v_anim.no_anim;
      if nb_anim > 3 then
        taux := taux + 0.02;
      else
        taux := taux + 0.01;
      end if;
		
	  nb_atel := nb_atelier(v_anim.no_anim);
	  
--      select count(*) into nb_atel 
--		from atelier
--		where no_anim=v_anim.no_anim;	
      if nb_atel > 0 then
        taux := taux + 0.01;
      end if;
	  
    else
		nb_atel := nb_atelier(v_anim.no_anim);
--      select count(*) into nb_atel from atelier
--        where no_anim=v_anim.no_anim;
      if nb_atel > 0 then
        taux := taux + 0.02;
      end if;
	  
    end if;
	
    cout_heure_aug := v_anim.cout_heure * taux;
    update animateur set cout_heure= cout_heure_aug
		where current of c_anim;
		
    dbms_output.put (v_anim.no_anim||','||v_anim.fonction||','||taux||',');
    dbms_output.put_line (nb_atel||','||nb_anim||','||v_anin.cout_heure||','||cout_heure_aug);
	
  end loop;
  commit;
end;

set serveroutput on;
execute augmentation;

  
-- atelier 2.3
create or replace procedure activite_vide 
	(p_ville Adherent.ville%type)
is

cursor c_acti is
  select * 
    from atelier inner join activite using (no_atel);

cursor c_insc (p_ville Adherent.ville%type, p_no_atel Activite.no_atel%type, p_jour Activite.jour%type) is
  select count(no_insc) nb_insc 
    from inscription inner join adherent using (no_adher)
    where ville = p_ville
      and no_atel = p_no_atel
      and jour = p_jour;

nb_insc integer;

begin

  for v_acti in c_acti loop
    
    open c_insc(p_ville, v_acti.no_atel, v_acti.jour);
    fetch c_insc into nb_insc;
    
    if nb_insc = 0 then
      dbms_output.put_line('L''atelier ' || v_acti.intitule || ' du ' || v_acti.jour || ' n''a pas d''inscrits.');
    end if;

    close c_insc;

  end loop;

end;
