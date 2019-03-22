set serveroutput on

declare

    -- Ateliers du dimanche
    cursor c_adherents is 
        select *
            from activite
                inner join atelier using (no_atel)
            where jour = 'DI';
    
    -- Activité avec le moins d'inscrits pour un atelier
    cursor c_activites(p_no_atel atelier.no_atel%type) is 
        select jour, count(no_insc) effectif
            from activite 
                left join inscription using (no_atel, jour)
            where jour <> 'DI'
                and no_atel = p_no_atel
            group by jour
            order by effectif;
            
    v_activite  c_activites%rowtype;
    
    -- exception personnalisée, déclenchement par raise ...
    mon_exception   exception; 
    
    -- exception code oracle -54
    row_locked      exception; pragma exception_init ( row_locked, -54 ); 
    deadlock        exception; pragma exception_init ( deadlock, -60 ); 
    
begin

    if 5 < 10 then
        raise mon_exception;
    end if;

    
   
    
exception
    when no_data_found then
        dbms_output.put_line('Données non trouvées');
    when too_many_rows then
        dbms_output.put_line('Doublons trouvés');
    when mon_exception then
        dbms_output.put_line('Mon exception');
    when row_locked then
        dbms_output.put_line('verrou ligne pour update');
    when deadlock then
        dbms_output.put_line('verrou table');
    
end;