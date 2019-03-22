--create sequence c_id
--  start with 200;

-- Auto-Incr�ment  
create or replace trigger ai_atelier
  before insert 
  on atelier for each row
  when (new.no_atel is null)
begin
  select c_id.nextval into :new.no_atel from dual;
  dbms_output.put_line('Cl� autoincr�ment� : ' || :new.no_atel);
end;

create or replace trigger primary_ai
  after create on schema
begin
  dbms_output.put_line('create ' || ora_dict_obj_type || ' ' || ora_dict_obj_name);  
  if ora_dict_obj_type = 'TABLE' then
 
  end if;
end;
  





-- Atelier 3.1
create or replace trigger animateur_atelier
  before insert or update of no_atel
  on inscription for each row
declare
  v_no_anim Animateur.no_anim%type;
  v_intitule Animateur.no_anim%type;
begin
  select no_anim, intitule into v_no_anim, v_intitule
    from atelier
    where no_atel = :new.no_atel;

  if v_no_anim is null then
    dbms_output.put_line('L''atelier ' || v_intitule || ' n''a pas d''animateur d�sign�');
  else
    dbms_output.put_line('L''atelier ' || v_intitule || ' est anim� par ' || v_no_anim);
  end if;
  
end;

-- Atelier 3.2
create or replace trigger animateur_atelier
  before insert or update of no_atel
  on inscription for each row
declare
  v_no_anim Animateur.no_anim%type;
  v_intitule Animateur.no_anim%type;
begin
  select no_anim, intitule into v_no_anim, v_intitule
    from atelier
    where no_atel = :new.no_atel;

  if v_no_anim is null then
    dbms_output.put_line('L''atelier ' || v_intitule || ' n''a pas d''animateur d�sign�');
  end if;
  
end;






















