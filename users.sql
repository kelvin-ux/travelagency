--ROLA U¯YTKOWNIK
CREATE ROLE Regularny_Uzytkownik;
GRANT SELECT ON OfertyWakacyjne_tab TO Regularny_Uzytkownik;
GRANT INSERT ON Rezerwacje_tab TO Regularny_Uzytkownik;
GRANT INSERT ON OcenyHoteli_tab TO Regularny_Uzytkownik;
GRANT SELECT ON Hotele_tab TO Regularny_Uzytkownik;
GRANT SELECT ON Kategorie_tab TO Regularny_Uzytkownik;
GRANT SELECT ON Promocje_tab TO Regularny_Uzytkownik;
GRANT EXECUTE ON Adresy_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Ocena_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Hotel_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Uzytkownik_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON OcenaHoteli_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Atrakcja_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON ListaAtrakcje_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Kategorie_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON OfertyWakacyjne_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Promotions_typ TO Regularny_Uzytkownik;
GRANT EXECUTE ON Rezerwacja_typ TO Regularny_Uzytkownik;
--ROLA KLIENT
CREATE ROLE Klient;
GRANT INSERT, UPDATE ON OfertyWakacyjne_tab TO Klient;
GRANT INSERT, UPDATE ON Promocje_tab TO Klient;
GRANT SELECT ON OfertyWakacyjne_tab TO Klient;
GRANT SELECT ON Promocje_tab TO Klient;
GRANT EXECUTE ON Adresy_typ TO Klient;
GRANT EXECUTE ON Ocena_typ TO Klient;
GRANT EXECUTE ON Hotel_typ TO Klient;
GRANT EXECUTE ON Uzytkownik_typ TO Klient;
GRANT EXECUTE ON OcenaHoteli_typ TO Klient;
GRANT EXECUTE ON Atrakcja_typ TO Klient;
GRANT EXECUTE ON ListaAtrakcje_typ TO Klient;
GRANT EXECUTE ON Kategorie_typ TO Klient;
GRANT EXECUTE ON OfertyWakacyjne_typ TO Klient;
GRANT EXECUTE ON Promotions_typ TO Klient;
GRANT EXECUTE ON Rezerwacja_typ TO Klient;
--ROLA ADMIN
CREATE ROLE Administrator;
GRANT ALL PRIVILEGES ON Hotele_tab TO Administrator;
GRANT ALL PRIVILEGES ON OfertyWakacyjne_tab TO Administrator;
GRANT ALL PRIVILEGES ON Promocje_tab TO Administrator;
GRANT ALL PRIVILEGES ON OcenyHoteli_tab TO Administrator;
GRANT ALL PRIVILEGES ON Uzytkownicy_tab TO Administrator;
GRANT ALL PRIVILEGES ON Rezerwacje_tab TO Administrator;
GRANT ALL PRIVILEGES ON Kategorie_tab TO Administrator;
GRANT CREATE USER, ALTER USER, DROP USER TO Administrator;

--USERS 
CREATE USER uzytkownik IDENTIFIED BY haslo;
GRANT Regularny_Uzytkownik TO uzytkownik;
GRANT CREATE SESSION TO uzytkownik;
--CLIENTS
CREATE USER klient1 IDENTIFIED BY haslo;
GRANT Klient TO klient1;
GRANT CREATE SESSION TO klient1;
--ADMIN
CREATE USER admin IDENTIFIED BY haslo;
GRANT Administrator TO admin;
GRANT CREATE SESSION TO admin;