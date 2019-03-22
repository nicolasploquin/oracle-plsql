select count(no_atel) into nb_atel
	from atelier
	where no_anim = ?

create or replace function nb_atelier 
		(p_no_anim Animateur.no_anim%type) 
		return integer 
is
	nombre integer;
begin
	
	select count(no_atel) into nombre
		from atelier
		where no_anim = p_no_anim;
	
	return nombre;

end;

select nb_atelier(6) from dual;

select nb_atelier(no_anim) 
	from animateur;







set serveroutput on;

declare

    date_erreur exception;
    pragma exception_init(date_erreur,-20001);

begin
    
    dbms_output.put_line('Atelier 4');
    dbms_output.put_line(years_between(to_date('1997-05-22','YYYY-MM-DD'),sysdate));
    
    -- insert into v_anim (nom, prenom, intitule, genre)
    --     values ('Ainslie', 'Ben', 'Voile', 'Sport');
  
    exception
        when date_erreur then 
            dbms_output.put_line('Erreur date');
            dbms_output.put_line(sqlcode);
            dbms_output.put_line(sqlerrm);
  
  
end;
