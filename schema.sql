CREATE SCHEMA IF NOT EXISTS public;

COMMENT ON SCHEMA public IS 'standard public schema';

-- DROP SEQUENCE public.dostawcy_dostawcaid_seq;

CREATE SEQUENCE public.dostawcy_dostawcaid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.dostawy_dostawaid_seq;

CREATE SEQUENCE public.dostawy_dostawaid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.kategorieproduktow_kategoriaid_seq;

CREATE SEQUENCE public.kategorieproduktow_kategoriaid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.klienci_klientid_seq;

CREATE SEQUENCE public.klienci_klientid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.listapromocji_promocjaid_seq;

CREATE SEQUENCE public.listapromocji_promocjaid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.platnosci_platnoscid_seq;

CREATE SEQUENCE public.platnosci_platnoscid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.pracownicy_pracownikid_seq;

CREATE SEQUENCE public.pracownicy_pracownikid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.produkty_produktid_seq;

CREATE SEQUENCE public.produkty_produktid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.promocje_promocjaid_seq;

CREATE SEQUENCE public.promocje_promocjaid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.recepty_receptaid_seq;

CREATE SEQUENCE public.recepty_receptaid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.szczegolyrecepty_szczegolreceptyid_seq;

CREATE SEQUENCE public.szczegolyrecepty_szczegolreceptyid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.zamowienia_zamowienieid_seq;

CREATE SEQUENCE public.zamowienia_zamowienieid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.dostawcy definition

-- Drop table

-- DROP TABLE public.dostawcy;

CREATE TABLE public.dostawcy (
	dostawcaid serial4 NOT NULL,
	nazwa varchar(100) NOT NULL,
	kontaktemail varchar(100) NULL,
	kontakttelefon varchar(15) NULL,
	adres text NULL,
	CONSTRAINT dostawcy_pkey PRIMARY KEY (dostawcaid)
);


-- public.kategorieproduktow definition

-- Drop table

-- DROP TABLE public.kategorieproduktow;

CREATE TABLE public.kategorieproduktow (
	kategoriaid serial4 NOT NULL,
	nazwa varchar(100) NOT NULL,
	opis text NULL,
	CONSTRAINT kategorieproduktow_pkey PRIMARY KEY (kategoriaid)
);


-- public.klienci definition

-- Drop table

-- DROP TABLE public.klienci;

CREATE TABLE public.klienci (
	klientid serial4 NOT NULL,
	imie varchar(50) NOT NULL,
	nazwisko varchar(50) NOT NULL,
	email varchar(100) NULL,
	telefon varchar(15) NULL,
	adres text NULL,
	CONSTRAINT klienci_pkey PRIMARY KEY (klientid)
);
CREATE INDEX indeks_imienia ON public.klienci USING btree (imie);


-- public.listapromocji definition

-- Drop table

-- DROP TABLE public.listapromocji;

CREATE TABLE public.listapromocji (
	promocjaid serial4 NOT NULL,
	produktid int4 NOT NULL,
	opispromocji text NULL,
	rabat numeric(5, 2) NOT NULL,
	CONSTRAINT listapromocji_pkey PRIMARY KEY (promocjaid)
);


-- public.pracownicy definition

-- Drop table

-- DROP TABLE public.pracownicy;

CREATE TABLE public.pracownicy (
	pracownikid serial4 NOT NULL,
	imie varchar(50) NOT NULL,
	nazwisko varchar(50) NOT NULL,
	stanowisko varchar(50) NOT NULL,
	datazatrudnienia date NOT NULL,
	email varchar(100) NULL,
	telefon varchar(15) NULL,
	CONSTRAINT pracownicy_pkey PRIMARY KEY (pracownikid)
);


-- public.promocje definition

-- Drop table

-- DROP TABLE public.promocje;

CREATE TABLE public.promocje (
	promocjaid serial4 NOT NULL,
	produktid int4 NOT NULL,
	nazwa varchar(100) NOT NULL,
	opis text NULL,
	rabat numeric(5, 2) NOT NULL,
	datarozpoczecia date NOT NULL,
	datazakonczenia date NOT NULL,
	CONSTRAINT promocje_pkey PRIMARY KEY (promocjaid),
	CONSTRAINT unique_produkt_id UNIQUE (produktid)
);


-- public.dostawy definition

-- Drop table

-- DROP TABLE public.dostawy;

CREATE TABLE public.dostawy (
	dostawaid serial4 NOT NULL,
	dostawcaid int4 NOT NULL,
	datadostawy date DEFAULT CURRENT_DATE NOT NULL,
	iloscproduktow int4 NOT NULL,
	status text DEFAULT 'Oczekuje'::text NOT NULL,
	CONSTRAINT dostawy_pkey PRIMARY KEY (dostawaid),
	CONSTRAINT dostawy_status_check CHECK ((status = ANY (ARRAY['Oczekuje'::text, 'W trakcie'::text, 'Zrealizowana'::text, 'Anulowana'::text]))),
	CONSTRAINT dostawy_dostawcaid_fkey FOREIGN KEY (dostawcaid) REFERENCES public.dostawcy(dostawcaid)
);

-- Table Triggers

create trigger po_dodaniu_dostawy after
insert
    on
    public.dostawy for each row execute function aktualizuj_ilosc_produktu();


-- public.produkty definition

-- Drop table

-- DROP TABLE public.produkty;

CREATE TABLE public.produkty (
	produktid serial4 NOT NULL,
	nazwa varchar(100) NOT NULL,
	opis text NULL,
	cena numeric(10, 2) NOT NULL,
	iloscnamagazynie int4 NULL,
	datawaznosci date NULL,
	wymagarecepty bool DEFAULT false NOT NULL,
	dostawcaid int4 NULL,
	CONSTRAINT produkty_pkey PRIMARY KEY (produktid),
	CONSTRAINT produkty_dostawcaid_fkey FOREIGN KEY (dostawcaid) REFERENCES public.dostawcy(dostawcaid)
);
CREATE INDEX indeks_nazwy ON public.produkty USING btree (nazwa);


-- public.recepty definition

-- Drop table

-- DROP TABLE public.recepty;

CREATE TABLE public.recepty (
	receptaid serial4 NOT NULL,
	klientid int4 NOT NULL,
	lekarz varchar(100) NOT NULL,
	datawystawienia date DEFAULT CURRENT_DATE NOT NULL,
	datawaznosci date NOT NULL,
	uwagi text NULL,
	CONSTRAINT recepty_pkey PRIMARY KEY (receptaid),
	CONSTRAINT recepty_klientid_fkey FOREIGN KEY (klientid) REFERENCES public.klienci(klientid) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX indeks_lekarzy ON public.recepty USING btree (lekarz);


-- public.szczegolyrecepty definition

-- Drop table

-- DROP TABLE public.szczegolyrecepty;

CREATE TABLE public.szczegolyrecepty (
	szczegolreceptyid serial4 NOT NULL,
	receptaid int4 NOT NULL,
	produktid int4 NOT NULL,
	ilosc int4 NOT NULL,
	nazwaproduktu varchar(100) NOT NULL,
	wymaganailosc int4 DEFAULT 3 NULL,
	CONSTRAINT szczegolyrecepty_pkey PRIMARY KEY (szczegolreceptyid),
	CONSTRAINT szczegolyrecepty_receptaid_fkey FOREIGN KEY (receptaid) REFERENCES public.recepty(receptaid)
);

-- Table Triggers

create trigger sprawdz_uzupelnienie_szczegolow after
insert
    or
update
    on
    public.szczegolyrecepty for each row execute function ustaw_status_zamowienia_na_zrealizowane();
create trigger sprawdz_date_przy_dodawaniu before
insert
    on
    public.szczegolyrecepty for each row execute function sprawdz_date_waznosci_produktu();


-- public.zamowienia definition

-- Drop table

-- DROP TABLE public.zamowienia;

CREATE TABLE public.zamowienia (
	zamowienieid serial4 NOT NULL,
	klientid int4 NOT NULL,
	receptaid int4 NULL,
	datazamowienia timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	status text DEFAULT 'W trakcie'::text NOT NULL,
	CONSTRAINT zamowienia_pkey PRIMARY KEY (zamowienieid),
	CONSTRAINT zamowienia_status_check CHECK ((status = ANY (ARRAY['Nowe'::text, 'W trakcie'::text, 'Zrealizowane'::text, 'Anulowane'::text]))),
	CONSTRAINT zamowienia_klientid_fkey FOREIGN KEY (klientid) REFERENCES public.klienci(klientid),
	CONSTRAINT zamowienia_receptaid_fkey FOREIGN KEY (receptaid) REFERENCES public.recepty(receptaid)
);


-- public.platnosci definition

-- Drop table

-- DROP TABLE public.platnosci;

CREATE TABLE public.platnosci (
	platnoscid serial4 NOT NULL,
	zamowienieid int4 NOT NULL,
	dataplatnosci timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	kwota numeric(10, 2) NOT NULL,
	metoda text NOT NULL,
	CONSTRAINT platnosci_metoda_check CHECK ((metoda = ANY (ARRAY['Gotówka'::text, 'Karta'::text, 'Przelew'::text, 'BLIK'::text]))),
	CONSTRAINT platnosci_pkey PRIMARY KEY (platnoscid),
	CONSTRAINT platnosci_zamowienieid_fkey FOREIGN KEY (zamowienieid) REFERENCES public.zamowienia(zamowienieid)
);



-- DROP FUNCTION public.aktualizuj_ilosc_produktu();

CREATE OR REPLACE FUNCTION public.aktualizuj_ilosc_produktu()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Aktualizacja ilości produktów w magazynie
    UPDATE Produkty
    SET IloscNaMagazynie = IloscNaMagazynie + NEW.IloscProduktow
    WHERE DostawcaID = NEW.DostawcaID;

    RETURN NEW;
END;
$function$
;

-- DROP PROCEDURE public.dodaj_klienta(varchar, varchar, varchar, varchar, text);

CREATE OR REPLACE PROCEDURE public.dodaj_klienta(IN imie character varying, IN nazwisko character varying, IN email character varying, IN telefon character varying, IN adres text)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    INSERT INTO Klienci (Imie, Nazwisko, Email, Telefon, Adres)
    VALUES (imie, nazwisko, email, telefon, adres);

    RAISE NOTICE 'Klient % % został dodany pomyślnie.', imie, nazwisko;
END;
$procedure$
;

-- DROP PROCEDURE public.monitorujstanmagazynowy();

CREATE OR REPLACE PROCEDURE public.monitorujstanmagazynowy()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    produkt RECORD;
    dostawca_id INT;
BEGIN
    FOR produkt IN 
        SELECT ProduktID, Nazwa, IloscNaMagazynie
        FROM Produkty
        WHERE IloscNaMagazynie < 50
    LOOP
        -- Sprawdzenie, czy Produkt ma przypisanego dostawcę
        SELECT DostawcaID INTO dostawca_id
        FROM Produkty
        WHERE ProduktID = produkt.ProduktID;

        -- Jeśli DostawcaID jest NULL, pomiń ten produkt
        IF dostawca_id IS NOT NULL THEN
            -- Dodanie zapytania o dostawę tylko, jeśli dostawca istnieje
            INSERT INTO Dostawy (DostawcaID, DataDostawy, IloscProduktow, Status)
            VALUES (
                dostawca_id,
                CURRENT_DATE + INTERVAL '2 days',
                100,
                'Oczekuje'
            );

            RAISE NOTICE 'Produkt % ma niski stan magazynowy (% jednostek). Dodano dostawę.', produkt.Nazwa, produkt.IloscNaMagazynie;
        ELSE
            -- Opcjonalnie: RAISE NOTICE lub inne logowanie, jeśli brak dostawcy
            RAISE NOTICE 'Produkt % nie ma przypisanego dostawcy, pomijam...', produkt.Nazwa;
        END IF;
    END LOOP;
END;
$procedure$
;

-- DROP FUNCTION public.sprawdz_date_waznosci();

CREATE OR REPLACE FUNCTION public.sprawdz_date_waznosci()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN

    IF NOT sprawdz_date_waznosci(NEW.ProduktID) THEN
        RAISE EXCEPTION 'Produkt ID % jest przeterminowany i nie można go dodać.', NEW.ProduktID;
    END IF;

    RETURN NEW;
END;
$function$
;

-- DROP FUNCTION public.sprawdz_date_waznosci_produktu();

CREATE OR REPLACE FUNCTION public.sprawdz_date_waznosci_produktu()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Sprawdzenie, czy produkt jest przeterminowany
    IF EXISTS (
        SELECT 1
        FROM Produkty
        WHERE ProduktID = NEW.ProduktID AND DataWaznosci < CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'Produkt ID % jest przeterminowany i nie można go dodać do zamówienia.', NEW.ProduktID;
    END IF;

    RETURN NEW;
END;
$function$
;

-- DROP FUNCTION public.ustaw_status_zamowienia_na_zrealizowane();

CREATE OR REPLACE FUNCTION public.ustaw_status_zamowienia_na_zrealizowane()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    ilosc_szczegolow INT;
    ilosc_zrealizowanych INT;
    ilosc_w_trakcie INT;
BEGIN
    -- Oblicz liczbę szczegółów zamówienia
    SELECT COUNT(*)
    INTO ilosc_szczegolow
    FROM SzczegolyRecepty
    WHERE ReceptaID = NEW.ReceptaID;

    -- Oblicz liczbę szczegółów w pełni zrealizowanych (Ilosc = WymaganaIlosc)
    SELECT COUNT(*)
    INTO ilosc_zrealizowanych
    FROM SzczegolyRecepty
    WHERE ReceptaID = NEW.ReceptaID AND Ilosc = WymaganaIlosc;

    -- Oblicz liczbę szczegółów w trakcie realizacji (Ilosc < WymaganaIlosc)
    SELECT COUNT(*)
    INTO ilosc_w_trakcie
    FROM SzczegolyRecepty
    WHERE ReceptaID = NEW.ReceptaID AND Ilosc < WymaganaIlosc;

    -- Ustaw status na "Zrealizowane", jeśli wszystkie szczegóły zostały zrealizowane
    IF ilosc_zrealizowanych = ilosc_szczegolow THEN
        UPDATE Zamowienia
        SET Status = 'Zrealizowane'
        WHERE ReceptaID = NEW.ReceptaID;

    -- Ustaw status na "W trakcie realizacji", jeśli istnieją szczegóły w trakcie realizacji
    ELSIF ilosc_w_trakcie > 0 THEN
        UPDATE Zamowienia
        SET Status = 'W trakcie'
        WHERE ReceptaID = NEW.ReceptaID;
    END IF;

    RETURN NEW;
END;
$function$
;

-- DROP PROCEDURE public.zaktualizuj_status_zamowienia(int4, varchar);

CREATE OR REPLACE PROCEDURE public.zaktualizuj_status_zamowienia(IN zamowienie_id integer, IN nowy_status character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE Zamowienia
    SET Status = nowy_status
    WHERE ZamowienieID = zamowienie_id;

    RAISE NOTICE 'Status zamówienia ID % został zaktualizowany do: %', zamowienie_id, nowy_status;
END;
$procedure$
;