#triggers pt insert utilizatori
DELIMITER // 
CREATE TRIGGER autentificare
AFTER INSERT
ON utilizator
FOR EACH ROW BEGIN
IF((SELECT tip from utilizator where id = new.id) = 0) THEN
INSERT INTO administrator(id_administrator,cnp) 
			VALUES(new.id,new.id);
ELSEIF((SELECT tip from utilizator where id = new.id) = 1) THEN
INSERT INTO angajat(id_angajat,cnp) VALUES (new.id,new.id);
ELSEIF((SELECT tip from utilizator where id = new.id) = 2) THEN
INSERT INTO clientt(id_client,cnp) VALUES (new.id,new.id);
END IF;
END //
DELIMITER ;



insert into utilizator (tip,nume,prenume,parola,adresa,telefon,email,nr_contract)
values(0,'Apostol','Alin','Alin', 'Bucuresti', '021367', 'alin_ap@gmail.com',34),
	(1,'Pop','Ion', 'Ion','Brasov','0265333','pop_ion@gmail.com',15),
    (1,'Rad', 'Paul','Paul','Cluj','0264321','rad_paul@gmail.com',17),
    (2,'Rus','Ana','Ana','Floresti','0264123','rus_ana@gmail.com',22),
    (2,'Luca','Maria','Maria','Constanta','0344567','luca_maria@gmail.com',8),
    (2,'Duma','Eva','Eva','Slatina','0343222','duma_eva@gmail.com',23);
    
UPDATE `banca`.`angajat` SET `norma` = '6', `salariu` = '3000', `sucursala` = 'Floresti', `departament` = 'Func' WHERE (`cnp` = '2');
UPDATE `banca`.`angajat` SET `norma` = '8', `salariu` = '4000', `sucursala` = 'BunaZiua', `departament` = 'IT' WHERE (`cnp` = '3');
UPDATE `banca`.`clientt` SET `data_nasterii` = '1978-05-05', `sursa_venit` = 'Salariu', `tranzactii_online` = '0' WHERE (`cnp` = '4');
UPDATE `banca`.`clientt` SET `data_nasterii` = '1960-01-04', `sursa_venit` = 'Pensie', `tranzactii_online` = '1' WHERE (`cnp` = '5');
UPDATE `banca`.`clientt` SET `data_nasterii` = '1995-09-03', `sursa_venit` = 'Antr', `tranzactii_online` = '1' WHERE (`cnp` = '6');

select *from tranzactie;
select * from transfer;
select * from conturi_favorite;
select * from clientt;
select * from utilizator;
select * from cont;
SELECT * from angajat;
select * from depozit;
select * from cereri_angajat;
select * from card;
select * from tranzactie;
select * from factura;
select * from conturi_favorite;
select * from factura;
