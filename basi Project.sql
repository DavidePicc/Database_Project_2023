--Tutti i drop table !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/*Per video e live si risolve il problema della chiave primaria aggiungendo un campo ID che funziona tipo matricola, ma va bene così ? O meglio fare una chiave primaria composta magari da (id_Account, titolo, data)
Sì, i video su YouTube sono identificati in modo univoco attraverso un codice chiamato "ID video". L'ID video di YouTube è un identificatore univoco assegnato a ciascun video presente sulla piattaforma.
L'ID video è una combinazione di caratteri alfanumerici, solitamente composta da undici caratteri. Questo codice univoco è associato a ogni video su YouTube e consente di identificarlo in modo univoco all'interno del sistema.
Puoi trovare l'ID video di un video di YouTube nella barra degli indirizzi del tuo browser quando sei sulla pagina del video. L'ID video appare dopo il segno "=" nell'URL del video. Ad esempio, se l'URL del video è "https://www.youtube.com/watch?v=ABC123", allora "ABC123" è l'ID univoco di quel video.*/





CREATE TYPE Gender AS ENUM('M', 'F', '/');

--Entità 1 Account
CREATE TABLE IF NOT EXISTS Account(
	id_Account varchar(256),
	username varchar(256) NOT NULL UNIQUE,
	mail varchar(256) NOT NULL UNIQUE,
	dataIscrizione date NOT NULL,
	password varchar(256) NOT NULL,
	imgProfilo varchar(256), --Link all'immagine
	nome_Utente varchar(256) NOT NULL,
	cognome_Utente varchar(256) NOT NULL,
	compleanno date,
	genere Gender NOT NULL,
	paese varchar(256) NOT NULL,


	PRIMARY KEY(id_Account)
);

--Entità 2 video / live
CREATE TABLE IF NOT EXISTS VIDEO(
	videoID INT UNSIGNED AUTO_INCREMENT, --ID unico per ogni video: tipo una matricola
	titolo varchar(256) NOT NULL,
	descrizione varchar(65535),
	dataPubblicazione date NOT NULL,
	views INT UNSIGNED NOT NULL,
	likes INT UNSIGNED NOT NULL,
	dislikes INT UNSIGNED NOT NULL,
	Durata INT UNSIGNED NOT NULL,
	id_Account varchar(256) NOT NULL,

	PRIMARY KEY(videoID)
	FOREIGN KEY(id_Account) REFERENCES Account(id_Account)

	--URL del video [Vincolo: Unico] -- Evitabile
);

CREATE TABLE IF NOT EXISTS LIVE(
	Live_ID INT UNSIGNED AUTO_INCREMENT, --ID unico per ogni live: tipo una matricola

);
/*	- Live_ID (identificatore univoco)
	- Titolo
	- Descrizione
	- URL della live
	- Data e ora di inizio
	- Durata
	- Numero di spettatori
	- ID del proprietario della live (riferimento all'Account_ID)*/

--Entità 3 iscrizioni / abbonamento
Iscrizioni -> abbonamento

--Entità 4 Like
Like

--Entità 5 Playplist
Playlist

--Entità 6 commento
Commento

--Entità 7 iscrizione playplist ?
Iscrizione playlist

/*
<DIFFERENZA ACCOUNT - CANALE>
	Certamente! Ecco la differenza tra un account e un canale su YouTube:

	Account:
	Un account su YouTube rappresenta l'identità di un singolo utente. Quando ti iscrivi a YouTube, crei un account che ti consente di accedere e gestire le tue attività sulla piattaforma. L'account contiene le informazioni personali dell'utente, come il nome utente, l'email, la password e le informazioni di base del profilo. È attraverso l'account che puoi caricare video, commentare, mettere mi piace e iscriverti ad altri canali.

	Canale:
	Un canale su YouTube rappresenta uno spazio dedicato a un contenuto specifico, gestito da un utente. Puoi considerare un canale come un "account pubblico" che ospita i video e le attività di un utente. Ogni account può creare uno o più canali associati ad esso. Un canale ha un nome, una descrizione e un'immagine del banner che possono essere personalizzati dall'utente per riflettere il proprio marchio o tema del contenuto.
	I canali consentono agli utenti di organizzare e presentare i propri video in modo coerente. Quando un utente carica un video, può scegliere su quale canale desidera pubblicarlo. I canali hanno i loro URL unici, che possono essere condivisi con gli altri utenti per raggiungere il contenuto specifico ospitato da quel canale.

	In sostanza, l'account è l'entità principale che rappresenta l'utente su YouTube, mentre il canale è un'entità associata all'account che ospita e organizza i video e le attività del contenuto specifico gestito dall'utente.
</DIFFERENZA ACCOUNT - CANALE>

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