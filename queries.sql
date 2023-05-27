--1)somma delle views di un canale/video
SELECT account, SUM(views) AS total_views
FROM Video
--WHERE id_Account = "id_canale"
GROUP BY account;

SELECT id_Video, SUM(views) AS total_views
FROM Views
--WHERE id_Video = "id_video"
GROUP BY id_Video;


--2)query parametrica: barra di ricerca video/canale/topic

--3)i tuoi video/preferiti/like/cronologia
SELECT *
FROM Video
WHERE id_Account = "id_canale";

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


--5)video ordinati in base al rating ricevuto(like+dislike/views)

--6)utenti a cui far vedere una ads(se hanno yt premium o sono abbonati ad un canale)
SELECT *
FROM Utenti
WHERE Prime = FALSE;
