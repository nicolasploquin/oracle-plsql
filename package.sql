create or replace package eni as

  function years_between (date_1 in date, date_2 in date)
    return integer;


end eni;


create or replace package body eni as

  function years_between (date_1 in date, date_2 in date)
    return integer is
  begin
    if date_1 > date_2 then 
      raise_application_error(-20001, 'La première date doit précéder la deuxième.');
    end if;
    return floor(months_between(date_2,date_1)/12);
  end;

end eni;
