# Banca

SISTEM BANCAR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
REALIZAT DE: SAND ANDREEA si TIVADAR SIMONA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GRUPA 30223
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Introducere 


Proiectul nostru reprezinta un sistem bancar si sustine activitati pentru 3 tipuri de utilizatori
Client
Angajat
Administrator
in functie de log-in ul ales

----------------------------------------------
* Cerinte / Recommended modules

Pentru accesare si utilizarea optima a proiectului nostru este necesar a avea instalat local
in calculator

	MySQL Workspace - cu Server local
	IntelliJ IDEA Community


---------------------------------------------

* Conectare baza de date - Java

Pentru conectarea bazei de date cu IntelliJ este necesar fisierul 
mysql-connector-java-8.0.22.jar , adaugat ca fisier extern in proiectu java 

Mai mult decat atat, trebuie realizata conectiunea astfel:

Connection connection = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/Banca",
                            "root", "password");


---------------------------------------------

* Instructiuni de utilizare

Odata cu rularea programului din IntelliJ, fereastra de start debuteaza cu LOG IN
Astfel, userul trebuie sa se logheze cu un username si o parola valida
A se observa in baza de data, tabel utilizator....numele si parolele aferente fiecarui tip de utilizator

In functie de utilizatorul logat, meniul de navigare este diferit
Pentru selectarea unei optiuni din meniu, se foloseste JComboBox-ul, 
iar apoi se apasa butonul "NEXT"

Se deschide o fereastra noua, cu anumite detalii/field-uri de completat,
in functie de selectia anterioara din meniu.
Se urmaresc butoanele (Generate, Deschidere cont, Vizualizare, ETC)
Fiecare fereastra se inchide pe X(close) sau atuomat, dupa apasarea butonului care genereaza comanda

Daca se doreste logarea cu un user diferit, se folosese butonul de LOG-OUT
Aplicatia debuteza din nou cu aceeasi fereastra de start/log-in


----------------------------------------------


SFARSIT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


