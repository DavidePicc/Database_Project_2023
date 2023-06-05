-- Eliminazione tabelle se già esistenti
DROP TABLE IF EXISTS LikeCommenti CASCADE;
DROP TABLE IF EXISTS LikeVideo CASCADE;
DROP TABLE IF EXISTS SegnalazioniVideo CASCADE;
DROP TABLE IF EXISTS SegnalazioniCommenti CASCADE;
DROP TABLE IF EXISTS SavedPlaylist CASCADE;
DROP TABLE IF EXISTS Commenti CASCADE;
DROP TABLE IF EXISTS Playlist CASCADE;
DROP TABLE IF EXISTS Abbonamenti CASCADE;
DROP TABLE IF EXISTS Views CASCADE;
DROP TABLE IF EXISTS Video CASCADE;
DROP TABLE IF EXISTS Account CASCADE;


-- Creazione tipi
DROP TYPE IF EXISTS Gender;
DROP TYPE IF EXISTS Stato;
DROP TYPE IF EXISTS Visibilita;
DROP TYPE IF EXISTS Abbonamento;
DROP TYPE IF EXISTS Likes;
DROP TYPE IF EXISTS Categorie;
DROP TYPE IF EXISTS Motivo;

CREATE TYPE Gender AS ENUM('M', 'F', '/');
CREATE TYPE Stato AS ENUM('Attivo', 'Sospeso', 'Eliminato');
CREATE TYPE Visibilita AS ENUM('Pubblico', 'Privato', 'Non in elenco');
CREATE TYPE Abbonamento AS ENUM('Gratis', '1.99', '4.99', '9.99', '14.99', '19.99', '24.99');
CREATE TYPE Likes AS ENUM('-1', '1');
CREATE TYPE Categorie AS ENUM (
  'Animali',
  'Auto e motori',
  'Fai da te e stile',
  'Film e animazione',
  'Giochi',
  'Intrattenimento',
  'Istruzione',
  'Musica',
  'Non profit e attivismo',
  'Notizie e politica',
  'Persone e blog',
  'Scienze e tecnologie',
  'Sport',
  'Umorismo',
  'Viaggi ed eventi'
);
CREATE TYPE Motivo AS ENUM (
  'Contenuti di natura sessuale',
  'Contenuti violenti o ripugnanti',
  'Contenuti offensivi',
  'Molestie o bullismo',
  'Azioni dannose o pericolose',
  'Disinformazione',
  'Abusi su minori',
  'Promuove il terrorismo',
  'Spam o ingannevole',
  'Non rispetta i miei diritti',
  'Problema con i sottotitoli',
  'Nessuna di queste opzioni descrive il mio problema',
  'Violazione del copyright'
);



--Entità 1 Account
CREATE TABLE IF NOT EXISTS Account(
	id_Account SERIAL, 					--Codice numerico univoco tipo matricola
	handle varchar(256) NOT NULL UNIQUE,--Nome unico per ogni utente, modificabile dall'utente
	mail varchar(256) NOT NULL UNIQUE,
	password varchar(256)NOT NULL,		--perche verra criptata
	dataIscrizione date NOT NULL,
	imgProfilo varchar(256), 			--Link all'immagine
	nome_Utente varchar(256) NOT NULL,
	cognome_Utente varchar(256) NOT NULL,
	compleanno date,
	genere Gender NOT NULL,
	paese varchar(256) NOT NULL,
	StatoAccount Stato NOT NULL,
	descrizione varchar(1000),
	premium boolean NOT NULL,			--Abbonamento YT premium(evita che un utente riceva le ads

	PRIMARY KEY(id_Account)
);



--Entità 2 video / live
CREATE TABLE IF NOT EXISTS Video(
	id_Video SERIAL, 					-- ID unico per ogni video: tipo una matricola
	titolo varchar(256) NOT NULL,
	descrizione varchar(500),
	dataPubblicazione timestamp NOT NULL,-- La data di pubblicazione corrisponde anche alla data di inizio per le live
	durata INT NOT NULL,	--live non ha durata che si aggiorna in tempo reale
	costo float, 						-- Costo: se 0=NULL se >0 = costo
	categoria Categorie,
	visibilita Visibilita DEFAULT 'Pubblico',
	stato Stato NOT NULL,
	id_Account INT NOT NULL,
	isLive boolean, 					-- Se 0=video, sennò live -> che poi verrà pubblicata come video
	dataFine timestamp, 				-- Nel caso fosse una live questa è la data in cui finisce
	thumbnail varchar(256),

	PRIMARY KEY(id_Video),
	FOREIGN KEY(id_Account) REFERENCES Account(id_Account) ON UPDATE CASCADE ON DELETE CASCADE, --Perchè se elimino un canale -> elimino tutti i video | Se modifico id_Account -> modifico anche il valore in tutti i suoi video
	CHECK((dataFine IS NULL AND isLive=false)OR(dataFine IS NULL AND isLive=true)OR(dataPubblicazione IS NOT NULL AND dataFine IS NOT NULL AND dataPubblicazione<dataFine AND isLive=false))
);--Ricordarsi di scrivere nella documentazione come creare URL account e video -> htpps://.../ID
--per le live serve numero di spettatori?(no è una cosa gestita non con con la base di dati)



--Entità 3 iscrizioni / abbonamento
CREATE TABLE IF NOT EXISTS Abbonamenti(
	canale INT, 					-- Canale a cui ci si abbona
	iscritto INT,					-- Canale di colui che si abbona
	livello Abbonamento NOT NULL, 	-- Se abbonamento = 'Gratis' -> solo iscrizione
	dataIscrizione timestamp NOT NULL,
	
	PRIMARY KEY(canale, iscritto),
	FOREIGN KEY(canale) REFERENCES Account(id_Account) ON UPDATE CASCADE ON DELETE CASCADE, -- Se viene modificato o eliminato un canale, verranno modificate/eliminate anche tutte le tuple contenenti i suoi iscritti
	FOREIGN KEY(iscritto) REFERENCES Account(id_Account) ON UPDATE CASCADE ON DELETE CASCADE,-- Se viene modificato o eliminato un canale, verranno modificate/eliminate anche tutte le tuple contenenti le sue iscrizioni
	check(iscritto<>canale) --controlla che uno non si inscriva a se stesso)
);



--Entità 4 Views
CREATE TABLE IF NOT EXISTS Views(
	account INT NOT NULL, 			-- Chi guarda
	id_Video INT NOT NULL,			-- Cosa guarda
	dataView timestamp NOT NULL,	-- Quando è avvenuta la visualizzazione

	PRIMARY KEY(account, id_Video),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE,-- Se elimino/modifico un canale -> elimino/modifico i suoi video -> elimino/modifico tutte le sue views
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON DELETE CASCADE ON UPDATE CASCADE	-- Se elimino/modifico un video -> elimino/modifico tutte le relative views
);



--Entità 5 Playlist
CREATE TABLE IF NOT EXISTS Playlist(
	id_Playlist SERIAL,
	account INT NOT NULL, 	--Creatore playlist
	id_Video INT NOT NULL,
	titolo varchar(256) DEFAULT 'Guarda più tardi', --Perché di default un account YT ha almeno questa playlist
	descrizione varchar(500),
	visibilita Visibilita DEFAULT 'Privato',

	PRIMARY KEY(id_Playlist),
	UNIQUE(titolo, account),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE, -- Se elimino/modifico un account -> elimino/modifico tutte le relative playlist,
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON DELETE CASCADE ON UPDATE CASCADE	 -- Se elimino/modifico un video -> lo elimino/modifico da tutte le relative playlist
);



--Entità 6 salvare playlist
CREATE TABLE IF NOT EXISTS SavedPlaylist( -- Salvare playlist private ?
	account INT NOT NULL,
	id_Playlist INT NOT NULL,

	PRIMARY KEY(account, id_Playlist),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE,		-- Se elimino/modifico un account -> elimino/modifico tutte le relative playlist salvate
	FOREIGN KEY(id_Playlist) REFERENCES Playlist(id_Playlist) ON DELETE CASCADE ON UPDATE CASCADE	-- Se elimino/modifico una playlist -> la elimino/modifico da tutti gli account che l'hanno salvata
);



--Entità 7 commento(che include la sottoclasse donazione)
CREATE TABLE IF NOT EXISTS Commenti(
	id_Commento SERIAL, 		--Codice univoco per ogni commento, utilizzato per le risposte ai commenti
	account INT NOT NULL, 		--Chi commenta
	id_Video INT NOT NULL, 		--Cosa commenta
	messaggio varchar(500) NOT NULL, 
	donazione float, 			--Campo per donazioni
	dataCommento timestamp NOT NULL,
	id_Risposta INT, 			-- Eventuale risposta ad un'altro commento

	PRIMARY KEY(id_Commento),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE,		-- Se elimino/modifico un account -> elimino/modifico tutti i relativi video -> elimino/modifico tutti i relativi commenti
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON DELETE CASCADE ON UPDATE CASCADE,			-- Se elimino/modifico un video -> elimino/modifico tutti i relativi commenti
	FOREIGN KEY(id_Risposta) REFERENCES Commenti(id_Commento) ON DELETE CASCADE ON UPDATE CASCADE,	-- Se elimino/modifico un commento padre -> elimino/modifico tutti i relativi commenti figli
	check(donazione>=0)
);



--Entità 8 segnalazioni dei video
CREATE TABLE IF NOT EXISTS SegnalazioniVideo(
	id_Segnalazione SERIAL, --Codice univoco per ogni segnalazione
	account INT NOT NULL, 	--Chi segnala
	id_Video INT NOT NULL, 	--Video segnalato
	motivo Motivo,
	descrizione varchar(50),
	data timestamp NOT NULL,
	
	PRIMARY KEY(id_Segnalazione),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON UPDATE CASCADE ON DELETE CASCADE,	-- Se elimino/modifico un account -> elimino/modifico tutti i relativi video -> elimino/modifico tutte le relative segnalazioni ai video
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON UPDATE CASCADE ON DELETE CASCADE		-- Se elimino/modifico un video -> elimino/modifico tutte le relative segnalazioni ai video
);



--Entità 9 segnalazioni dei commenti
CREATE TABLE IF NOT EXISTS SegnalazioniCommenti(
	id_Segnalazione SERIAL, 	--Codice univoco per ogni segnalazione
	account INT NOT NULL, 		--chi segnala
	id_Commento INT NOT NULL, 	--commento segnalato
	motivo Motivo,
	data timestamp NOT NULL,
	
	PRIMARY KEY(id_Segnalazione),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE,		-- Se elimino/modifico un account -> elimino/modifico tutti i relativi video -> elimino/modifico tutte le relative segnalazioni ai commenti
	FOREIGN KEY(id_Commento) REFERENCES Commenti(id_Commento) ON DELETE CASCADE ON UPDATE CASCADE	-- Se elimino/modifico un video -> elimino/modifico tutte le relative segnalazioni ai commenti
);



--Entità 10 Like ai video
CREATE TABLE IF NOT EXISTS LikeVideo(
	id_Like SERIAL,
	account INT NOT NULL, 
	id_Video INT NOT NULL, 
	data timestamp NOT NULL,
	valutation Likes NOT NULL, 	-- -1=dislike  1=like
	
	PRIMARY KEY(id_Like),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON UPDATE CASCADE ON DELETE CASCADE,	-- Se elimino/modifico un account -> elimino/modifico tutti i relativi video -> elimino/modifico tutti i relativi like al video
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON UPDATE CASCADE ON DELETE CASCADE		-- Se elimino/modifico un video -> elimino/modifico tutti i relativi like al video
);



--Entità 11 Like ai commenti
CREATE TABLE IF NOT EXISTS LikeCommenti(
	id_Like SERIAL,
	account INT NOT NULL, 
	id_Commento INT NOT NULL, 
	data timestamp NOT NULL,
	valutation Likes NOT NULL, 	-- -1=dislike  1=like
	
	PRIMARY KEY(id_Like),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE,		-- Se elimino/modifico un account -> elimino/modifico tutti i relativi video -> elimino/modifico tutti i relativi commenti al video
	FOREIGN KEY(id_Commento) REFERENCES Commenti(id_Commento) ON DELETE CASCADE ON UPDATE CASCADE	-- Se elimino/modifico un video -> elimino/modifico tutti i relativi commenti al video
);
