--1)somma delle views di un canale/video
--creare un view con questo, views per ogni canale poi usarl a sotto per views del canale.
CREATE VIEW ViewsPerVideo AS(
SELECT id_Video, COUNT(account) AS total_views
FROM Views
GROUP BY id_Video
);

SELECT Video.id_account, SUM(total_views) AS ViewsCanale
FROM ViewsPerVideo, Video
GROUP BY Video.id_account
HAVING SUM(total_views)>10;

--2)video in tendenza(con limit 10)
SELECT V.*
FROM Video AS V
JOIN (
  SELECT id_Video, COUNT(*) AS num_views
  FROM Views
  GROUP BY id_Video
) AS VIEWS ON V.id_Video = VIEWS.id_Video
ORDER BY VIEWS.num_views DESC
LIMIT 10;


--3)video ordinati in base al rating ricevuto(like+dislike/views) 
-- uso la view creata sopra per le visualizzazioni e un altra view
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

--4)utenti a cui far vedere una ads(se hanno yt premium o sono abbonati ad un canale)
SELECT *
FROM account
WHERE premium = FALSE;

--5) lista delle live in onda ora
SELECT *
FROM Video
WHERE isLive = true; --non serve che controlli se la live già data fine perchè è messo come check nel codice per la creazione della tabella

--6) Query che crea le playlist "Mi piace" e "Guarda più tardi" per ogni utente
INSERT INTO Playlist (account, titolo, descrizione, visibilita)
SELECT id_Account, 'Guarda più tardi', ' ', 'Privato'
FROM account;

INSERT INTO Playlist (account, titolo, descrizione, visibilita)
SELECT id_Account, 'Video piaciuti', 'descrizione', 'Privato'
FROM account;

--7)agginta dei video a cui ogni utente ha messo mi piace alla playlist mi piace
INSERT INTO VideoPlaylist(id_Video,id_Playlist)
SELECT L.id_Video, P.id_Playlist
FROM Playlist AS P, LikeVideo AS L
WHERE L.valutation='1' AND L.account=P.account AND P.titolo='Video piaciuti'

--8) Proiezione dei commenti, in questo caso una conversazione di commenti che rispondono al commento 1682
SELECT  * 
FROM Commenti
WHERE id_commento = 1682 OR id_risposta = 1682
ORDER BY datacommento
