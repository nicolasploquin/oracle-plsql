create or replace function years_between (date1 in date, date2 in date) 
  return decimal
  is
    erreur varchar2(100);
  begin
    if date1 < date2 then
      erreur := 'La première date doit être postérieure à la deuxième date.';
      raise_application_error(-20001, erreur);
    end if;
    return months_between(date1,date2)/12;
  end;
