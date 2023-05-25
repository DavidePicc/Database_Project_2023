-- Eliminazione tabelle se già esistenti
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Video;
DROP TABLE IF EXISTS Abbonamenti;
DROP TABLE IF EXISTS Views;
DROP TABLE IF EXISTS Playlist;
DROP TABLE IF EXISTS Commenti;
DROP TABLE IF EXISTS SavedPlaylist;
DROP TABLE IF EXISTS SegnalazioniVideo;
DROP TABLE IF EXISTS SegnalazioniCommenti;
DROP TABLE IF EXISTS LikeVideo;
DROP TABLE IF EXISTS LikeCommenti;



-- Creazione tipi
CREATE TYPE Gender AS ENUM('M', 'F', '/');
CREATE TYPE Stato AS ENUM('Attivo', 'Sospeso', 'Eliminato');
CREATE TYPE Visibilita AS ENUM('Pubblico', 'Privato', 'Non in elenco');
CREATE TYPE Abbonamento AS ENUM('Gratis', '1.99', '4.99', '9.99', '14.99', '19.99', '24.99');
CREATE TYPE Like AS ENUM(-1, 1);
CREATE TYPE Categorie AS ENUM('Animali', 'Auto e motori', 'Fai da te e stile', 'Film e animazione', 'Giochi', 'Intrattenimento', 'Istruzione', 'Musica', 'Non profit e attivismo', 'Notizie e politica', 'Persone e blog', 'Scienze e tecnologie', 'Sport', 'Umorismo', 'Viaggi ed eventi')
CREATE TYPE Motivo AS ENUM (
  'Contenuti di natura sessuale',
  'Contenuti violenti o ripugnanti',
  'Contenuti offensivi o che incitano all''odio',
  'Molestie o bullismo',
  'Azioni dannose o pericolose',
  'Disinformazione',
  'Abusi su minori',
  'Promuove il terrorismo',
  'Spam o ingannevole',
  'Non rispetta i miei diritti',
  'Problema con i sottotitoli',
  'Nessuna di queste opzioni descrive il mio problema'
);



--Entità 1 Account
CREATE TABLE IF NOT EXISTS Account(
	id_Account INT UNSIGNED AUTO_INCREMENT, --Codice numerico univoco tipo matricola
	handle varchar(256) NOT NULL UNIQUE, --Nome unico per ogni utente, modificabile dall'utente
	mail varchar(256) NOT NULL UNIQUE,
	password varchar(256)NOT NULL,--perche verra criptata
	dataIscrizione date NOT NULL,
	password varchar(256) NOT NULL,
	imgProfilo varchar(256), --Link all'immagine
	nome_Utente varchar(256) NOT NULL,
	cognome_Utente varchar(256) NOT NULL,
	compleanno date,
	genere Gender NOT NULL,
	paese varchar(256) NOT NULL,
	StatoAccount Stato NOT NULL,
	descrizione varchar(1000),
	premium boolean NOT NULL,	--Abbonamento YT premium(evita che un utente riceva le ads

	PRIMARY KEY(id_Account)
);


--Entità 2 video / live
CREATE TABLE IF NOT EXISTS Video(
	id_Video INT UNSIGNED AUTO_INCREMENT, -- ID unico per ogni video: tipo una matricola
	titolo varchar(256) NOT NULL,
	descrizione varchar(500),
	dataPubblicazione datetime NOT NULL, -- La data di pubblicazione corrisponde anche alla data di inizio per le live
	durata INT UNSIGNED NOT NULL,	
	costo float UNSIGNED, -- Costo: se 0=NULL se >0 = costo
	categoria Categorie,
	visibilita Visibilita DEFAULT 'Pubblico',
	stato Stato NOT NULL,
	id_Account varchar(256) NOT NULL,
	isLive boolean, -- Se 0=video, sennò live -> che poi verrà pubblicata come video
	dataFine datetime, -- Nel caso fosse una live questa è la data in cui finisce

	PRIMARY KEY(id_Video),
	FOREIGN KEY(id_Account) REFERENCES Account(id_Account) ON UPDATE CASCADE ON DELETE CASCADE, --Perchè se elimino un canale -> elimino tutti i video | Se modifico id_Account -> modifico anche il valore in tutti i suoi video (ma si può modificare id_Account ???)
	CHECK((dataFine IS NULL AND isLive=true)OR(dataPubblicazione IS NOT NULL AND dataFine IS NOT NULL AND dataPubblicazione<dataFine AND isLive=false))
);--Ricordarsi di scrivere nella documentazione come creare URL account e video -> htpps://.../ID

--per le live serve numero di spettatori?(no è una cosa gestita non con con la base di dati)


--Entità 3 iscrizioni / abbonamento
CREATE TABLE IF NOT EXISTS Abbonamenti(--Usiamo id_Account per gestire solo DELETE ON CASCADE, siccome handle potrebbe essere modificato
	canale INT UNSIGNED, 			-- Canale a cui ci si abbona
	iscritto INT UNSIGNED,			-- Canale di colui che si abbona
	livello Abbonamento NOT NULL, 	-- Se abbonamento = 'Gratis' -> solo iscrizione

	PRIMARY KEY(canale, iscritto),
	FOREIGN KEY(canale) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE-- UPDATE ON CASCADE DELETE ON CASCADE, -- Se viene modificato o eliminato un canale, verranno modificati/eliminati anche tutte le tuple che lo riguardano -> dove ci si abbona al canale
	FOREIGN KEY(iscritto) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se viene modificato o eliminato un canale, verranno modificati/eliminati anche tutte le tuple che lo riguardano -> dove il canale è l'abbonato
);



--Entità 4 Views, (Entità like Spostata fuori)!!!
CREATE TABLE IF NOT EXISTS Views(
	account INT UNSIGNED NOT NULL, 	-- Chi guarda
	id_Video INT UNSIGNED NOT NULL,	-- Cosa guarda
	--valutation Likes DEFAULT 0, 	-- -1=dislike 0=nulla 1=like
	dataView datetime NOT NULL		-- Quando è avvenuta la visualizzazione

	PRIMARY KEY(account, id_Video),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE, -- Se elimino un canale -> NON elimino le sue views -> sennò toglierei views ai video degli altri
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON DELETE CASCADE ON UPDATE CASCADE	-- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino un video -> elimino tutte le relative views
);

CREATE TABLE IF NOT EXISTS LikeCommenti(
	id_Like INT UNSIGNED AUTO_INCREMENT,
	account INT UNSIGNED NOT NULL, 
	id_Video INT UNSIGNED NOT NULL, 
	data datetime NOT NULL,
	valutation Likes, 	-- -1=dislike  1=like
	
	PRIMARY KEY(id_Like),
	FOREIGN KEY(account) REFERENCES Account(id_Account) --ON DELETE CASCADE ON UPDATE CASCADE
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) -- ON DELETE CASCADE ON UPDATE CASCADE
);



--Entità 5 Playlist
CREATE TABLE IF NOT EXISTS Playlist(
	id_Playlist INT UNSIGNED AUTO_INCREMENT,
	account INT UNSIGNED NOT NULL, --Creatore playlist
	id_Video INT UNSIGNED NOT NULL,
	titolo varchar(256) DEFAULT 'Guarda più tardi', --Perchè di default un account YT ha almeno questa playlist
	descrizione varchar(500),
	visibilita Visibilita DEFAULT 'Privato',

	PRIMARY KEY(id_Playlist),
	UNIQUE(titolo, account),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino un account -> elimino tutte le relative playlist,
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino un video -> lo elimino da tutte le relative playlist
);



--Entità 6 commento(che include la sottoclasse donazione)
CREATE TABLE IF NOT EXISTS Commenti(
	id_Commento INT UNSIGNED AUTO_INCREMENT,--Codice univoco per ogni commento, utilizzato per le risposte ai commenti
	account INT UNSIGNED NOT NULL, --Chi commenta
	id_Video INT UNSIGNED NOT NULL,--Cosa commenta
	messaggio varchar(500) NOT NULL, 
	donazione float, --Campo per donazioni
	dataCommento datetime NOT NULL,
	id_Risposta INT UNSIGNED,-- Eventuale risposta ad un'altro commento

	PRIMARY KEY(id_Commento),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino un account -> elimino tutti i relativi commenti,
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video), ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino un video -> elimino tutti i relativi commenti,
	FOREIGN KEY(id_Risposta) REFERENCES Commenti(id_Commento) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino/modifico un commento padre -> elimino/modifico tutti i relativi commenti figli,
	check(donazione>=0)
);

--SEGNALAZIONI
CREATE TABLE IF NOT EXISTS SegnalazioniVideo(
	id_Segnalazione INT UNSIGNED AUTO_INCREMENT,--Codice univoco per ogni segnalazione
	account INT UNSIGNED NOT NULL, --chi segnala
	id_Video INT UNSIGNED NOT NULL, --video segnalato
	motivo Motivo,
	descrizione varchar(50),
	data datetime NOT NULL,
	
	PRIMARY KEY(id_Segnalazione),
	FOREIGN KEY(account) REFERENCES Account(id_Account) --ON DELETE CASCADE ON UPDATE CASCADE
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video) --ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS SegnalazioniCommenti(
	id_Segnalazione INT UNSIGNED AUTO_INCREMENT,--Codice univoco per ogni segnalazione
	account INT UNSIGNED NOT NULL, --chi segnala
	id_Commento INT UNSIGNED NOT NULL, --commento segnalato
	motivo Motivo,
	data datetime NOT NULL,
	
	PRIMARY KEY(id_Segnalazione),
	FOREIGN KEY(account) REFERENCES Account(id_Account) --ON DELETE CASCADE ON UPDATE CASCADE
	FOREIGN KEY(id_Commento) REFERENCES Commenti(id_Commento) -- ON DELETE CASCADE ON UPDATE CASCADE
);


--Entità 7 salvare playlist
CREATE TABLE IF NOT EXISTS SavedPlaylist( -- Salvare playlist private ?
	account INT UNSIGNED NOT NULL,
	id_Playlist INT UNSIGNED NOT NULL,

	PRIMARY KEY(account, id_Playlist),
	FOREIGN KEY(account) REFERENCES Account(id_Account) ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino un account -> elimino tutte le relative playlist salvate
	FOREIGN KEY(id_Playlist) REFERENCES Playlist(id_Playlist), ON DELETE CASCADE ON UPDATE CASCADE -- UPDATE ON CASCADE DELETE ON CASCADE, -- Se elimino una playlist -> la elimino da tutti gli account che l'hanno salvata
);

CREATE TABLE IF NOT EXISTS LikeCommenti(
	id_Like INT UNSIGNED AUTO_INCREMENT,
	account INT UNSIGNED NOT NULL, 
	id_Commento INT UNSIGNED NOT NULL, 
	data datetime NOT NULL,
	valutation Likes, 	-- -1=dislike  1=like
	
	PRIMARY KEY(id_Like),
	FOREIGN KEY(account) REFERENCES Account(id_Account) --ON DELETE CASCADE ON UPDATE CASCADE
	FOREIGN KEY(id_Commento) REFERENCES Commenti(id_Commento) -- ON DELETE CASCADE ON UPDATE CASCADE
);

/*
<IDEE>
	Per creare una base di dati per un progetto basato su YouTube, puoi considerare le seguenti entità e i relativi attributi:

	1. Account:
	- Account_ID (identificatore univoco)
	- Nome utente
	- Email
	- Password
	- Data di registrazione
	- Informazioni sul profilo (ad esempio, nome, cognome, immagine del profilo)

	2. Video:
	- Video_ID (identificatore univoco)
	- Titolo
	- Descrizione
	- URL del video
	- Data di pubblicazione
	- Durata
	- Numero di visualizzazioni
	- Numero di Mi Piace
	- Numero di Non mi piace
	- ID del proprietario del video (riferimento all'Account_ID)

	3. Live:
	- Live_ID (identificatore univoco)
	- Titolo
	- Descrizione
	- URL della live
	- Data e ora di inizio
	- Durata
	- Numero di spettatori
	- ID del proprietario della live (riferimento all'Account_ID)

	4. Iscrizioni:
	- Iscrizione_ID (identificatore univoco)
	- ID dell'account che si iscrive (riferimento all'Account_ID)
	- ID del canale a cui viene effettuata l'iscrizione (riferimento all'Account_ID del canale)

	5. Abbonamento:
	- Abbonamento_ID (identificatore univoco)
	- ID dell'account che effettua l'abbonamento (riferimento all'Account_ID)
	- ID del canale a cui viene effettuato l'abbonamento (riferimento all'Account_ID del canale)

	6. Like:
	- Like_ID (identificatore univoco)
	- ID dell'account che effettua il like (riferimento all'Account_ID)
	- ID del video o della live a cui viene dato il like (riferimento al Video_ID o al Live_ID)

	7. Playlist:
	- Playlist_ID (identificatore univoco)
	- Nome della playlist
	- Descrizione
	- Data di creazione
	- ID del proprietario della playlist (riferimento all'Account_ID)

	8. Commento:
	- Commento_ID (identificatore univoco)
	- Testo del commento
	- Data e ora del commento
	- ID dell'account che ha scritto il commento (riferimento all'Account_ID)
	- ID del video o della live a cui viene fatto il commento (riferimento al Video_ID o al Live_ID)

	9. Iscrizione playlist:
	- IscrizionePlaylist_ID (identificatore univoco)
	- ID dell'account che si iscrive alla playlist (riferimento all'Account_ID)
	- ID della playlist a cui viene effettuata l'iscrizione (riferimento al Playlist_ID)

	Queste entità coprono molti aspetti principali di YouTube. Tuttavia, ci sono altre entità che potrebbero essere significative, a seconda delle specifiche del tuo progetto. Alcune idee aggiuntive potrebbero includere:

	- Canale: un'entità separata per rappresentare un canale di YouTube, che contiene informazioni specifiche del canale, come il nome del canale, la descrizione, la

	data di creazione e l'immagine del banner.
	- Categorie: un'entità per categorizzare i video in base a specifici argomenti o generi.
	- Notifiche: un'entità per tenere traccia delle notifiche inviate agli utenti, come notifiche di nuovi video, commenti o live streaming.
	- Segnalazioni: un'entità per gestire le segnalazioni di contenuti inappropriati o violazioni delle regole da parte degli utenti.
	- Visualizzazioni video: se desideri tracciare informazioni dettagliate sulle visualizzazioni dei video, potresti creare un'entità separata per tenere traccia di ogni visualizzazione, con attributi come l'ID del video, l'ID dell'utente che ha visualizzato il video e la data e l'ora della visualizzazione.

	Ricorda che le entità e gli attributi specifici possono variare in base alle esigenze del tuo progetto. Assicurati di considerare i requisiti e gli obiettivi del tuo progetto durante la progettazione della base di dati.
</IDEE>
*/
