set serveroutput on

declare
/*
    type t_atelier is record (
        no_atel     atelier.no_atel%type, 
        intitule    atelier.intitule%type
    );
*/

    v_nom_anim  animateur.nom%type := 'BUCHER';
    v_no_anim   animateur.no_anim%type;

    v_atelier   atelier%rowtype;
--    v_atelier   t_ateliers;

begin
    
    select no_anim into v_no_anim
        from animateur
        where nom = v_nom_anim;

    select c_no.nextval into v_atelier.no_atel from dual;
    v_atelier.no_atel := c_no.nextval; -- oracle11g

    v_atelier.intitule := 'GOLF';
    v_atelier.genre := 'SPORT';
    v_atelier.vente_heure := 12;
    
    v_atelier.no_anim := v_no_anim;

    insert into atelier values v_atelier;
    commit;
    
-- exception

--    rollback;

end;