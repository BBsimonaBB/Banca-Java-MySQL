CREATE DATABASE IF NOT EXISTS banca;
Use banca;


CREATE TABLE IF NOT EXISTS utilizator(
id int unique auto_increment primary key,
tip int,
 #0 - admin; 1 - angajat; 2-client
nume varchar(20),
prenume varchar(20),
parola varchar(11),
adresa varchar(30),
telefon varchar(10),
email varchar(20),
nr_contract int,
iban varchar(25)
);

CREATE TABLE IF NOT EXISTS angajat(
cnp varchar(10) primary key,
id_angajat int,
norma int,
salariu int,
sucursala varchar(20),
departament varchar(5),
FOREIGN KEY(id_angajat) references utilizator(id)
);

CREATE TABLE IF NOT EXISTS clientt(
cnp varchar(10) primary key,
id_client int,
data_nasterii date ,
sursa_venit varchar(10),
tranzactii_online boolean,
nr_conturi int default 0,
FOREIGN KEY(id_client) references utilizator(id)
);

CREATE TABLE IF NOT EXISTS administrator(
cnp varchar(10) primary key,
id_administrator int,
FOREIGN KEY(id_administrator) references utilizator(id)
);

CREATE TABLE IF NOT EXISTS departamente(
nume varchar(5) primary key,
activ_bancare boolean,
modificare_bd boolean,
activ_utilizator boolean,
id_angajat int,
FOREIGN KEY(id_angajat) references angajat(id_angajat)
);

CREATE TABLE IF NOT EXISTS CONT(
iban varchar(25) primary key,
id_utilizator int,
FOREIGN KEY(id_utilizator) references utilizator(id),
tip int,
sold_curent int default 0,
#0 - economii; 1 - curent pt moment
data_creare date,
data_expirare date
);

CREATE TABLE IF NOT EXISTS depozit(
id int unique auto_increment primary key,
iban varchar(25),
FOREIGN KEY (iban) references CONT(iban),
suma_depozit int,
perioada int,
#1,3,6
dobanda int, #5,10,15
aprobare boolean default 0
);

CREATE TABLE IF NOT EXISTS transfer(
id int unique auto_increment primary key,
statuss enum('CREATED','SUCCESSFUL','ERROR') default 'CREATED',
emitator_iban varchar(25),
receptor_iban varchar(25),
FOREIGN KEY(emitator_iban) references cont(iban),
FOREIGN KEY(receptor_iban) references cont(iban),
suma int,
aprobat boolean default 0,
comision int default 0
#depinde daca e straina banca
);

CREATE TABLE IF NOT EXISTS factura(
cod int primary key,
suma int,
furnizor varchar(10),
platita boolean default 0
);

CREATE TABLE IF NOT EXISTS cont_facturi(
iban varchar(25) primary key,
id_client int,
FOREIGN KEY (id_client) references clientt(id_client),
cod_factura int,
FOREIGN KEY(cod_factura) references factura(cod),
sold_curent int
);

CREATE TABLE IF NOT EXISTS salarii(
cont_sursa varchar(25) primary key,
suma int,
cont_destinatie varchar(25),
FOREIGN KEY (cont_destinatie) references cont(iban)
);

CREATE TABLE IF NOT EXISTS tranzactie(
id int unique auto_increment primary key,
denumire_tranzactie enum('DESCHIDERE_CONT','DESCHIDERE_DEPOZIT','TRANSFER','LICHIDARE_DEPOZIT','LICHIDARE_CONT'),
id_persoana int,
iban varchar(25),
#FOREIGN KEY (iban) references cont(iban),
tip_cont int,
iban_receptor varchar(25),
id_depozit varchar(25),
perioada int,
suma_tranzactionata int,
sold_initial int,
sold_final int
);

CREATE TABLE IF NOT EXISTS conturi_favorite(
id int unique auto_increment primary key,
id_persoana int,
FOREIGN KEY(id_persoana) references clientt(id_client),
iban_favorit varchar(25),
FOREIGN KEY(iban_favorit) references cont(iban)
);

CREATE TABLE IF NOT EXISTS cereri_admin(
id int unique auto_increment primary key,
denumire_cerere enum('SOLICITARE_CARD','LICHIDARE_DEPOZIT'),
iban varchar(25),
FOREIGN KEY (iban) references cont(iban),
id_persoana int,
FOREIGN KEY(id_persoana) references utilizator(id),
raspuns_admin boolean default false,
raspuns_angajat boolean default false
);

CREATE TABLE IF NOT EXISTS cereri_angajat(
id int unique auto_increment primary key,
denumire_cerere enum('SOLICITARE_CARD','DESCHIDERE_DEPOZIT','INITIERE_TRANSFER'),
iban varchar(25),
FOREIGN KEY (iban) references cont(iban),
id_persoana int,
FOREIGN KEY(id_persoana) references utilizator(id),
id_transfer int,
FOREIGN KEY(id_transfer) references transfer(id),
raspuns_angajat boolean default false,
raspuns_admin boolean default false
);
