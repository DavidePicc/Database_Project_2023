-- Popolamento tabella Account
INSERT INTO Account (handle, mail, password, dataIscrizione, imgProfilo, nome_Utente, cognome_Utente, compleanno, genere, paese, StatoAccount, descrizione, premium)
VALUES
('utente1', 'utente1@example.com', 'password123', '2023-01-01', 'https://example.com/image1.jpg', 'Mario', 'Rossi', '1990-05-10', 'M', 'Italia', 'Attivo', 'Descrizione utente 1', true),
('utente2', 'utente2@example.com', 'password456', '2023-02-15', 'https://example.com/image2.jpg', 'Laura', 'Verdi', '1985-09-20', 'F', 'Spagna', 'Attivo', 'Descrizione utente 2', false),
('utente3', 'utente3@example.com', 'password789', '2023-03-20', 'https://example.com/image3.jpg', 'Luigi', 'Bianchi', '1995-07-01', '/', 'Francia', 'Sospeso', 'Descrizione utente 3', true),
('utente4', 'utente4@example.com', 'password123', '2023-04-10', 'https://example.com/image4.jpg', 'Marco', 'Rossi', '1990-12-05', 'M', 'Italia', 'Attivo', 'Descrizione utente 4', true),
('utente5', 'utente5@example.com', 'password789', '2023-05-20', 'https://example.com/image5.jpg', 'Giulia', 'Ferrari', '1988-06-15', 'F', 'Italia', 'Sospeso', 'Descrizione utente 5', false),
('utente6', 'utente6@example.com', 'passwordabc', '2023-06-25', 'https://example.com/image6.jpg', 'Alessio', 'Ricci', '1993-03-12', 'M', 'Italia', 'Attivo', 'Descrizione utente 6', true),
('utente7', 'utente7@example.com', 'passwordxyz', '2023-07-08', 'https://example.com/image7.jpg', 'Simona', 'Gallo', '1996-09-25', 'F', 'Italia', 'Attivo', 'Descrizione utente 7', false),
('utente8', 'utente8@example.com', 'password321', '2023-08-12', 'https://example.com/image8.jpg', 'Giovanni', 'Martini', '1992-02-18', 'M', 'Italia', 'Sospeso', 'Descrizione utente 8', true),
('utente9', 'utente9@example.com', 'password456', '2023-09-20', 'https://example.com/image9.jpg', 'Sara', 'Conti', '1998-07-05', 'F', 'Italia', 'Attivo', 'Descrizione utente 9', false);

-- Popolamento tabella Video
INSERT INTO Video (titolo, descrizione, dataPubblicazione, durata, costo, categoria, visibilita, stato, id_Account, isLive, dataFine)
VALUES
('Titolo del video 1', 'Descrizione del video 1', '2023-04-01 10:00:00', 300, 0, 'Musica', 'Pubblico', 'Attivo', 1, false, NULL),
('Titolo del video 2', 'Descrizione del video 2', '2023-04-05 15:30:00', 600, 4.99, 'Film e animazione', 'Privato', 'Attivo', 2, false, NULL),
('Titolo della live 1', 'Descrizione della live 1', '2023-05-10 20:00:00', 120, 0, 'Intrattenimento', 'Pubblico', 'Attivo', 1, true, '2023-05-10 22:00:00');
('Titolo del video 3', 'Descrizione del video 3', '2023-06-15 14:30:00', 480, 2.99, 'Sport', 'Pubblico', 'Attivo', 3, false, NULL),
('Titolo del video 4', 'Descrizione del video 4', '2023-07-20 09:45:00', 240, 0, 'Cucina', 'Privato', 'Attivo', 4, false, NULL),
('Titolo della live 2', 'Descrizione della live 2', '2023-08-10 18:00:00', 90, 0, 'Intrattenimento', 'Pubblico', 'Attivo', 2, true, '2023-08-10 19:30:00'),
('Titolo del video 5', 'Descrizione del video 5', '2023-09-05 11:15:00', 420, 1.99, 'Viaggi', 'Pubblico', 'Attivo', 5, false, NULL),
('Titolo del video 6', 'Descrizione del video 6', '2023-10-12 16:30:00', 180, 0, 'Tutorial', 'Privato', 'Attivo', 3, false, NULL),
('Titolo della live 3', 'Descrizione della live 3', '2023-11-20 19:00:00', 150, 0, 'Intrattenimento', 'Pubblico', 'Attivo', 4, true, '2023-11-20 21:30:00'),
('Titolo del video 7', 'Descrizione del video 7', '2023-12-15 13:45:00', 300, 3.99, 'Musica', 'Pubblico', 'Attivo', 6, false, NULL),
('Titolo del video 8', 'Descrizione del video 8', '2024-01-10 08:30:00', 600, 0, 'Film e animazione', 'Privato', 'Attivo', 5, false, NULL),
('Titolo della live 4', 'Descrizione della live 4', '2024-02-25 21:30:00', 120, 0, 'Intrattenimento', 'Pubblico', 'Attivo', 6, true, '2024-02-25 23:00:00');

-- Popolamento tabella Abbonamenti
INSERT INTO Abbonamenti (canale, iscritto, livello, dataIscrizione)
VALUES (1, 2, '1.99', '2023-04-02 12:00:00'),
(2, 1, '4.99', '2023-04-06 09:30:00'),
(3, 2, '3.99', '2023-05-15 16:45:00'),
(2, 3, '2.99', '2023-06-20 14:30:00'),
(1, 4, '1.99', '2023-07-10 11:15:00'),
(4, 1, '4.99', '2023-08-25 19:30:00'),
(2, 5, '0.99', '2023-09-18 10:45:00'),
(5, 2, '2.99', '2023-10-30 15:00:00'),
(4, 3, '3.99', '2023-11-12 12:30:00');

-- Popolamento tabella Views
INSERT INTO Views (account, id_Video, dataView)
VALUES (1, 2, '2023-04-02 14:30:00'),
       (2, 1, '2023-04-03 09:45:00'),
       (1, 3, '2023-05-11 08:00:00'),
       (3, 2, '2023-06-15 12:30:00'),
       (4, 1, '2023-07-20 16:15:00'),
       (2, 4, '2023-08-10 09:00:00'),
       (5, 3, '2023-09-25 14:45:00'),
       (3, 5, '2023-10-18 11:30:00'),
       (4, 2, '2023-11-30 15:30:00');


-- Popolamento tabella Playlist
INSERT INTO Playlist (account, id_Video, titolo, descrizione, visibilita)
VALUES (1, 2, 'Playlist preferiti', 'Le mie video preferiti', 'Pubblico'),
       (2, 3, 'Guarda dopo', 'Video da guardare in seguito', 'Privato'),
       (1, 4, 'Playlist divertenti', 'Video comici e divertenti', 'Pubblico'),
       (3, 1, 'Playlist musica', 'Le mie canzoni preferite', 'Privato'),
       (2, 5, 'Playlist viaggi', 'Video dei miei viaggi in giro per il mondo', 'Pubblico'),
       (4, 3, 'Playlist motivazionali', 'Video per l'ispirazione e la motivazione', 'Privato'),
       (5, 1, 'Playlist tutorial', 'Tutorial su vari argomenti', 'Pubblico'),
       (3, 2, 'Playlist film', 'I miei film preferiti', 'Privato'),
       (4, 4, 'Playlist sport', 'Video sportivi e allenamenti', 'Pubblico');


-- Popolamento tabella SavedPlaylist
INSERT INTO SavedPlaylist (account, id_Playlist)
VALUES (1, 2),
       (2, 1),
       (3, 4),
       (1, 3),
       (4, 2),
       (5, 1),
       (2, 3),
       (3, 5),
       (4, 1);


-- Popolamento tabella Commenti
INSERT INTO Commenti (account, id_Video, messaggio, donazione, dataCommento, id_Risposta)
VALUES (1, 2, 'Bellissimo video!', 0, '2023-04-02 15:00:00', NULL),
       (2, 1, 'Grazie mille!', 0, '2023-04-03 10:00:00', 1),
       (1, 3, 'Non mi è piaciuto molto...', 0, '2023-05-11 09:00:00', NULL),
       (3, 2, 'Interessante punto di vista.', 0, '2023-06-15 13:30:00', 1),
       (4, 1, 'Mi piace molto questa serie!', 0, '2023-07-20 17:15:00', NULL),
       (2, 4, 'Complimenti per la grafica!', 0, '2023-08-10 10:00:00', NULL),
       (5, 3, 'Spero ci sia un seguito!', 0, '2023-09-25 15:45:00', NULL),
       (3, 5, 'Mi ha emozionato molto.', 0, '2023-10-18 12:30:00', NULL),
       (4, 2, 'Non vedo l'ora di vedere il prossimo episodio!', 0, '2023-11-30 16:30:00', NULL);


-- Popolamento tabella SegnalazioniVideo
INSERT INTO SegnalazioniVideo (account, id_Video, motivo, descrizione, data)
VALUES (1, 2, 'Contenuti violenti o ripugnanti', 'Video troppo violento', '2023-04-02 16:00:00'),
       (2, 1, 'Contenuti di natura sessuale', 'Video inappropriato', '2023-04-03 11:00:00'),
       (3, 1, 'Violazione del copyright', 'Contenuto protetto da copyright', '2023-05-05 10:30:00'),
       (4, 3, 'Spam o frodi', 'Contenuto spam', '2023-06-10 15:45:00'),
       (5, 2, 'Contenuti diffamatori', 'Diffamazione nel video', '2023-07-15 09:15:00');

-- Popolamento tabella SegnalazioniCommenti
INSERT INTO SegnalazioniCommenti (account, id_Commento, motivo, data)
VALUES (1, 2, 'Contenuti offensivi o che incitano all''odio', '2023-04-03 12:00:00'),
       (2, 1, 'Molestie o bullismo', '2023-04-03 13:00:00'),
       (3, 4, 'Violazione delle linee guida della community', '2023-05-06 14:30:00'),
       (4, 3, 'Commento spam', '2023-06-11 16:45:00'),
       (5, 5, 'Contenuti diffamatori', '2023-07-16 11:30:00');


-- Popolamento tabella LikeVideo
INSERT INTO LikeVideo (account, id_Video, data, valutation)
VALUES (1, 2, '2023-04-02 14:00:00', '1'),
       (2, 1, '2023-04-03 09:00:00', '1'),
       (3, 1, '2023-04-03 10:00:00', '-1'),
       (4, 3, '2023-05-05 11:30:00', '1'),
       (5, 2, '2023-06-10 16:45:00', '1'),
       (1, 4, '2023-07-15 09:30:00', '-1'),
       (2, 3, '2023-08-20 12:15:00', '1'),
       (3, 5, '2023-09-25 14:30:00', '1'),
       (4, 2, '2023-10-30 17:00:00', '1'),
       (5, 1, '2023-12-05 10:45:00', '-1'),
       (1, 5, '2024-01-10 13:30:00', '-1'),
       (2, 4, '2024-02-15 16:15:00', '1'),
       (3, 3, '2024-03-20 09:30:00', '1'),
       (4, 1, '2024-04-25 12:00:00', '1'),
       (5, 5, '2024-05-30 14:45:00', '1');


-- Popolamento tabella LikeCommenti
INSERT INTO LikeCommenti (account, id_Commento, data, valutation)
VALUES (1, 2, '2023-04-03 11:00:00', '1'),
       (2, 1, '2023-04-03 12:00:00', '-1'),
       (3, 1, '2023-04-03 13:00:00', '1'),
       (4, 3, '2023-04-04 10:00:00', '1'),
       (5, 2, '2023-04-05 09:00:00', '-1');


/*
--Altri dati
-- Popolamento tabella Account
INSERT INTO Account (handle, mail, password, dataIscrizione, imgProfilo, nome_Utente, cognome_Utente, compleanno, genere, paese, StatoAccount, descrizione, premium)
VALUES ('user1', 'user1@example.com', 'password1', '2023-01-01', 'https://example.com/img1.jpg', 'John', 'Doe', '1990-01-01', 'M', 'Italy', 'Attivo', 'Descrizione account', true);

INSERT INTO Account (handle, mail, password, dataIscrizione, imgProfilo, nome_Utente, cognome_Utente, compleanno, genere, paese, StatoAccount, descrizione, premium)
VALUES ('user2', 'user2@example.com', 'password2', '2023-01-02', 'https://example.com/img2.jpg', 'Jane', 'Smith', '1995-02-15', 'F', 'USA', 'Attivo', 'Descrizione account', false);

-- Popolamento tabella Video
INSERT INTO Video (titolo, descrizione, dataPubblicazione, durata, costo, categoria, visibilita, stato, id_Account, isLive, dataFine)
VALUES ('Video 1', 'Descrizione video 1', '2023-02-01 12:00:00', 300, 0.99, 'Intrattenimento', 'Pubblico', 'Attivo', 1, false, null);

INSERT INTO Video (titolo, descrizione, dataPubblicazione, durata, costo, categoria, visibilita, stato, id_Account, isLive, dataFine)
VALUES ('Video 2', 'Descrizione video 2', '2023-02-02 14:30:00', 240, 0, 'Musica', 'Pubblico', 'Attivo', 2, false, null);

-- Popolamento tabella Abbonamenti
INSERT INTO Abbonamenti (canale, iscritto, livello, dataIscrizione)
VALUES (1, 2, '4.99', '2023-02-01 15:00:00');

INSERT INTO Abbonamenti (canale, iscritto, livello, dataIscrizione)
VALUES (2, 1, 'Gratis', '2023-02-02 10:30:00');

-- Popolamento tabella Views
INSERT INTO Views (account, id_Video, dataView)
VALUES (1, 2, '2023-02-03 16:00:00');

INSERT INTO Views (account, id_Video, dataView)
VALUES (2, 1, '2023-02-04 11:30:00');

-- Popolamento tabella Playlist
INSERT INTO Playlist (account, id_Video, titolo, descrizione, visibilita)
VALUES (1, 2, 'Guarda più tardi', 'Playlist dei video da guardare in seguito', 'Privato');

INSERT INTO Playlist (account, id_Video, titolo, descrizione, visibilita)
VALUES (2, 1, 'Playlist preferiti', 'Playlist dei miei video preferiti', 'Pubblico');

-- Popolamento tabella SavedPlaylist
--INSERT INTO SavedPlaylist (account, id_Playlist)
--VALUES (1, 2);

--INSERT INTO SavedPlaylist (account, id_Playlist)
--VALUES (2, 1);

-- Popolamento tabella Commenti
INSERT INTO Commenti (account, id_Video, messaggio, donazione, dataCommento, id_Risposta)
VALUES (1, 2, 'Questo video è fantastico!', 0, '2023-02-05 10:00:00', null);

INSERT INTO Commenti (account, id_Video, messaggio, donazione, dataCommento, id_Risposta)
VALUES (2, 1, 'Mi piace molto la canzone di questo video!', 5.99, '2023-02-06 12:30:00', 1);

-- Popolamento tabella SegnalazioniVideo
INSERT INTO SegnalazioniVideo (account, id_Video, motivo, descrizione, data)
VALUES (1, 2, 'Contenuti offensivi o che incitano all'odio', 'Il video contiene linguaggio inappropriato.', '2023-02-07 14:00:00');

INSERT INTO SegnalazioniVideo (account, id_Video, motivo, descrizione, data)
VALUES (2, 1, 'Violazione del copyright', 'Il video utilizza materiale protetto da copyright senza autorizzazione.', '2023-02-08 09:30:00');

-- Popolamento tabella SegnalazioniCommenti
INSERT INTO SegnalazioniCommenti (account, id_Commento, motivo, data)
VALUES (1, 2, 'Molestie o bullismo', '2023-02-09 11:00:00');

INSERT INTO SegnalazioniCommenti (account, id_Commento, motivo, data)
VALUES (2, 1, 'Spam o ingannevole', '2023-02-10 12:30:00');

-- Popolamento tabella LikeVideo
INSERT INTO LikeVideo (account, id_Video, data, valutation)
VALUES (1, 2, '2023-02-11 14:00:00', '1');

INSERT INTO LikeVideo (account, id_Video, data, valutation)
VALUES (2, 1, '2023-02-12 09:00:00', '-1');

-- Popolamento tabella LikeCommenti
INSERT INTO LikeCommenti (account, id_Commento, data, valutation)
VALUES (1, 2, '2023-02-13 11:00:00', '-1');

INSERT INTO LikeCommenti (account, id_Commento, data, valutation)
VALUES (2, 1, '2023-02-14 12:00:00', '1');*/
