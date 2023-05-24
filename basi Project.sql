--Tutti i drop table !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/*Per video e live si risolve il problema della chiave primaria aggiungendo un campo ID che funziona tipo matricola, ma va bene così ? O meglio fare una chiave primaria composta magari da (id_Account, titolo, data)
Sì, i video su YouTube sono identificati in modo univoco attraverso un codice chiamato "ID video". L'ID video di YouTube è un identificatore univoco assegnato a ciascun video presente sulla piattaforma.
L'ID video è una combinazione di caratteri alfanumerici, solitamente composta da undici caratteri. Questo codice univoco è associato a ogni video su YouTube e consente di identificarlo in modo univoco all'interno del sistema.
Puoi trovare l'ID video di un video di YouTube nella barra degli indirizzi del tuo browser quando sei sulla pagina del video. L'ID video appare dopo il segno "=" nell'URL del video. Ad esempio, se l'URL del video è "https://www.youtube.com/watch?v=ABC123", allora "ABC123" è l'ID univoco di quel video.*/





CREATE TYPE Gender AS ENUM('M', 'F', '/');
CREATE TYPE Stato AS ENUM('Attivo', 'Sospeso', 'Eliminato');
CREATE TYPE Visibilita AS ENUM('Pubblico', 'Privato', 'Non in elenco');
CREATE TYPE Abbonamento AS ENUM('Gratis', '1.99', '4.99', '9.99', '14.99', '19.99', '24.99');
CREATE TYPE Like AS ENUM(-1, 0, 1);
CREATE TYPE Categorie AS ENUM('Animali', 'Auto e motori', 'Fai da te e stile', 'Film e animazione', 'Giochi', 'Intrattenimento', 'Istruzione', 'Musica', 'Non profit e attivismo', 'Notizie e politica', 'Persone e blog', 'Scienze e tecnologie', 'Sport', 'Umorismo', 'Viaggi ed eventi')

--Entità 1 Account
CREATE TABLE IF NOT EXISTS Account(
	id_Account INT UNSIGNED AUTO_INCREMENT, --Codice numerico univoco tipo matricola
	handle varchar(256) NOT NULL UNIQUE, --Nome unico per ogni utente, modificabile dall'utente
	mail varchar(256) NOT NULL UNIQUE,
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
	premium boolean NOT NULL,	--Abbonamento YT premium

	PRIMARY KEY(id_Account)
);



--Entità 2 video / live
CREATE TABLE IF NOT EXISTS Video(
	id_Video INT UNSIGNED AUTO_INCREMENT, --ID unico per ogni video: tipo una matricola
	titolo varchar(256) NOT NULL,
	descrizione varchar(500),
	dataPubblicazione datetime NOT NULL,
	durata INT UNSIGNED NOT NULL,	
	costo float UNSIGNED, --Costo: se 0=NULL se >0 = costo
	categoria Categorie,
	visibilita Visibilita DEFAULT 'Pubblico',
	stato Stato NOT NULL,
	id_Account varchar(256) NOT NULL,
	isLive boolean,--Se 0=video, sennò live -> che poi verrà pubblicata come video
	dataFine datetime, --Nel caso fosse una live questa è la data in cui finisce

	PRIMARY KEY(id_Video),
	FOREIGN KEY(id_Account) REFERENCES Account(id_Account)
);--Ricordarsi di scrivere nella documentazione come creare URL account e video -> htpps://.../ID



--Entità 3 iscrizioni / abbonamento
CREATE TABLE IF NOT EXISTS Abbonamenti(--Usiamo id_Account per gestire solo DELETE ON CASCADE, siccome handle potrebbe essere modificato
	canale INT UNSIGNED,
	iscritto INT UNSIGNED,
	livello Abbonamento NOT NULL,--Se abbonamento = 'Gratis' -> solo iscrizione

	PRIMARY KEY(canale, iscritto),
	FOREIGN KEY(canale) REFERENCES Account(id_Account),
	FOREIGN KEY(iscritto) REFERENCES Account(id_Account)
);



--Entità 4 Views, (Entità like è stata incorporata dentro di questa)
CREATE TABLE IF NOT EXISTS Views(
	account INT UNSIGNED NOT NULL, --Chi guarda
	id_Video INT UNSIGNED NOT NULL,--Cosa guarda
	valutation Likes DEFAULT 0, -- -1=dislike 0=nulla 1=like

	PRIMARY KEY(account, id_Video),
	FOREIGN KEY(account) REFERENCES Account(id_Account),
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video)
);



--Entità 5 Playlist
CREATE TABLE IF NOT EXISTS Playlist(
	id_Playlist INT UNSIGNED AUTO_INCREMENT,
	titolo varchar(256) DEFAULT 'Guarda più tardi', --Perchè di default un account YT ha almeno questa playlist
	descrizione varchar(500),
	visibilita Visibilita DEFAULT 'Privato',
	account INT UNSIGNED NOT NULL, --Creatore playlist
	id_Video INT UNSIGNED NOT NULL,

	PRIMARY KEY(id_Playlist),
	UNIQUE(titolo, account),
	FOREIGN KEY(account) REFERENCES Account(id_Account),
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video)
);



--Entità 6 commento
CREATE TABLE IF NOT EXISTS Commenti(
	id_Commento INT UNSIGNED AUTO_INCREMENT,--Codice univoco per ogni commento, utilizzato per le risposte ai commenti
	account INT UNSIGNED NOT NULL, --Chi commenta
	id_Video INT UNSIGNED NOT NULL,--Cosa commenta
	messaggio varchar(500) NOT NULL, 
	donazione float, --Campo per donazioni
	dataCommento datetime NOT NULL,
	id_Risposta INT UNSIGNED,-- Eventuale risposta ad un'altro commento

	PRIMARY KEY(id_Commento),
	FOREIGN KEY(account) REFERENCES Account(id_Account),
	FOREIGN KEY(id_Video) REFERENCES Video(id_Video),
	FOREIGN KEY(id_Risposta) REFERENCES Commenti(id_Commento)
);



--Entità 7 salvare playlist
CREATE TABLE IF NOT EXISTS SavedPlaylist( -- Salvare playlist private ?
	account INT UNSIGNED NOT NULL,
	id_Playlist INT UNSIGNED NOT NULL,

	PRIMARY KEY(account, id_Playlist),
	FOREIGN KEY(account) REFERENCES Account(id_Account),
	FOREIGN KEY(id_Playlist) REFERENCES Playlist(id_Playlist),
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