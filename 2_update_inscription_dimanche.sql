set serveroutput on

declare

    -- Ateliers du dimanche
    cursor c_ateliers is 
        select no_atel, jour, intitule
            from activite
                inner join atelier using (no_atel)
            where jour = 'DI';
    
    -- Activit� avec le moins d'inscrits pour un atelier
    cursor c_activites(p_no_atel atelier.no_atel%type) is 
        select jour, count(no_insc) effectif
            from activite 
                left join inscription using (no_atel, jour)
            where jour <> 'DI'
                and no_atel = p_no_atel
            group by jour
            order by effectif;
            
    v_activite  c_activites%rowtype;

begin
    
    for v_atelier in c_ateliers loop

        open c_activites(v_atelier.no_atel);
        
        fetch c_activites into v_activite; 
        
        if c_activites%found then
        
            dbms_output.put_line('L''activit� ' || v_atelier.intitule || ' du dimanche est annul�e.');
        
            dbms_output.put_line('Les inscrits � l''atelier ' || v_atelier.intitule 
                          || ' du dimanche sont transf�r�s dans le groupe du ' || v_activite.jour 
                          || '.'); 
                          
            update inscription set
                jour = v_activite.jour
                where jour = 'DI'
                    and no_atel = v_atelier.no_atel;

            delete from activite 
                where no_atel = v_atelier.no_atel
                    and jour = 'DI';

        end if;                     
        
        close c_activites;
                
    end loop;
    
    commit;
    
exception
    when no_data_found then
        dbms_output.put_line('Donn�es non trouv�es');
    when too_many_rows then
        dbms_output.put_line('Doublons trouv�s');
    
    
end;