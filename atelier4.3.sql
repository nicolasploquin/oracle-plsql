declare

  cursor c_villes is
      select distinct ville from Adherent;

  effectif_ville integer;
  
  v_genre_effectif association.t_genre_count;

begin

  for v_villes in c_villes loop
  
    select count(*) into effectif_ville
      from adherent inner join inscription using (no_adher)
      where ville = v_villes.ville;
    
    v_genre_effectif := association.genre(v_villes.ville);
    
    dbms_output.put_line('Le genre ' || v_genre_effectif.genre || ' représente ' || (v_genre_effectif.effectif / effectif_ville * 100) || '% des adhérents de la ville de ' || v_villes.ville || '.' );
  
  end loop;

end;