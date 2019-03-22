create or replace function effectif_activite (p_no_atel integer, p_jour string) 
  return integer
  is
    effectif integer;
  begin
    select count(no_insc) into effectif
        from inscription 
        where no_atel = p_no_atel
            and jour = p_jour;
    return effectif;
  end;
