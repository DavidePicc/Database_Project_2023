--1)somma delle views di un canale/video
--creare un view con questo, views per ogni canale poi usarl a sotto per views del canale.
CREATE VIEW AS ViewsPerVideo(
SELECT id_Video, COUNT(account) AS total_views
FROM Views
--WHERE id_Video = "id_video" --per uno specifico video, senza per tutti i video
GROUP BY id_Video;
);

--serve per forza view pk non abbiamo colonna views in video
SELECT Video.account, SUM(total_views) AS ViewsCanale
FROM ViewsPerVideo, Video
--WHERE id_Account = "id_canale"
GROUP BY id_Video;

--2)query parametrica: barra di ricerca video/canale/topic; su C++


--3)i tuoi video/preferiti/like/cronologia
SELECT *
FROM Video
WHERE id_Account = "id_canale";
ORDER BY dataPubblicazione DESC

SELECT Video.*
FROM Video
INNER JOIN Playlist SP ON V.id_Video = SP.id_Video
WHERE SP.account = "id_utente" AND titolo="preferiti";

SELECT Video.*
FROM Video
INNER JOIN LikeVideo LV ON V.id_Video = LV.id_Video
WHERE LV.account = <id_utente>;

SELECT Video.*
FROM Video
INNER JOIN Views V ON V.id_Video = V.id_Video
WHERE V.account = "id_utente"
ORDER BY V.dataView DESC;

--4)video in tendenza(con limit 10)
SELECT Video.*
FROM Video
JOIN (
  SELECT id_Video, COUNT(*) AS num_views
  FROM Views
  GROUP BY id_Video
) VIEWS ON V.id_Video = VIEWS.id_Video
ORDER BY VIEWS.num_views DESC
LIMIT 10;

--5)video ordinati in base al rating ricevuto(like+dislike/views) //uso la view creata sopra per le visualizzazioni e un altra view
CREATE VIEW AS SommaLike(
SELECT id_Video, SUM(valutation) AS SommaLike
FROM LikeVideo                     
GROUP BY id_Video
);
SELECT S.id_Video, (S.SommaLike/V.total_views) --AS RATING
FROM SommaLike AS S, ViewsPerVideo AS V
--ORDER BY RATING DESC

--6)utenti a cui far vedere una ads(se hanno yt premium o sono abbonati ad un canale)
SELECT *
FROM Utenti
WHERE Prime = FALSE;

--7) lista delle live in onda ora
SELECT *
FROM Video
WHERE isLive=1; --non serve che controlli se la live già data fine perchè è messo come check nel codice per la creazione della tabella
