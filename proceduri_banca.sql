#Deschidere cont
DROP PROCEDURE IF EXISTS deschidere_cont;

DELIMITER //
CREATE PROCEDURE deschidere_cont(iban varchar(25),id_utilizator int, tip int, sumaa int)
BEGIN
	SET @data_acum = now();
    SELECT COUNT(iban) as conturi from cont where id_utilizator = cont.id_utilizator into @nr_conturi;
    IF(@nr_conturi < 5 ) THEN
    INSERT into cont(cont.iban,id_utilizator,tip,sold_curent,data_creare,data_expirare) 
    values (iban,id_utilizator,tip, sumaa,@data_acum, INTERVAL 1 YEAR+ @data_acum);
    SELECT nr_conturi from clientt where id_client = id_utilizator into @numarconturi;
    SET @numarconturi = @numarconturi +1;
    UPDATE clientt
    SET nr_conturi = @numarconturi
    WHERE id_client = id_utilizator;
    
    UPDATE utilizator
    SET utilizator.iban = iban
    where id = id_utilizator;
    
    INSERT into tranzactie(denumire_tranzactie,iban,suma_tranzactionata,sold_initial,sold_final) values('DESCHIDERE_CONT',iban,sumaa,0,sumaa);
    #(SELECT nr_conturi from clientt where id_client = id_utilizator) = (SELECT nr_conturi from clientt where id_client = id_utilizator) + 1;
    END IF;
end //
DELIMITER ;


DROP PROCEDURE IF EXISTS deschidere_depozit;
DELIMITER //
CREATE PROCEDURE deschidere_depozit(ibann varchar(25), perioada int, suma int,raspuns_angajat boolean)
BEGIN
	SELECT id_utilizator from cont where cont.iban = ibann into @id;
	IF(perioada = 1) then SET @dobanda = 5;
    elseif (perioada = 3) then SET @dobanda = 10;
    elseif (perioada = 6) then SET @dobanda = 15;
    end if;
    SET @suma_depozitt = suma*(100+@dobanda)/100;
    INSERT INTO depozit(iban,suma_depozit,perioada,dobanda,aprobare) values(ibann,@suma_depozitt,perioada,@dobanda,raspuns_angajat);
    IF( suma > 500000) THEN
    INSERT INTO cereri_angajat(denumire_cerere,iban,id_persoana) values ('DESCHIDERE_DEPOZIT', ibann, @id);
    ELSE
    UPDATE depozit
    SET aprobare = 1
    where ibann = iban;
    SELECT MAX(id) from depozit into @id_depozitt;
    INSERT INTO tranzactie(denumire_tranzactie,iban,id_depozit,suma_tranzactionata,sold_initial,sold_final) values('DESCHIDERE_DEPOZIT',ibann,@id_depozitt,@suma_depozitt,0,@suma_depozitt);
    END IF;
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS aprobare_depozit;
DELIMITER //
CREATE PROCEDURE aprobare_depozit(id_cerere int, raspuns boolean)
BEGIN
	IF(raspuns = 0) THEN
		DELETE FROM cereri_angajat where id_cerere = id;
     ELSE 
    SELECT id from cereri_angajat where id_cerere = id into @idd;
    SELECT iban from depozit where id_cerere = @idd into @ibann;
	SELECT suma_depozit from depozit where @ibann = depozit.iban and id_cerere = @idd into @suma_depozitt;
    SELECT perioada from depozit where depozit.iban = @ibann and id_cerere = @idd into @perioadaa;
    SELECT dobanda from depozit where depozit.iban = @ibann and id_cerere = @idd into @dobandaa;
    SET @suma_depozitt = @suma_depozitt*(100+@dobandaa)/100;
    INSERT INTO depozit(iban,suma_depozit,perioada,dobanda,aprobare) values (@ibann,@suma_depozitt,@perioadaa,@dobandaa,1);
    SELECT MAX(id) from depozit into @id_depozitt;
    INSERT INTO tranzactie(denumire_tranzactie,iban,id_depozit,perioada,sold_initial) 
    values('DESCHIDERE_DEPOZIT',ibann,@id_depozitt,@perioadaa,@suma_depozitt);
    
    DELETE FROM cereri_angajat WHERE id_cerere = id;
    END IF;
    
    DELETE FROM depozit where aprobare = 0;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS lichidare_cont;
DELIMITER //      
CREATE PROCEDURE lichidare_cont(iban_lichidat varchar(25))
BEGIN
	SELECT id_utilizator from cont where cont.iban = iban_lichidat into @id_proprietar;
    SELECT nr_conturi from clientt where id_client = @id_proprietar into @numarconturi;
    SELECT sold_curent from cont where iban = iban_lichidat into @suma;
    SELECT tip from cont where iban = iban_lichidat into @tipp;
    SET @numarconturi = @numarconturi - 1;
    SET SQL_SAFE_UPDATES=0;
    UPDATE clientt
    SET nr_conturi = @numarconturi
    WHERE id_client = @id_proprietar;
    INSERT INTO tranzactie(denumire_tranzactie, id_persoana,iban,tip_cont,sold_initial) values('LICHIDARE_CONT',@id_proprietar,iban_lichidat,@tipp,@suma);
    DELETE from cereri_angajat where cereri_angajat.iban = iban_lichidat;
    DELETE from depozit where iban = iban_lichidat;
    DELETE from transfer where receptor_iban = iban_lichidat;
    DELETE from transfer where emitator_iban = iban_lichidat;
    DELETE from cont where iban = iban_lichidat;
    
    SET SQL_SAFE_UPDATES=1;
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS lichidare_depozit;
DELIMITER //
CREATE PROCEDURE lichidare_depozit(id_depozit_lichidat varchar(25), raspuns_admin boolean)
BEGIN
	SELECT suma_depozit from depozit where id_depozit_lichidat = id into @suma;
    SELECT iban from depozit where id_depozit_lichidat = id into @ibann;
    SELECT id_utilizator from cont where iban = @ibann into @id;
    SELECT perioada from depozit where id_depozit_lichidat = id into @perioadaa;
    IF(@suma > 500000) THEN
    INSERT INTO cereri_admin(denumire_cerere,iban,id_persoana) values ('LICHIDARE_DEPOZIT',@ibann,@id);
    #IF((@suma>500000 and raspuns_admin = 1) or @suma < 500000) THEN
    ELSE
		SET @suma = 98/100 * @suma;
		UPDATE cont
        set sold_curent = sold_curent + @suma
        where iban = @ibann;
        INSERT INTO tranzactie(denumire_tranzactie,id_persoana,iban,id_depozit,perioada,sold_initial)
        values('LICHIDARE_DEPOZIT',@id,@ibann,id_depozit_lichidat,@perioadaa,@suma);
		DELETE from depozit where id_depozit_lichidat = id;
	END IF;
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS aprobare_lichidare;
DELIMITER //
CREATE PROCEDURE aprobare_lichidare(id_cerere int, raspuns boolean)
BEGIN
	#SELECT id from cereri_admin where id_cerere = id into @idd;
    SELECT iban from cereri_admin where id_cerere = id into @ibann;
	SELECT suma_depozit from depozit where @ibann = iban into @suma;
	SELECT id from depozit where @ibann = iban into @id_depozit_lichidat;

    IF(raspuns = 1) then 
		SET @suma = 98/100 * @suma;
		UPDATE cont
        set sold_curent = sold_curent + @suma
        where iban = @ibann;
		DELETE from depozit where @ibann = iban;
        DELETE FROM cereri_admin where id_cerere = id;
    end if;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS cerere_card;
DELIMITER //
CREATE PROCEDURE cerere_card(iban_card varchar(25), id int, raspuns_admin boolean, raspuns_angajat boolean)
BEGIN
    SELECT id_utilizator from cont where iban_card = iban into @id_proprietar;
    IF(id = @id_proprietar) THEN
        INSERT INTO cereri_angajat(denumire_cerere,iban,id_persoana) values('SOLICITARE_CARD',iban_card, @id_proprietar);
        INSERT INTO cereri_admin(denumire_cerere,iban,id_persoana) values('SOLICITARE_CARD',iban_card, @id_proprietar);
    END IF;
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS aprobare_card_angajat;
DELIMITER //
CREATE PROCEDURE aprobare_card_angajat(iban_card varchar(25), id int,raspuns_angajat boolean, raspuns_admin boolean)
BEGIN
	
    if(raspuns_angajat=1) then 
        UPDATE cereri_angajat
        set raspuns_angajat = 1
        WHERE iban_card = iban;
		UPDATE cereri_admin
        set raspuns_angajat = 1
        WHERE iban_card = iban;
	end if;
    if(raspuns_admin=1) then
         UPDATE cereri_angajat
         set raspuns_admin = 1
         WHERE iban_card = iban;
         UPDATE cereri_admin
         set raspuns_admin = 1
         WHERE iban_card = iban;
	end if;
        
    SELECT id_utilizator from cont where iban_card = iban into @id_proprietar;
	SELECT raspuns_angajat from cereri_angajat where iban_card = iban into @raspuns_angajat;
	SELECT raspuns_admin from cereri_angajat where iban_card = iban into @raspuns_admin;
	SELECT raspuns_angajat from cereri_admin where iban_card = iban into @raspuns_angajat1;
	SELECT raspuns_admin from cereri_admin where iban_card = iban into @raspuns_admin1;
        
    IF(id = @id_proprietar and ((@raspuns_admin= 1 and @raspuns_angajat=1) or (@raspuns_admin1= 1 and @raspuns_angajat1=1))) THEN
        INSERT INTO card(iban) VALUES (iban_card);
		DELETE FROM cereri_angajat where iban_card = iban;
        DELETE FROM cereri_admin where iban_card = iban;
    END IF;
    DELETE FROM cereri_angajat WHERE iban_card = iban;
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS aprobare_card_admin;
DELIMITER //
CREATE PROCEDURE aprobare_card_admin(iban_card varchar(25), id int,raspuns_angajat boolean, raspuns_admin boolean)
BEGIN
    if(raspuns_angajat=1) then 
        UPDATE cereri_angajat
        set raspuns_angajat = 1
        WHERE iban_card = iban;
		UPDATE cereri_admin
        set raspuns_angajat = 1
        WHERE iban_card = iban;
	end if;
    if(raspuns_admin=1) then
         UPDATE cereri_angajat
         set raspuns_admin = 1
         WHERE iban_card = iban;
         UPDATE cereri_admin
         set raspuns_admin = 1
         WHERE iban_card = iban;
	end if;
    SELECT id_utilizator from cont where iban_card = iban into @id_proprietar;
	SELECT raspuns_angajat from cereri_angajat where iban_card = iban into @raspuns_angajat;
	SELECT raspuns_admin from cereri_angajat where iban_card = iban into @raspuns_admin;
	SELECT raspuns_angajat from cereri_admin where iban_card = iban into @raspuns_angajat1;
	SELECT raspuns_admin from cereri_admin where iban_card = iban into @raspuns_admin1;
        
    IF(id = @id_proprietar and ((@raspuns_admin= 1 and @raspuns_angajat=1) or (@raspuns_admin1= 1 and @raspuns_angajat1=1))) THEN
        INSERT INTO card(iban) VALUES (iban_card);
		DELETE FROM cereri_angajat where iban_card = iban;
        DELETE FROM cereri_admin where iban_card = iban;
    END IF;

    DELETE FROM cereri_admin WHERE iban_card = iban;

end //
DELIMITER ;

select * from utilizator;
DROP VIEW IF EXISTS VizualizareConturi;
CREATE VIEW VizualizareConturi AS
SELECT cont.iban as IBAN, utilizator.nume as Nume, utilizator.prenume as Prenume
from cont
INNER JOIN utilizator
on cont.id_utilizator = utilizator.id;
select *from utilizator;
select * from depozit;




#atentie pe aici am ramas cu compilatu...mai jos de atata nu am compilat
select * from CONT_FACTURI;
INSERT INTO `banca`.`factura` (`cod`, `suma`, `furnizor`) VALUES ('123', '200', 'eon');
INSERT INTO `banca`.`factura` (`cod`, `suma`, `furnizor`) VALUES ('124', '400', 'VITAL');
INSERT INTO `banca`.`CONT_FACTURI` (`iban`, `id_client`, `cod_factura`, `sold_curent`) VALUES ('0123', '4', '123', '500');
DROP PROCEDURE IF EXISTS plata_facturi;
DELIMITER //
CREATE PROCEDURE plata_facturi(cod_factura int, iban_factura varchar(25))
BEGIN
	SELECT suma from factura where cod = cod_factura into @plata;
    SELECT sold_curent from cont_facturi where iban_factura = iban into @sold_total;
    if(@sold_total>@plata) THEN
		UPDATE factura
        SET platita = 1
        WHERE cod = cod_factura;
        
		UPDATE cont_facturi
        SET sold_curent = sold_curent - @plata
        WHERE iban_factura = iban;
		SELECT * from factura where cod = cod_factura;
    end if;
end //
DELIMITER ;

DROP PROCEDURE IF EXISTS initiere_transfer;
DELIMITER //
CREATE PROCEDURE initiere_transfer(id_emitator int, iban_emitatorr varchar(25), iban_receptorr varchar(25), sumaa int)
BEGIN
	#SET FOREIGN_KEY_CHECKS=0;
	INSERT INTO transfer(emitator_iban,receptor_iban,suma) values(iban_emitatorr,iban_receptorr,sumaa);
    SELECT id from transfer where emitator_iban = iban_emitatorr and receptor_iban = iban_receptorr and suma = sumaa into @id_transfer;
    SELECT sold_curent from cont where iban = iban_emitatorr into @sold_emitator;
    IF(sumaa >5000 OR sumaa > @sold_emitator) then
    update transfer
    set statuss = 'ERROR'
    WHERE iban_receptorr = receptor_iban and iban_emitatorr = emitator_iban;
    END IF;
    IF(iban_receptorr LIKE '%BT%') then
		UPDATE transfer
        SET comision = 0
        WHERE iban_receptorr = receptor_iban and iban_emitatorr = emitator_iban;
	ELSE 
        UPDATE transfer
        SET comision = 1
        WHERE iban_receptorr = receptor_iban and iban_emitatorr = emitator_iban;
end if;        
    INSERT INTO cereri_angajat(denumire_cerere,iban,id_persoana,id_transfer) values('INITIERE_TRANSFER',iban_emitatorr,id_emitator,@id_transfer);    
    #SET FOREIGN_KEY_CHECKS=1;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS transfer_favorit;
DELIMITER //
CREATE PROCEDURE transfer_favorit(id_emitator int, nume_receptor varchar(20), suma int)
BEGIN
	SELECT iban from utilizator where nume = nume_receptor into @iban_receptor;
    SELECT iban_favorit FROM conturi_favorite where id_emitator = id and @iban_receptor = iban_favorit;
    SELECT iban from cont where id_emitator = id_utilizator into @iban_emitator;
    IF(@iban_repector != NULL ) THEN
		CALL initiere_transfer(id_emitator,@iban_emitator,@iban_receptor,suma);
	END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS aprobare_transfer;
DELIMITER //
CREATE PROCEDURE aprobare_transfer(id_transferr int, raspuns boolean)
BEGIN
	IF(raspuns = 0) THEN
		UPDATE transfer
        SET statuss = 'ERROR'
        WHERE transfer.id = id_transferr;
        
        DELETE FROM cereri_angajat WHERE id_transfer = id_transferr;
	ELSE
		UPDATE transfer
        SET statuss = 'SUCCESSFUL' 
        WHERE transfer.id = id_transferr;
        
        UPDATE transfer
        SET aprobat = 1
        WHERE transfer.id = id_transferr;
        
        SELECT suma from transfer where id_transferr = transfer.id into @suma_totala;
        SELECT receptor_iban from transfer where id_transferr = transfer.id into @receptor;
        SELECT emitator_iban from transfer where id_transferr = transfer.id into @emitator;
        SELECT comision from transfer where id_transferr = id into @comisionn;
		SELECT sold_curent from cont where iban = @emitator into @sold_emitator;
        SELECT sold_curent from cont where iban = @receptor into @sold_receptor;
        
        UPDATE cont
        SET sold_curent = sold_curent - @suma_totala
        WHERE iban = @emitator;
        INSERT INTO tranzactie(denumire_tranzactie,iban,iban_receptor,suma_tranzactionata,sold_initial,sold_final) 
        values('TRANSFER',@emitator,@receptor,@suma_totala,@sold_emitator, @sold_emitator - @suma_totala);
        
        IF(@comisionn != 0) THEN	
			SET @suma_totala = @suma_totala - 1/100*@suma_totala;
        END IF;
        
        
        UPDATE cont
        SET sold_curent = sold_curent + @suma_totala
        WHERE iban = @receptor;
        INSERT INTO tranzactie(denumire_tranzactie,iban,suma_tranzactionata,sold_initial,sold_final) 
        values('TRANSFER',@receptor,@suma_totala,@sold_receptor, @sold_receptor + @suma_totala);
        DELETE FROM cereri_angajat where id_transfer = id_transferr;
	END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS versiune_bd;
DELIMITER //
CREATE PROCEDURE versiune_bd(nr_versiune int)
BEGIN
	SELECT MAX(id) from tranzactie into @x;
	forloop: LOOP
    IF @x <= nr_versiune THEN
    LEAVE forloop;
    END IF;
    SELECT denumire_tranzactie from tranzactie where id = @x into @denumire;
    SELECT iban from tranzactie where id = @x into @ibann;
    SELECT id_depozit from tranzactie where id = @x into @id_depozitt;
    SELECT id_persoana from tranzactie where id = @x into @id_utilizatorr;
    SELECT tip_cont from tranzactie where id = @x into @tipp;
    SELECT sold_initial from tranzactie where id = @x into @sold_curentt;
    SELECT perioada from tranzactie where id = @x into @perioadaa;
    IF(@denumire = 'DESCHIDERE_CONT') THEN
            DELETE FROM cont where iban = @ibann;
	ELSEIF(@denumire = 'DESCHIDERE_DEPOZIT') THEN
            DELETE FROM depozit where id = @id_depozitt;
    ELSEIF(@denumire = 'LICHIDARE_CONT') THEN
            INSERT INTO cont(iban,id_utilizator,tip,sold_curent,data_creare,data_expirare) 
            values (@ibann,@id_utilizatorr,@tipp,@sold_curentt,now(),INTERVAL 1 YEAR + now());
	ELSEIF(@denumire = 'LICHIDARE_DEPOZIT') THEN
			INSERT INTO depozit(id,iban,suma_depozit,perioada,dobanda,aprobare) values(@id_depozitt,@ibann,@sold_curentt,@perioadaa,10,1);
	ELSEIF(@denumire = 'TRANSFER') THEN
			UPDATE cont
            SET sold_curent = @sold_curentt
            WHERE iban = @ibann;
	END IF;
    DELETE FROM tranzactie where id = @x;
	SET @x = @x - 1;
  END LOOP;
END //
DELIMITER ;
call versiune_bd(2);

DROP VIEW IF EXISTS VizualizareTranzactii;
CREATE VIEW VizualizareTranzactii AS
SELECT tranzactie.iban as IBAN, tranzactie.denumire_tranzactie as Denumire, tranzactie.suma_tranzactionata as Suma
from tranzactie;
