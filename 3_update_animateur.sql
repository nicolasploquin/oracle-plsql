set serveroutput on

declare
    -- augmentation du cout heure des animateurs en fonction des règles de
    -- gestion suivantes :
    -- Directeur : taux=1%
    -- Cadre , addition des taux de la façon suivante
    --      si reponsable de plus de 3 animateurs : taux=2% sinon taux=1%
    --      si anime un atelier taux=1% sinon 0%
    -- Agent, si anime 1 atelier taux=2% sinon taux=0%

    cursor c_animateurs is 
        select no_anim, fonction, cout_heure
            from animateur 
        for update of cout_heure nowait;
    
    nb_atel         integer;   -- nombre d'ateliers animés
    nb_anim         integer;   -- nombre d'agents encadrés
    taux            float;
    cout_heure_aug  animateur.cout_heure%type;
    
    v_no_anim_en_cours  animateur.no_anim%type;

    -- exception personnalisée, déclenchement par raise ...
    mon_exception   exception; 
    
    -- exception code oracle -54
    row_locked      exception; pragma exception_init ( row_locked, -54 ); 
    deadlock        exception; pragma exception_init ( deadlock, -60 ); 


begin

    v_no_anim_en_cours := 0;
    
    for v_anim in c_animateurs loop
    
        v_no_anim_en_cours := v_anim.no_anim;
    
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
            
            -- nb_atel := nb_atelier(v_anim.no_anim);
          
            select count(*) into nb_atel 
                from atelier
                where no_anim = v_anim.no_anim;	
            
            if nb_atel > 0 then
                taux := taux + 0.01;
            end if;
          
        else   -- Agent
        
            -- nb_atel := nb_atelier(v_anim.no_anim);
            select count(*) into nb_atel 
                from atelier
                where no_anim = v_anim.no_anim;
            
            if nb_atel > 0 then
                taux := taux + 0.02;
            end if;
          
        end if;
        
        cout_heure_aug := v_anim.cout_heure * taux;
        update animateur set cout_heure = cout_heure_aug
            where current of c_animateurs;
            
        dbms_output.put (lpad(v_anim.no_anim,2)||' - '||rpad(v_anim.fonction,10)||' - '||taux||' - ');
        dbms_output.put_line (nb_atel||' - '||nb_anim||' - '||v_anim.cout_heure||' - '||cout_heure_aug);
        
    end loop;
--    commit;
    
exception
    when no_data_found then
        dbms_output.put_line('Données non trouvées');
    when too_many_rows then
        dbms_output.put_line('Doublons trouvés');
    when mon_exception then
        dbms_output.put_line('Mon exception');
    when row_locked then
        dbms_output.put_line('verrou ligne pour update (' || v_no_anim_en_cours || ')');
        
        
    when deadlock then
        dbms_output.put_line('verrou table');
    
    
end;