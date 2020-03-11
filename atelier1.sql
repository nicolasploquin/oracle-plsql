-- set serveroutput on;
begin

-- Atelier 1.A - Adhérent le plus jeune de la ville de Nantes
dbms_output.put_line('1.A - Adhérent le plus jeune de la ville de Nantes');
declare
  maxdate date;
  vnom VARCHAR2(30000);
begin
  select max(date_naissance) into maxdate
    from adherent
    where ville='NANTES';
  select prenom||' '||nom into vnom
    from adherent 
    where date_naissance = maxdate
    and ville= 'NANTES';
    
  dbms_output.put_line(vnom||' est le plus jeune adhérent de Nantes');
end;


-- Atelier 1.B - Nombre d'inscrits par atelier
dbms_output.put_line('1.B - (for) Nombre d''inscrits par atelier');
declare
  v_eff int;
  v_intitule atelier.intitule%type;
begin
  dbms_output.put_line(' --- for --- ');
    
  for v_no_atel in 1..16 loop

    select intitule, count(*)
      into v_intitule, v_eff
      from atelier
        inner join inscription using (no_atel)
      where no_atel = v_no_atel
      group by intitule;
      
    dbms_output.put_line(v_eff || ' inscrits à l''atelier ' || v_intitule);

  end loop;

end;

-- Atelier 1.B - Nombre d'inscrits par atelier
dbms_output.put_line('1.B - (cursor) Nombre d''inscrits par atelier');
declare
  cursor c_effectif is
    select intitule, count(*) effectif
      from atelier
        inner join inscription using (no_atel)
      group by intitule;
begin
  dbms_output.put_line(' --- cursor --- ');
  
  
  for v_effectif in c_effectif loop      
    dbms_output.put_line(v_effectif.effectif || ' inscrits à l''atelier ' || v_effectif.intitule);

      
  end loop;
  
    
    
    
end;
-- atelier 1.C
-- Nombre d'inscrits par ville
declare
  type t_eff is table of int;
  type t_intitule is table of atelier.intitule%type;
  v_eff t_eff;
  v_intitule t_intitule;
  
begin
  dbms_output.put_line(' --- bulk collect --- ');
  
  select intitule, count(*) bulk collect into v_intitule, v_eff
    from atelier
      inner join inscription using (no_atel)
    group by intitule;
 
  for i in 1..v_intitule.count loop      
    dbms_output.put_line(v_eff(i) || ' inscrits à l''atelier ' || v_intitule(i));  
  end loop;
  
end;

  




end;
