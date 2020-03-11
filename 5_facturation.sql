drop table Facture_Detail;
drop table Facture;

create table Facture (
    no_fact number(6) primary key,
    no_adher number(6),
    date date,
    montant number(8,2)
)
create table Facture_Detail (
    no_fact number(6),
    no_insc number(6),
    no_atel number(6),
    jour char(2),
    duree number(2),
    montant number(8,2)
)

create procedure facturation (
    p_no_adher number(6),
    p_date date
) as
    cursor c_activites as
        select no_insc, no_atel, jour, duree, cout_heure
            from inscription 
                inner join activite using (no_atel,jour)
                inner join atelier using (no_atel)
            where no_adher = p_no_adher
                and date_inscription < p_date
    ;

    v_montant_facture facture.montant%type := 0;
    v_montant_detail facture_detail.montant%type;
    v_no_facture facture.no_fact%type;
begin
    select max(no_fact) + 1 into v_no_facture from facture;

    for v_activite in c_activites loop
        v_montant_detail := v_activite.duree * v_activite.coute_heure;
        
        insert into facture_detail (no_fact, no_insc, no_atel, jour, duree, montant)
            values (v_no_facture, v_activite.no_insc, v_activite.no_atel, v_activite.jour, v_activite.duree, v_montant_detail)

    end loop;


end;
/