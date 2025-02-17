//query parametrica: barra di ricerca video/canale/topic
#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"
using namespace std ;

#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"  // Il vostro nome utente
#define PG_DB "project"     // Il nome del database
#define PG_PASS "password"  // La vostra password
#define PG_PORT 5432

//Funzione di controllo dei risultati
void checkResults(PGresult* res, const PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Risultati inconsistenti! " << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}


//Funzione di comodo per scrivere le parole con l'iniziale maiuscola
string capitalizeString(const string& input) {
    if(input.empty()) {
        return input;  // Restituisce la stringa vuota se l'input è vuoto
    }

    string result = input;
    result[0] = toupper(result[0]);  // Converte il primo carattere in maiuscolo

    for(size_t i = 1; i < result.length(); i++) {
        result[i] = tolower(result[i]);  // Converte tutti gli altri caratteri in minuscolo
    }
    return result;
}



//Funzione per stampare i risultati
void stampaRes(PGresult* res){
    int tuple = PQntuples(res);
    int campi = PQnfields(res);

    /*Doppia modalità di visualizzazione in cui si sceglie la più adeguata:
        - Se 1 solo risultato
        - Se >1 risultati*/

    if(tuple > 1){
        for (int i = 0; i < campi; ++i) {
            cout << capitalizeString(PQfname(res, i));
            if(i < campi-1)
                cout << ", ";
        }
        cout << endl;

        for (int i = 0; i < tuple; ++i) {
            for (int j = 0; j < campi; ++j) {
                cout << PQgetvalue(res, i, j);
                if(j < campi-1)
                    cout << ", ";
            }
            cout << endl;
        }
    }else if(tuple == 1){
        for (int i = 0; i < campi; ++i)
            cout << capitalizeString(PQfname(res, i)) << ": \t\t" << PQgetvalue(res, 0, i) << endl;
    }else{
        cout << "Nessun risultato " << endl;
    }
}



//Funzione di esecuzione della query con 0 parametri
void queryProcedureNoParamNoOut(PGconn* conn, string query){
    const char* par1 = query.c_str();

    PGresult* res = PQexec (conn, par1) ;
    cout << "\nQuery completata con successo !\n";

    PQclear (res);
}



//Funzione di esecuzione della query con 0 parametri
void queryProcedureNoParam(PGconn* conn, string query){
    const char* par1 = query.c_str();

    cout << "\nRisultati della ricerca: \n";

    PGresult* res = PQexec (conn, par1) ;
    checkResults(res, conn);

    stampaRes(res);
    PQclear (res);
}



//Funzione di esecuzione della query con 1 parametro (chiesto qui dentro)
void queryProcedure(PGconn* conn, string query){
    string input;
    getline(cin, input);

    PGresult* stmt = PQprepare(conn, "query_ricerca", query.c_str(), 1, NULL);
    
    const char* parameter = input.c_str();
    cout << "\nRisultati della ricerca: \n";

    PGresult* res = PQexecPrepared(conn, "query_ricerca", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);

    stampaRes(res);
    PQclear (res);
}



//Funzione di esecuzione della query con 1 parametro (passato dal main)
void queryProcedure(PGconn* conn, string query, string p1){
    PGresult* stmt = PQprepare(conn, "query_ricerca", query.c_str(), 1, NULL);
    
    const char* parameter = p1.c_str();
    cout << "\nRisultati della ricerca: \n";

    PGresult* res = PQexecPrepared(conn, "query_ricerca", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);

    stampaRes(res);
    PQclear (res);
}



//Funzione di esecuzione della query con 2 parametri (passati dal main)
void queryProcedure(PGconn* conn, string query, string p1, string p2){
    PGresult* stmt = PQprepare(conn, "query_ricerca_2Param", query.c_str(), 2, NULL);
    
    const char* par1 = p1.c_str();
    const char* par2 = p2.c_str();
    const char* paramValues2[2] = {par1, par2};

    cout << "\nRisultati della ricerca: \n";

    PGresult* res = PQexecPrepared(conn, "query_ricerca_2Param", 2, paramValues2, NULL, 0, 0);
    checkResults(res, conn);

    stampaRes(res);
    PQclear (res);
}



int main(int argc, char **argv) {
    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione: " << PQerrorMessage(conn) << endl;
        exit(1);
    }

    //Menu per ricerca
    int scelta = -1;

    do{
        cout << "Selezionare l'opzione desiderata: \n\n" <<
                "Queries parametriche\n" <<
                "0) Terminare ricerca\n" <<
                "1) Ricerca video\n" <<
                "2) Ricerca canale\n" <<
                "3) Ricerca video per categoria\n" <<
                "4) Ricerca canale per categoria\n" <<
                "5) Ricerca video di un canale\n" <<
                "6) Ricerca video di una categoria specifica appartenenti allo stesso canale \n\n" <<
                "Queries SQL\n" <<
                "7) Vedere le views totali di ogni canale\n" <<
                "8) Creazione playlist ''Mi piace'' e ''Guarda piu tardi''\n" <<
                "9) Aggiunta dei video piaciuti alla playlist ''Mi piace'' per ogni utente\n" <<
                "10) Classifica video (video ordinati in base al rating ricevuto)\n" <<
                "11) Video in tendenza\n" <<
                "12) Utenti che vedranno la pubblicita\n" <<
                "13) Live in corso\n" <<
                "14) Visualizzazione commenti\n" <<
                "\nInserire scelta: ";
        cin >> scelta;
        cin.ignore();

        switch(scelta){
            case 1:{
                    cout << "Inserire il titolo del video: ";
                    string query = "SELECT A.handle, A.imgprofilo, V.thumbnail, V.titolo, V.descrizione, V.datapubblicazione, V.durata, V.costo FROM Video AS V JOIN account AS A ON V.id_account = A.id_account WHERE titolo = $1::varchar(256) AND visibilita = 'Pubblico'";
                    queryProcedure(conn, query);
                }
            break;

            case 2:{
                    cout << "Inserire il nome del canale: ";
                    string query = "SELECT imgprofilo, handle, dataiscrizione FROM Account WHERE handle = $1::varchar(256) AND statoaccount = 'Attivo'";
                    queryProcedure(conn, query);
                }
            break;

            case 3:{
                    cout << "Inserire il nome della categoria (iniziale maiuscola): ";
                    string query = "SELECT A.handle, A.imgprofilo, V.thumbnail, V.titolo, V.descrizione, V.datapubblicazione, V.durata, V.costo FROM Video AS V JOIN account AS A ON V.id_account = A.id_account  WHERE categoria = $1::Categorie AND visibilita = 'Pubblico'";
                    queryProcedure(conn, query);
                }
            break;

            case 4:{
                    cout << "Inserire il nome della categoria (iniziale maiuscola):  ";
                    string query = "SELECT DISTINCT A.imgprofilo, A.handle, A.dataiscrizione, A.descrizione FROM Account AS A JOIN Video AS V ON V.id_account = A.id_account WHERE V.categoria = $1::Categorie AND statoaccount = 'Attivo'";
                    queryProcedure(conn, query);
                }
            break;

            case 5:{
                    cout << "Inserire il nome del canale: ";
                    string query = "SELECT A.handle, A.imgprofilo, V.thumbnail, V.titolo, V.descrizione, V.datapubblicazione, V.durata, V.costo FROM Video AS V JOIN account AS A ON V.id_account = A.id_account WHERE handle = $1::varchar(256) AND visibilita = 'Pubblico'";
                    queryProcedure(conn, query);
                }
            break;

            case 6:{
                    string in1, in2;
                    cout << "Inserire il nome del canale: ";
                    getline(cin, in1);

                    cout << "Inserire il nome della categoria: ";
                    getline(cin, in2);

                    string query = "SELECT A.handle, A.imgprofilo, V.thumbnail, V.titolo, V.descrizione, V.datapubblicazione, V.durata, V.costo FROM Video AS V JOIN account AS A ON V.id_account = A.id_account WHERE A.handle = $1::varchar(256) AND V.categoria = $2::Categorie AND visibilita = 'Pubblico'";
                    queryProcedure(conn, query, in1, in2);
                }
            break;

            case 7:{
                    string query = "DROP VIEW IF EXISTS ViewsPerVideo; CREATE VIEW ViewsPerVideo AS(SELECT id_Video, COUNT(account) AS total_views FROM Views GROUP BY id_Video); SELECT Video.id_account, SUM(total_views) AS ViewsCanale FROM ViewsPerVideo, Video GROUP BY Video.id_account HAVING SUM(total_views) > 10;";
                    queryProcedureNoParam(conn, query);
            }
            break;

            case 8:{
                    string query = "INSERT INTO Playlist (account, titolo, descrizione, visibilita) SELECT id_Account, 'Guarda più tardi', 'I tuoi video da guardare più tardi', 'Privato' FROM account; INSERT INTO Playlist (account, titolo, descrizione, visibilita) SELECT id_Account, 'Video piaciuti', 'I video a cui hai messo like', 'Privato' FROM account; INSERT INTO VideoPlaylist(id_Video,id_Playlist) SELECT L.id_Video, P.id_Playlist FROM Playlist AS P, LikeVideo AS L WHERE L.valutation='1' AND L.account=P.account AND P.titolo='Video piaciuti';";
                    queryProcedureNoParamNoOut(conn, query);
            }
            break;

            case 9:{
                    string query = "INSERT INTO VideoPlaylist(id_Video,id_Playlist) SELECT L.id_Video, P.id_Playlist FROM Playlist AS P, LikeVideo AS L WHERE L.valutation='1' AND L.account=P.account AND P.titolo='Video piaciuti'";
                    queryProcedureNoParamNoOut(conn, query);
            }
            break;

            case 10:{
                    string query = "DROP VIEW IF EXISTS ViewsPerVideo; DROP VIEW IF EXISTS SommaLike; DROP VIEW IF EXISTS voto; CREATE VIEW ViewsPerVideo AS(SELECT id_Video, COUNT(account) AS total_views FROM Views GROUP BY id_Video); CREATE VIEW voto AS(SELECT id_Video, CASE WHEN valutation = '1' THEN 1.0 ELSE -1.0 END AS stato FROM LikeVideo); CREATE VIEW SommaLike AS(SELECT id_Video, SUM(stato) AS SommaLike FROM voto GROUP BY id_Video); SELECT S.id_Video, (S.SommaLike/V.total_views) AS RATING FROM SommaLike AS S JOIN ViewsPerVideo AS V ON S.id_Video=V.id_Video ORDER BY RATING DESC;";
                    queryProcedureNoParam(conn, query);
            }
            break;

            case 11:{
                    string query = "SELECT V.* FROM Video AS V JOIN (SELECT id_Video, COUNT(*) AS num_views FROM Views GROUP BY id_Video) AS VIEWS ON V.id_Video = VIEWS.id_Video ORDER BY VIEWS.num_views DESC LIMIT 10;";
                    queryProcedureNoParam(conn, query);
            }
            break;

            case 12:{
                    string query = "SELECT * FROM account WHERE premium = FALSE;";
                    queryProcedureNoParam(conn, query);
            }
            break;

            case 13:{
                    string query = "SELECT * FROM Video WHERE isLive = true;";
                    queryProcedureNoParam(conn, query);
            }
            break;

            case 14:{
                    string query;
                    query = "SELECT  * FROM Commenti WHERE id_commento = 1682 OR id_risposta = 1682 ORDER BY datacommento";
                    queryProcedureNoParam(conn, query);

            }
            break;
        }
        cout << "\n-----------------------------------\n\n";
    }while(scelta != 0);

    PQfinish(conn);

    return 0;
}
