CREATE OR REPLACE FUNCTION DECODE_JOUR 
(
  JOUR IN VARCHAR2 
) RETURN VARCHAR2 AS 

    v_jour VARCHAR2(30);

BEGIN
    select decode(jour, 'LU', 'Lundi', 'MA', 'Mardi', 'ME', 'Mercredi', 'JE', 'Jeudi', 'VE', 'Vendredi', 'SA', 'Samedi', 'DI', 'Dimanche')
        into v_jour
        from dual;
  RETURN v_jour;
END DECODE_JOUR;