--1)somma delle views di un canale/video
--creare un view con questo, views per ogni canale poi usarl a sotto per views del canale.
CREATE VIEW ViewsPerVideo AS(
SELECT id_Video, COUNT(account) AS total_views
FROM Views
GROUP BY id_Video
);

--serve per forza view pk non abbiamo colonna views in video
SELECT Video.id_account, SUM(total_views) AS ViewsCanale
FROM ViewsPerVideo, Video
--WHERE id_Account = "id_canale"
GROUP BY Video.id_account;

--2)query parametrica: barra di ricerca video/canale/topic; su C++
-- Vedere file query.cpp

--3)i tuoi video/preferiti/like/cronologia
SELECT *
FROM Video
--WHERE id_Account = "id_canale"
ORDER BY dataPubblicazione DESC;

SELECT V.*
FROM Video AS V
INNER JOIN Playlist AS SP ON V.id_Video = SP.id_Video
--WHERE SP.account = "id_utente" AND titolo="preferiti";

SELECT V.*
FROM Video AS V
INNER JOIN LikeVideo LV ON V.id_Video = LV.id_Video
WHERE LV.account = <id_utente>;

SELECT V.*
FROM Video AS V
INNER JOIN LikeVideo AS LV ON V.id_Video = LV.id_Video
--WHERE LV.account = <id_utente>;

--4)video in tendenza(con limit 10)
SELECT V.*
FROM Video AS V
JOIN (
  SELECT id_Video, COUNT(*) AS num_views
  FROM Views
  GROUP BY id_Video
) AS VIEWS ON V.id_Video = VIEWS.id_Video
ORDER BY VIEWS.num_views DESC
LIMIT 10;


--5)video ordinati in base al rating ricevuto(like+dislike/views) //uso la view creata sopra per le visualizzazioni e un altra view
DROP VIEW IF EXISTS ViewsPerVideo;
DROP VIEW IF EXISTS SommaLike;
DROP VIEW IF EXISTS voto;

CREATE VIEW ViewsPerVideo AS(
SELECT id_Video, COUNT(account) AS total_views
FROM Views
GROUP BY id_Video);

CREATE VIEW voto AS(
SELECT id_Video,
    CASE
        WHEN valutation = '1' THEN 1.0
        ELSE -1.0
    END AS stato
FROM LikeVideo);

CREATE VIEW SommaLike AS(
SELECT id_Video, SUM(stato) AS SommaLike
FROM voto                      
GROUP BY id_Video);

SELECT S.id_Video, (S.SommaLike/V.total_views) AS RATING
FROM SommaLike AS S JOIN ViewsPerVideo AS V ON S.id_Video=V.id_Video
ORDER BY RATING DESC;

--6)utenti a cui far vedere una ads(se hanno yt premium o sono abbonati ad un canale)
SELECT *
FROM account
WHERE premium = FALSE;

--7) lista delle live in onda ora
SELECT *
FROM Video
WHERE isLive = true; --non serve che controlli se la live già data fine perchè è messo come check nel codice per la creazione della tabella

--(8) QUERY CH CREA LA PLAYLIST MI PIACE E GUARDA PIU' TARDI PER OGNI UTENTE
INSERT INTO Playlist (account, id_Video, titolo, descrizione, visibilita)
SELECT id_Account, 'Guarda più tardi', ' ', 'Privato'
FROM account

INSERT INTO Playlist (account, id_Video, titolo, descrizione, visibilita)
SELECT id_Account, 'Video piaciuti', 'descrizione', 'Privato'
FROM account




