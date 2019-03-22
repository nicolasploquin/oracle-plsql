set serveroutput on

declare

-- Supprimer les activités qui n'ont pas d'inscrits 
-- dont les ateliers ont plus de 2 jours de pratique possibles

    -- Atelier avec plus de 2 activités
    cursor c_ateliers is 
        select no_atel, intitule
          from atelier
            inner join activite using (no_atel)
          group by no_atel, intitule
            having count(jour) > 2;
    
    cursor c_activites(p_no_atel atelier.no_atel%type) is 
        select no_atel, jour
          from activite
            left outer join inscription using (no_atel, jour)
          where no_atel = p_no_atel
          group by no_atel, jour
            having count(no_insc) = 0;
    


begin
    
    for v_atel in c_ateliers loop
    
        dbms_output.put_line('L''atelier ' || v_atel.intitule 
                             || ' a plus de 2 activités.');
                             
        for v_activite in c_activites(v_atel.no_atel) loop
             
            dbms_output.put_line('L''activté ' || v_activite.no_atel || v_atel.intitule 
                          || ' du ' || v_activite.jour 
                          || ' sera supprimée car il n''y a pas d''inscrits.'); 
                             
            delete from activite
                where no_atel = v_activite.no_atel
                    and jour = v_activite.jour;
                
        end loop;
    
    end loop;
    
    commit;
end;