set serveroutput on;
declare
  nombre number(2) := 10;
begin
  dbms_output.put_line(nombre);
  
-- Atelier 1.1a
dbms_output.new_line();
dbms_output.put_line('--- Atelier 1.1a ---');
declare
  v_no_atel Atelier.no_atel%type;
  v_intitule Atelier.intitule%type;
  v_effectif integer;
begin
  for v_no_atel in 1..16  loop
    select count(*), intitule into v_effectif, v_intitule
      from Atelier
        inner join Inscription using (no_atel)
        inner join Adherent using (no_adher)
      where no_atel = v_no_atel
      group by intitule;
    dbms_output.put_line(v_effectif || ' inscrits à l''atelier ' || v_intitule);
  end loop;
end;
  
-- Atelier 1.1b
dbms_output.new_line();
dbms_output.put_line('--- Atelier 1.1b ---');
declare
  cursor c_effectifs is select count(*) as effectif, intitule
    from Atelier
      inner join Inscription using (no_atel)
      inner join Adherent using (no_adher)
    group by intitule;
  v_effectif c_effectifs%rowtype;
begin
  for v_effectif in c_effectifs loop
    dbms_output.put_line(v_effectif.effectif || ' inscrits à l''atelier ' || v_effectif.intitule);
  end loop;
end;
  
-- Atelier 1.1 bulk
dbms_output.new_line();
dbms_output.put_line('--- Atelier 1.1 bulk ---');
declare
  type t_intitule is table of Atelier.intitule%type;
  type t_effectif is table of integer;
  l_intitule t_intitule;
  l_effectif t_effectif;
begin
  select count(*) effectif, intitule 
    bulk collect into l_effectif, l_intitule
    from Atelier
      inner join Inscription using (no_atel)
      inner join Adherent using (no_adher)
    group by intitule;
  for i in l_effectif.first..l_effectif.last loop
    dbms_output.put_line(l_effectif(i) || ' inscrits à l''atelier ' || l_intitule(i));
  end loop;
end;
  
-- Atelier 1.2a
dbms_output.new_line();
dbms_output.put_line('--- Atelier 1.2a ---');
declare
  v_nom varchar2(255);
  v_max_date Adherent.date_naissance%type;
begin
  -- recherche la date de naissance du plus jeune nantais
  select max(date_naissance) into v_max_date
    from adherent
    where ville='NANTES';
  -- recherche les nom et prénom du nantais ayant né ce jour (v_max_date)
  select prenom||' '||nom into v_nom
    from adherent 
    where date_naissance = v_max_date
    and ville= 'NANTES';
  dbms_output.put_line(v_nom || ' est la plus jeune inscrite nantaise.');
end;
  
-- Atelier 1.2b
dbms_output.new_line();
dbms_output.put_line('--- Atelier 1.2b ---');
declare
  v_nom varchar2(255);
  cursor c_adherent is
    select prenom||' '||nom
      from adherent
      where ville='NANTES'
      order by date_naissance desc;
begin
  open c_adherent;
  fetch c_adherent into v_nom;
  dbms_output.put_line(v_nom || ' est la plus jeune inscrite nantaise.');
end;
  
-- Atelier 1.2c
dbms_output.new_line();
dbms_output.put_line('--- Atelier 1.2c ---');
declare
  v_nom varchar2(255);
  cursor c_adherent(p_ville Adherent.ville%type) is
    select prenom||' '||nom
      from adherent
      where ville=p_ville
      order by date_naissance desc;
begin
  open c_adherent('NANTES');
  fetch c_adherent into v_nom;
  dbms_output.put_line(v_nom || ' est la plus jeune inscrite nantaise.');
end;
  
-- Atelier 2.1a
dbms_output.new_line();
dbms_output.put_line('--- Atelier 2.1a ---');
declare
  -- Ateliers ayant plus de 2 activités
  cursor c_atelier is
    select no_atel
      from activite
      group by no_atel
        having count(*) > 2;
  -- Nombre d'inscrits aux activités de l'atelier
  cursor c_activite(p_no_atel Atelier.no_atel%type) is  -- Activite.no_atel%type
    select no_atel, jour
      from activite
        left outer join inscription using (no_atel, jour)
      where no_atel = p_no_atel
      group by no_atel, jour
        having count(no_insc) = 0;
  v_atelier c_atelier%rowtype;
  v_activite c_activite%rowtype;
begin
  for v_atelier in c_atelier loop
    for v_activite in c_activite(v_atelier.no_atel) loop
      
--      delete from activite
--        where no_atel = v_activite.no_atel
--          and jour = v_activite.jour;

      dbms_output.put_line('L''atelier ' || v_activite.no_atel || ' n''aura pas lieu le ' || v_activite.jour || ' faute de participant.');
    end loop;
  end loop;
  commit;
end;
  
-- Atelier 2.1b
dbms_output.new_line();
dbms_output.put_line('--- Atelier 2.1b ---');
declare
  -- Ateliers ayant plus de 2 activités
  cursor c_atelier is
    select no_atel
      from activite
      group by no_atel
        having count(*) > 2;
  -- Atelier
  cursor c_activite(p_no_atel Atelier.no_atel%type) is
    select no_atel, jour
      from activite
        left outer join inscription using (no_atel, jour)
      where no_atel = p_no_atel
      group by no_atel, jour
        having count(no_insc) = 0;
  v_atelier c_atelier%rowtype;
  v_activite c_activite%rowtype;
begin
  for v_atelier in c_atelier loop
    for v_activite in c_activite(v_atelier.no_atel) loop
      
      delete from activite
        where no_atel = v_activite.no_atel
          and jour = v_activite.jour;

      dbms_output.put_line('L''atelier ' || v_activite.no_atel || ' n''aura pas lieu le ' || v_activite.jour || ' faute de participant.');
    end loop;
  end loop;
  commit;
end;
  
-- Atelier 2.2
dbms_output.new_line();
dbms_output.put_line('--- Atelier 2.2 ---');
declare
  -- Inscriptions aux activités du dimanche
  cursor c_inscription is
    select * from inscription
      where jour = 'DI'
    for update of jour;
  -- Activités ayant le moins d'inscrits (hors dimanche)
  cursor c_activite(p_no_atel Atelier.no_atel%type) is
    select no_atel, jour, count(no_insc) effectif
      from activite
        left outer join inscription using (no_atel, jour)
      where no_atel = p_no_atel
        and jour <> 'DI'
      group by no_atel, jour
      order by effectif;
  v_inscription c_inscription%rowtype;
  v_activite c_activite%rowtype;
begin
  for v_inscription in c_inscription loop
    open c_activite(v_inscription.no_atel);
    fetch c_activite into v_activite;
    if c_activite%found then
      update inscription 
        set jour = v_activite.jour
        where current of c_inscription;
      dbms_output.put_line('L''atelier ' || v_activite.no_atel || ' du dimanche aura lieu le ' || v_activite.jour || '.');
    end if;
    close c_activite;
  end loop;
  delete from activite act
    where jour = 'DI'
      and not exists (
        select no_insc from inscription insc
          where insc.no_atel = act.no_atel
            and jour = 'DI'
      );
  dbms_output.put_line(sql%rowcount || ' lignes supprimées.');

  commit;
end;
  
-- Atelier 2.2
dbms_output.new_line();
dbms_output.put_line('--- Atelier 2.2 ---');
declare
  -- Animateurs
  cursor c_animateur is
    select * from animateur
    for update of cout_heure;
  v_animateur c_animateur%rowtype;
  taux real;
  agents integer := 0;
  ateliers integer := 0;
  revalorisation Animateur.cout_heure%type;
begin
  for v_animateur in c_animateur loop
    taux := 1;
    if v_animateur.fonction = 'Directeur' then
      taux := taux + 0.01;
    elsif v_animateur.fonction = 'Cadre' then
      select count(ani.no_anim) into agents
        from animateur resp
          left outer join animateur ani on resp.no_anim = ani.no_resp
        where resp.no_anim = v_animateur.no_anim;
      if agents > 3 then
        taux := taux + 0.02;
      else
        taux := taux + 0.01;
      end if;
      select count(no_atel) into ateliers
        from animateur
          left outer join atelier using (no_anim)
        where no_anim = v_animateur.no_anim;
      if ateliers > 0 then
        taux := taux + 0.01;
      end if;
    elsif v_animateur.fonction = 'Agent' then
      select count(no_atel) into ateliers
        from animateur
          left outer join atelier using (no_anim);
      if ateliers > 0 then
        taux := taux + 0.02;
      end if;
    end if;
    revalorisation := v_animateur.cout_heure * taux;
    update animateur 
      set cout_heure = revalorisation
      where current of c_animateur;
    dbms_output.put_line('La rémunération de ' || v_animateur.prenom || ' ' || v_animateur.nom 
                      || ' est passé de ' || v_animateur.cout_heure || ' €/h à ' || revalorisation 
                      || ' €/h. (+' || (taux-1)*100 || '%)');
  end loop;
  commit;
end;
  
-- Tests Triggers
dbms_output.new_line();
dbms_output.put_line('--- Tests Triggers ---');

insert into Atelier (intitule, genre, vente_heure)
  values ('VOILE', 'SPORT', 15);
insert into Atelier (no_atel, intitule, genre, vente_heure)
  values (20,'GOLF', 'SPORT', 18);
insert into Activite (no_atel, jour, duree)
  values (20, 'SA', 4);
insert into Activite (no_atel, jour, duree)
  values (20, 'DI', 4);
commit;

-- Atelier 3.1
dbms_output.new_line();
dbms_output.put_line('--- Atelier 3.1 ---');

insert into inscription (no_insc, no_adher, no_atel, jour, date_inscription)
  values (c_id.nextval, 8, 20, 'SA', sysdate);
insert into inscription (no_insc, no_adher, no_atel, jour, date_inscription)
  values (c_id.nextval, 24, 20, 'DI', sysdate);
update inscription
  set no_atel = 20, jour = 'DI'
  where mod(no_insc, 7) = 0;
commit;

  
end; -- fin script plsql





